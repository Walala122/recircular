import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginScreen({super.key, required this.onLogin, required this.onRegister});

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
          child: Column(
            children: [
              const SizedBox(height: 14),
              const Center(child: ReCircularLogo(fontSize: 44)),
              const SizedBox(height: 18),

              // Tagline
              SectionCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: const Text(
                  'El espacio para llevar la economía circular a tu negocio',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMid, height: 1.4),
                ),
              ),
              const SizedBox(height: 18),

              // Form
              SectionCard(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
                child: Column(
                  children: [
                    const Text(
                      'Inicia sesión para acceder',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                    const SizedBox(height: 20),
                    UInput(label: 'CORREO ELECTRÓNICO', placeholder: 'tu@empresa.cl', controller: emailCtrl, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 18),
                    UInput(label: 'CONTRASEÑA', placeholder: '••••••••', controller: passCtrl, obscureText: true),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              PrimaryButton(
                label: 'Ingresar',
                onTap: onLogin,
                color: const Color(0xFFE0DBD2),
                textColor: AppColors.textMid,
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: onRegister,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB8B0A4)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Registrarse', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF7A6A5A))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
