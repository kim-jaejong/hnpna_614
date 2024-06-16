// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/theme.dart';
import 'auth_provider.dart';
import 'custom_text_form_field.dart';

class CustomForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>(); // 1. 글로벌 key
  final _addrtessController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  CustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // 2. 글로벌 key를 Form 태그에 연결하여 해당 key로 Form의 상태를 관리할 수 있다.
      key: _formKey,
      child: Column(
        children: [
//          const SizedBox(height: largeGap),
          CustomTextFormField("이름",
              controller: _nameController, inputType: InputType.name),
          CustomTextFormField("전화",
              controller: _phoneController, inputType: InputType.phone),
          const SizedBox(height: mediumGap),
          CustomTextFormField("비밀번호",
              controller: _passwordController, inputType: InputType.password),
          const SizedBox(height: mediumGap),
          CustomTextFormField("주소",
              controller: _addrtessController, inputType: InputType.address),
          const SizedBox(height: largeGap),
          // 3. TextButton 추가
          TextButton(
            onPressed: () {
              // 4. 유효성 검사
              bool isValid = _formKey.currentState!.validate();
              print('유효성 검사 결과: $isValid');
              if (isValid) {
                try {
                  Navigator.pop(context);
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  authProvider.login(
                    _nameController.text,
                    _phoneController.text,
                    _addrtessController.text,
                    _passwordController.text,
                  );
                  print(
                    '전화: ${_phoneController.text}, 이름: ${_nameController.text}, 주소: ${_addrtessController.text}',
                  );
                } catch (e) {
                  print('An error occurred: $e');
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
