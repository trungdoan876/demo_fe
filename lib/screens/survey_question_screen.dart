import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/survey_service.dart';
import '../theme.dart';

class SurveyQuestion {
  const SurveyQuestion({
    required this.question,
    this.subtitle,
    required this.options,
  });

  final String question;
  final String? subtitle;
  final List<String> options;
}

class SurveyQuestionScreen extends StatelessWidget {
  const SurveyQuestionScreen({
    super.key,
    required this.appTitle,
    required this.question,
    this.subtitle,
    required this.options,
    this.nextLabel = 'NEXT',
    this.onNext,
  });

  final String appTitle;
  final String question;
  final String? subtitle;
  final List<String> options;
  final String nextLabel;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = AppTheme.primaryBlue;

    Widget option(String label) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
        ),
        child: Text(
          label,
          style: GoogleFonts.beVietnamPro(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: null,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      question,
                      key: const Key('survey_question'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: Colors.black.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    for (int i = 0; i < options.length; i++) ...[
                      option(options[i]),
                      if (i != options.length - 1) const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        key: const Key('survey_next_button'),
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          nextLabel,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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

class SurveyFlowScreen extends StatefulWidget {
  const SurveyFlowScreen({
    super.key,
    required this.appTitle,
    required this.questions,
    this.nextLabel = 'NEXT',
  });

  final String appTitle;
  final List<SurveyQuestion> questions;
  final String nextLabel;

  @override
  State<SurveyFlowScreen> createState() => _SurveyFlowScreenState();
}

class _SurveyFlowScreenState extends State<SurveyFlowScreen> {
  int currentIndex = 0;

  void handleNext() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex += 1;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final SurveyQuestion q = widget.questions[currentIndex];
    return SurveyQuestionScreen(
      appTitle: widget.appTitle,
      question: q.question,
      subtitle: q.subtitle,
      options: q.options,
      nextLabel: widget.nextLabel,
      onNext: handleNext,
    );
  }
}

class SurveyFlowRemoteScreen extends StatefulWidget {
  const SurveyFlowRemoteScreen({super.key, this.appTitle = 'Wello'});

  final String appTitle;

  @override
  State<SurveyFlowRemoteScreen> createState() => _SurveyFlowRemoteScreenState();
}

class _SurveyFlowRemoteScreenState extends State<SurveyFlowRemoteScreen> with SingleTickerProviderStateMixin {
  final SurveyService _service = SurveyService();
  bool _loading = true;
  List<QuestionModel> _questions = const [];
  final Map<int, int> _answers = {};
  int _index = 0;
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat(reverse: true);
    _load();
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final qs = await _service.getActiveQuestions();
      setState(() {
        _questions = qs;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải câu hỏi: $e')));
    }
  }

  Future<void> _submit() async {
    try {
      await _service.submitAnswers(
        _answers.entries.map((e) => AnswerItem(questionId: e.key, optionId: e.value)).toList(),
      );
      final plan = await _service.generatePlan();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Plan: ${plan.goal}')));
      Navigator.of(context).maybePop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gửi câu trả lời thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_questions.isEmpty) {
      return const Scaffold(body: Center(child: Text('Chưa có câu hỏi')));
    }
    final q = _questions[_index];
    final bool isLast = _index == _questions.length - 1;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () {
            if (_index > 0) setState(() => _index -= 1);
          },
        ),
        title: null,
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (context, child) {
                      final double dy = math.sin(_floatCtrl.value * 2 * math.pi) * 6;
                      return Transform.translate(offset: Offset(0, dy), child: child);
                    },
                    child: _GradientText(
                      'Wello',
                      style: GoogleFonts.pacifico(
                        fontSize: 40,
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
                  const SizedBox(height: 8),
                  _QuestionCard(
                    question: q,
                    selectedOptionId: _answers[q.id],
                    onSelect: (optId) => setState(() => _answers[q.id] = optId),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _answers[q.id] == null
                          ? null
                          : () {
                              if (isLast) {
                                _submit();
                              } else {
                                setState(() => _index += 1);
                              }
                            },
                      child: Text(isLast ? 'HOÀN THÀNH' : 'NEXT'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question, required this.selectedOptionId, required this.onSelect});

  final QuestionModel question;
  final int? selectedOptionId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = AppTheme.primaryBlue;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          question.content,
          textAlign: TextAlign.center,
          style: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.w700, height: 1.35, color: Colors.black87),
        ),
        const SizedBox(height: 16),
        for (final o in question.options) ...[
          _OptionTile(
            label: o.label,
            selected: selectedOptionId == o.id,
            onTap: () => onSelect(o.id),
            primaryBlue: primaryBlue,
          ),
          const SizedBox(height: 12),
        ],
      ]),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.selected, required this.onTap, required this.primaryBlue});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color primaryBlue;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? primaryBlue.withValues(alpha: 0.08) : const Color(0xFFF7F8FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? primaryBlue : Colors.black.withValues(alpha: 0.08), width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? primaryBlue : Colors.transparent,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: primaryBlue, width: 1.6),
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.beVietnamPro(fontSize: 14, color: Colors.black.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


