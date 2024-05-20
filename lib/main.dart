import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orre_web/presenter/waiting/waiting_screen.dart';
import 'package:orre_web/services/debug.services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'presenter/storeinfo/store_info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) => Builder(
        builder: (context) => MaterialApp.router(
          routerConfig: _router,
          title: 'Reservation',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ),
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        printd("Navigating to HomePage, fullPath: ${state.fullPath}");
        return HomePage();
      },
    ),
    GoRoute(
      path: '/reservation/:storeCode',
      builder: (context, state) {
        printd("Navigating to ReservationPage, fullPath: ${state.fullPath}");
        final storeCode = int.parse(state.pathParameters['storeCode']!);
        return StoreDetailInfoWidget(null, storeCode: storeCode);
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
  ],
  errorBuilder: (context, state) {
    printd('Error: ${state.error}');
    return ErrorPage(state.error);
  },
);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reservation'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/reservation/1');
              },
              child: Text('Go to Store 1'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/reservation/2');
              },
              child: Text('Go to Store 2'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/reservation/3');
              },
              child: Text('Go to Store 3'),
            ),
          ],
        ));
  }
}

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage(this.error);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Text(error?.toString() ?? 'Unknown error'),
      ),
    );
  }
}
