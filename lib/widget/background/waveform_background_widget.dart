import 'package:flutter/material.dart';
import 'package:orre_web/services/debug.services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orre_web/services/debug.services.dart';

class WaveformBackgroundWidget extends ConsumerWidget {
  final Color backgroundColor;
  final Widget child;

  const WaveformBackgroundWidget(
      {Key? key, required this.child, this.backgroundColor = Colors.white})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          color: backgroundColor,
        ),
        Image.asset(
          "assets/images/waveform/wave_shadow.png",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Image.asset(
          "assets/images/waveform/wave.png",
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        child,
      ],
    );
  }
}
