import 'package:flutter/material.dart';
import 'package:orre_web/services/debug_services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/widget/text/text_widget.dart';

import 'store_info_screen_waiting_cancel_dialog.dart';
import 'store_info_screen_waiting_dialog.dart';

class WaitingButton extends ConsumerWidget {
  final int storeCode;
  final bool waitingState;

  WaitingButton({required this.storeCode, required this.waitingState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton.extended(
            backgroundColor: Color(0xFFFFB74D),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              printd("waitingState" + {waitingState}.toString());
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return waitingState
                      ? WaitingCancelDialog(
                          storeCode: storeCode, waitingState: waitingState)
                      : WaitingDialog(
                          storeCode: storeCode,
                          waitingState: waitingState,
                        );
                },
              );
            },
            label: waitingState
                ? const Row(
                    children: [
                      Icon(Icons.group_remove_rounded),
                      SizedBox(width: 8),
                      TextWidget(
                        '웨이팅 취소',
                        color: Colors.white,
                      ),
                    ],
                  )
                : const Row(
                    children: [
                      Icon(Icons.group_add_rounded),
                      SizedBox(width: 8),
                      TextWidget(
                        '신청 및 조회',
                        color: Colors.white,
                      ),
                    ],
                  )),
      ),
    );
  }
}
