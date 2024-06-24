import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webviewx/webviewx.dart';

class AdsenseBannerWidget extends ConsumerStatefulWidget {
  final double width;
  final double height;

  const AdsenseBannerWidget({
    super.key,
    this.width = 320,
    this.height = 100,
  });

  @override
  AdsenseBannerWidgetState createState() => AdsenseBannerWidgetState();
}

class AdsenseBannerWidgetState extends ConsumerState<AdsenseBannerWidget> {
  late WebViewXController webViewXController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: WebViewX(
        width: widget.width,
        height: widget.height,
        initialContent:
            """<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${dotenv.env['ADSENSE_CLIENT_ID']}"
     crossorigin="anonymous"></script>
<!-- 배너 광고 -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="${dotenv.env['ADSENSE_CLIENT_ID']}"
     data-ad-slot="3060048968"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>""",
        initialSourceType: SourceType.HTML,
        onWebViewCreated: (controller) {
          webViewXController = controller;
        },
      ),
    );
  }
}
