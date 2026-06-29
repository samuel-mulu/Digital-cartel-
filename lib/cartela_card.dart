import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'app_i18n.dart';
import 'game_rules.dart';

class CartelaCard extends StatefulWidget {
  const CartelaCard({
    super.key,
    required this.cartelaNumber,
    required this.cartela,
    required this.totalCartelas,
    required this.isFirstPlace,
    required this.isInLandscape,
    required this.screenWidth,
    required this.selectedGameRule,
    required this.language,
    required this.onRemove,
    required this.onReset,
    required this.onCellMarkChanged,
  });

  final String cartelaNumber;
  final Map<String, List<dynamic>> cartela;
  final int totalCartelas;
  final bool isFirstPlace;
  final bool isInLandscape;
  final double screenWidth;
  final GameRule selectedGameRule;
  final AppLanguage language;
  final VoidCallback onRemove;
  final VoidCallback onReset;
  final void Function(String column, String value, bool newState)
      onCellMarkChanged;

  @override
  State<CartelaCard> createState() => _CartelaCardState();
}

class _CartelaCardState extends State<CartelaCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _oneAwayBlinkController;
  bool _wasBingo = false;

  @override
  void initState() {
    super.initState();
    _oneAwayBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
  }

  @override
  void dispose() {
    _oneAwayBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSingleCartela = widget.totalCartelas == 1;
    final int markedCount = (widget.cartela['marked'] as List<bool>)
        .where((marked) => marked)
        .length;
    final GameResult gameResult =
        evaluateCartelaForGame(widget.cartela, widget.selectedGameRule);
    final bool hasGameBingo = gameResult.isBingo;
    final bool isOneAway = gameResult.isOneAway;
    final bool showStatusBadge = hasGameBingo || isOneAway;
    final Set<int> oneAwayCellIndexes = gameResult.oneAwayCellIndexes.toSet();
    final List<WinPattern> completedPatterns = selectWinningPatternsForDisplay(
      widget.cartela,
      widget.selectedGameRule,
    );
    _syncOneAwayBlink(isOneAway);
    _vibrateWhenBingoStarts(hasGameBingo);

    return Container(
      width: widget.isInLandscape
          ? widget.screenWidth * 0.25
          : (isSingleCartela ? 180 : 120),
      height: widget.isInLandscape ? widget.screenWidth * 0.35 : null,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        border: Border.all(
          color: widget.isFirstPlace ? Colors.amber : Colors.deepPurpleAccent,
          width: widget.isFirstPlace ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: widget.isFirstPlace
              ? [Colors.amber.shade100, Colors.amber.shade300]
              : [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.isFirstPlace
                ? Colors.amber.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.3),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(markedCount),
              _buildColumnLabels(),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Stack(
                    children: [
                      _buildCellsGrid(oneAwayCellIndexes),
                      if (completedPatterns.isNotEmpty)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _WinningPatternPainter(
                                winningPatterns: completedPatterns,
                                crossAxisSpacing: widget.isInLandscape ? 1 : 4,
                                mainAxisSpacing: widget.isInLandscape ? 2 : 6,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (showStatusBadge) _buildStatusBadge(hasGameBingo: hasGameBingo),
        ],
      ),
    );
  }

  void _syncOneAwayBlink(bool shouldBlink) {
    if (shouldBlink) {
      if (!_oneAwayBlinkController.isAnimating) {
        _oneAwayBlinkController.repeat(reverse: true);
      }
      return;
    }

    if (_oneAwayBlinkController.isAnimating) {
      _oneAwayBlinkController.stop();
    }
    if (_oneAwayBlinkController.value != 0) {
      _oneAwayBlinkController.value = 0;
    }
  }

  void _vibrateWhenBingoStarts(bool hasGameBingo) {
    if (hasGameBingo && !_wasBingo) {
      _wasBingo = true;
      _vibrateSafely();
      return;
    }

    if (!hasGameBingo) {
      _wasBingo = false;
    }
  }

  Future<void> _vibrateSafely() async {
    try {
      final bool canVibrate = await Vibration.hasVibrator();
      if (!canVibrate) {
        return;
      }
      final bool hasAmplitudeControl = await Vibration.hasAmplitudeControl();
      if (hasAmplitudeControl) {
        await Vibration.vibrate(
          pattern: const [0, 700, 180, 900, 180, 1200],
          intensities: const [0, 255, 0, 255, 0, 255],
        );
      } else {
        await Vibration.vibrate(
          pattern: const [0, 700, 180, 900, 180, 1200],
        );
      }
    } catch (_) {
      // Some platforms or browsers do not allow vibration; ignore safely.
    }
  }

  Widget _buildHeader(int markedCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        children: [
          if (widget.isFirstPlace)
            const Icon(
              Icons.emoji_events,
              color: Colors.amber,
              size: 16,
            ),
          if (widget.isFirstPlace) const SizedBox(width: 2),
          Expanded(
            child: Row(
              children: [
                Text(
                  "NO=${widget.cartelaNumber}",
                  style: TextStyle(
                    fontSize: widget.isInLandscape ? 11 : 13,
                    fontWeight: FontWeight.bold,
                    color: widget.isFirstPlace
                        ? Colors.amber.shade900
                        : Colors.deepPurple,
                  ),
                ),
                Text(
                  " ($markedCount)",
                  style: TextStyle(
                    fontSize: widget.isInLandscape ? 9 : 11,
                    fontWeight: FontWeight.bold,
                    color: widget.isFirstPlace
                        ? Colors.amber.shade900
                        : Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onRemove,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.delete,
                size: 16,
                color: widget.isFirstPlace
                    ? Colors.amber.shade900
                    : Colors.deepPurple,
              ),
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: widget.onReset,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.refresh,
                size: 14,
                color: widget.isFirstPlace
                    ? Colors.amber.shade900
                    : Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnLabels() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ['B', 'I', 'N', 'G', 'O'].map((label) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: widget.isInLandscape ? 12 : 14,
                fontWeight: FontWeight.bold,
                color: widget.isFirstPlace
                    ? Colors.amber.shade900
                    : Colors.deepPurple,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCellsGrid(Set<int> oneAwayCellIndexes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: widget.isInLandscape ? 1 : 4,
        mainAxisSpacing: widget.isInLandscape ? 2 : 6,
        childAspectRatio: widget.isInLandscape ? 0.9 : 1,
      ),
      itemCount: 25,
      itemBuilder: (context, index) {
        final String cellValue = _getCellValue(index);
        final bool isMarked = widget.cartela['marked']?[index] ?? false;
        final Color cellColor = (index == 12)
            ? Colors.orange
            : isMarked
                ? Colors.orange
                : Colors.white;
        final bool isNeededOneAwayCell = oneAwayCellIndexes.contains(index);
        final Text cellText = Text(
          cellValue,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: widget.isInLandscape ? 14 : 17,
          ),
        );

        return GestureDetector(
          onTap: () {
            if (index != 12 && cellValue.isNotEmpty) {
              final int columnIndex = index % 5;
              final String column = ['B', 'I', 'N', 'G', 'O'][columnIndex];
              final bool currentState =
                  widget.cartela['marked']?[index] ?? false;
              final bool newState = !currentState;

              widget.onCellMarkChanged(column, cellValue, newState);
            }
          },
          child: isNeededOneAwayCell
              ? AnimatedBuilder(
                  animation: _oneAwayBlinkController,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          Colors.white,
                          Colors.redAccent,
                          _oneAwayBlinkController.value,
                        ),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: cellText,
                )
              : Container(
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: Colors.deepPurpleAccent,
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: cellText,
                ),
        );
      },
    );
  }

  Widget _buildStatusBadge({required bool hasGameBingo}) {
    final i18n = AppI18n(widget.language);
    return Positioned(
      left: 0,
      right: 0,
      bottom: widget.isInLandscape ? -12 : -14,
      child: IgnorePointer(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: hasGameBingo
                  ? (widget.isFirstPlace
                      ? Colors.amber.shade900
                      : Colors.green.shade700)
                  : Colors.red.shade700,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasGameBingo
                      ? Icons.emoji_events
                      : Icons.notifications_active,
                  color: Colors.white,
                  size: widget.isInLandscape ? 15 : 18,
                  semanticLabel: hasGameBingo
                      ? '${AppI18n.catalogDisplayName(widget.selectedGameRule.name)} Bingo'
                      : '${AppI18n.catalogDisplayName(widget.selectedGameRule.name)} one away',
                ),
                const SizedBox(width: 4),
                Text(
                  hasGameBingo ? i18n.t('bingo') : i18n.t('one_away'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widget.isInLandscape ? 12 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCellValue(int index) {
    final List<String> columns = ['B', 'I', 'N', 'G', 'O'];
    final int columnIndex = index % 5;
    final int rowIndex = index ~/ 5;

    if (columnIndex == 2 && rowIndex == 2) return "FREE";

    return widget.cartela[columns[columnIndex]]?[rowIndex]?.toString() ?? "";
  }
}

class _WinningPatternPainter extends CustomPainter {
  const _WinningPatternPainter({
    required this.winningPatterns,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
  });

  final List<WinPattern> winningPatterns;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    if (winningPatterns.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    final double cellWidth = (size.width - (crossAxisSpacing * 4)) / 5;
    final double cellHeight = (size.height - (mainAxisSpacing * 4)) / 5;
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    Offset cellCenter(int index) {
      final int row = index ~/ 5;
      final int col = index % 5;

      return Offset(
        col * (cellWidth + crossAxisSpacing) + (cellWidth / 2),
        row * (cellHeight + mainAxisSpacing) + (cellHeight / 2),
      );
    }

    final Set<String> drawnEdges = {};

    void drawEdge(int from, int to) {
      final int a = from < to ? from : to;
      final int b = from < to ? to : from;
      final key = '$a-$b';
      if (!drawnEdges.add(key)) {
        return;
      }
      canvas.drawLine(cellCenter(from), cellCenter(to), paint);
    }

    for (final pattern in winningPatterns) {
      final Set<int> patternCells = pattern.cellIndexes.toSet();

      if (_drawTriangleOutlineIfNeeded(
        pattern: pattern,
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }
      if (_drawBigYIfNeeded(
        pattern: pattern,
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }
      if (_drawBigNIfNeeded(
        pattern: pattern,
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }
      if (_drawSmallHIfNeeded(
        pattern: pattern,
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }
      if (_drawSmallXIfNeeded(
        pattern: pattern,
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }
      if (_drawStraightBingoLineIfNeeded(
        patternCells: patternCells,
        drawEdge: drawEdge,
      )) {
        continue;
      }

      for (final cell in patternCells) {
        final int row = cell ~/ 5;
        final int col = cell % 5;

        for (final (dRow, dCol) in const [
          (0, 1), // right
          (1, 0), // down
        ]) {
          final int nextRow = row + dRow;
          final int nextCol = col + dCol;
          if (nextRow < 0 || nextRow > 4 || nextCol < 0 || nextCol > 4) {
            continue;
          }
          final int nextCell = (nextRow * 5) + nextCol;
          if (patternCells.contains(nextCell)) {
            drawEdge(cell, nextCell);
          }
        }
      }
    }

    // Draw dots for standalone winning cells not connected by lines.
    if (drawnEdges.isEmpty) {
      for (final pattern in winningPatterns) {
        for (final cell in pattern.cellIndexes) {
          canvas.drawCircle(cellCenter(cell), 5, paint);
        }
      }
    }
  }

  bool _drawTriangleOutlineIfNeeded({
    required WinPattern pattern,
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    final bool isTriangle = pattern.patternGroup == triangleShapeGroup ||
        pattern.name.toLowerCase().contains('triangle');
    if (!isTriangle || patternCells.length != 6) {
      return false;
    }

    final rows = patternCells.map((index) => index ~/ 5).toList();
    final cols = patternCells.map((index) => index % 5).toList();
    final int minRow = rows.reduce((a, b) => a < b ? a : b);
    final int maxRow = rows.reduce((a, b) => a > b ? a : b);
    final int minCol = cols.reduce((a, b) => a < b ? a : b);
    final int maxCol = cols.reduce((a, b) => a > b ? a : b);

    if (maxRow - minRow != 2 || maxCol - minCol != 2) {
      return false;
    }

    List<int> rowCounts = List<int>.generate(
      3,
      (i) => patternCells.where((index) => (index ~/ 5) == (minRow + i)).length,
    );
    List<int> colCounts = List<int>.generate(
      3,
      (i) => patternCells.where((index) => (index % 5) == (minCol + i)).length,
    );

    int indexAt(int row, int col) => (row * 5) + col;

    late final List<int> corners;
    if (_sameCounts(rowCounts, const [3, 2, 1]) &&
        _sameCounts(colCounts, const [3, 2, 1])) {
      // Top-left triangle.
      corners = [
        indexAt(minRow, minCol),
        indexAt(minRow, maxCol),
        indexAt(maxRow, minCol),
      ];
    } else if (_sameCounts(rowCounts, const [3, 2, 1]) &&
        _sameCounts(colCounts, const [1, 2, 3])) {
      // Top-right triangle.
      corners = [
        indexAt(minRow, minCol),
        indexAt(minRow, maxCol),
        indexAt(maxRow, maxCol),
      ];
    } else if (_sameCounts(rowCounts, const [1, 2, 3]) &&
        _sameCounts(colCounts, const [3, 2, 1])) {
      // Bottom-left triangle.
      corners = [
        indexAt(minRow, minCol),
        indexAt(maxRow, minCol),
        indexAt(maxRow, maxCol),
      ];
    } else if (_sameCounts(rowCounts, const [1, 2, 3]) &&
        _sameCounts(colCounts, const [1, 2, 3])) {
      // Bottom-right triangle.
      corners = [
        indexAt(minRow, maxCol),
        indexAt(maxRow, minCol),
        indexAt(maxRow, maxCol),
      ];
    } else {
      return false;
    }

    if (!corners.every(patternCells.contains)) {
      return false;
    }

    drawEdge(corners[0], corners[1]);
    drawEdge(corners[1], corners[2]);
    drawEdge(corners[2], corners[0]);
    return true;
  }

  bool _sameCounts(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static const Set<int> _mainDiagonalCells = {0, 6, 12, 18, 24};
  static const Set<int> _antiDiagonalCells = {4, 8, 12, 16, 20};
  static const List<int> _mainDiagonalOrdered = [0, 6, 12, 18, 24];
  static const List<int> _antiDiagonalOrdered = [4, 8, 12, 16, 20];

  /// 7-cell small H (two orientations, like mini BIG H).
  bool _drawSmallHIfNeeded({
    required WinPattern pattern,
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    if (patternCells.length != 7) {
      return false;
    }
    if (pattern.patternGroup != smallHShapeGroup &&
        !pattern.name.contains(smallHGameName)) {
      return false;
    }

    final rows = patternCells.map((index) => index ~/ 5).toList()..sort();
    final cols = patternCells.map((index) => index % 5).toList()..sort();
    final int minRow = rows.first;
    final int maxRow = rows.last;
    final int minCol = cols.first;
    final int maxCol = cols.last;
    if (maxRow - minRow != 2 || maxCol - minCol != 2) {
      return false;
    }

    int at(int row, int col) => (row * 5) + col;

    final leftCol = {at(minRow, minCol), at(minRow + 1, minCol), at(minRow + 2, minCol)};
    final rightCol = {
      at(minRow, maxCol),
      at(minRow + 1, maxCol),
      at(minRow + 2, maxCol),
    };
    final topRow = {at(minRow, minCol), at(minRow, minCol + 1), at(minRow, maxCol)};
    final midRow = {
      at(minRow + 1, minCol),
      at(minRow + 1, minCol + 1),
      at(minRow + 1, maxCol),
    };
    final bottomRow = {
      at(minRow + 2, minCol),
      at(minRow + 2, minCol + 1),
      at(minRow + 2, maxCol),
    };

    final bool isSides = leftCol.every(patternCells.contains) &&
        rightCol.every(patternCells.contains) &&
        midRow.every(patternCells.contains);
    final bool isTopBottom = topRow.every(patternCells.contains) &&
        bottomRow.every(patternCells.contains) &&
        patternCells.contains(at(minRow + 1, minCol + 1));

    if (isSides) {
      drawEdge(at(minRow, minCol), at(minRow + 2, minCol));
      drawEdge(at(minRow, maxCol), at(minRow + 2, maxCol));
      drawEdge(at(minRow + 1, minCol), at(minRow + 1, maxCol));
      return true;
    }
    if (isTopBottom) {
      drawEdge(at(minRow, minCol), at(minRow, maxCol));
      drawEdge(at(minRow + 2, minCol), at(minRow + 2, maxCol));
      drawEdge(at(minRow, minCol + 1), at(minRow + 2, minCol + 1));
      return true;
    }

    return false;
  }

  /// 5-cell small X: diagonal legs only (no orthogonal grid lines).
  bool _drawSmallXIfNeeded({
    required WinPattern pattern,
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    if (patternCells.length != 5) {
      return false;
    }
    if (pattern.patternGroup != smallXShapeGroup &&
        !pattern.name.contains(smallXShapeGroup)) {
      return false;
    }

    final rows = patternCells.map((index) => index ~/ 5).toList()..sort();
    final cols = patternCells.map((index) => index % 5).toList()..sort();
    final int minRow = rows.first;
    final int maxRow = rows.last;
    final int minCol = cols.first;
    final int maxCol = cols.last;
    if (maxRow - minRow != 2 || maxCol - minCol != 2) {
      return false;
    }

    int at(int row, int col) => (row * 5) + col;

    final topLeft = at(minRow, minCol);
    final topRight = at(minRow, maxCol);
    final bottomLeft = at(maxRow, minCol);
    final bottomRight = at(maxRow, maxCol);
    final center = at(minRow + 1, minCol + 1);

    if (!patternCells.containsAll(
      {topLeft, topRight, bottomLeft, bottomRight, center},
    )) {
      return false;
    }

    drawEdge(topLeft, bottomRight);
    drawEdge(topRight, bottomLeft);
    return true;
  }

  /// BIG N / BIG H: full rows/columns (and full diagonals when all marked).
  bool _drawBigNIfNeeded({
    required WinPattern pattern,
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    if (!pattern.name.contains(bigNShapeGameName) &&
        !pattern.name.contains(bigHShapeGameName)) {
      return false;
    }

    var drewAny = false;

    void drawLineIfAllPresent(List<int> cells) {
      if (cells.length < 2) {
        return;
      }
      if (cells.every(patternCells.contains)) {
        drawEdge(cells.first, cells.last);
        drewAny = true;
      }
    }

    for (int row = 0; row < 5; row++) {
      drawLineIfAllPresent(List.generate(5, (col) => (row * 5) + col));
    }
    for (int col = 0; col < 5; col++) {
      drawLineIfAllPresent(List.generate(5, (row) => (row * 5) + col));
    }

    void drawDiagonalMarkedOnly(List<int> diagonal) {
      if (diagonal.every(patternCells.contains)) {
        drawEdge(diagonal.first, diagonal.last);
        drewAny = true;
        return;
      }
      // Only connect consecutive marked cells — never span unmarked squares.
      for (int i = 0; i < diagonal.length - 1; i++) {
        final int a = diagonal[i];
        final int b = diagonal[i + 1];
        if (patternCells.contains(a) && patternCells.contains(b)) {
          drawEdge(a, b);
          drewAny = true;
        }
      }
    }

    drawDiagonalMarkedOnly(_mainDiagonalOrdered);
    drawDiagonalMarkedOnly(_antiDiagonalOrdered);

    return drewAny;
  }

  /// Full row, column, or diagonal — one continuous line (like BIG N branches).
  bool _drawStraightBingoLineIfNeeded({
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    if (patternCells.length != 5) {
      return false;
    }

    final rows = patternCells.map((index) => index ~/ 5).toSet();
    if (rows.length == 1) {
      final row = rows.first;
      drawEdge(row * 5, (row * 5) + 4);
      return true;
    }

    final cols = patternCells.map((index) => index % 5).toSet();
    if (cols.length == 1) {
      final col = cols.first;
      drawEdge(col, 20 + col);
      return true;
    }

    if (patternCells.containsAll(_mainDiagonalCells)) {
      drawEdge(_mainDiagonalOrdered.first, _mainDiagonalOrdered.last);
      return true;
    }

    if (patternCells.containsAll(_antiDiagonalCells)) {
      drawEdge(_antiDiagonalOrdered.first, _antiDiagonalOrdered.last);
      return true;
    }

    return false;
  }

  bool _drawBigYIfNeeded({
    required WinPattern pattern,
    required Set<int> patternCells,
    required void Function(int from, int to) drawEdge,
  }) {
    if (!pattern.name.toLowerCase().contains(bigYShapeGameName.toLowerCase())) {
      return false;
    }

    // BIG Y patterns include diagonal branches; draw those explicit branches.
    final rowCounts = <int, int>{};
    for (final cell in patternCells) {
      final row = cell ~/ 5;
      rowCounts[row] = (rowCounts[row] ?? 0) + 1;
    }
    final List<int> centerCandidates = [
      for (final cell in patternCells)
        if ((rowCounts[cell ~/ 5] ?? 0) >= 2) cell,
    ];
    if (centerCandidates.isEmpty) {
      return false;
    }
    final int center = centerCandidates.first;
    final int centerRow = center ~/ 5;
    final int centerCol = center % 5;

    bool connectedByStep(int from, int to) {
      final r1 = from ~/ 5;
      final c1 = from % 5;
      final r2 = to ~/ 5;
      final c2 = to % 5;
      final dr = (r1 - r2).abs();
      final dc = (c1 - c2).abs();
      return dr <= 1 && dc <= 1 && (dr + dc) > 0;
    }

    final remaining = patternCells.where((cell) => cell != center).toList();
    remaining.sort((a, b) {
      final da = ((a ~/ 5) - centerRow).abs() + ((a % 5) - centerCol).abs();
      final db = ((b ~/ 5) - centerRow).abs() + ((b % 5) - centerCol).abs();
      return da.compareTo(db);
    });

    for (final cell in remaining) {
      int? bestFrom;
      int bestDist = 999;
      for (final candidate in [center, ...remaining]) {
        if (candidate == cell) continue;
        if (!patternCells.contains(candidate)) continue;
        if (!connectedByStep(candidate, cell)) continue;
        final dist = ((candidate ~/ 5) - centerRow).abs() +
            ((candidate % 5) - centerCol).abs();
        if (dist < bestDist) {
          bestDist = dist;
          bestFrom = candidate;
        }
      }
      if (bestFrom != null) {
        drawEdge(bestFrom, cell);
      }
    }

    return true;
  }

  @override
  bool shouldRepaint(_WinningPatternPainter oldDelegate) {
    return oldDelegate.winningPatterns != winningPatterns ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing;
  }
}
