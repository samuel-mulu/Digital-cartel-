import 'package:flutter/material.dart';

import 'app_i18n.dart';

/// Full-screen splash that scales on every device (no cropped PNG).
class GeezBingoSplashView extends StatelessWidget {
  const GeezBingoSplashView({
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
                  const SizedBox(height: 36),
                  const _AnimatedBingoBalls(),
                  const SizedBox(height: 20),
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

class _AnimatedBingoBalls extends StatefulWidget {
  const _AnimatedBingoBalls();

  @override
  State<_AnimatedBingoBalls> createState() => _AnimatedBingoBallsState();
}

class _AnimatedBingoBallsState extends State<_AnimatedBingoBalls>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _pulseController;

  static const List<String> _letters = ['B', 'I', 'N', 'G', 'O'];
  static const List<Color> _ballColors = [
    Color(0xFF1565C0), // B — blue
    Color(0xFFC62828), // I — red
    Color(0xFFF5F5F5), // N — white
    Color(0xFFFFD54F), // G — gold (ግእዝ highlight)
    Color(0xFF2E7D32), // O — green
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _entranceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_letters.length, (index) {
          final isG = index == 3;
          final isLight = index == 2 || index == 3;
          final start = 0.13 * index;
          final end = (start + 0.55).clamp(0.0, 1.0);

          final scaleAnim = CurvedAnimation(
            parent: _entranceController,
            curve: Interval(start, end, curve: Curves.elasticOut),
          );
          final fadeAnim = CurvedAnimation(
            parent: _entranceController,
            curve: Interval(
              start,
              (start + 0.28).clamp(0.0, 1.0),
              curve: Curves.easeIn,
            ),
          );

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: isG ? 8 : 5),
            child: AnimatedBuilder(
              animation: isG
                  ? Listenable.merge([_entranceController, _pulseController])
                  : _entranceController,
              builder: (context, child) {
                final pulse =
                    isG ? 1.0 + (_pulseController.value * 0.08) : 1.0;
                return Opacity(
                  opacity: fadeAnim.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: scaleAnim.value * pulse,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: isG ? 62 : 46,
                height: isG ? 62 : 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _ballColors[index],
                  border: Border.all(
                    color: isG
                        ? const Color(0xFFFF8F00)
                        : (isLight
                            ? Colors.grey.shade400
                            : Colors.white24),
                    width: isG ? 3.5 : 2,
                  ),
                  boxShadow: isG
                      ? const [
                          BoxShadow(
                            color: Color(0xAAFFD54F),
                            blurRadius: 18,
                            spreadRadius: 3,
                            offset: Offset(0, 2),
                          ),
                          BoxShadow(
                            color: Color(0x55000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : const [
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
                    fontSize: isG ? 26 : 22,
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.black87 : Colors.white,
                  ),
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
