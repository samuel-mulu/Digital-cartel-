import 'package:flutter_test/flutter_test.dart';

import 'package:bingo_application_1/app_i18n.dart';
import 'package:bingo_application_1/game_rules.dart';

Map<String, List<dynamic>> cartelaWithMarked(Iterable<int> markedIndexes) {
  final markedSet = markedIndexes.toSet();
  return {
    'B': const <int>[1, 2, 3, 4, 5],
    'I': const <int>[16, 17, 18, 19, 20],
    'N': const <dynamic>[31, 32, 'FREE', 34, 35],
    'G': const <int>[46, 47, 48, 49, 50],
    'O': const <int>[61, 62, 63, 64, 65],
    'marked': List<bool>.generate(25, markedSet.contains),
  };
}

void main() {
  test('all registered game rules are valid', () {
    expect(validateAvailableGameRules(), isEmpty);
  });

  test('FREE center counts as marked for Half House', () {
    final topThreeRowsWithoutFree = {
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      13,
      14,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(topThreeRowsWithoutFree),
      halfHouseGameRule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningCellIndexes, contains(12));
  });

  test('FULL-HOUSE detects one away and the missing cell', () {
    final allExceptFive = {
      for (int index = 0; index < 25; index++)
        if (index != 5 && index != 12) index,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(allExceptFive),
      fullHouseGameRule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isTrue);
    expect(result.oneAwayCellIndexes, [5]);
  });

  test('Square count requires non-overlapping squares', () {
    final threeSquares = {
      0,
      1,
      5,
      6,
      3,
      4,
      8,
      9,
      15,
      16,
      20,
      21,
    };
    final rule = buildActiveGameRule(
      rectangleGameRule,
      defaultTiezazPatternGroups,
      rectangleCount: 3,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeSquares),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.requiredCount, 12);
    expect(result.winningPatterns, hasLength(3));
  });

  test('Rectangule requires two non-overlapping 6-cell rectangles', () {
    final twoRectangules = {
      0,
      1,
      5,
      6,
      10,
      11,
      13,
      14,
      18,
      19,
      23,
      24,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoRectangules),
      rectanguleGameRule,
    );

    expect(result.isBingo, isTrue);
    expect(result.requiredCount, 12);
    expect(result.winningPatterns, hasLength(defaultRectanguleCount));
  });

  test('Rectangule also supports horizontal (row) rectangles', () {
    final twoHorizontalRectangules = {
      // Top-left 2x3
      0, 1, 2, 5, 6, 7,
      // Bottom-right 2x3
      17, 18, 19, 22, 23, 24,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoHorizontalRectangules),
      rectanguleGameRule,
    );

    expect(result.isBingo, isTrue);
    expect(result.requiredCount, 12);
    expect(result.winningPatterns, hasLength(defaultRectanguleCount));
  });

  test('Rectangule does not win when the two shapes overlap', () {
    final overlappingRectangules = {
      0,
      1,
      5,
      6,
      10,
      11,
      2,
      7,
      12,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(overlappingRectangules),
      rectanguleGameRule,
    );

    expect(result.isBingo, isFalse);
    expect(result.winningPatterns, isEmpty);
  });

  test('Rectangule supports selecting up to 3', () {
    final twoRectangules = {
      0,
      1,
      5,
      6,
      10,
      11,
      13,
      14,
      18,
      19,
      23,
      24,
    };
    final rule = buildActiveGameRule(
      rectanguleGameRule,
      defaultTiezazPatternGroups,
      rectanguleCount: 3,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoRectangules),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('Columns game supports selecting up to 4 columns', () {
    final fourColumns = {
      // Columns 0,1,2,3 across all rows.
      0, 1, 2, 3,
      5, 6, 7, 8,
      10, 11, 12, 13,
      15, 16, 17, 18,
      20, 21, 22, 23,
    };
    final rule = buildActiveGameRule(
      columnsGameRule,
      defaultTiezazPatternGroups,
      columnsCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourColumns),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(4));
  });

  test('Columns game does not win if selected column count not reached', () {
    final threeColumns = {
      0,
      1,
      2,
      5,
      6,
      7,
      10,
      11,
      12,
      15,
      16,
      17,
      20,
      21,
      22,
    };
    final rule = buildActiveGameRule(
      columnsGameRule,
      defaultTiezazPatternGroups,
      columnsCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeColumns),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('Rows game supports selecting up to 4 rows', () {
    final fourRows = {
      // Rows 0,1,2,3 across all columns.
      0, 1, 2, 3, 4,
      5, 6, 7, 8, 9,
      10, 11, 12, 13, 14,
      15, 16, 17, 18, 19,
    };
    final rule = buildActiveGameRule(
      rowsGameRule,
      defaultTiezazPatternGroups,
      rowsCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourRows),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(4));
  });

  test('Rows game does not win if selected row count not reached', () {
    final threeRows = {
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
    };
    final rule = buildActiveGameRule(
      rowsGameRule,
      defaultTiezazPatternGroups,
      rowsCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeRows),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('Diagonal game supports selecting both diagonals (max 2)', () {
    final twoDiagonals = {
      0,
      4,
      6,
      8,
      12,
      16,
      18,
      20,
      24,
    };
    final rule = buildActiveGameRule(
      diagonalGameRule,
      defaultTiezazPatternGroups,
      diagonalCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoDiagonals),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(2));
  });

  test('Diagonal game does not win if second diagonal is missing', () {
    final oneDiagonal = {
      0,
      6,
      12,
      18,
      24,
    };
    final rule = buildActiveGameRule(
      diagonalGameRule,
      defaultTiezazPatternGroups,
      diagonalCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneDiagonal),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('Diagonal display keeps progressive completed patterns', () {
    final oneDiagonalComplete = {
      // Left-to-right diagonal complete.
      0, 6, 12, 18, 24,
    };
    final twoDiagonalsComplete = {
      // Both diagonals complete.
      0, 4, 6, 8, 12, 16, 18, 20, 24,
    };

    final rule = buildActiveGameRule(
      diagonalGameRule,
      defaultTiezazPatternGroups,
      diagonalCount: 2,
    );

    final firstDisplay = selectWinningPatternsForDisplay(
      cartelaWithMarked(oneDiagonalComplete),
      rule,
    );
    final secondDisplay = selectWinningPatternsForDisplay(
      cartelaWithMarked(twoDiagonalsComplete),
      rule,
    );

    expect(firstDisplay, hasLength(1));
    expect(secondDisplay, hasLength(2));
  });

  test('LIne touches free supports up to 4 center-touching lines', () {
    final fourCenterLines = {
      // Center column
      2, 7, 12, 17, 22,
      // Center row
      10, 11, 13, 14,
      // Main diagonal
      0, 6, 18, 24,
      // Anti diagonal
      4, 8, 16, 20,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourCenterLines),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(4));
  });

  test('LIne touches free ignores non-center lines', () {
    final threeLinesWithoutFreeLine = {
      // Row 1 + Column 1 + Column 2, but no completed row 3/column 3.
      0, 1, 2, 3, 4,
      5, 10, 15, 20,
      6, 11, 16, 21,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 3,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeLinesWithoutFreeLine),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('LIne touches free counts only center row/column/diagonals', () {
    final threeConnectedLines = {
      // Center column
      2, 7, 12, 17, 22,
      // Center row
      10, 11, 13, 14,
      // Anti diagonal
      4, 8, 16, 20,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 3,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeConnectedLines),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(3));
  });

  test('LIne touches free allows diagonals in selected count', () {
    final threeLinesWithDiagonal = {
      // Center column
      2, 7, 12, 17, 22,
      // Center row
      10, 11, 13, 14,
      // Main diagonal
      0, 6, 18, 24,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 3,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(threeLinesWithDiagonal),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(3));
  });

  test('LIne touches free does not bingo with one line when count is two', () {
    final oneCompletedLine = {
      // Only center column complete.
      2, 7, 12, 17, 22,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneCompletedLine),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.winningPatterns, isEmpty);
  });

  test('LIne touches free one-away is based on selected count goal', () {
    final oneMissingForTwoLines = {
      // Column 3 complete.
      2, 7, 12, 17, 22,
      // Row 3 missing only O3 (index 14).
      10, 11, 13,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneMissingForTwoLines),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isTrue);
    expect(result.oneAwayCellIndexes, [14]);
  });

  test('LIne touches free does not show one-away for only one near line', () {
    final oneNearLineOnly = {
      // Center row missing only O3 (index 14), no second near-complete line.
      10, 11, 12, 13,
    };
    final rule = buildActiveGameRule(
      lineTouchesFreeGameRule,
      defaultTiezazPatternGroups,
      lineTouchesFreeCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneNearLineOnly),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isFalse);
    expect(result.oneAwayCellIndexes, isEmpty);
  });

  test('lines with out free wins with 4 non-free rows/columns', () {
    final fourNonFreeLines = {
      // Rows 1 and 2
      0, 1, 2, 3, 4,
      5, 6, 7, 8, 9,
      // Columns 1 and 2
      10, 15, 20,
      11, 16, 21,
    };
    final rule = buildActiveGameRule(
      linesWithoutFreeGameRule,
      defaultTiezazPatternGroups,
      linesWithoutFreeCount: 4,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourNonFreeLines),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(4));
  });

  test('lines with out free does not count center row/column or diagonals', () {
    final onlyExcludedLines = {
      // Center row + center column + one diagonal.
      10, 11, 12, 13, 14,
      2, 7, 17, 22,
      0, 6, 18, 24,
    };
    final rule = buildActiveGameRule(
      linesWithoutFreeGameRule,
      defaultTiezazPatternGroups,
      linesWithoutFreeCount: 1,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(onlyExcludedLines),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('lines with out free one-away is based on selected count goal', () {
    final oneLineOnlyNear = {
      // Row 1 missing only O1 (index 4).
      0, 1, 2, 3,
      // No second near-complete line.
    };
    final rule = buildActiveGameRule(
      linesWithoutFreeGameRule,
      defaultTiezazPatternGroups,
      linesWithoutFreeCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneLineOnlyNear),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isFalse);
    expect(result.oneAwayCellIndexes, isEmpty);
  });

  test('line supports mixed rows columns diagonals up to 7', () {
    final sevenLines = {
      // Rows 1 and 2
      0, 1, 2, 3, 4,
      5, 6, 7, 8, 9,
      // Columns 1, 2, and 4
      10, 15, 20,
      11, 16, 21,
      13, 18, 23,
      // Main diagonal
      12, 24,
      // Second diagonal
      14, 17,
    };
    final rule = buildActiveGameRule(
      lineGameRule,
      defaultTiezazPatternGroups,
      lineCount: 7,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(sevenLines),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(7));
  });

  test('line does not win when selected count is not reached', () {
    final sixLines = {
      // Rows 1 and 2
      0, 1, 2, 3, 4,
      5, 6, 7, 8, 9,
      // Columns 1 and 4
      10, 15, 20,
      13, 18, 23,
      // Main diagonal only
      12, 24,
    };
    final rule = buildActiveGameRule(
      lineGameRule,
      defaultTiezazPatternGroups,
      lineCount: 7,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(sixLines),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('line one-away is based on selected count goal', () {
    final oneAwayForDifferentLines = {
      // Row 1 is one-away (missing O1/index 4)
      0, 1, 2, 3,
      // Column 1 is one-away (missing B5/index 20)
      5, 10, 15,
    };
    final rule = buildActiveGameRule(
      lineGameRule,
      defaultTiezazPatternGroups,
      lineCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneAwayForDifferentLines),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isFalse);
    expect(result.oneAwayCellIndexes, isEmpty);
  });

  test('line one-away appears on final missing cell for selected goal', () {
    final oneCompleteOneNear = {
      // Row 1 complete.
      0, 1, 2, 3, 4,
      // Column 1 near-complete, missing B5/index 20.
      5, 10, 15,
    };
    final rule = buildActiveGameRule(
      lineGameRule,
      defaultTiezazPatternGroups,
      lineCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneCompleteOneNear),
      rule,
    );

    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isTrue);
    expect(result.oneAwayCellIndexes, [20]);
  });

  test('line display keeps progressive completed patterns', () {
    final oneLineComplete = {
      // One complete line: row 1.
      0, 1, 2, 3, 4,
    };
    final twoLinesComplete = {
      // Row 1 + column 1 complete.
      0, 1, 2, 3, 4,
      5, 10, 15, 20,
    };
    final rule = buildActiveGameRule(
      lineGameRule,
      defaultTiezazPatternGroups,
      lineCount: 2,
    );

    final oneLineDisplay = selectWinningPatternsForDisplay(
      cartelaWithMarked(oneLineComplete),
      rule,
    );
    final twoLineDisplay = selectWinningPatternsForDisplay(
      cartelaWithMarked(twoLinesComplete),
      rule,
    );

    expect(oneLineDisplay, hasLength(1));
    expect(twoLineDisplay, hasLength(2));
  });

  test('Pyramid supports top, bottom, left and right rotations', () {
    final pyramidPatterns = <Set<int>>[
      {2, 6, 7, 8, 10, 11, 12, 13, 14}, // Top
      {22, 16, 17, 18, 10, 11, 12, 13, 14}, // Bottom
      {10, 6, 11, 16, 2, 7, 12, 17, 22}, // Left
      {14, 8, 13, 18, 2, 7, 12, 17, 22}, // Right
    ];

    for (final cells in pyramidPatterns) {
      final result = evaluateCartelaForGame(
        cartelaWithMarked(cells),
        pyramidGameRule,
      );
      expect(result.isBingo, isTrue);
    }
  });

  test('Pyramid supports shifted positions (not fixed spot)', () {
    final shiftedTop = {
      // Top pyramid shifted down by one row.
      7,
      11,
      12,
      13,
      15,
      16,
      17,
      18,
      19,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(shiftedTop),
      pyramidGameRule,
    );

    expect(result.isBingo, isTrue);
  });

  test('Triangle requires two non-overlapping 6-cell triangles', () {
    final twoTriangles = {
      0,
      1,
      2,
      5,
      6,
      10,
      14,
      18,
      19,
      22,
      23,
      24,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoTriangles),
      triangleGameRule,
    );

    expect(result.isBingo, isTrue);
    expect(result.requiredCount, 12);
    expect(result.winningPatterns, hasLength(defaultTriangleCount));
  });

  test('Triangle supports count 1 (max 2)', () {
    final oneTriangle = {
      0,
      1,
      2,
      5,
      6,
      10,
    };
    final rule = buildActiveGameRule(
      triangleGameRule,
      defaultTiezazPatternGroups,
      triangleCount: 1,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneTriangle),
      rule,
    );
    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(1));
  });

  test('4 by 4 triangle game wins with one 4x4 triangle when count is 1', () {
    final oneTriangle4x4 = {
      // Top-left orientation in top-left 4x4 window (10 cells).
      0, 1, 2, 3,
      5, 6, 7,
      10, 11,
      15,
    };
    final rule = buildActiveGameRule(
      triangle4x4GameRule,
      defaultTiezazPatternGroups,
      triangle4x4Count: 1,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneTriangle4x4),
      rule,
    );
    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(1));
  });

  test('Triangle does not win without two complete non-overlapping shapes', () {
    final incompleteTriangles = {
      0,
      1,
      2,
      5,
      6,
      10,
      7,
      11,
      12,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(incompleteTriangles),
      triangleGameRule,
    );

    expect(result.isBingo, isFalse);
    expect(result.winningPatterns, isEmpty);
  });

  test('BIG H wins with top row, full N column, and bottom row', () {
    final hCells = {0, 1, 2, 3, 4, 7, 12, 17, 20, 21, 22, 23, 24};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(hCells),
      bigHShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG H wins with full B and O columns plus middle row', () {
    final hCells = {0, 5, 10, 11, 12, 13, 14, 15, 20, 4, 9, 19, 24};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(hCells),
      bigHShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG N wins when one N pattern is complete', () {
    final nCells = {0, 1, 2, 3, 4, 8, 12, 16, 20, 21, 22, 23, 24};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(nCells),
      bigNShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG N second pattern wins when complete', () {
    final nCells = {0, 5, 10, 15, 20, 6, 12, 18, 24, 19, 14, 9, 4};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(nCells),
      bigNShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG Y wins when one Y pattern is complete', () {
    final yCells = {0, 6, 12, 17, 22, 8, 4};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(yCells),
      bigYShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG Y right orientation wins when complete', () {
    final yCells = {0, 20, 6, 16, 12, 13, 14};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(yCells),
      bigYShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG Y bottom orientation wins when complete', () {
    final yCells = {20, 16, 12, 18, 24, 7, 2};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(yCells),
      bigYShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG Y left orientation wins when complete', () {
    final yCells = {4, 24, 8, 18, 12, 11, 10};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(yCells),
      bigYShapeGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('BIG Cross wins with full N column and third row', () {
    final crossCells = {2, 7, 12, 17, 22, 10, 11, 13, 14};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(crossCells),
      bigCrossGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('ትእዛዝ completes selected non-overlapping groups', () {
    final crossSquareAndL = {
      1,
      5,
      6,
      7,
      11,
      3,
      4,
      8,
      9,
      15,
      20,
      21,
    };
    final rule = buildActiveGameRule(
      tiezazGameRule,
      defaultTiezazPatternGroups,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(crossSquareAndL),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(3));
  });

  test('small L shape completes four non-overlapping small L patterns', () {
    final fourSmallLs = {
      0,
      5,
      6,
      3,
      8,
      9,
      15,
      20,
      21,
      18,
      23,
      24,
    };

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourSmallLs),
      smallLShapeGameRule,
    );

    expect(result.isBingo, isTrue);
    expect(result.requiredCount, 12);
    expect(result.winningPatterns, hasLength(defaultSmallLShapeCount));
  });

  test('small L supports max 5 and does not win at four when set to five', () {
    final fourSmallLs = {
      0,
      5,
      6,
      3,
      8,
      9,
      15,
      20,
      21,
      18,
      23,
      24,
    };
    final rule = buildActiveGameRule(
      smallLShapeGameRule,
      defaultTiezazPatternGroups,
      smallLCount: 5,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(fourSmallLs),
      rule,
    );

    expect(result.isBingo, isFalse);
  });

  test('small + (cross) max count is 2 and wins for 2', () {
    final twoNonOverlappingCrosses = {
      // Cross centered at I2 and cross centered at G4.
      1, 5, 6, 7, 11,
      13, 17, 18, 19, 23,
    };
    final rule = buildActiveGameRule(
      smallCrossGameRule,
      defaultTiezazPatternGroups,
      smallCrossCount: 2,
    );

    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoNonOverlappingCrosses),
      rule,
    );

    expect(result.isBingo, isTrue);
    expect(result.winningPatterns, hasLength(2));
  });

  test('small T wins with 5-cell T shape', () {
    // Top-oriented small T in the top-left 3x3 window.
    final tCells = {0, 1, 2, 6, 11};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(tCells),
      smallTGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small T supports max 4 count selection', () {
    final oneT = {0, 1, 2, 6, 11};
    final rule = buildActiveGameRule(
      smallTGameRule,
      defaultTiezazPatternGroups,
      smallTCount: 4,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneT),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small T count 2 does not allow overlapping shapes', () {
    final overlappingTwoT = {
      // T at (row 0, col 0): 0,1,2,6,11
      0, 1, 2, 6, 11,
      // T at (row 0, col 1): 1,2,3,7,12 (shares 1 and 2)
      3, 7, 12,
    };
    final rule = buildActiveGameRule(
      smallTGameRule,
      defaultTiezazPatternGroups,
      smallTCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(overlappingTwoT),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small X wins with 5-cell X shape example', () {
    // Example from request: N1 O1 G2 N3 O3
    final xCells = {2, 4, 8, 12, 14};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(xCells),
      smallXGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small X supports max 2 count selection', () {
    final oneX = {2, 4, 8, 12, 14};
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(oneX),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small X count 2 does not allow overlapping shapes', () {
    final overlappingTwoX = {
      // X at (row 0, col 0): 0,2,6,10,12
      0, 2, 6, 10, 12,
      // X at (row 0, col 2): 2,4,8,12,14 (shares 2 and 12)
      4, 8, 14,
    };
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(overlappingTwoX),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small X count 2 allows two separate non-crossed X shapes', () {
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );

    Set<int>? compatibleUnion;
    final patterns = smallXGameRule.patterns;
    for (var i = 0; i < patterns.length; i++) {
      for (var j = i + 1; j < patterns.length; j++) {
        final union = {
          ...patterns[i].cellIndexes,
          ...patterns[j].cellIndexes,
        };
        final result = evaluateCartelaForGame(cartelaWithMarked(union), rule);
        if (result.isBingo) {
          compatibleUnion = union;
          break;
        }
      }
      if (compatibleUnion != null) {
        break;
      }
    }
    expect(compatibleUnion, isNotNull);

    final separate = evaluateCartelaForGame(
      cartelaWithMarked(compatibleUnion!),
      rule,
    );
    expect(separate.isBingo, isTrue);
    expect(separate.winningPatterns.length, 2);
  });

  test('small X count 2 one away only for valid bingo not crossed second X', () {
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );

    // Complete X at (1,1); partial marks toward a crossing X at (0,1) — not bingo.
    const firstX = {6, 8, 12, 16, 18};
    const crossingSecond = {1, 3, 7, 17, 21, 23};
    final marked = {...firstX, ...crossingSecond};

    final result = evaluateCartelaForGame(cartelaWithMarked(marked), rule);
    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isFalse);
    expect(result.oneAwayCellIndexes, isEmpty);
  });

  test('small X count 1 one away highlights single missing X cell', () {
    const almostX = {2, 4, 8, 12};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(almostX),
      smallXGameRule,
    );
    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isTrue);
    expect(result.oneAwayCellIndexes, [14]);
  });

  test('small X patterns must not share cells or cross diagonal lines', () {
    final patterns = smallXGameRule.patterns;
    for (var i = 0; i < patterns.length; i++) {
      for (var j = i + 1; j < patterns.length; j++) {
        final a = patterns[i];
        final b = patterns[j];
        final shared = a.cellIndexes.toSet().intersection(b.cellIndexes.toSet());
        final rule = buildActiveGameRule(
          smallXGameRule,
          defaultTiezazPatternGroups,
          smallXCount: 2,
        );
        final union = {...a.cellIndexes, ...b.cellIndexes};
        final result = evaluateCartelaForGame(
          cartelaWithMarked(union),
          rule,
        );
        if (shared.isNotEmpty) {
          expect(result.isBingo, isFalse,
              reason: '${a.name} vs ${b.name} share $shared');
        }
      }
    }
  });

  test('small X count 2 rejects two X crossed at FREE', () {
    // X at (0,0) and X at (2,2) both use center FREE — must not count as 2.
    final crossedAtFree = {0, 2, 6, 10, 12, 14, 17, 20, 24};
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );
    expect(
      evaluateCartelaForGame(cartelaWithMarked(crossedAtFree), rule).isBingo,
      isFalse,
    );
    final display = selectWinningPatternsForDisplay(
      cartelaWithMarked(crossedAtFree),
      rule,
    );
    expect(display.length, lessThan(2));
  });

  test('small X count 2 rejects crossed X sharing I2', () {
    // First X (1,1) plus cells that complete a second X crossing at I2 (7).
    final crossedCells = {6, 8, 12, 16, 18, 7, 17, 18, 21, 23};
    final rule = buildActiveGameRule(
      smallXGameRule,
      defaultTiezazPatternGroups,
      smallXCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(crossedCells),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small O wins with 8-cell O shape example', () {
    // Closed 3x3 O ring at top-left.
    final oCells = {0, 1, 2, 5, 7, 10, 11, 12};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(oCells),
      smallOGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small O is fixed to count 1', () {
    final twoOShapes = {
      // O ring at top-left.
      0, 1, 2, 5, 7, 10, 11, 12,
      // O ring at top-right.
      2, 3, 4, 7, 9, 12, 13, 14,
    };
    final rule = buildActiveGameRule(
      smallOGameRule,
      defaultTiezazPatternGroups,
      smallOCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoOShapes),
      rule,
    );
    expect(result.isBingo, isTrue);
    expect(rule.requiredPatternCounts[smallOShapeGroup], 1);
  });

  test('small H wins with top row center stem bottom row', () {
    // Top–N–bottom 3×3 at row 0, col 2: N1 G1 O1 · G2 · N3 G3 O3
    final hCells = {2, 3, 4, 8, 12, 13, 14};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(hCells),
      smallHGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small H wins with B-O sides like mini BIG H', () {
    // 3×3 at top-left: B1 B2 B3 + O1 O2 O3 + middle row I2 N2 G2
    final hCells = {0, 5, 10, 2, 7, 12, 6};
    final result = evaluateCartelaForGame(
      cartelaWithMarked(hCells),
      smallHGameRule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small H supports max 2', () {
    final twoHShapes = {
      // Top-N-Bottom at (0,0)
      0, 1, 2, 6, 10, 11, 12,
      // Top-N-Bottom at (1,2) — disjoint from the first
      7, 8, 9, 13, 17, 18, 19,
    };
    final rule = buildActiveGameRule(
      smallHGameRule,
      defaultTiezazPatternGroups,
      smallHCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoHShapes),
      rule,
    );
    expect(result.isBingo, isTrue);
  });

  test('small H count 2 does not allow overlapping shapes', () {
    final overlappingTwoH = {
      // H at (row 0, col 0): 0,1,2,6,10,11,12
      0, 1, 2, 6, 10, 11, 12,
      // H at (row 0, col 1): 1,2,3,7,11,12,13 (shares 1,2,11,12)
      3, 7, 13,
    };
    final rule = buildActiveGameRule(
      smallHGameRule,
      defaultTiezazPatternGroups,
      smallHCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(overlappingTwoH),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('small H count 2 does not allow sharing FREE only', () {
    final twoHSharingFree = {
      // Top-N-Bottom at (0,2)
      2, 3, 4, 8, 12, 13, 14,
      // B-O Sides at (2,0) — shares only FREE (12)
      10, 15, 20, 17, 22, 16,
    };
    final rule = buildActiveGameRule(
      smallHGameRule,
      defaultTiezazPatternGroups,
      smallHCount: 2,
    );
    final result = evaluateCartelaForGame(
      cartelaWithMarked(twoHSharingFree),
      rule,
    );
    expect(result.isBingo, isFalse);
  });

  test('best cartela prefers first bingo and keeps tie order', () {
    final cartelas = <String, Map<String, List<dynamic>>>{
      'first-progress': cartelaWithMarked({0, 1, 2, 3}),
      'first-bingo': cartelaWithMarked({
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        13,
        14,
      }),
      'second-bingo': cartelaWithMarked({
        10,
        11,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
      }),
    };

    final bestKey = findBestCartelaKeyForGame(cartelas, halfHouseGameRule);

    expect(bestKey, 'first-bingo');
  });

  test('best cartela uses closest progress when no card has bingo', () {
    final cartelas = <String, Map<String, List<dynamic>>>{
      'weaker': cartelaWithMarked({0, 1, 2}),
      'closest': cartelaWithMarked({
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        13,
      }),
    };

    final bestKey = findBestCartelaKeyForGame(cartelas, halfHouseGameRule);

    expect(bestKey, 'closest');
  });

  test('static mix presets are valid and numbered 1-14', () {
    expect(staticMixPresets, hasLength(14));
    for (var i = 0; i < staticMixPresets.length; i++) {
      final preset = staticMixPresets[i];
      expect(preset.id, 'mix_${(i + 1).toString().padLeft(2, '0')}');
      final rule = buildStaticMixGameRule(preset);
      expect(validateGameRule(rule), isEmpty);
      expect(rule.patterns, isNotEmpty);
    }
  });

  test('Mix 1 allows overlapping row column diagonal', () {
    final rule = buildStaticMixGameRule(staticMixPresets[0]);
    final result = evaluateCartelaForGame(
      cartelaWithMarked({0, 1, 2, 3, 4, 5, 10, 15, 20, 6, 12, 18, 24}),
      rule,
    );
    expect(result.isBingo, isTrue);
  });

  test('Mix 3 requires non-overlapping diagonal and two small L', () {
    final rule = buildStaticMixGameRule(staticMixPresets[2]);
    final mainDiagonal = {0, 6, 12, 18, 24};
    final smallL1 = {2, 7, 8};
    final smallL2 = {16, 21, 22};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...mainDiagonal, ...smallL1, ...smallL2}),
        rule,
      ).isBingo,
      isTrue,
    );
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...mainDiagonal, 2, 7, 8, 7, 11, 12}),
        rule,
      ).isBingo,
      isFalse,
    );
  });

  test('Mix 5 rejects overlapping BIG T and square', () {
    final rule = buildStaticMixGameRule(staticMixPresets[4]);
    expect(rule.requiredPatternCounts.length, 2);
    expect(
      rule.groupAllowSharedCellIndexes.values.every((cells) => cells.isEmpty),
      isTrue,
    );

    final bigTTop = {0, 1, 2, 3, 4, 7, 12, 17, 22};
    final squareTopLeft = {0, 1, 5, 6};
    final overlapResult = evaluateCartelaForGame(
      cartelaWithMarked({...bigTTop, ...squareTopLeft}),
      rule,
    );
    expect(overlapResult.isBingo, isFalse);

    final disjoint = {...bigTTop, 18, 19, 23, 24};
    expect(
      evaluateCartelaForGame(cartelaWithMarked(disjoint), rule).isBingo,
      isTrue,
    );
  });

  test('Mix 11 allows overlapping lines but not square on line cells', () {
    final rule = buildStaticMixGameRule(staticMixPresets[10]);
    final row0 = {0, 1, 2, 3, 4};
    final col0 = {0, 5, 10, 15, 20};
    final square = {18, 19, 23, 24};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...row0, ...col0, ...square}),
        rule,
      ).isBingo,
      isTrue,
    );
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...row0, ...col0, 0, 1, 5, 6}),
        rule,
      ).isBingo,
      isFalse,
    );
  });

  test('Mix 8 rejects overlapping small T and diagonal', () {
    final rule = buildStaticMixGameRule(staticMixPresets[7]);
    final smallTTopLeft = {0, 1, 2, 6, 11};
    final diagMain = {0, 6, 12, 18, 24};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...smallTTopLeft, ...diagMain}),
        rule,
      ).isBingo,
      isFalse,
    );
    final antiDiagonal = {4, 8, 12, 16, 20};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...smallTTopLeft, ...antiDiagonal}),
        rule,
      ).isBingo,
      isTrue,
    );
  });

  test('Mix 14 allows all BIG L orientations with non-overlapping small L', () {
    final rule = buildStaticMixGameRule(staticMixPresets[13]);
    expect(
      rule.patterns.any((pattern) => pattern.name.contains('Top Left')),
      isTrue,
    );
    final topLeftBigL = {0, 1, 2, 3, 4, 5, 10, 15, 20};
    final smallLAt_1_2 = {7, 12, 13};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...topLeftBigL, ...smallLAt_1_2}),
        rule,
      ).isBingo,
      isTrue,
    );
    final overlappingSmallL = {9, 14, 15};
    expect(
      evaluateCartelaForGame(
        cartelaWithMarked({...topLeftBigL, ...overlappingSmallL}),
        rule,
      ).isBingo,
      isFalse,
    );
  });

  test('buildActiveGameRule uses static mix preset', () {
    final mixRule = staticMixPresetGameRules[1];
    final rule = buildActiveGameRule(
      mixRule,
      defaultTiezazPatternGroups,
    );
    expect(rule.name, 'mix_02');
    expect(rule.patterns, isNotEmpty);
    expect(
      rule.requiredPatternCounts.containsKey(
        '$columnsGameName::$columnsShapeGroup',
      ),
      isTrue,
    );
  });

  test('Mix 5 one away highlights single missing cell', () {
    final rule = buildStaticMixGameRule(staticMixPresets[4]);
    final bigTTop = {0, 1, 2, 3, 4, 7, 12, 17, 22};
    final almostSquare = {18, 19, 23};
    final result = evaluateCartelaForGame(
      cartelaWithMarked({...bigTTop, ...almostSquare}),
      rule,
    );
    expect(result.isBingo, isFalse);
    expect(result.isOneAway, isTrue);
    expect(result.oneAwayCellIndexes, [24]);
  });

  test('pattern count limits match standalone play', () {
    expect(allowedPatternCountsForGame(columnsGameName), [1, 2, 3, 4]);
    expect(allowedPatternCountsForGame(rectangleGameName), [1, 2, 3, 4]);
    expect(allowedPatternCountsForGame(smallCrossGameName), [1, 2]);
    expect(allowedPatternCountsForGame(smallOGameName), [1]);
    expect(clampPatternCountForGame(columnsGameName, 10), 4);
    expect(clampPatternCountForGame(rectangleGameName, 10), 4);
    expect(clampPatternCountForGame(smallCrossGameName, 4), 2);
    expect(clampPatternCountForGame(lineGameName, 0), 1);
  });

  test('game display names map internal rule names to English labels', () {
    final i18n = AppI18n(AppLanguage.english);
    expect(i18n.gameDisplayName(lineGameName), 'Line');
    expect(i18n.gameDisplayName(rectanguleGameName), 'Rectangle');
    expect(i18n.gameDisplayName(triangleGameName), '3 by 3 triangle');
  });

  test('game display names use Amharic when language is Amharic', () {
    final i18n = AppI18n(AppLanguage.amharic);
    expect(i18n.gameDisplayName(lineGameName), 'መስመር');
    expect(i18n.gameDisplayName('Half House'), 'ፍርቂ ገዛ');
  });

  test('game display names show Amharic-only labels in catalog', () {
    final i18n = AppI18n(AppLanguage.english);
    expect(
      i18n.gameDisplayNameBilingual(lineGameName),
      'መስመር',
    );
    expect(
      i18n.gameCatalogListLabel(3, lineGameName),
      '3. መስመር',
    );
    expect(
      i18n.gameDisplayNameBilingual(rectanguleGameName),
      'ሬክታንግል',
    );
    expect(
      i18n.gameCatalogListLabel(28, 'mix_01'),
      '28. ዝደቀሰ + ደው ዝበለ + ዲያጎናል',
    );
    expect(
      i18n.gameCatalogListLabel(3, 'Half House'),
      '3. ፍርቂ ገዛ',
    );
  });

  test('availableGameRules lists mix presets before small O', () {
    expect(availableGameRules, hasLength(42));
    expect(availableGameRules.first.name, 'Manual');
    expect(availableGameRules[1].name, 'FULL-HOUSE');
    expect(availableGameRules[2].name, 'Half House');
    expect(availableGameRules[3].name, lineGameName);
    expect(availableGameRules[27].name, 'mix_01');
    expect(availableGameRules[40].name, 'mix_14');
    expect(availableGameRules.last.name, smallOGameName);
    expect(
      availableGameRules.any((rule) => rule.name == mixedJoinGameName),
      isFalse,
    );
    expect(
      availableGameRules.any((rule) => rule.name == tiezazGameName),
      isFalse,
    );
  });
}
