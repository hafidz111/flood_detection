import 'package:flood_detection/providers/auth_provider.dart';
import 'package:flood_detection/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      try {
        await auth.register(email.text, password.text);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi berhasil! Silakan login.")),
        );
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? "Pendaftaran gagal"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF132A3B),
          appBar: AppBar(
            title: const Text(
              "Daftar Akun",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(0xFF132A3B),
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: AuthForm(
                  title: "Daftar Sekarang",
                  emailController: email,
                  passwordController: password,
                  confirmPasswordController: confirmPassword,
                  onSubmit: _register,
                  isRegisterMode: true,
                ),
              ),
            ),
          ),
        ),
        if (authProvider.isAuthenticating)
          Positioned.fill(
            child: Container(
              color: Color.fromRGBO(0, 0, 0, 0.55),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
