import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../auth/widgets/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF6C8CF3);
    final Color subtitleColor = Colors.black.withValues(alpha: 0.6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxW = constraints.maxWidth;
            final EdgeInsets screenPadding = EdgeInsets.symmetric(
              horizontal: maxW * 0.08,
              vertical: 24,
            );

            return SingleChildScrollView(
              padding: screenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: math.max(0, constraints.maxHeight - screenPadding.vertical)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    AspectRatio(
                      aspectRatio: 1.4,
                      child: Image.asset(
                        'assets/images/wello.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 12),
                    Text(
                      'Wello giúp bạn đạt được mục tiêu sức khỏe \nvới các phân tích chuyên sâu, theo dõi vấn đề \nsức khoẻ và những thử thách hấp dẫn.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hãy bắt đầu hành trình khoẻ mạnh hơn \nngay hôm nay!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: subtitleColor,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const _LoginRouteProxy(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Let's Start",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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

// Tách route để tránh circular import nếu cần dùng nơi khác
class _LoginRouteProxy extends StatelessWidget {
  const _LoginRouteProxy();

  @override
  Widget build(BuildContext context) => const LoginScreen();
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


