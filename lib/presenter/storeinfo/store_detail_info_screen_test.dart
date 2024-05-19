import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/model/store_info_model.dart';
import 'package:orre_web/widget/text/text_widget.dart';

class StoreDetailInfoTestScreen extends ConsumerWidget {
  final StoreDetailInfo storeDetailInfo;

  const StoreDetailInfoTestScreen({Key? key, required this.storeDetailInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final network = ref.watch(networkStreamProvider);
    // network.when(data: (value) {
    //   if (value) {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         // Add a return statement at the end of the builder function
    //         return AlertPopupWidget(
    //             title: "네트워크 연결 상태가 확인되었습니다.", buttonText: "확인");
    //       },
    //     );
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (context) {
    //         // Add a return statement at the end of the builder function
    //         return AlertPopupWidget(title: "네트워크가 유실되었습니다.", buttonText: "확인");
    //       },
    //     );
    //   }
    // }, loading: () {
    //   printd('loading');
    // }, error: (Object error, StackTrace stackTrace) {
    //   printd('error');
    // });

    return Scaffold(
      body: TextWidget("test"),
    );
  }
}
