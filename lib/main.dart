import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orre_web/model/store_info_model.dart';
import 'package:orre_web/presenter/legal/company_footer.dart';
import 'package:orre_web/presenter/qr_scanner_widget.dart';
import 'package:orre_web/presenter/waiting/waiting_screen.dart';
import 'package:orre_web/services/debug_services.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orre_web/widget/advertisement/adfit_banner_widget.dart';
import 'package:orre_web/widget/background/waveform_background_widget.dart';
import 'package:orre_web/widget/button/small_button_widget.dart';
import 'package:orre_web/widget/popup/alert_popup_widget.dart';
import 'package:orre_web/widget/text/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'presenter/legal/oss_licenses_screen.dart';
import 'presenter/storeinfo/store_info_screen.dart';
import 'services/app_version_service.dart';
import 'widget/loading_indicator/coustom_loading_indicator.dart';
// import 'widget/advertisement/adsense_banner_widget.dart';

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPush: $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPop: $route");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidRemove: $route");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    printd("DidReplace: $newRoute");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await dotenv.load(fileName: ".env");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) => Builder(
        builder: (context) => GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidgetBuilder: (progress) {
            return CustomLoadingImage(
              size: 160.r,
            );
          },
          overlayColor: Colors.black.withOpacity(0.8),
          child: MaterialApp.router(
            routerConfig: _router,
            title: '오리',
            theme: ThemeData(
              primaryColor: const Color(0xFFFFB74D),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFFFFB74D)),
            ),
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: "/",
  observers: [RouterObserver()],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        printd("Navigating to HomePage, fullPath: ${state.fullPath}");
        return const HomePage();
      },
    ),
    GoRoute(
      path: '/reservation/:storeCode',
      builder: (context, state) {
        StoreDetailInfo? info = state.extra as StoreDetailInfo?;

        printd("Navigating to ReservationPage, fullPath: ${state.fullPath}");
        printd("Extra: $info");
        if (info == null) {
          final storeCode = int.parse(state.pathParameters['storeCode']!);
          return StoreDetailInfoWidget(null, storeCode: storeCode);
        } else {
          return NonNullStoreDetailInfoWidget(info);
        }
      },
    ),
    GoRoute(
      path: '/reservation/:storeCode/:userPhoneNumber',
      builder: (context, state) {
        printd(
            "Navigating to ReservationPage for Specific User, fullPath: ${state.fullPath}");
        final storeCode = int.parse(state.pathParameters['storeCode']!);
        final userPhoneNumber =
            state.pathParameters['userPhoneNumber']!.replaceAll('-', '');
        return WaitingScreen(
            storeCode: storeCode, userPhoneNumber: userPhoneNumber);
      },
    ),
    GoRoute(
      path: '/legal/license',
      builder: (context, state) {
        printd("Navigating to LicensePage, fullPath: ${state.fullPath}");
        return const OssLicensesPage();
      },
    ),
  ],
  errorBuilder: (context, state) {
    printd('Error: ${state.error}');
    return ErrorPage(state.error);
  },
);

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextWidget('Error'),
      ),
      body: Center(
        child: Text(error?.toString() ?? 'Unknown error'),
      ),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    initializePackageInfo(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveformBackgroundWidget(
        backgroundColor: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              TextWidget(
                '오리',
                fontFamily: 'Dovemayo_gothic',
                fontSize: 48.r,
                color: Colors.black,
                letterSpacing: 32.r,
              ),
              SizedBox(
                height: 20.r,
              ),
              ClipOval(
                child: Container(
                  color: const Color(0xFFFFB74D),
                  child: Image.asset(
                    "assets/images/orre_logo.png",
                    width: 200.r,
                    height: 200.r,
                  ),
                ),
              ),
              SizedBox(
                height: 20.r,
              ),
              TextWidget(
                '원격 줄서기, 원격 주문 서비스',
                fontFamily: 'Dovemayo_gothic',
                fontSize: 16.sp,
                color: const Color(0xFFFFB74D),
              ),
              SizedBox(
                height: 20.r,
              ),
              SmallButtonWidget(
                text: "테스트 가게로 이동",
                minSize: Size(200.r, 50.r),
                maxSize: Size(200.r, 50.r),
                onPressed: () {
                  context.go('/reservation/999');
                },
              ),
              const Spacer(),
              const Spacer(flex: 2),
              // 사업자 정보 Footer
              CompanyFooter(5.sp),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        distance: 100.0,
        type: ExpandableFabType.side,
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.menu_open_sharp),
          fabSize: ExpandableFabSize.large,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFFFB74D),
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.large,
          child: const Icon(Icons.close_fullscreen),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFFFFB74D),
          shape: const CircleBorder(),
        ),
        children: [
          FloatingActionButton.large(
            heroTag: 'qr',
            shape: const CircleBorder(),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFFFB74D),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QrScannerScreen()),
            ),
            tooltip: 'QR코드 스캔',
            child: const Icon(Icons.qr_code_scanner_rounded),
          ),
          FloatingActionButton.large(
            heroTag: 'contract',
            shape: const CircleBorder(),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFFFB74D),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertPopupWidget(
                  title: "오리와 함께 웨이팅 서비스를 시작해보세요!",
                  subtitle: "아래 버튼을 눌러주세요.",
                  buttonText: '계약 방법 보기',
                  cancelButton: true,
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'https://aeioudev.notion.site/db6980c4bb4748e1a73cc9ce83b033bc?pvs=4'));
                  },
                ),
              );
            },
            tooltip: '오리와 계약',
            child: const Icon(Icons.business_rounded),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        // child: AdsenseBannerWidget(width: 1.sw, height: 50),
        child: AdfitBannerWidget(isBigBanner: false, width: 1.sw, height: 50.h),
      ),
    );
  }
}
