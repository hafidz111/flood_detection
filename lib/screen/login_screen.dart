import 'package:flood_detection/providers/auth_provider.dart';
import 'package:flood_detection/screen/register_screen.dart';
import 'package:flood_detection/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      try {
        await auth.login(email.text, password.text);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Login gagal'),
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
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: AuthForm(
                      title: "Login",
                      emailController: email,
                      passwordController: password,
                      onSubmit: _login,
                      isRegisterMode: false,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: const [
                      Expanded(child: Divider(color: Colors.white54)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Belum Punya Akun?',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white54)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: authProvider.isAuthenticating
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF007B9A),
                        foregroundColor: Colors.white,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (authProvider.isAuthenticating)
          Positioned.fill(
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.55),
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
