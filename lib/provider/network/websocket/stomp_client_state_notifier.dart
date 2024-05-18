import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/provider/error_state_notifier.dart';
import 'package:orre_web/provider/network/https/get_service_log_state_notifier.dart';
import 'package:orre_web/provider/network/websocket/store_detail_info_state_notifier.dart';
import 'package:orre_web/provider/network/websocket/store_waiting_info_list_state_notifier.dart';
import 'package:orre_web/provider/network/websocket/store_waiting_info_request_state_notifier.dart';
import 'package:orre_web/provider/network/websocket/store_waiting_usercall_list_state_notifier.dart';
import 'package:orre_web/provider/userinfo/user_info_state_notifier.dart';
import 'package:orre_web/services/network/websocket_services.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

final stompErrorStack = StateProvider<int>((ref) => 0);
final firstStompSetup = StateProvider<bool>((ref) => false);

enum StompStatus {
  CONNECTED,
  DISCONNECTED,
  ERROR,
}

final stompState = StateProvider<StompStatus>((ref) {
  return StompStatus.DISCONNECTED;
});

final stompClientStateNotifierProvider =
    StateNotifierProvider<StompClientStateNotifier, StompClient?>((ref) {
  return StompClientStateNotifier(ref);
});

class StompClientStateNotifier extends StateNotifier<StompClient?> {
  final Ref ref;
  late StompClient client;
  StompClientStateNotifier(this.ref) : super(null);

  Future<bool> connect() async {
    final stream = configureClient();
    stream.listen((event) {
      print("stompClientStateNotifierProvider event : $event");
    });
    return true;
  }

  Stream<StompStatus> configureClient() {
    print("configureClient");
    final streamController = StreamController<StompStatus>.broadcast();

    if (state != null) {
      // 이미 configureClient가 실행되었을 경우 재설정 하지 않음
      return streamController.stream;
    } else {
      client = StompClient(
        config: StompConfig(
          url: WebSocketService.url,
          onConnect: (StompFrame frame) {
            final firstBoot = ref.read(firstStompSetup.notifier).state;
            ref.read(stompState.notifier).state = StompStatus.CONNECTED;
            streamController.add(StompStatus.CONNECTED);
            onConnectCallback(frame);
          },
          onWebSocketError: (dynamic error) {
            print("websocket error: $error");
            // 연결 실패 시 0.5초 후 재시도
            streamController.add(reconnectionCallback(StompStatus.ERROR));
          },
          onDisconnect: (_) {
            print('disconnected');
            // 연결 끊김 시 0.5초 후 재시도
            streamController.add(reconnectionCallback(StompStatus.ERROR));
          },
          onStompError: (p0) {
            print("stomp error: $p0");
            // 연결 실패 시 0.5초 후 재시도
            streamController.add(reconnectionCallback(StompStatus.ERROR));
          },
          onWebSocketDone: () {
            ref.read(stompState.notifier).state = StompStatus.DISCONNECTED;
            print("websocket done");
            // 연결 끊김 시 재시도 로직
          },
          onDebugMessage: (message) {
            print("debug message: ${message.toString()}");
          },
          heartbeatIncoming: Duration(seconds: 1),
          heartbeatOutgoing: Duration(seconds: 1),
          reconnectDelay: Duration(milliseconds: 500),
        ),
      );

      Future.delayed(Duration(milliseconds: 10), () {
        if (client.connected) {
          print("이미 연결되어 있음");
          return;
        }
        state = client;
        state?.activate();
      });
    }
    return streamController.stream;
  }

  void onConnectCallback(StompFrame connectFrame) {
    print("웹소켓 연결 성공");
    ref.read(stompErrorStack.notifier).state = 0;
    ref.read(firstStompSetup.notifier).state = true;

    // 필요한 초기화 수행
    // 예를 들어, 여기서 다시 구독 로직을 실행
  }

  // void reconnect() {
  //   print("reconnected");
  //   // 재시도 시, 구독 로직을 다시 실행
  //   if (ref
  //       .read(errorStateNotifierProvider.notifier)
  //       .state
  //       .contains(Error.network)) {
  //     return;
  //   }
  //   state?.activate();
  //   ref.read(storeWaitingInfoListNotifierProvider.notifier).reconnect();
  //   ref.read(storeWaitingRequestNotifierProvider.notifier).reconnect();
  //   ref.read(storeWaitingUserCallNotifierProvider.notifier).reconnect();
  // }

  StompStatus reconnectionCallback(StompStatus status) {
    print("reconnectionCallback");
    if (ref
        .read(errorStateNotifierProvider.notifier)
        .state
        .contains(Error.network)) {
      return status;
    }
    if (ref.read(stompErrorStack.notifier).state == 5) {
      return status;
    }
    ref.read(stompState.notifier).state = status;
    Future.delayed(Duration(milliseconds: 500), () {
      print("웹소켓 재시도");
      state?.activate();
      ref.read(stompErrorStack.notifier).state++;
    });
    return status;
  }

  Future<void> disconnect() async {
    client.deactivate();
  }
}
