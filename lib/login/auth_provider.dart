import 'package:flutter/material.dart';
import 'user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;

  bool get isLoggedIn => _currentUser != null;

  User get currentUser => _currentUser!;

  void login(String name, String phoneNumber, String address, String password) {
    // 로그인 로직... 로그인 성공 시 _currentUser를 설정
    _currentUser = User(
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        password: password);
    notifyListeners();
  }

  // void checkLoginStatus(BuildContext context) {
  //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //   if (!authProvider.isLoggedIn) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const Login()),
  //     );
  //   }
  // }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

// AuthProvider 클래스는 이미 로그인 상태를 관리하고 사용자 정보를 저장하는 기능을 가지고 있다.
// login 메서드를 통해 사용자 정보를 받아 로그인 상태를 설정하고,
// logout 메서드를 통해 로그아웃 상태를 설정한다.
// 또한 isLoggedIn과 currentUser를 통해 현재 로그인 상태와 사용자 정보를 얻을 수 있다.
// 따라서 이 클래스에 추가적으로 구현해야 할 로직은 없다.
// 다만, 실제 애플리케이션에서는 login 메서드에서 서버와의 통신을 통해 실제 로그인 처리를 수행하고,
// 로그인이 성공하면 서버로부터 받은 사용자 정보를 _currentUser에 저장하는 등의
// 추가적인 로직이 필요할 수 있다.
// 이러한 로직은 프로젝트의 요구 사항과 서버의 API에 따라 달라진다.

// login 메서드에서 서버와의 통신을 통해 실제 로그인 처리를 수행한다고 하는 것은
// 이미 이전에 로그인에 의해 서버에 정보를 저장하고
// 이제 그 정보를 서버에서 가져와서 이번에 사용자가 입력한 정보와 비교해서 확인한다는 의미인가?

// 네, 맞습니다. 일반적으로 로그인 프로세스는 사용자가 입력한 정보(이름, 전화번호, 주소 등)를 서버에 전송하고,
// 서버는 이 정보를 이미 저장된 사용자 정보와 비교합니다.
// 사용자가 입력한 정보와 서버에 저장된 정보가 일치하면 로그인이 성공한 것으로 간주하고,
// 일치하지 않으면 로그인이 실패한 것으로 간주합니다.
//
// 이 과정에서 서버는 사용자의 비밀번호와 같은 민감한 정보를 안전하게 보호하기 위해
// 해시와 같은 방법을 사용하여 정보를 저장하고 비교합니다.
// 따라서 실제로 서버에 저장된 비밀번호를 직접 가져오는 것이 아니라,
// 사용자가 입력한 비밀번호를 같은 방법으로 해시하여 서버에 저장된 해시와 비교하는 방식으로 로그인을 처리합니다.
//
// 이러한 로그인 처리 로직은 `AuthProvider`의 `login` 메서드에서 구현될 수 있습니다.
// 이 메서드는 사용자가 입력한 정보를 받아 서버에 전송하고,
// 서버의 응답을 받아 로그인 성공 여부를 판단하고,
// 로그인이 성공하면 사용자 정보를 `_currentUser`에 저장하는 역할을 합니다.
// 이 과정에서 HTTP 요청을 보내고 응답을 받는 등의 네트워크 통신이 필요하므로,
// `login` 메서드는 비동기 메서드로 구현되어야 합니다.

// class AuthProvider with ChangeNotifier {
//   User? _currentUser;
//
//   User get currentUser => _currentUser!;
//   bool get isLoggedIn => _currentUser != null;
//
//   Future<void> login(String name, String phoneNumber, String address, String password) async {
//     if (isLoggedIn) {
//       // 이미 로그인한 상태라면, 새로 입력한 정보로 currentUser를 업데이트합니다.
//       _currentUser = User(
//         name: name,
//         phoneNumber: phoneNumber,
//         address: address,
//       );
//     } else {
//       // 그렇지 않은 경우에는 기존의 로그인 로직을 수행합니다.
//       // 서버에 로그인 요청을 보내고, 응답을 받아 처리하는 코드를 여기에 작성합니다.
//       // 예를 들어, 다음과 같이 작성할 수 있습니다.
//       final response = await http.post(
//         Uri.parse('https://example.com/login'),
//         body: {
//           'name': name,
//           'phoneNumber': phoneNumber,
//           'address': address,
//           'password': password,
//         },
//       );
//       if (response.statusCode == 200) {
//         _currentUser = User(
//           name: name,
//           phoneNumber: phoneNumber,
//           address: address,
//         );
//       } else {
//         throw Exception('Failed to login');
//       }
//     }
//     notifyListeners();
//   }
// }
