import 'package:flood_detection/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/validator_utils.dart';
import 'auth_input_field.dart';
import 'logo_header.dart';

class AuthForm extends StatelessWidget {
  final String title;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final VoidCallback onSubmit;
  final bool isRegisterMode;

  const AuthForm({
    super.key,
    required this.title,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
    required this.onSubmit,
    this.isRegisterMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      children: [
        const LogoHeader(),
        const SizedBox(height: 60),

        AuthInputField(
          controller: emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: ValidatorUtil.emailValidator,
        ),
        const SizedBox(height: 16),

        AuthInputField(
          controller: passwordController,
          hintText: 'Password',
          obscureText: true,
          validator: ValidatorUtil.passwordValidator,
        ),
        const SizedBox(height: 16),

        if (isRegisterMode)
          AuthInputField(
            controller: confirmPasswordController!,
            hintText: 'Konfirmasi Password',
            obscureText: true,
            validator: (value) => ValidatorUtil.confirmPasswordValidator(
              value,
              passwordController.text,
            ),
          ),

        if (isRegisterMode) const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authProvider.isAuthenticating ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRegisterMode
                  ? const Color(0xFF007B9A)
                  : const Color(0xFF004D7A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
