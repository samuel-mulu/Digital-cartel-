import 'package:flutter/material.dart';

import 'app_i18n.dart';

/// Full-screen splash that scales on every device (no cropped PNG).
class FriendsBingoSplashView extends StatelessWidget {
  const FriendsBingoSplashView({
    super.key,
    required this.language,
    this.showLoader = true,
  });

  final AppLanguage language;
  final bool showLoader;

  static const Color _purpleDeep = Color(0xFF311B92);
  static const Color _purpleMid = Color(0xFF4A148C);
  static const Color _purpleLight = Color(0xFF6A1B9A);
  static const Color _gold = Color(0xFFFFD54F);

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n(language);
    final size = MediaQuery.sizeOf(context);
    final titleSize = (size.width * 0.11).clamp(28.0, 42.0);

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_purpleLight, _purpleMid, _purpleDeep],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _BingoGridBackdrop(opacity: 0.08),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Image.asset(
                    'assets/images/logo.webp',
                    height: (size.height * 0.14).clamp(72.0, 120.0),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.casino,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    i18n.t('app_name'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      height: 1.1,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Color(0xAA000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                        Shadow(
                          color: Color(0x66FFD54F),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _BingoLetterBalls(),
                  const SizedBox(height: 16),
                  Text(
                    i18n.t('splash_tagline'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                      fontWeight: FontWeight.w600,
                      color: _gold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(flex: 3),
                  if (showLoader)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BingoLetterBalls extends StatelessWidget {
  const _BingoLetterBalls();

  static const List<String> _letters = ['B', 'I', 'N', 'G', 'O'];
  static const List<Color> _ballColors = [
    Color(0xFF1565C0),
    Color(0xFFC62828),
    Color(0xFFF5F5F5),
    Color(0xFF2E7D32),
    Color(0xFFF9A825),
  ];

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_letters.length, (index) {
          final isLightBall = index == 2;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _ballColors[index],
                border: Border.all(
                  color: isLightBall ? Colors.grey.shade400 : Colors.white24,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                _letters[index],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isLightBall ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BingoGridBackdrop extends StatelessWidget {
  const _BingoGridBackdrop({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GridPainter(opacity: opacity),
        size: Size.infinite,
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter({required this.opacity});

  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..strokeWidth = 1;

    const cols = 5;
    const rows = 5;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    for (int c = 0; c <= cols; c++) {
      final x = c * cellW;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (int r = 0; r <= rows; r++) {
      final y = r * cellH;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
