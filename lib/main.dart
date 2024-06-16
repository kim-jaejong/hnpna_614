import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home/permission_manager.dart';
import 'common/theme.dart';
import 'home/home_page.dart';
import 'login/auth_provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    PermissionManager permission = PermissionManager();
    permission.requestPermissions().then((isGranted) {
      if (!isGranted) {
        permission.showPermissionMessage(context);
        return;
      }
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        // 다른 프로바이더들...
      ],
      child: MaterialApp(
        title: ' 핸드폰 앨범 hnpna 0614',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: const HomePage(),
      ),
    );
  }
}
