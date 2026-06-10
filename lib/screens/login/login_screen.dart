import 'package:flutter/material.dart';
import 'dart:ui' show ImageFilter;
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/common_widgets.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword = true;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  late final AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  void _onEmailFocusChange() {
    if (_emailFocused != _emailFocusNode.hasFocus) {
      setState(() => _emailFocused = _emailFocusNode.hasFocus);
    }
  }

  void _onPasswordFocusChange() {
    if (_passwordFocused != _passwordFocusNode.hasFocus) {
      setState(() => _passwordFocused = _passwordFocusNode.hasFocus);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const LocalOrNetworkImage(
            source: kCourtImage,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.36),
                  Colors.black.withOpacity(0.92),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _gradientController,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + _gradientController.value, -1),
                      end: Alignment(1 - _gradientController.value, 1),
                      colors: [
                        kGold.withOpacity(0.12),
                        kTeal.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'avatar',
                      child: Container(
                        width: 103,
                        height: 103,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [kGold, kTeal],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: kGold.withOpacity(0.3),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ClipOval(
                            child: const LocalOrNetworkImage(
                              source: kHeroPlayerImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Padel Fighter League',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kGold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .slideY(
                            begin: -0.3,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 8),
                    const Text(
                      'Bienvenido a la liga',
                      style: TextStyle(color: kTextSecondary, fontSize: 14),
                    )
                        .animate()
                        .fadeIn(
                            delay: 200.ms,
                            duration: 600.ms,
                            curve: Curves.easeOut)
                        .slideY(
                            begin: -0.2,
                            end: 0,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 24),
                    const _DemoCredentialsCard(),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      isFocused: _emailFocused,
                    )
                        .animate()
                        .fadeIn(
                            delay: 400.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut)
                        .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Contrase\u00f1a',
                      icon: Icons.lock_outline,
                      obscure: _obscurePassword,
                      focusNode: _passwordFocusNode,
                      isFocused: _passwordFocused,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextSecondary,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: 600.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut)
                        .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGold,
                          foregroundColor: kOnGold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'INICIAR SESI\u00d3N',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                            delay: 800.ms,
                            duration: 500.ms,
                            curve: Curves.easeOut)
                        .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOutCubic),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '\u00bfOlvidaste tu contrase\u00f1a?',
                        style: TextStyle(color: kTeal),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(child: Divider(color: kCardBorder)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text('O',
                              style: TextStyle(color: kTextSecondary)),
                        ),
                        Expanded(child: Divider(color: kCardBorder)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _login,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kTextPrimary,
                          side: const BorderSide(color: kCardBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Continuar como invitado',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required FocusNode focusNode,
    required bool isFocused,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: kGold.withOpacity(0.4),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: const TextStyle(color: kTextPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kTextSecondary),
          prefixIcon: Icon(icon, color: kTextSecondary),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: kCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kGold, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _DemoCredentialsCard extends StatelessWidget {
  const _DemoCredentialsCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: kCard.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credenciales de prueba',
                style: TextStyle(
                  color: kGold,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              _CredentialRow(label: 'Usuario', value: 'juan@padelfighter.test'),
              SizedBox(height: 6),
              _CredentialRow(label: 'Contrase\u00f1a', value: '123456'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;

  const _CredentialRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 86,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: kTextSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: kTextPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
