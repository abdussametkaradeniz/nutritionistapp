import 'package:diet_app/presentation/pages/auth/forgot_password_page.dart';
import 'package:diet_app/presentation/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../../core/utils/extensions/context_extensions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../../core/utils/extensions/string_extensions.dart';
import '../../../core/services/snackbar_service.dart';
import '../../../presentation/pages/home/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authNotifierProvider.notifier).signIn(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  void _navigateToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (previous, current) {
      current.maybeWhen(
        authenticated: (_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        error: (failure) {
          SnackbarService.showError(context, failure.message);
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: context.paddingNormal,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo veya İllüstrasyon
                  Icon(
                    Icons.health_and_safety_outlined,
                    size: 80,
                    color: context.colorScheme.primary,
                  ),
                  const SizedBox(height: 32),

                  // Başlık
                  Text(
                    'Hoş Geldiniz',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hesabınıza giriş yapın',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email alanı
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'E-posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'E-posta gerekli';
                      }
                      if (!value!.isValidEmail) {
                        return 'Geçerli bir e-posta giriniz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Şifre alanı
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Şifre gerekli';
                      }
                      if (value!.length < 6) {
                        return 'Şifre en az 6 karakter olmalı';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Şifremi Unuttum
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _navigateToForgotPassword,
                      child: const Text('Şifremi Unuttum'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Giriş Yap butonu
                  GradientButton(
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => _handleLogin,
                    ),
                    child: state.maybeWhen(
                      loading: () => const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      orElse: () => const Text('Giriş Yap'),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Kayıt Ol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hesabınız yok mu?',
                        style: context.textTheme.bodyLarge,
                      ),
                      TextButton(
                        onPressed: _navigateToRegister,
                        child: const Text('Kayıt Olun'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
