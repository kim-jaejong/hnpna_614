import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'user.dart';
import '../common/theme.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String text;
//   final TextEditingController controller;
//   final InputType inputType;
//
//   const CustomTextFormField(this.text,
//       {required this.controller, this.inputType = InputType.name, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     User? user;
//     String hintText = "$text 입력";
//     if (authProvider.isLoggedIn) {
//       user = authProvider.currentUser;
//     } else {
//       user = null;
//     }
//
//     // user의 값이 있으면 controller.text에 설정합니다.
//     if (user != null) {
//       switch (inputType) {
//         case InputType.name:
//           controller.text = user.name;
//           break;
//         case InputType.phone:
//           controller.text = user.phoneNumber;
//           break;
//         case InputType.address:
//           controller.text = user.address;
//           break;
//         case InputType.emailAddress:
//           controller.text = user.email;
//           break;
//         default:
//           break;
//       }
//     }
//
//     TextInputType keyboardType = TextInputType.text;
//     List<TextInputFormatter>? inputFormatters;
//     bool obscureText = false;
//
//     switch (inputType) {
//       case InputType.name:
//         keyboardType = TextInputType.text;
//         hintText = controller.text.isNotEmpty
//             ? controller.text
//             : user?.name ?? hintText;
//         break;
//
//       case InputType.phone:
//         keyboardType = TextInputType.phone;
//         inputFormatters = [
//           FilteringTextInputFormatter.allow(
//               RegExp(r'[0-9-]')), // Only allow digits and hyphen
//           LengthLimitingTextInputFormatter(13), // Limit to 13 characters
//         ];
//         hintText = controller.text.isNotEmpty
//             ? controller.text
//             : user?.phoneNumber ?? hintText;
//         break;
//       case InputType.address:
//         keyboardType = TextInputType.streetAddress;
//         hintText = controller.text.isNotEmpty
//             ? controller.text
//             : user?.address ?? hintText;
//         break;
//
//       case InputType.password:
//         keyboardType = TextInputType.visiblePassword;
//         obscureText = true;
//         hintText = '**********';
//         break;
//
//       case InputType.emailAddress:
//         keyboardType = TextInputType.emailAddress;
//         inputFormatters = [
//           FilteringTextInputFormatter.allow(RegExp(
//               r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')), // Only allow email address
//         ];
//         hintText = controller.text.isNotEmpty
//             ? controller.text
//             : user?.email ?? hintText;
//         break;
//
//       default:
//         keyboardType = TextInputType.text;
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 8),
//         Text(text),
//         const SizedBox(height: 1),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           inputFormatters: inputFormatters,
//           validator: (value) {
//             // controller.text가 비어 있는지 확인합니다.
//             if (controller.text.isEmpty) {
//               return "입력 요망.";
//             } else {
//               return null;
//             }
//           },
//           obscureText: obscureText,
//           decoration: InputDecoration(
//               hintText: hintText,
//               enabledBorder: const UnderlineInputBorder(),
//               focusedBorder: const UnderlineInputBorder(),
//               errorBorder: const UnderlineInputBorder(),
//               labelStyle: const TextStyle(fontSize: 8, color: Colors.black),
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 8.0) // 입력 상자 내부의 패딩 조정
//               ),
//         ),
//       ],
//     );
//   }
// }

class CustomTextFormField extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final InputType inputType;

  const CustomTextFormField(this.text,
      {required this.controller, this.inputType = InputType.name, super.key});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextInputType keyboardType;
  List<TextInputFormatter>? inputFormatters;
  bool obscureText = false;
  String hintText = "";

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    User? user;
    if (authProvider.isLoggedIn) {
      user = authProvider.currentUser;
    } else {
      user = null;
    }

    // user의 값이 있으면 controller.text에 설정합니다.
    if (user != null) {
      switch (widget.inputType) {
        case InputType.name:
          widget.controller.text = user.name;
          break;
        case InputType.phone:
          widget.controller.text = user.phoneNumber;
          break;
        case InputType.address:
          widget.controller.text = user.address;
          break;
        case InputType.emailAddress:
          widget.controller.text = user.email;
          break;
        default:
          break;
      }
    }

    hintText = "${widget.text} 입력";
    _setInputType();
  }

  void _setInputType() {
    switch (widget.inputType) {
      case InputType.name:
        keyboardType = TextInputType.text;
        hintText = widget.controller.text.isNotEmpty
            ? widget.controller.text
            : hintText;
        break;

      case InputType.phone:
        keyboardType = TextInputType.phone;
        inputFormatters = [
          FilteringTextInputFormatter.allow(
              RegExp(r'[0-9-]')), // Only allow digits and hyphen
          LengthLimitingTextInputFormatter(13), // Limit to 13 characters
        ];
        hintText = widget.controller.text.isNotEmpty
            ? widget.controller.text
            : hintText;
        break;
      case InputType.address:
        keyboardType = TextInputType.streetAddress;
        hintText = widget.controller.text.isNotEmpty
            ? widget.controller.text
            : hintText;
        break;

      case InputType.password:
        keyboardType = TextInputType.visiblePassword;
        obscureText = true;
        hintText = '**********';
        break;

      case InputType.emailAddress:
        keyboardType = TextInputType.emailAddress;
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(
              r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$')),
          // Only allow email address
        ];
        hintText = widget.controller.text.isNotEmpty
            ? widget.controller.text
            : hintText;
        break;

      default:
        keyboardType = TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(widget.text),
        const SizedBox(height: 1),
        TextFormField(
          controller: widget.controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          // onChanged: (value) {
          //   // 사용자가 입력한 값을 controller.text에 저장합니다.
          //   widget.controller.text = value;
          // },
          validator: (value) {
            // controller.text가 비어 있는지 확인합니다.
            if (widget.controller.text.isEmpty) {
              return "입력 요망.";
            } else {
              return null;
            }
          },
          obscureText: obscureText,
          decoration: InputDecoration(
              hintText: hintText,
              enabledBorder: const UnderlineInputBorder(),
              focusedBorder: const UnderlineInputBorder(),
              errorBorder: const UnderlineInputBorder(),
              labelStyle: const TextStyle(fontSize: 8, color: Colors.black),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0) // 입력 상자 내부의 패딩 조정
              ),
        ),
      ],
    );
  }
}
