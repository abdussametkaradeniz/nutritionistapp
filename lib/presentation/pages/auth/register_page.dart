import 'package:diet_app/presentation/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/auth/auth_state.dart';
import '../../../core/utils/extensions/context_extensions.dart';
import '../../../core/utils/extensions/string_extensions.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/gradient_button.dart';
import '../../../core/services/snackbar_service.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      final registerData = {
        'email': _emailController.text.trim(),
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
        'phoneNumber': _phoneNumberController.text.trim(),
        'profile': {
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'age': int.tryParse(_ageController.text.trim()),
        },
      };

      await ref.read(authNotifierProvider.notifier).signUp(registerData);
    }
  }

  void _showAgePickerDialog() {
    int selectedAge = int.tryParse(_ageController.text) ?? 18;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yaş Seçin'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return NumberPicker(
                value: selectedAge,
                minValue: 12,
                maxValue: 100,
                step: 1,
                haptics: true,
                onChanged: (value) {
                  setState(() {
                    selectedAge = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                _ageController.text = selectedAge.toString();
                Navigator.pop(context);
              },
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(
      authNotifierProvider,
      (previous, current) {
        current.maybeWhen(
          error: (failure) {
            SnackbarService.showError(context, failure.message);
          },
          authenticated: (_) {
            SnackbarService.showSuccess(context, 'Kayıt başarılı!');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
          orElse: () {},
        );
      },
    );

    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
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
                  // İsim (Required)
                  CustomTextField(
                    controller: _firstNameController,
                    hintText: 'İsim *',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'İsim gerekli';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Soyisim (Required)
                  CustomTextField(
                    controller: _lastNameController,
                    hintText: 'Soyisim *',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Soyisim gerekli';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kullanıcı Adı (Optional)
                  CustomTextField(
                    controller: _usernameController,
                    hintText: 'Kullanıcı Adı',
                    prefixIcon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 16),

                  // Email (Optional)
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'E-posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value?.isNotEmpty ?? false) {
                        if (!value!.isValidEmail) {
                          return 'Geçerli bir e-posta giriniz';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _ageController,
                    hintText: 'Yaş',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.numbers,
                    readOnly: true,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: _showAgePickerDialog,
                    ),
                    onTapCallback: _showAgePickerDialog,
                  ),
                  const SizedBox(height: 16),

                  // Telefon Numarası (Optional)
                  CustomTextField(
                    controller: _phoneNumberController,
                    hintText: 'Telefon Numarası',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_android,
                  ),
                  const SizedBox(height: 16),

                  // Şifre (Required)
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Şifre *',
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
                  const SizedBox(height: 16),

                  // Şifre Tekrar
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Şifre Tekrar',
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Şifre tekrarı gerekli';
                      }
                      if (value != _passwordController.text) {
                        return 'Şifreler eşleşmiyor';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Kayıt Ol butonu
                  GradientButton(
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => _handleRegister,
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
                      orElse: () => const Text('Kayıt Ol'),
                    ),
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
