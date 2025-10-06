import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/services/auth_service.dart';
import 'register_screen.dart';
import '../../survey/widgets/survey_question_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.authService});

  final AuthService? authService;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final AuthService _authService;
  bool _isLoading = false;
  late final AnimationController _floatCtrl;

  @override
  void dispose() {
    _floatCtrl.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  Future<void> _onLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.login(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SurveyFlowRemoteScreen(appTitle: 'Wello')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF6C8CF3);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final EdgeInsets pad = const EdgeInsets.symmetric(horizontal: 24, vertical: 24);
            return SingleChildScrollView(
              padding: pad,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - pad.vertical),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    AnimatedBuilder(
                      animation: _floatCtrl,
                      builder: (context, child) {
                        final double dy = math.sin(_floatCtrl.value * 2 * math.pi) * 6;
                        return Transform.translate(
                          offset: Offset(0, dy),
                          child: child,
                        );
                      },
                      child: _GradientText(
                        'Wello',
                        style: GoogleFonts.pacifico(
                          fontSize: 46,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                        ),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6C8CF3), Color(0xFF667EEA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Đăng nhập để tiếp tục',
                      key: const Key('login_title'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _LabeledField(controller: _emailController, label: 'Email'),
                    const SizedBox(height: 14),
                    _LabeledField(controller: _passwordController, label: 'Password', obscure: true),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Quên mật khẩu?',
                          style: GoogleFonts.inter(color: primaryBlue),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        key: const Key('login_button'),
                        onPressed: _isLoading ? null : _onLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Đăng nhập',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RegisterScreen()),
                              );
                            },
                      child: Text(
                        'Tạo tài khoản',
                        style: GoogleFonts.inter(
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, this.obscure = false, this.controller});

  final String label;
  final bool obscure;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final Color border = const Color(0xFF6C8CF3);
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: border,
      style: GoogleFonts.inter(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        hintText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border.withValues(alpha: 0.4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: border, width: 1.4),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _GradientText extends StatelessWidget {
  const _GradientText(this.text, {required this.style, required this.gradient});

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: style.copyWith(color: Colors.white, shadows: const [
          Shadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
        ]),
      ),
    );
  }
}


