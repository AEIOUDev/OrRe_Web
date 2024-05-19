import 'package:flutter/material.dart';
import 'package:orre_web/services/debug.services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/presenter/error/server_error_screen.dart';
import 'package:orre_web/provider/network/connectivity_state_notifier.dart';
import 'package:orre_web/provider/network/websocket/stomp_client_state_notifier.dart';
import 'package:orre_web/widget/text/text_widget.dart';

class WebsocketErrorScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final stomp = ref.watch(stompClientStateNotifierProvider);
    final stompStack = ref.watch(stompErrorStack);
    final networkError = ref.watch(networkStateNotifierProvider);

    printd("ServerErrorScreen : $stompStack");
    // 네트워크 연결은 정상이나 웹소켓 연결을 5번 이상 실패했을 경우
    if (stompStack > 5 && networkError == true) {
      // 서버 에러로 판단하여 서버 에러 화면으로 이동
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ServerErrorScreen()));
    } else {
      printd("다시 시도하기");
      ref.read(stompClientStateNotifierProvider)?.activate();
    }
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextWidget('웹소켓을 불러오는데 실패했습니다.'),
            ElevatedButton(
              onPressed: () {
                printd("다시 시도하기");
                ref.read(stompErrorStack.notifier).state = 0;
                ref.read(stompClientStateNotifierProvider)?.activate();
              },
              child: const TextWidget('다시 시도하기'),
            ),
          ],
        ),
      ),
    );
  }
}
