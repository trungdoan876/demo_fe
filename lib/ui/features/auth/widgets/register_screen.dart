import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String? _validate() {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;
    final confirm = _confirmController.text;
    if (email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      return 'Vui lòng nhập đầy đủ thông tin';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) return 'Email không hợp lệ';
    if (pass.length < 6) return 'Mật khẩu phải tối thiểu 6 ký tự';
    if (pass != confirm) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  Future<void> _onRegister() async {
    final error = _validate();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _authService.register(
        _emailController.text.trim(),
        _passwordController.text,
        _nameController.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công. Vui lòng đăng nhập.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thất bại: $e')),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Text(
                'Tạo tài khoản',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Tạo một tài khoản để bạn có thể khám phá tất cả các bài tập hiện có',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _Field(controller: _emailController, hint: 'Email'),
              const SizedBox(height: 14),
              _Field(controller: _passwordController, hint: 'Password', obscure: true),
              const SizedBox(height: 14),
              _Field(controller: _confirmController, hint: 'Confirm Password', obscure: true),
              const SizedBox(height: 18),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onRegister,
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
                          'Đăng kí',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Bạn đã có tài khoản',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.black.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Hoặc tiếp tục với',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: primaryBlue),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _SocialIcon(label: 'G'),
                  SizedBox(width: 12),
                  _SocialIcon(label: 'f'),
                  SizedBox(width: 12),
                  _SocialIcon(label: ''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.controller, required this.hint, this.obscure = false});

  final TextEditingController controller;
  final String hint;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    final Color border = const Color(0xFF6C8CF3);
    return TextField(
      controller: controller,
      obscureText: obscure,
      cursorColor: border,
      style: GoogleFonts.inter(color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
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


