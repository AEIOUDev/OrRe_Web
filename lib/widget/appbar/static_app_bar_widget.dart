import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/widget/text/text_widget.dart';

class StaticAppBarWidget extends ConsumerWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const StaticAppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 5),
      child: Row(
        children: [
          leading ?? SizedBox(width: 20),
          TextWidget(
            title,
            fontSize: 32,
            color: Colors.white,
          ),
          Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
