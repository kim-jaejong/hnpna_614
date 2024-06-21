import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home/permission_manager.dart';
import 'common/theme.dart';
import 'move_routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionManager permission = PermissionManager();
    permission.requestPermissions().then((isGranted) {
      if (!isGranted) {
        permission.showPermissionMessage(context);
        print('권한허용 안됨 ');
        return;
      }
    });

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: ' 핸드폰 앨범 hnpna 0614',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: Routes.photoTaggerPage, // Routes.loginPage,
      routes: getRouters(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ko', ''), // Korean
      ],
    );
  }
}
