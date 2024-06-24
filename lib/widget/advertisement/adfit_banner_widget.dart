import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webviewx/webviewx.dart';

class AdfitBannerWidget extends ConsumerStatefulWidget {
  final bool isBigBanner;
  final double width;
  final double height;

  const AdfitBannerWidget({
    super.key,
    required this.isBigBanner,
    this.width = 320,
    this.height = 100,
  });

  @override
  AdfitBannerWidgetState createState() => AdfitBannerWidgetState();
}

class AdfitBannerWidgetState extends ConsumerState<AdfitBannerWidget> {
  late WebViewXController webViewXController;

  @override
  Widget build(BuildContext context) {
    return widget.isBigBanner
        ? SizedBox(
            width: widget.width,
            height: widget.height,
            child: WebViewX(
              width: widget.width,
              height: widget.height,
              initialContent:
                  """<ins class="kakao_ad_area" style="display:none;"
data-ad-unit = "${dotenv.env['ADFIT_BIG_BANNER_UNIT_ID']}"
data-ad-width = "320"
data-ad-height = "100"></ins>
<script type="text/javascript" src="//t1.daumcdn.net/kas/static/ba.min.js" async></script>""",
              initialSourceType: SourceType.HTML,
              onWebViewCreated: (controller) {
                webViewXController = controller;
              },
            ),
          )
        : SizedBox(
            width: widget.width,
            height: widget.height,
            child: WebViewX(
              width: widget.width,
              height: widget.height,
              initialContent:
                  """<ins class="kakao_ad_area" style="display:none;"
data-ad-unit = "${dotenv.env['ADFIT_SMALL_BANNER_UNIT_ID']}"
data-ad-width = "320"
data-ad-height = "50"></ins>
<script type="text/javascript" src="//t1.daumcdn.net/kas/static/ba.min.js" async></script>""",
              initialSourceType: SourceType.HTML,
              onWebViewCreated: (controller) {
                webViewXController = controller;
              },
            ),
          );
  }
}
