import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login/login.dart';
import '../login/auth_provider.dart';

class PreviousAlbums extends StatelessWidget {
  const PreviousAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    if (!authProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('로그인 필요'),
              content: const Text('로그인이 필요한 서비스입니다. 로그인 하시겠습니까?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('아니오'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('예'),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      });
    } else {
      print('User Info: ${authProvider.currentUser}');
    }

    return const Scaffold(
      body: Center(
        child: Text('Previous Albums'),
      ),
    );
  }
}
