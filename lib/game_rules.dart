class WinPattern {
  const WinPattern({
    required this.name,
    required this.cellIndexes,
    this.patternGroup,
  });

  final String name;
  final List<int> cellIndexes;
  final String? patternGroup;
}

class GameRule {
  const GameRule({
    required this.name,
    required this.patterns,
    this.requiresAllPatternGroups = false,
    this.requiredPatternCounts = const {},
    this.allowSharedCellIndexes = const {},
    this.groupAllowSharedCellIndexes = const {},
  });

  final String name;
  final List<WinPattern> patterns;
  final bool requiresAllPatternGroups;
  final Map<String, int> requiredPatternCounts;
  final Set<int> allowSharedCellIndexes;
  final Map<String, Set<int>> groupAllowSharedCellIndexes;
}

class GameResult {
  const GameResult({
    required this.bestPattern,
    required this.markedCount,
    required this.requiredCount,
    required this.isBingo,
    required this.missingCellIndexes,
    required this.oneAwayCellIndexes,
    required this.winningCellIndexes,
    this.winningPatterns = const [],
  });

  final WinPattern? bestPattern;
  final int markedCount;
  final int requiredCount;
  final bool isBingo;
  final List<int> missingCellIndexes;
  final List<int> oneAwayCellIndexes;
  final List<int> winningCellIndexes;
  final List<WinPattern> winningPatterns;

  bool get isOneAway => !isBingo && oneAwayCellIndexes.isNotEmpty;
}

const GameRule manualGameRule = GameRule(
  name: 'Manual',
  patterns: [],
);

const GameRule halfHouseGameRule = GameRule(
  name: 'Half House',
  patterns: [
    WinPattern(
      name: 'Top 3 Rows',
      cellIndexes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14],
    ),
    WinPattern(
      name: 'Bottom 3 Rows',
      cellIndexes: [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24],
    ),
    WinPattern(
      name: 'Left 3 Columns',
      cellIndexes: [0, 1, 2, 5, 6, 7, 10, 11, 12, 15, 16, 17, 20, 21, 22],
    ),
    WinPattern(
      name: 'Right 3 Columns',
      cellIndexes: [2, 3, 4, 7, 8, 9, 12, 13, 14, 17, 18, 19, 22, 23, 24],
    ),
    WinPattern(
      name: 'Middle 3 Rows',
      cellIndexes: [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19],
    ),
    WinPattern(
      name: 'Middle 3 Columns',
      cellIndexes: [1, 2, 3, 6, 7, 8, 11, 12, 13, 16, 17, 18, 21, 22, 23],
    ),
    WinPattern(
      name: 'Left Triangle',
      cellIndexes: [0, 5, 6, 10, 11, 12, 15, 16, 17, 18, 20, 21, 22, 23, 24],
    ),
    WinPattern(
      name: 'Right Triangle',
      cellIndexes: [4, 8, 9, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24],
    ),
    WinPattern(
      name: 'Top Right Triangle',
      cellIndexes: [0, 1, 2, 3, 4, 6, 7, 8, 9, 12, 13, 14, 18, 19, 24],
    ),
    WinPattern(
      name: 'Top Left Triangle',
      cellIndexes: [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 15, 16, 20],
    ),
  ],
);

const GameRule fullHouseGameRule = GameRule(
  name: 'FULL-HOUSE',
  patterns: [
    WinPattern(
      name: 'Full House',
      cellIndexes: [
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
      ],
    ),
  ],
);

const String tiezazGameName = 'ትእዛዝ';
const String tiezazCrossGroup = 'Cross / +';
const String tiezazRectangleGroup = 'Square';
const String tiezazLShapeGroup = 'L Shape';
const String rectangleGameName = 'Square';
const String rectanguleGameName = 'Rectangule';
const String rectanguleShapeGroup = 'Rectangule';
const String columnsGameName = 'Columns';
const String columnsShapeGroup = 'Columns';
const String rowsGameName = 'Rows';
const String rowsShapeGroup = 'Rows';
const String diagonalGameName = 'Diagonal';
const String diagonalShapeGroup = 'Diagonal';
const String lineTouchesFreeGameName = 'LIne touches free';
const String lineTouchesFreeShapeGroup = 'Line touches free';
const String linesWithoutFreeGameName = 'lines with out free';
const String linesWithoutFreeShapeGroup = 'lines with out free';
const String lineGameName = 'line';
const String lineShapeGroup = 'line';
const String triangleGameName = '2 triangle';
const String triangleShapeGroup = 'Triangle';
const String triangle4x4GameName = '4 by 4 triangle';
const String triangle4x4ShapeGroup = 'Triangle 4x4';
const String pyramidGameName = 'Pyramid';
const String bigLShapeGameName = 'BIG L Shape';
const String bigTShapeGameName = 'BIG T';
const String bigHShapeGameName = 'BIG H';
const String bigNShapeGameName = 'BIG N';
const String bigYShapeGameName = 'BIG Y';
const String bigCrossGameName = 'BIG Cross';
const String rightShapeGameName = 'RIGHT Shape';
const String smallTAndXGameName = 'small T shape and X shape';
const String smallTShapeGroup = 'T Shape';
const String smallXShapeGroup = 'X Shape';
const String smallTGameName = 'small T';
const String smallXGameName = 'small X';
const String smallOGameName = 'small O';
const String smallHGameName = 'small H';
const String smallCrossGameName = 'small + (cross)';
const String smallLShapeGameName = 'small L';
const String smallLShapeGroup = 'small L';
const String smallOShapeGroup = 'small O';
const String smallHShapeGroup = 'small H';
const int defaultSmallLShapeCount = 4;
const int defaultSmallCrossCount = 1;
const int maxSmallCrossCount = 2;
const int defaultSmallOCount = 1;
const int maxSmallOCount = 1;
const int defaultSmallHCount = 1;
const int defaultSmallTCount = 1;
const int defaultSmallXCount = 1;
const int maxSmallXCount = 2;
const int defaultRectangleCount = 3;
const int maxRectangleCount = 4;
const int defaultRectanguleCount = 2;
const int maxRectanguleCount = 3;
const int defaultColumnsCount = 1;
const int defaultRowsCount = 1;
const int defaultDiagonalCount = 1;
const int defaultLineTouchesFreeCount = 1;
const int maxLineTouchesFreeCount = 4;
const int defaultLinesWithoutFreeCount = 1;
const int defaultLineCount = 1;
const int defaultTriangleCount = 2;
const int defaultTriangle4x4Count = 2;

const Set<String> defaultTiezazPatternGroups = {
  tiezazCrossGroup,
  tiezazRectangleGroup,
  tiezazLShapeGroup,
};

const String mixedJoinGameName = 'Mixed Join';

/// All cell indexes — used as group shared mask so overlap is allowed.
Set<int> get _allSharedCellIndexes =>
    Set<int>.from(List<int>.generate(25, (i) => i));

class StaticMixPart {
  const StaticMixPart({
    required this.subGameName,
    required this.count,
    this.allowOverlap = false,
    this.allowedPatternNames,
  });

  final String subGameName;
  final int count;
  final bool allowOverlap;
  final Set<String>? allowedPatternNames;
}

class StaticMixPreset {
  const StaticMixPreset({
    required this.id,
    required this.i18nKey,
    required this.parts,
  });

  final String id;
  final String i18nKey;
  final List<StaticMixPart> parts;
}

const List<StaticMixPreset> staticMixPresets = [
  StaticMixPreset(
    id: 'mix_01',
    i18nKey: 'mix_preset_01',
    parts: [
      StaticMixPart(subGameName: rowsGameName, count: 1, allowOverlap: true),
      StaticMixPart(subGameName: columnsGameName, count: 1, allowOverlap: true),
      StaticMixPart(subGameName: diagonalGameName, count: 1, allowOverlap: true),
    ],
  ),
  StaticMixPreset(
    id: 'mix_02',
    i18nKey: 'mix_preset_02',
    parts: [
      StaticMixPart(subGameName: columnsGameName, count: 1, allowOverlap: true),
      StaticMixPart(subGameName: rowsGameName, count: 1, allowOverlap: true),
    ],
  ),
  StaticMixPreset(
    id: 'mix_03',
    i18nKey: 'mix_preset_03',
    parts: [
      StaticMixPart(subGameName: diagonalGameName, count: 1),
      StaticMixPart(subGameName: smallLShapeGameName, count: 2),
    ],
  ),
  StaticMixPreset(
    id: 'mix_04',
    i18nKey: 'mix_preset_04',
    parts: [
      StaticMixPart(subGameName: diagonalGameName, count: 2, allowOverlap: true),
      StaticMixPart(subGameName: rowsGameName, count: 1, allowOverlap: true),
    ],
  ),
  StaticMixPreset(
    id: 'mix_05',
    i18nKey: 'mix_preset_05',
    parts: [
      StaticMixPart(subGameName: bigTShapeGameName, count: 1),
      StaticMixPart(subGameName: rectangleGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_06',
    i18nKey: 'mix_preset_06',
    parts: [
      StaticMixPart(subGameName: smallTGameName, count: 1),
      StaticMixPart(subGameName: rectangleGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_07',
    i18nKey: 'mix_preset_07',
    parts: [
      StaticMixPart(subGameName: bigTShapeGameName, count: 1, allowOverlap: true),
      StaticMixPart(subGameName: diagonalGameName, count: 1, allowOverlap: true),
    ],
  ),
  StaticMixPreset(
    id: 'mix_08',
    i18nKey: 'mix_preset_08',
    parts: [
      StaticMixPart(subGameName: smallTGameName, count: 1),
      StaticMixPart(subGameName: diagonalGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_09',
    i18nKey: 'mix_preset_09',
    parts: [
      StaticMixPart(subGameName: smallCrossGameName, count: 1),
      StaticMixPart(subGameName: rectangleGameName, count: 1),
      StaticMixPart(subGameName: smallLShapeGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_10',
    i18nKey: 'mix_preset_10',
    parts: [
      StaticMixPart(subGameName: smallOGameName, count: 1),
      StaticMixPart(subGameName: lineGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_11',
    i18nKey: 'mix_preset_11',
    parts: [
      StaticMixPart(subGameName: lineGameName, count: 2, allowOverlap: true),
      StaticMixPart(subGameName: rectangleGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_12',
    i18nKey: 'mix_preset_12',
    parts: [
      StaticMixPart(subGameName: pyramidGameName, count: 1),
      StaticMixPart(subGameName: lineGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_13',
    i18nKey: 'mix_preset_13',
    parts: [
      StaticMixPart(subGameName: rightShapeGameName, count: 1),
      StaticMixPart(subGameName: rectangleGameName, count: 1),
    ],
  ),
  StaticMixPreset(
    id: 'mix_14',
    i18nKey: 'mix_preset_14',
    parts: [
      StaticMixPart(subGameName: bigLShapeGameName, count: 1),
      StaticMixPart(subGameName: smallLShapeGameName, count: 1),
    ],
  ),
];

StaticMixPreset? staticMixPresetById(String? id) {
  if (id == null || id.isEmpty) {
    return null;
  }
  for (final preset in staticMixPresets) {
    if (preset.id == id) {
      return preset;
    }
  }
  return null;
}

bool isStaticMixPresetGameName(String gameName) =>
    staticMixPresetById(gameName) != null;

final List<GameRule> staticMixPresetGameRules = [
  for (final preset in staticMixPresets)
    GameRule(
      name: preset.id,
      patterns: const [],
      requiresAllPatternGroups: true,
    ),
];

/// Allowed pattern counts in standalone play.
List<int> allowedPatternCountsForGame(String gameName) {
  switch (gameName) {
    case rectangleGameName:
      return const [1, 2, 3, 4];
    case rectanguleGameName:
      return const [1, 2, 3];
    case columnsGameName:
      return const [1, 2, 3, 4];
    case rowsGameName:
      return const [1, 2, 3, 4];
    case diagonalGameName:
      return const [1, 2];
    case lineTouchesFreeGameName:
      return const [1, 2, 3, 4];
    case linesWithoutFreeGameName:
      return const [1, 2, 3, 4];
    case lineGameName:
      return const [1, 2, 3, 4, 5, 6, 7];
    case triangleGameName:
      return const [1, 2];
    case triangle4x4GameName:
      return const [1, 2];
    case smallCrossGameName:
      return const [1, 2];
    case smallTGameName:
      return const [1, 2, 3, 4];
    case smallXGameName:
      return const [1, 2];
    case smallLShapeGameName:
      return const [1, 2, 3, 4, 5];
    case smallHGameName:
      return const [1, 2];
    case smallOGameName:
      return const [1];
    default:
      return const [];
  }
}

bool gameSupportsPatternCount(String gameName) =>
    allowedPatternCountsForGame(gameName).isNotEmpty;

int clampPatternCountForGame(String gameName, int count) {
  final allowed = allowedPatternCountsForGame(gameName);
  if (allowed.isEmpty) {
    return count;
  }
  if (allowed.contains(count)) {
    return count;
  }
  if (count > allowed.last) {
    return allowed.last;
  }
  return allowed.first;
}

String _mixedJoinGroupKey(String gameName, String groupName) =>
    '$gameName::$groupName';

GameRule _buildSubRuleForStaticMixPart(StaticMixPart part) {
  final count = part.count;
  var rule = buildConfiguredGameRule(
    part.subGameName,
    rectangleCount:
        part.subGameName == rectangleGameName ? count : defaultRectangleCount,
    rectanguleCount:
        part.subGameName == rectanguleGameName ? count : defaultRectanguleCount,
    columnsCount:
        part.subGameName == columnsGameName ? count : defaultColumnsCount,
    rowsCount: part.subGameName == rowsGameName ? count : defaultRowsCount,
    diagonalCount:
        part.subGameName == diagonalGameName ? count : defaultDiagonalCount,
    lineTouchesFreeCount: part.subGameName == lineTouchesFreeGameName
        ? count
        : defaultLineTouchesFreeCount,
    linesWithoutFreeCount: part.subGameName == linesWithoutFreeGameName
        ? count
        : defaultLinesWithoutFreeCount,
    lineCount: part.subGameName == lineGameName ? count : defaultLineCount,
    smallLCount:
        part.subGameName == smallLShapeGameName ? count : defaultSmallLShapeCount,
    smallCrossCount:
        part.subGameName == smallCrossGameName ? count : defaultSmallCrossCount,
    smallOCount:
        part.subGameName == smallOGameName ? count : defaultSmallOCount,
    smallHCount:
        part.subGameName == smallHGameName ? count : defaultSmallHCount,
    smallTCount:
        part.subGameName == smallTGameName ? count : defaultSmallTCount,
    smallXCount:
        part.subGameName == smallXGameName ? count : defaultSmallXCount,
    triangleCount:
        part.subGameName == triangleGameName ? count : defaultTriangleCount,
    triangle4x4Count: part.subGameName == triangle4x4GameName
        ? count
        : defaultTriangle4x4Count,
  );

  if (part.allowedPatternNames != null) {
    rule = GameRule(
      name: rule.name,
      patterns: rule.patterns
          .where((pattern) => part.allowedPatternNames!.contains(pattern.name))
          .toList(),
      requiresAllPatternGroups: rule.requiresAllPatternGroups,
      requiredPatternCounts: rule.requiredPatternCounts,
      allowSharedCellIndexes: rule.allowSharedCellIndexes,
      groupAllowSharedCellIndexes: rule.groupAllowSharedCellIndexes,
    );
  }

  return rule;
}

GameRule buildStaticMixGameRule(StaticMixPreset? preset) {
  if (preset == null) {
    return mixedJoinGameRule;
  }

  final allPatterns = <WinPattern>[];
  final allCounts = <String, int>{};
  final groupShared = <String, Set<int>>{};

  for (final part in preset.parts) {
    final subRule = _buildSubRuleForStaticMixPart(part);
    final prepared = _prepareSubRuleForMixedJoin(part.subGameName, subRule);
    allPatterns.addAll(prepared.patterns);
    allCounts.addAll(prepared.requiredPatternCounts);
    groupShared.addAll(prepared.groupAllowSharedCellIndexes);

    if (part.allowOverlap) {
      for (final groupKey in prepared.requiredPatternCounts.keys) {
        groupShared[groupKey] = _allSharedCellIndexes;
      }
    } else {
      for (final groupKey in prepared.requiredPatternCounts.keys) {
        groupShared[groupKey] = const {};
      }
    }
  }

  return GameRule(
    name: preset.id,
    patterns: allPatterns,
    requiresAllPatternGroups: true,
    requiredPatternCounts: allCounts,
    groupAllowSharedCellIndexes: groupShared,
  );
}

final GameRule tiezazGameRule = GameRule(
  name: tiezazGameName,
  patterns: _buildTiezazPatterns(defaultTiezazPatternGroups),
  requiresAllPatternGroups: true,
);

final GameRule rectangleGameRule = GameRule(
  name: rectangleGameName,
  patterns: _buildRectanglePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {tiezazRectangleGroup: defaultRectangleCount},
);

final GameRule rectanguleGameRule = GameRule(
  name: rectanguleGameName,
  patterns: _buildRectangulePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {rectanguleShapeGroup: defaultRectanguleCount},
);

final GameRule columnsGameRule = GameRule(
  name: columnsGameName,
  patterns: _buildColumnsPatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {columnsShapeGroup: defaultColumnsCount},
);

final GameRule rowsGameRule = GameRule(
  name: rowsGameName,
  patterns: _buildRowsPatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {rowsShapeGroup: defaultRowsCount},
);

final GameRule diagonalGameRule = GameRule(
  name: diagonalGameName,
  patterns: _buildDiagonalPatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {diagonalShapeGroup: defaultDiagonalCount},
  allowSharedCellIndexes: {12},
);

final GameRule lineTouchesFreeGameRule = GameRule(
  name: lineTouchesFreeGameName,
  patterns: _buildLineTouchesFreePatterns(),
  requiredPatternCounts: {
    lineTouchesFreeShapeGroup: defaultLineTouchesFreeCount
  },
);

final GameRule linesWithoutFreeGameRule = GameRule(
  name: linesWithoutFreeGameName,
  patterns: _buildLinesWithoutFreePatterns(),
  requiredPatternCounts: {
    linesWithoutFreeShapeGroup: defaultLinesWithoutFreeCount
  },
);

final GameRule lineGameRule = GameRule(
  name: lineGameName,
  patterns: _buildLinePatterns(),
  requiredPatternCounts: {lineShapeGroup: defaultLineCount},
);

final GameRule triangleGameRule = GameRule(
  name: triangleGameName,
  patterns: _buildTrianglePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {triangleShapeGroup: defaultTriangleCount},
);

final GameRule triangle4x4GameRule = GameRule(
  name: triangle4x4GameName,
  patterns: _buildTriangle4x4Patterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {triangle4x4ShapeGroup: defaultTriangle4x4Count},
);

final GameRule pyramidGameRule = GameRule(
  name: pyramidGameName,
  patterns: _buildPyramidPatterns(),
);

final GameRule bigLShapeGameRule = GameRule(
  name: bigLShapeGameName,
  patterns: _buildBigLShapePatterns(),
);

final GameRule bigTShapeGameRule = GameRule(
  name: bigTShapeGameName,
  patterns: _buildBigTShapePatterns(),
);

final GameRule bigHShapeGameRule = GameRule(
  name: bigHShapeGameName,
  patterns: _buildBigHShapePatterns(),
);

final GameRule bigNShapeGameRule = GameRule(
  name: bigNShapeGameName,
  patterns: _buildBigNShapePatterns(),
);

final GameRule bigYShapeGameRule = GameRule(
  name: bigYShapeGameName,
  patterns: _buildBigYShapePatterns(),
);

final GameRule bigCrossGameRule = GameRule(
  name: bigCrossGameName,
  patterns: _buildBigCrossPatterns(),
);

final GameRule rightShapeGameRule = GameRule(
  name: rightShapeGameName,
  patterns: _buildRightShapePatterns(),
);

final GameRule smallTAndXGameRule = GameRule(
  name: smallTAndXGameName,
  patterns: [
    ..._buildSmallTShapePatterns(),
    ..._buildSmallXShapePatterns(),
  ],
  requiresAllPatternGroups: true,
);

final GameRule smallTGameRule = GameRule(
  name: smallTGameName,
  patterns: _buildSmallTShapePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {smallTShapeGroup: defaultSmallTCount},
);

final GameRule smallXGameRule = GameRule(
  name: smallXGameName,
  patterns: _buildSmallXShapePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {smallXShapeGroup: defaultSmallXCount},
);

final GameRule smallOGameRule = GameRule(
  name: smallOGameName,
  patterns: _buildSmallOPatterns(),
  requiredPatternCounts: {smallOShapeGroup: defaultSmallOCount},
);

final GameRule smallHGameRule = GameRule(
  name: smallHGameName,
  patterns: _buildSmallHPatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {smallHShapeGroup: defaultSmallHCount},
);

final GameRule smallCrossGameRule = GameRule(
  name: smallCrossGameName,
  patterns: _buildCrossPatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {tiezazCrossGroup: defaultSmallCrossCount},
);

final GameRule smallLShapeGameRule = GameRule(
  name: smallLShapeGameName,
  patterns: _buildSmallLShapePatterns(),
  requiresAllPatternGroups: true,
  requiredPatternCounts: {smallLShapeGroup: defaultSmallLShapeCount},
);

const GameRule defaultGameRule = manualGameRule;

const GameRule mixedJoinGameRule = GameRule(
  name: mixedJoinGameName,
  patterns: [],
  requiresAllPatternGroups: true,
);

final List<GameRule> availableGameRules = [
  manualGameRule,
  fullHouseGameRule,
  halfHouseGameRule,
  lineGameRule,
  columnsGameRule,
  rowsGameRule,
  diagonalGameRule,
  lineTouchesFreeGameRule,
  linesWithoutFreeGameRule,
  rectangleGameRule,
  rectanguleGameRule,
  triangleGameRule,
  triangle4x4GameRule,
  pyramidGameRule,
  bigLShapeGameRule,
  bigTShapeGameRule,
  bigHShapeGameRule,
  bigNShapeGameRule,
  bigYShapeGameRule,
  bigCrossGameRule,
  rightShapeGameRule,
  smallTAndXGameRule,
  smallTGameRule,
  smallXGameRule,
  smallHGameRule,
  smallCrossGameRule,
  smallLShapeGameRule,
  ...staticMixPresetGameRules,
  smallOGameRule,
];

List<String> validateAvailableGameRules() {
  return [
    for (final rule in availableGameRules) ...validateGameRule(rule),
  ];
}

List<String> validateGameRule(GameRule gameRule) {
  final errors = <String>[];
  final groupNames = <String>{};

  if (gameRule.name.trim().isEmpty) {
    errors.add('Game rule has an empty name.');
  }

  for (final pattern in gameRule.patterns) {
    if (pattern.name.trim().isEmpty) {
      errors.add('${gameRule.name} has a pattern with an empty name.');
    }

    if (pattern.cellIndexes.isEmpty) {
      errors.add('${gameRule.name}/${pattern.name} has no cells.');
    }

    final uniqueCells = <int>{};
    for (final index in pattern.cellIndexes) {
      if (index < 0 || index > 24) {
        errors.add('${gameRule.name}/${pattern.name} has invalid cell $index.');
      }
      if (!uniqueCells.add(index)) {
        errors.add('${gameRule.name}/${pattern.name} repeats cell $index.');
      }
    }

    final groupName = pattern.patternGroup;
    if (groupName != null) {
      groupNames.add(groupName);
    } else if (gameRule.requiresAllPatternGroups) {
      errors.add('${gameRule.name}/${pattern.name} is missing patternGroup.');
    }
  }

  if (gameRule.requiresAllPatternGroups &&
      gameRule.patterns.isNotEmpty &&
      groupNames.isEmpty) {
    errors.add('${gameRule.name} requires groups but has no grouped patterns.');
  }

  for (final entry in gameRule.requiredPatternCounts.entries) {
    if (entry.value < 1) {
      errors.add('${gameRule.name}/${entry.key} requires an invalid count.');
    }
    if (!groupNames.contains(entry.key)) {
      errors.add('${gameRule.name} requires unknown group ${entry.key}.');
    }
  }

  for (final index in gameRule.allowSharedCellIndexes) {
    if (index < 0 || index > 24) {
      errors.add('${gameRule.name} has invalid shared cell $index.');
    }
  }

  for (final entry in gameRule.groupAllowSharedCellIndexes.entries) {
    if (!groupNames.contains(entry.key)) {
      errors.add('${gameRule.name} has unknown shared group ${entry.key}.');
    }
    for (final index in entry.value) {
      if (index < 0 || index > 24) {
        errors.add('${gameRule.name}/${entry.key} has invalid shared cell $index.');
      }
    }
  }

  return errors;
}

GameRule buildConfiguredGameRule(
  String gameName, {
  int rectangleCount = defaultRectangleCount,
  int rectanguleCount = defaultRectanguleCount,
  int columnsCount = defaultColumnsCount,
  int rowsCount = defaultRowsCount,
  int diagonalCount = defaultDiagonalCount,
  int lineTouchesFreeCount = defaultLineTouchesFreeCount,
  int linesWithoutFreeCount = defaultLinesWithoutFreeCount,
  int lineCount = defaultLineCount,
  int smallLCount = defaultSmallLShapeCount,
  int smallCrossCount = defaultSmallCrossCount,
  int smallOCount = defaultSmallOCount,
  int smallHCount = defaultSmallHCount,
  int smallTCount = defaultSmallTCount,
  int smallXCount = defaultSmallXCount,
  int triangleCount = defaultTriangleCount,
  int triangle4x4Count = defaultTriangle4x4Count,
}) {
  if (gameName == rectangleGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildRectanglePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        tiezazRectangleGroup:
            clampPatternCountForGame(gameName, rectangleCount),
      },
    );
  }
  if (gameName == rectanguleGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildRectangulePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        rectanguleShapeGroup:
            clampPatternCountForGame(gameName, rectanguleCount),
      },
    );
  }
  if (gameName == columnsGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildColumnsPatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        columnsShapeGroup: clampPatternCountForGame(gameName, columnsCount),
      },
    );
  }
  if (gameName == rowsGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildRowsPatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        rowsShapeGroup: clampPatternCountForGame(gameName, rowsCount),
      },
    );
  }
  if (gameName == diagonalGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildDiagonalPatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        diagonalShapeGroup: clampPatternCountForGame(gameName, diagonalCount),
      },
      allowSharedCellIndexes: diagonalGameRule.allowSharedCellIndexes,
    );
  }
  if (gameName == lineTouchesFreeGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildLineTouchesFreePatterns(),
      requiredPatternCounts: {
        lineTouchesFreeShapeGroup: clampPatternCountForGame(
          gameName,
          lineTouchesFreeCount,
        ),
      },
    );
  }
  if (gameName == linesWithoutFreeGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildLinesWithoutFreePatterns(),
      requiredPatternCounts: {
        linesWithoutFreeShapeGroup: clampPatternCountForGame(
          gameName,
          linesWithoutFreeCount,
        ),
      },
    );
  }
  if (gameName == lineGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildLinePatterns(),
      requiredPatternCounts: {
        lineShapeGroup: clampPatternCountForGame(gameName, lineCount),
      },
    );
  }
  if (gameName == triangleGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildTrianglePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        triangleShapeGroup: clampPatternCountForGame(gameName, triangleCount),
      },
    );
  }
  if (gameName == triangle4x4GameName) {
    return GameRule(
      name: gameName,
      patterns: _buildTriangle4x4Patterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        triangle4x4ShapeGroup:
            clampPatternCountForGame(gameName, triangle4x4Count),
      },
    );
  }
  if (gameName == smallLShapeGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildSmallLShapePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        smallLShapeGroup: clampPatternCountForGame(gameName, smallLCount),
      },
    );
  }
  if (gameName == smallCrossGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildCrossPatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        tiezazCrossGroup: clampPatternCountForGame(gameName, smallCrossCount),
      },
    );
  }
  if (gameName == smallOGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildSmallOPatterns(),
      requiredPatternCounts: {
        smallOShapeGroup: clampPatternCountForGame(gameName, smallOCount),
      },
    );
  }
  if (gameName == smallHGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildSmallHPatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        smallHShapeGroup: clampPatternCountForGame(gameName, smallHCount),
      },
    );
  }
  if (gameName == smallTGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildSmallTShapePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        smallTShapeGroup: clampPatternCountForGame(gameName, smallTCount),
      },
    );
  }
  if (gameName == smallXGameName) {
    return GameRule(
      name: gameName,
      patterns: _buildSmallXShapePatterns(),
      requiresAllPatternGroups: true,
      requiredPatternCounts: {
        smallXShapeGroup: clampPatternCountForGame(gameName, smallXCount),
      },
    );
  }

  return availableGameRules.firstWhere(
    (rule) => rule.name == gameName,
    orElse: () => manualGameRule,
  );
}

({
  List<WinPattern> patterns,
  Map<String, int> requiredPatternCounts,
  Map<String, Set<int>> groupAllowSharedCellIndexes,
}) _prepareSubRuleForMixedJoin(String gameName, GameRule subRule) {
  final patterns = <WinPattern>[];
  final counts = <String, int>{};
  final shared = <String, Set<int>>{};

  final hasGroups =
      subRule.patterns.any((pattern) => pattern.patternGroup != null);

  if (!hasGroups) {
    final groupKey = _mixedJoinGroupKey(gameName, gameName);
    for (final pattern in subRule.patterns) {
      patterns.add(
        WinPattern(
          name: pattern.name,
          cellIndexes: pattern.cellIndexes,
          patternGroup: groupKey,
        ),
      );
    }
    counts[groupKey] = 1;
  } else {
    final groupNames = <String>[];
    for (final pattern in subRule.patterns) {
      final groupName = pattern.patternGroup;
      if (groupName != null && !groupNames.contains(groupName)) {
        groupNames.add(groupName);
      }
    }

    for (final pattern in subRule.patterns) {
      final groupName = pattern.patternGroup;
      if (groupName == null) {
        continue;
      }
      patterns.add(
        WinPattern(
          name: pattern.name,
          cellIndexes: pattern.cellIndexes,
          patternGroup: _mixedJoinGroupKey(gameName, groupName),
        ),
      );
    }

    for (final groupName in groupNames) {
      final groupKey = _mixedJoinGroupKey(gameName, groupName);
      counts[groupKey] = subRule.requiredPatternCounts[groupName] ?? 1;
    }
  }

  if (gameName == diagonalGameName && subRule.allowSharedCellIndexes.isNotEmpty) {
    final diagonalGroupKey = _mixedJoinGroupKey(gameName, diagonalShapeGroup);
    shared[diagonalGroupKey] = Set<int>.from(subRule.allowSharedCellIndexes);
  }

  return (
    patterns: patterns,
    requiredPatternCounts: counts,
    groupAllowSharedCellIndexes: shared,
  );
}

GameRule buildActiveGameRule(
  GameRule selectedGameRule,
  Set<String> selectedPatternGroups, {
  int rectangleCount = defaultRectangleCount,
  int rectanguleCount = defaultRectanguleCount,
  int columnsCount = defaultColumnsCount,
  int rowsCount = defaultRowsCount,
  int diagonalCount = defaultDiagonalCount,
  int lineTouchesFreeCount = defaultLineTouchesFreeCount,
  int linesWithoutFreeCount = defaultLinesWithoutFreeCount,
  int lineCount = defaultLineCount,
  int smallLCount = defaultSmallLShapeCount,
  int smallCrossCount = defaultSmallCrossCount,
  int smallOCount = defaultSmallOCount,
  int smallHCount = defaultSmallHCount,
  int smallTCount = defaultSmallTCount,
  int smallXCount = defaultSmallXCount,
  int triangleCount = defaultTriangleCount,
  int triangle4x4Count = defaultTriangle4x4Count,
}) {
  if (isStaticMixPresetGameName(selectedGameRule.name)) {
    return buildStaticMixGameRule(staticMixPresetById(selectedGameRule.name));
  }

  if (selectedGameRule.name == tiezazGameName) {
    return GameRule(
      name: selectedGameRule.name,
      patterns: _buildTiezazPatterns(selectedPatternGroups),
      requiresAllPatternGroups: true,
    );
  }

  return buildConfiguredGameRule(
    selectedGameRule.name,
    rectangleCount: rectangleCount,
    rectanguleCount: rectanguleCount,
    columnsCount: columnsCount,
    rowsCount: rowsCount,
    diagonalCount: diagonalCount,
    lineTouchesFreeCount: lineTouchesFreeCount,
    linesWithoutFreeCount: linesWithoutFreeCount,
    lineCount: lineCount,
    smallLCount: smallLCount,
    smallCrossCount: smallCrossCount,
    smallOCount: smallOCount,
    smallHCount: smallHCount,
    smallTCount: smallTCount,
    smallXCount: smallXCount,
    triangleCount: triangleCount,
    triangle4x4Count: triangle4x4Count,
  );
}

List<WinPattern> _buildTiezazPatterns(Set<String> selectedGroups) {
  return [
    if (selectedGroups.contains(tiezazCrossGroup)) ..._buildCrossPatterns(),
    if (selectedGroups.contains(tiezazRectangleGroup))
      ..._buildRectanglePatterns(),
    if (selectedGroups.contains(tiezazLShapeGroup)) ..._buildLShapePatterns(),
  ];
}

List<WinPattern> _buildCrossPatterns() {
  final patterns = <WinPattern>[];

  for (int row = 1; row <= 3; row++) {
    for (int col = 1; col <= 3; col++) {
      patterns.add(
        WinPattern(
          name: '$tiezazCrossGroup ${patterns.length + 1}',
          patternGroup: tiezazCrossGroup,
          cellIndexes: [
            _cellIndex(row - 1, col),
            _cellIndex(row, col - 1),
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row + 1, col),
          ],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildRectanglePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 3; row++) {
    for (int col = 0; col <= 3; col++) {
      patterns.add(
        WinPattern(
          name: '$tiezazRectangleGroup ${patterns.length + 1}',
          patternGroup: tiezazRectangleGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row + 1, col),
            _cellIndex(row + 1, col + 1),
          ],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildRectangulePatterns() {
  final patterns = <WinPattern>[];

  // Vertical 3x2 rectangle (column-oriented).
  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 3; col++) {
      patterns.add(
        WinPattern(
          name: '$rectanguleShapeGroup ${patterns.length + 1}',
          patternGroup: rectanguleShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row + 1, col),
            _cellIndex(row + 1, col + 1),
            _cellIndex(row + 2, col),
            _cellIndex(row + 2, col + 1),
          ],
        ),
      );
    }
  }

  // Horizontal 2x3 rectangle (row-oriented).
  for (int row = 0; row <= 3; row++) {
    for (int col = 0; col <= 2; col++) {
      patterns.add(
        WinPattern(
          name: '$rectanguleShapeGroup ${patterns.length + 1}',
          patternGroup: rectanguleShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row, col + 2),
            _cellIndex(row + 1, col),
            _cellIndex(row + 1, col + 1),
            _cellIndex(row + 1, col + 2),
          ],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildColumnsPatterns() {
  return [
    for (int col = 0; col < 5; col++)
      WinPattern(
        name: '$columnsShapeGroup ${col + 1}',
        patternGroup: columnsShapeGroup,
        cellIndexes: [
          _cellIndex(0, col),
          _cellIndex(1, col),
          _cellIndex(2, col),
          _cellIndex(3, col),
          _cellIndex(4, col),
        ],
      ),
  ];
}

List<WinPattern> _buildRowsPatterns() {
  return [
    for (int row = 0; row < 5; row++)
      WinPattern(
        name: '$rowsShapeGroup ${row + 1}',
        patternGroup: rowsShapeGroup,
        cellIndexes: [
          _cellIndex(row, 0),
          _cellIndex(row, 1),
          _cellIndex(row, 2),
          _cellIndex(row, 3),
          _cellIndex(row, 4),
        ],
      ),
  ];
}

List<WinPattern> _buildDiagonalPatterns() {
  return [
    WinPattern(
      name: '$diagonalShapeGroup Left to Right',
      patternGroup: diagonalShapeGroup,
      cellIndexes: [
        _cellIndex(0, 0),
        _cellIndex(1, 1),
        _cellIndex(2, 2),
        _cellIndex(3, 3),
        _cellIndex(4, 4),
      ],
    ),
    WinPattern(
      name: '$diagonalShapeGroup Right to Left',
      patternGroup: diagonalShapeGroup,
      cellIndexes: [
        _cellIndex(0, 4),
        _cellIndex(1, 3),
        _cellIndex(2, 2),
        _cellIndex(3, 1),
        _cellIndex(4, 0),
      ],
    ),
  ];
}

List<WinPattern> _buildLineTouchesFreePatterns() {
  // LIne touches free is only the 4 lines passing through FREE (N3/index 12):
  // center column, center row, and the 2 diagonals.
  return [
    WinPattern(
      name: '$lineTouchesFreeShapeGroup Column 3',
      patternGroup: lineTouchesFreeShapeGroup,
      cellIndexes: [
        _cellIndex(0, 2),
        _cellIndex(1, 2),
        _cellIndex(2, 2),
        _cellIndex(3, 2),
        _cellIndex(4, 2),
      ],
    ),
    WinPattern(
      name: '$lineTouchesFreeShapeGroup Row 3',
      patternGroup: lineTouchesFreeShapeGroup,
      cellIndexes: [
        _cellIndex(2, 0),
        _cellIndex(2, 1),
        _cellIndex(2, 2),
        _cellIndex(2, 3),
        _cellIndex(2, 4),
      ],
    ),
    WinPattern(
      name: '$lineTouchesFreeShapeGroup Diagonal Left to Right',
      patternGroup: lineTouchesFreeShapeGroup,
      cellIndexes: [
        _cellIndex(0, 0),
        _cellIndex(1, 1),
        _cellIndex(2, 2),
        _cellIndex(3, 3),
        _cellIndex(4, 4),
      ],
    ),
    WinPattern(
      name: '$lineTouchesFreeShapeGroup Diagonal Right to Left',
      patternGroup: lineTouchesFreeShapeGroup,
      cellIndexes: [
        _cellIndex(0, 4),
        _cellIndex(1, 3),
        _cellIndex(2, 2),
        _cellIndex(3, 1),
        _cellIndex(4, 0),
      ],
    ),
  ];
}

List<WinPattern> _buildLinesWithoutFreePatterns() {
  // Rows/columns only. Any line touching FREE (index 12) is excluded.
  // Diagonals are intentionally excluded.
  return [
    for (int row = 0; row < 5; row++)
      if (row != 2)
        WinPattern(
          name: '$linesWithoutFreeShapeGroup Row ${row + 1}',
          patternGroup: linesWithoutFreeShapeGroup,
          cellIndexes: [
            _cellIndex(row, 0),
            _cellIndex(row, 1),
            _cellIndex(row, 2),
            _cellIndex(row, 3),
            _cellIndex(row, 4),
          ],
        ),
    for (int col = 0; col < 5; col++)
      if (col != 2)
        WinPattern(
          name: '$linesWithoutFreeShapeGroup Column ${col + 1}',
          patternGroup: linesWithoutFreeShapeGroup,
          cellIndexes: [
            _cellIndex(0, col),
            _cellIndex(1, col),
            _cellIndex(2, col),
            _cellIndex(3, col),
            _cellIndex(4, col),
          ],
        ),
  ];
}

List<WinPattern> _buildLinePatterns() {
  // Combined lines game: rows + columns + diagonals.
  // Lines touching FREE and not touching FREE are all valid.
  return [
    for (int row = 0; row < 5; row++)
      WinPattern(
        name: '$lineShapeGroup Row ${row + 1}',
        patternGroup: lineShapeGroup,
        cellIndexes: [
          _cellIndex(row, 0),
          _cellIndex(row, 1),
          _cellIndex(row, 2),
          _cellIndex(row, 3),
          _cellIndex(row, 4),
        ],
      ),
    for (int col = 0; col < 5; col++)
      WinPattern(
        name: '$lineShapeGroup Column ${col + 1}',
        patternGroup: lineShapeGroup,
        cellIndexes: [
          _cellIndex(0, col),
          _cellIndex(1, col),
          _cellIndex(2, col),
          _cellIndex(3, col),
          _cellIndex(4, col),
        ],
      ),
    WinPattern(
      name: '$lineShapeGroup Diagonal Left to Right',
      patternGroup: lineShapeGroup,
      cellIndexes: [
        _cellIndex(0, 0),
        _cellIndex(1, 1),
        _cellIndex(2, 2),
        _cellIndex(3, 3),
        _cellIndex(4, 4),
      ],
    ),
    WinPattern(
      name: '$lineShapeGroup Diagonal Right to Left',
      patternGroup: lineShapeGroup,
      cellIndexes: [
        _cellIndex(0, 4),
        _cellIndex(1, 3),
        _cellIndex(2, 2),
        _cellIndex(3, 1),
        _cellIndex(4, 0),
      ],
    ),
  ];
}

List<WinPattern> _buildTrianglePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 2; col++) {
      final topLeft = _cellIndex(row, col);
      final topCenter = _cellIndex(row, col + 1);
      final topRight = _cellIndex(row, col + 2);
      final middleLeft = _cellIndex(row + 1, col);
      final middleCenter = _cellIndex(row + 1, col + 1);
      final middleRight = _cellIndex(row + 1, col + 2);
      final bottomLeft = _cellIndex(row + 2, col);
      final bottomCenter = _cellIndex(row + 2, col + 1);
      final bottomRight = _cellIndex(row + 2, col + 2);

      for (final cells in [
        [topLeft, topCenter, topRight, middleLeft, middleCenter, bottomLeft],
        [topLeft, topCenter, topRight, middleCenter, middleRight, bottomRight],
        [
          topLeft,
          middleLeft,
          middleCenter,
          bottomLeft,
          bottomCenter,
          bottomRight
        ],
        [
          topRight,
          middleCenter,
          middleRight,
          bottomLeft,
          bottomCenter,
          bottomRight
        ],
      ]) {
        patterns.add(
          WinPattern(
            name: '$triangleShapeGroup ${patterns.length + 1}',
            patternGroup: triangleShapeGroup,
            cellIndexes: cells,
          ),
        );
      }
    }
  }

  return patterns;
}

List<WinPattern> _buildTriangle4x4Patterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 1; row++) {
    for (int col = 0; col <= 1; col++) {
      final topLeft = <int>[];
      final topRight = <int>[];
      final bottomLeft = <int>[];
      final bottomRight = <int>[];

      for (int dr = 0; dr < 4; dr++) {
        for (int dc = 0; dc < 4; dc++) {
          final idx = _cellIndex(row + dr, col + dc);
          if (dr + dc <= 3) {
            topLeft.add(idx);
          }
          if (dr + (3 - dc) <= 3) {
            topRight.add(idx);
          }
          if ((3 - dr) + dc <= 3) {
            bottomLeft.add(idx);
          }
          if ((3 - dr) + (3 - dc) <= 3) {
            bottomRight.add(idx);
          }
        }
      }

      for (final cells in [topLeft, topRight, bottomLeft, bottomRight]) {
        patterns.add(
          WinPattern(
            name: '$triangle4x4ShapeGroup ${patterns.length + 1}',
            patternGroup: triangle4x4ShapeGroup,
            cellIndexes: cells,
          ),
        );
      }
    }
  }

  return patterns;
}

List<WinPattern> _buildLShapePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 3; row++) {
    for (int col = 0; col <= 3; col++) {
      final topLeft = _cellIndex(row, col);
      final bottomLeft = _cellIndex(row + 1, col);
      final bottomRight = _cellIndex(row + 1, col + 1);

      patterns.add(
        WinPattern(
          name: '$tiezazLShapeGroup ${patterns.length + 1}',
          patternGroup: tiezazLShapeGroup,
          cellIndexes: [topLeft, bottomLeft, bottomRight],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildPyramidPatterns() {
  final patterns = <WinPattern>[];

  // Top/Bottom can slide vertically (start rows 0..2).
  for (int startRow = 0; startRow <= 2; startRow++) {
    patterns.add(
      WinPattern(
        name: '$pyramidGameName Top ${patterns.length + 1}',
        cellIndexes: [
          _cellIndex(startRow, 2),
          _cellIndex(startRow + 1, 1),
          _cellIndex(startRow + 1, 2),
          _cellIndex(startRow + 1, 3),
          _cellIndex(startRow + 2, 0),
          _cellIndex(startRow + 2, 1),
          _cellIndex(startRow + 2, 2),
          _cellIndex(startRow + 2, 3),
          _cellIndex(startRow + 2, 4),
        ],
      ),
    );
    patterns.add(
      WinPattern(
        name: '$pyramidGameName Bottom ${patterns.length + 1}',
        cellIndexes: [
          _cellIndex(startRow, 0),
          _cellIndex(startRow, 1),
          _cellIndex(startRow, 2),
          _cellIndex(startRow, 3),
          _cellIndex(startRow, 4),
          _cellIndex(startRow + 1, 1),
          _cellIndex(startRow + 1, 2),
          _cellIndex(startRow + 1, 3),
          _cellIndex(startRow + 2, 2),
        ],
      ),
    );
  }

  // Left/Right can slide horizontally (start cols 0..2).
  for (int startCol = 0; startCol <= 2; startCol++) {
    patterns.add(
      WinPattern(
        name: '$pyramidGameName Left ${patterns.length + 1}',
        cellIndexes: [
          _cellIndex(2, startCol),
          _cellIndex(1, startCol + 1),
          _cellIndex(2, startCol + 1),
          _cellIndex(3, startCol + 1),
          _cellIndex(0, startCol + 2),
          _cellIndex(1, startCol + 2),
          _cellIndex(2, startCol + 2),
          _cellIndex(3, startCol + 2),
          _cellIndex(4, startCol + 2),
        ],
      ),
    );
    patterns.add(
      WinPattern(
        name: '$pyramidGameName Right ${patterns.length + 1}',
        cellIndexes: [
          _cellIndex(0, startCol),
          _cellIndex(1, startCol),
          _cellIndex(2, startCol),
          _cellIndex(3, startCol),
          _cellIndex(4, startCol),
          _cellIndex(1, startCol + 1),
          _cellIndex(2, startCol + 1),
          _cellIndex(3, startCol + 1),
          _cellIndex(2, startCol + 2),
        ],
      ),
    );
  }

  return patterns;
}

List<WinPattern> _buildBigLShapePatterns() {
  return [
    const WinPattern(
      name: '$bigLShapeGameName Bottom Left',
      cellIndexes: [0, 5, 10, 15, 20, 21, 22, 23, 24],
    ),
    const WinPattern(
      name: '$bigLShapeGameName Bottom Right',
      cellIndexes: [4, 9, 14, 19, 20, 21, 22, 23, 24],
    ),
    const WinPattern(
      name: '$bigLShapeGameName Top Left',
      cellIndexes: [0, 1, 2, 3, 4, 5, 10, 15, 20],
    ),
    const WinPattern(
      name: '$bigLShapeGameName Top Right',
      cellIndexes: [0, 1, 2, 3, 4, 9, 14, 19, 24],
    ),
  ];
}

List<WinPattern> _buildBigTShapePatterns() {
  return [
    const WinPattern(
      name: '$bigTShapeGameName Top',
      cellIndexes: [0, 1, 2, 3, 4, 7, 12, 17, 22],
    ),
    const WinPattern(
      name: '$bigTShapeGameName Bottom',
      cellIndexes: [2, 7, 12, 17, 20, 21, 22, 23, 24],
    ),
    const WinPattern(
      name: '$bigTShapeGameName Left',
      cellIndexes: [0, 5, 10, 11, 12, 13, 14, 15, 20],
    ),
    const WinPattern(
      name: '$bigTShapeGameName Right',
      cellIndexes: [4, 9, 10, 11, 12, 13, 14, 19, 24],
    ),
  ];
}

List<WinPattern> _buildBigNShapePatterns() {
  return [
    const WinPattern(
      // Top-heavy N:
      // B1 I1 N1 G1 O1 G2 N3 I4 B5 I5 N5 G5 O5
      name: '$bigNShapeGameName Top',
      cellIndexes: [0, 1, 2, 3, 4, 8, 12, 16, 20, 21, 22, 23, 24],
    ),
    const WinPattern(
      // Side-heavy N:
      // B1 B2 B3 B4 B5 I2 N3 G4 O5 O4 O3 O2 O1
      name: '$bigNShapeGameName Side',
      cellIndexes: [0, 5, 10, 15, 20, 6, 12, 18, 24, 19, 14, 9, 4],
    ),
  ];
}

List<WinPattern> _buildBigYShapePatterns() {
  return [
    const WinPattern(
      // Top orientation: two upper arms + downward stem.
      // B1 I2 N3 G2 O1 N4 N5
      name: '$bigYShapeGameName Top',
      cellIndexes: [0, 6, 12, 17, 22, 8, 4],
    ),
    const WinPattern(
      // Right orientation: two left arms + rightward stem.
      // B1 B5 I2 I4 N3 G3 O3
      name: '$bigYShapeGameName Right',
      cellIndexes: [0, 20, 6, 16, 12, 13, 14],
    ),
    const WinPattern(
      // Bottom orientation: two lower arms + upward stem.
      // B5 I4 N3 G4 O5 N2 N1
      name: '$bigYShapeGameName Bottom',
      cellIndexes: [20, 16, 12, 18, 24, 7, 2],
    ),
    const WinPattern(
      // Left orientation: two right arms + leftward stem.
      // O1 O5 G2 G4 N3 I3 B3
      name: '$bigYShapeGameName Left',
      cellIndexes: [4, 24, 8, 18, 12, 11, 10],
    ),
  ];
}

List<WinPattern> _buildBigCrossPatterns() {
  return [
    const WinPattern(
      // Full N column + full third row (cross through FREE).
      name: '$bigCrossGameName Center Cross',
      cellIndexes: [2, 7, 12, 17, 22, 10, 11, 13, 14],
    ),
  ];
}

List<WinPattern> _buildBigHShapePatterns() {
  return [
    const WinPattern(
      // Full B column + full O column + middle row (B3–O3).
      name: '$bigHShapeGameName B-O Sides',
      cellIndexes: [0, 5, 10, 11, 12, 13, 14, 15, 20, 4, 9, 19, 24],
    ),
    const WinPattern(
      // Top row (B1–O1) + full N column + bottom row (B5–O5).
      name: '$bigHShapeGameName Top-N-Bottom',
      cellIndexes: [0, 1, 2, 3, 4, 7, 12, 17, 22, 20, 21, 23, 24],
    ),
  ];
}

List<WinPattern> _buildRightShapePatterns() {
  return [
    const WinPattern(
      name: '$rightShapeGameName Left Side',
      cellIndexes: [0, 4, 5, 8, 10, 12, 15, 16, 20],
    ),
    const WinPattern(
      name: '$rightShapeGameName Top Side',
      cellIndexes: [0, 1, 2, 3, 4, 6, 12, 18, 24],
    ),
    const WinPattern(
      name: '$rightShapeGameName Right Side',
      cellIndexes: [4, 8, 9, 12, 14, 16, 19, 20, 24],
    ),
    const WinPattern(
      name: '$rightShapeGameName Bottom Side',
      cellIndexes: [0, 6, 12, 18, 20, 21, 22, 23, 24],
    ),
  ];
}

List<WinPattern> _buildSmallTShapePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 2; col++) {
      final topLeft = _cellIndex(row, col);
      final topCenter = _cellIndex(row, col + 1);
      final topRight = _cellIndex(row, col + 2);
      final middleLeft = _cellIndex(row + 1, col);
      final middleCenter = _cellIndex(row + 1, col + 1);
      final middleRight = _cellIndex(row + 1, col + 2);
      final bottomLeft = _cellIndex(row + 2, col);
      final bottomCenter = _cellIndex(row + 2, col + 1);
      final bottomRight = _cellIndex(row + 2, col + 2);

      for (final cells in [
        [topLeft, topCenter, topRight, middleCenter, bottomCenter],
        [bottomLeft, bottomCenter, bottomRight, middleCenter, topCenter],
        [topLeft, middleLeft, bottomLeft, middleCenter, middleRight],
        [topRight, middleRight, bottomRight, middleCenter, middleLeft],
      ]) {
        patterns.add(
          WinPattern(
            name: '$smallTShapeGroup ${patterns.length + 1}',
            patternGroup: smallTShapeGroup,
            cellIndexes: cells,
          ),
        );
      }
    }
  }

  return patterns;
}

List<WinPattern> _buildSmallXShapePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 2; col++) {
      patterns.add(
        WinPattern(
          name: '$smallXShapeGroup ${patterns.length + 1}',
          patternGroup: smallXShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 2),
            _cellIndex(row + 1, col + 1),
            _cellIndex(row + 2, col),
            _cellIndex(row + 2, col + 2),
          ],
        ),
      );
    }
  }

  return patterns;
}

/// Top-left corner of the 3×3 block for a valid small X pattern.
(int, int)? _smallXTopLeftCorner(WinPattern pattern) {
  if (pattern.cellIndexes.length != 5) {
    return null;
  }
  final rows = pattern.cellIndexes.map((index) => index ~/ 5).toList();
  final cols = pattern.cellIndexes.map((index) => index % 5).toList();
  final int minRow = rows.reduce((a, b) => a < b ? a : b);
  final int maxRow = rows.reduce((a, b) => a > b ? a : b);
  final int minCol = cols.reduce((a, b) => a < b ? a : b);
  final int maxCol = cols.reduce((a, b) => a > b ? a : b);
  if (maxRow - minRow != 2 || maxCol - minCol != 2) {
    return null;
  }

  final topLeft = _cellIndex(minRow, minCol);
  final topRight = _cellIndex(minRow, maxCol);
  final bottomLeft = _cellIndex(maxRow, minCol);
  final bottomRight = _cellIndex(maxRow, maxCol);
  final center = _cellIndex(minRow + 1, minCol + 1);
  final expected = {topLeft, topRight, bottomLeft, bottomRight, center};
  if (expected.length != 5 || !expected.containsAll(pattern.cellIndexes)) {
    return null;
  }
  return (minRow, minCol);
}

List<(int, int, int, int)> _smallXDiagonalSegments(WinPattern pattern) {
  final corner = _smallXTopLeftCorner(pattern);
  if (corner == null) {
    return const [];
  }
  final (row, col) = corner;
  return [
    (row, col, row + 2, col + 2),
    (row, col + 2, row + 2, col),
  ];
}

int _segmentOrientation(
  int rowA,
  int colA,
  int rowB,
  int colB,
  int rowC,
  int colC,
) {
  final cross =
      (colB - colA) * (rowC - rowA) - (rowB - rowA) * (colC - colA);
  if (cross == 0) {
    return 0;
  }
  return cross > 0 ? 1 : 2;
}

bool _pointOnSegment(
  int rowA,
  int colA,
  int rowB,
  int colB,
  int rowC,
  int colC,
) {
  return rowC <= (rowA > rowB ? rowA : rowB) &&
      rowC >= (rowA < rowB ? rowA : rowB) &&
      colC <= (colA > colB ? colA : colB) &&
      colC >= (colA < colB ? colA : colB);
}

bool _gridSegmentsIntersect(
  int rowA1,
  int colA1,
  int rowA2,
  int colA2,
  int rowB1,
  int colB1,
  int rowB2,
  int colB2,
) {
  final o1 = _segmentOrientation(rowA1, colA1, rowA2, colA2, rowB1, colB1);
  final o2 = _segmentOrientation(rowA1, colA1, rowA2, colA2, rowB2, colB2);
  final o3 = _segmentOrientation(rowB1, colB1, rowB2, colB2, rowA1, colA1);
  final o4 = _segmentOrientation(rowB1, colB1, rowB2, colB2, rowA2, colA2);

  if (o1 != o2 && o3 != o4) {
    return true;
  }

  if (o1 == 0 && _pointOnSegment(rowA1, colA1, rowA2, colA2, rowB1, colB1)) {
    return true;
  }
  if (o2 == 0 && _pointOnSegment(rowA1, colA1, rowA2, colA2, rowB2, colB2)) {
    return true;
  }
  if (o3 == 0 && _pointOnSegment(rowB1, colB1, rowB2, colB2, rowA1, colA1)) {
    return true;
  }
  if (o4 == 0 && _pointOnSegment(rowB1, colB1, rowB2, colB2, rowA2, colA2)) {
    return true;
  }

  return false;
}

/// Two small X patterns may not share cells or have diagonal lines that cross.
bool _smallXPatternsAreCompatible(WinPattern first, WinPattern second) {
  if (first.patternGroup != smallXShapeGroup ||
      second.patternGroup != smallXShapeGroup) {
    return true;
  }

  final firstCells = first.cellIndexes.toSet();
  final secondCells = second.cellIndexes.toSet();
  if (firstCells.intersection(secondCells).isNotEmpty) {
    return false;
  }

  final firstSegments = _smallXDiagonalSegments(first);
  final secondSegments = _smallXDiagonalSegments(second);
  for (final firstSegment in firstSegments) {
    for (final secondSegment in secondSegments) {
      if (_gridSegmentsIntersect(
        firstSegment.$1,
        firstSegment.$2,
        firstSegment.$3,
        firstSegment.$4,
        secondSegment.$1,
        secondSegment.$2,
        secondSegment.$3,
        secondSegment.$4,
      )) {
        return false;
      }
    }
  }

  return true;
}

bool _smallXCandidateCombinesWith(
  WinPattern candidate,
  Iterable<WinPattern> others,
) {
  for (final other in others) {
    if (!_smallXPatternsAreCompatible(candidate, other)) {
      return false;
    }
  }
  return true;
}

List<WinPattern> _buildSmallOPatterns() {
  final patterns = <WinPattern>[];

  // Closed 3x3 O ring (8 cells): top row + side middles + bottom row.
  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 2; col++) {
      patterns.add(
        WinPattern(
          name: '$smallOShapeGroup ${patterns.length + 1}',
          patternGroup: smallOShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row, col + 2),
            _cellIndex(row + 1, col),
            _cellIndex(row + 1, col + 2),
            _cellIndex(row + 2, col),
            _cellIndex(row + 2, col + 1),
            _cellIndex(row + 2, col + 2),
          ],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildSmallHPatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 2; row++) {
    for (int col = 0; col <= 2; col++) {
      // Mini BIG H: left + right columns + middle row (3×3 “B–O sides”).
      patterns.add(
        WinPattern(
          name: '$smallHShapeGroup B-O Sides',
          patternGroup: smallHShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row + 1, col),
            _cellIndex(row + 2, col),
            _cellIndex(row, col + 2),
            _cellIndex(row + 1, col + 2),
            _cellIndex(row + 2, col + 2),
            _cellIndex(row + 1, col + 1),
          ],
        ),
      );
      // Mini BIG H: top + bottom rows + center cell (3×3 “top–N–bottom”).
      patterns.add(
        WinPattern(
          name: '$smallHShapeGroup Top-N-Bottom',
          patternGroup: smallHShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row, col + 1),
            _cellIndex(row, col + 2),
            _cellIndex(row + 1, col + 1),
            _cellIndex(row + 2, col),
            _cellIndex(row + 2, col + 1),
            _cellIndex(row + 2, col + 2),
          ],
        ),
      );
    }
  }

  return patterns;
}

List<WinPattern> _buildSmallLShapePatterns() {
  final patterns = <WinPattern>[];

  for (int row = 0; row <= 3; row++) {
    for (int col = 0; col <= 3; col++) {
      // Single-side L only: top-left -> bottom-left -> bottom-right.
      patterns.add(
        WinPattern(
          name: '$smallLShapeGroup ${patterns.length + 1}',
          patternGroup: smallLShapeGroup,
          cellIndexes: [
            _cellIndex(row, col),
            _cellIndex(row + 1, col),
            _cellIndex(row + 1, col + 1),
          ],
        ),
      );
    }
  }

  return patterns;
}

int _cellIndex(int row, int col) => (row * 5) + col;

int _cellMaskForIndexes(Iterable<int> indexes) {
  var mask = 0;
  for (final index in indexes) {
    if (index >= 0 && index < 25) {
      mask |= 1 << index;
    }
  }
  return mask;
}

int _markedCellMask(List<bool> marked) {
  var mask = 0;
  for (int index = 0; index < 25; index++) {
    if (_isCellMarkedForGame(index, marked)) {
      mask |= 1 << index;
    }
  }
  return mask;
}

List<int> _cellIndexesFromMask(int mask) {
  final indexes = <int>[];
  for (int index = 0; index < 25; index++) {
    if ((mask & (1 << index)) != 0) {
      indexes.add(index);
    }
  }
  return indexes;
}

int _bitCount(int mask) {
  var count = 0;
  var value = mask;
  while (value != 0) {
    value &= value - 1;
    count++;
  }
  return count;
}

int _singleIndexFromMask(int mask) {
  for (int index = 0; index < 25; index++) {
    if ((mask & (1 << index)) != 0) {
      return index;
    }
  }
  return -1;
}

GameResult evaluateCartelaForGame(
  Map<String, List<dynamic>> cartela,
  GameRule gameRule, {
  bool includeOneAway = true,
}) {
  _debugValidateGameRule(gameRule);

  final List<bool> marked = List<bool>.from(
    cartela['marked'] ?? List<bool>.generate(25, (index) => false),
  );

  if (isStaticMixPresetGameName(gameRule.name) ||
      gameRule.name == mixedJoinGameName) {
    if (gameRule.patterns.isEmpty) {
      return const GameResult(
        bestPattern: null,
        markedCount: 0,
        requiredCount: 0,
        isBingo: false,
        missingCellIndexes: [],
        oneAwayCellIndexes: [],
        winningCellIndexes: [],
      );
    }
    return _evaluateRequiredPatternGroups(
      gameRule,
      marked,
      includeOneAway: includeOneAway,
    );
  }

  if (gameRule.name == diagonalGameName) {
    final requiredCount = gameRule.requiredPatternCounts[diagonalShapeGroup] ??
        defaultDiagonalCount;
    return _evaluateDiagonalGame(marked, requiredCount, includeOneAway);
  }
  if (gameRule.name == lineTouchesFreeGameName) {
    final requiredCount =
        gameRule.requiredPatternCounts[lineTouchesFreeShapeGroup] ??
            defaultLineTouchesFreeCount;
    return _evaluateLineTouchesFreeGame(marked, requiredCount, includeOneAway);
  }
  if (gameRule.name == linesWithoutFreeGameName) {
    final requiredCount =
        gameRule.requiredPatternCounts[linesWithoutFreeShapeGroup] ??
            defaultLinesWithoutFreeCount;
    return _evaluateLinesWithoutFreeGame(marked, requiredCount, includeOneAway);
  }
  if (gameRule.name == lineGameName) {
    final requiredCount =
        gameRule.requiredPatternCounts[lineShapeGroup] ?? defaultLineCount;
    return _evaluateLineGame(marked, requiredCount, includeOneAway);
  }
  if (gameRule.name == smallOGameName) {
    final requiredCount =
        gameRule.requiredPatternCounts[smallOShapeGroup] ?? defaultSmallOCount;
    return _evaluateCountedPatternGame(
      marked,
      _buildSmallOPatterns(),
      requiredCount,
      includeOneAway,
    );
  }
  if (gameRule.name == smallHGameName && !gameRule.requiresAllPatternGroups) {
    final requiredCount =
        gameRule.requiredPatternCounts[smallHShapeGroup] ?? defaultSmallHCount;
    return _evaluateCountedPatternGame(
      marked,
      _buildSmallHPatterns(),
      requiredCount,
      includeOneAway,
    );
  }
  if (gameRule.name == smallTGameName && !gameRule.requiresAllPatternGroups) {
    final requiredCount =
        gameRule.requiredPatternCounts[smallTShapeGroup] ?? defaultSmallTCount;
    return _evaluateCountedPatternGame(
      marked,
      _buildSmallTShapePatterns(),
      requiredCount,
      includeOneAway,
    );
  }
  if (gameRule.name == smallXGameName && !gameRule.requiresAllPatternGroups) {
    final requiredCount =
        gameRule.requiredPatternCounts[smallXShapeGroup] ?? defaultSmallXCount;
    return _evaluateCountedPatternGame(
      marked,
      _buildSmallXShapePatterns(),
      requiredCount,
      includeOneAway,
    );
  }

  if (gameRule.requiresAllPatternGroups) {
    return _evaluateRequiredPatternGroups(
      gameRule,
      marked,
      includeOneAway: includeOneAway,
    );
  }

  WinPattern? bestPattern;
  int bestMarkedCount = -1;
  int bestRequiredCount = 0;
  List<int> bestMissingCellIndexes = const [];
  final Set<int> oneAwayCellIndexes = {};
  final Set<int> winningCellIndexes = {};
  final completedPatterns = <WinPattern>[];
  bool hasBingo = false;

  for (final pattern in gameRule.patterns) {
    final int markedCount = pattern.cellIndexes
        .where((index) => _isCellMarkedForGame(index, marked))
        .length;
    final List<int> missingCellIndexes = pattern.cellIndexes
        .where((index) => !_isCellMarkedForGame(index, marked))
        .toList();
    final bool isComplete = markedCount == pattern.cellIndexes.length;

    if (isComplete) {
      winningCellIndexes.addAll(pattern.cellIndexes);
      completedPatterns.add(pattern);
    }

    if (includeOneAway && !isComplete && missingCellIndexes.length == 1) {
      oneAwayCellIndexes.add(missingCellIndexes.first);
    }

    if (bestPattern == null ||
        (isComplete && !hasBingo) ||
        (!hasBingo && !isComplete && markedCount > bestMarkedCount)) {
      bestPattern = pattern;
      bestMarkedCount = markedCount;
      bestRequiredCount = pattern.cellIndexes.length;
      bestMissingCellIndexes = missingCellIndexes;
      hasBingo = isComplete;
    }
  }

  return GameResult(
    bestPattern: bestPattern,
    markedCount: bestMarkedCount < 0 ? 0 : bestMarkedCount,
    requiredCount: bestRequiredCount,
    isBingo: hasBingo,
    missingCellIndexes: bestMissingCellIndexes,
    oneAwayCellIndexes: hasBingo ? const [] : oneAwayCellIndexes.toList(),
    winningCellIndexes: hasBingo ? winningCellIndexes.toList() : const [],
    winningPatterns: hasBingo ? completedPatterns : const [],
  );
}

GameResult _evaluateDiagonalGame(
  List<bool> marked,
  int requiredDiagonalCount,
  bool includeOneAway,
) {
  final leftToRight = [0, 6, 12, 18, 24]; // B1 I2 N3 G4 O5
  final rightToLeft = [4, 8, 12, 16, 20]; // O1 G2 N3 I4 B5
  final diagonals = [leftToRight, rightToLeft];

  int diagonalMarkedCount(List<int> diagonal) =>
      diagonal.where((index) => _isCellMarkedForGame(index, marked)).length;

  List<int> diagonalMissing(List<int> diagonal) =>
      diagonal.where((index) => !_isCellMarkedForGame(index, marked)).toList();

  final completeFlags =
      diagonals.map((diagonal) => diagonalMissing(diagonal).isEmpty).toList();
  final completeIndexes = <int>[
    for (int i = 0; i < completeFlags.length; i++)
      if (completeFlags[i]) i,
  ];

  if (requiredDiagonalCount <= 1) {
    final bool isBingo = completeIndexes.isNotEmpty;
    int bestIndex = 0;
    int bestCount = -1;
    List<int> bestMissing = diagonalMissing(diagonals[0]);
    for (int i = 0; i < diagonals.length; i++) {
      final count = diagonalMarkedCount(diagonals[i]);
      final missing = diagonalMissing(diagonals[i]);
      if (count > bestCount) {
        bestCount = count;
        bestIndex = i;
        bestMissing = missing;
      }
    }

    final oneAwayCells = includeOneAway && !isBingo
        ? [
            for (int i = 0; i < diagonals.length; i++)
              if (diagonalMissing(diagonals[i]).length == 1)
                diagonalMissing(diagonals[i]).first,
          ].toSet().toList()
        : const <int>[];

    final winningPatterns = isBingo
        ? <WinPattern>[
            WinPattern(
              name: completeIndexes.first == 0
                  ? '$diagonalShapeGroup Left to Right'
                  : '$diagonalShapeGroup Right to Left',
              patternGroup: diagonalShapeGroup,
              cellIndexes: diagonals[completeIndexes.first],
            )
          ]
        : const <WinPattern>[];

    final winningCells =
        isBingo ? diagonals[completeIndexes.first] : const <int>[];

    return GameResult(
      bestPattern: WinPattern(
        name: bestIndex == 0
            ? '$diagonalShapeGroup Left to Right'
            : '$diagonalShapeGroup Right to Left',
        patternGroup: diagonalShapeGroup,
        cellIndexes: diagonals[bestIndex],
      ),
      markedCount: bestCount < 0 ? 0 : bestCount,
      requiredCount: 5,
      isBingo: isBingo,
      missingCellIndexes: bestMissing,
      oneAwayCellIndexes: oneAwayCells,
      winningCellIndexes: winningCells,
      winningPatterns: winningPatterns,
    );
  }

  // For count 2, both diagonals are required (center FREE is shared).
  final bool bothComplete = completeFlags.every((v) => v);
  final unionCells = <int>{...leftToRight, ...rightToLeft}.toList();
  final markedCount =
      unionCells.where((index) => _isCellMarkedForGame(index, marked)).length;
  final missingUnion = unionCells
      .where((index) => !_isCellMarkedForGame(index, marked))
      .toList();

  final oneAwayCells =
      includeOneAway && !bothComplete && missingUnion.length == 1
          ? [missingUnion.first]
          : const <int>[];

  return GameResult(
    bestPattern: WinPattern(
      name: '$diagonalShapeGroup Both',
      patternGroup: diagonalShapeGroup,
      cellIndexes: unionCells,
    ),
    markedCount: markedCount,
    requiredCount: unionCells.length,
    isBingo: bothComplete,
    missingCellIndexes: missingUnion,
    oneAwayCellIndexes: oneAwayCells,
    winningCellIndexes: bothComplete ? unionCells : const [],
    winningPatterns: bothComplete
        ? [
            WinPattern(
              name: '$diagonalShapeGroup Left to Right',
              patternGroup: diagonalShapeGroup,
              cellIndexes: leftToRight,
            ),
            WinPattern(
              name: '$diagonalShapeGroup Right to Left',
              patternGroup: diagonalShapeGroup,
              cellIndexes: rightToLeft,
            ),
          ]
        : const [],
  );
}

GameResult _evaluateLineTouchesFreeGame(
  List<bool> marked,
  int requiredLineCount,
  bool includeOneAway,
) {
  final base = _evaluateCountedPatternGame(
    marked,
    _buildLineTouchesFreePatterns(),
    requiredLineCount,
    false,
  );

  if (!includeOneAway || base.isBingo) {
    return base;
  }

  return GameResult(
    bestPattern: base.bestPattern,
    markedCount: base.markedCount,
    requiredCount: base.requiredCount,
    isBingo: base.isBingo,
    missingCellIndexes: base.missingCellIndexes,
    oneAwayCellIndexes: _collectGoalOneAwayCellsForCountedPatterns(
      _buildLineTouchesFreePatterns(),
      marked,
      requiredLineCount,
    ),
    winningCellIndexes: base.winningCellIndexes,
    winningPatterns: base.winningPatterns,
  );
}

GameResult _evaluateLinesWithoutFreeGame(
  List<bool> marked,
  int requiredLineCount,
  bool includeOneAway,
) {
  final base = _evaluateCountedPatternGame(
    marked,
    _buildLinesWithoutFreePatterns(),
    requiredLineCount,
    false,
  );

  if (!includeOneAway || base.isBingo) {
    return base;
  }

  return GameResult(
    bestPattern: base.bestPattern,
    markedCount: base.markedCount,
    requiredCount: base.requiredCount,
    isBingo: base.isBingo,
    missingCellIndexes: base.missingCellIndexes,
    oneAwayCellIndexes: _collectGoalOneAwayCellsForCountedPatterns(
      _buildLinesWithoutFreePatterns(),
      marked,
      requiredLineCount,
    ),
    winningCellIndexes: base.winningCellIndexes,
    winningPatterns: base.winningPatterns,
  );
}

GameResult _evaluateLineGame(
  List<bool> marked,
  int requiredLineCount,
  bool includeOneAway,
) {
  final base = _evaluateCountedPatternGame(
    marked,
    _buildLinePatterns(),
    requiredLineCount,
    false,
  );

  if (!includeOneAway || base.isBingo) {
    return base;
  }

  return GameResult(
    bestPattern: base.bestPattern,
    markedCount: base.markedCount,
    requiredCount: base.requiredCount,
    isBingo: base.isBingo,
    missingCellIndexes: base.missingCellIndexes,
    oneAwayCellIndexes: _collectGoalOneAwayCellsForCountedPatterns(
      _buildLinePatterns(),
      marked,
      requiredLineCount,
    ),
    winningCellIndexes: base.winningCellIndexes,
    winningPatterns: base.winningPatterns,
  );
}

GameResult _evaluateCountedPatternGame(
  List<bool> marked,
  List<WinPattern> patterns,
  int requiredPatternCount,
  bool includeOneAway,
) {
  final scores = <(WinPattern pattern, int markedCount, List<int> missing)>[];
  final completed = <WinPattern>[];

  for (final pattern in patterns) {
    final missing = pattern.cellIndexes
        .where((index) => !_isCellMarkedForGame(index, marked))
        .toList();
    final markedCount = pattern.cellIndexes.length - missing.length;
    scores.add((pattern, markedCount, missing));
    if (missing.isEmpty) {
      completed.add(pattern);
    }
  }

  final isBingo = completed.length >= requiredPatternCount;
  scores.sort((a, b) => b.$2.compareTo(a.$2));
  final top = scores.take(requiredPatternCount).toList();
  final missingTop = top.expand((entry) => entry.$3).toSet().toList();
  final markedTop = top.fold<int>(0, (sum, entry) => sum + entry.$2);
  final winningPatterns = isBingo
      ? completed.take(requiredPatternCount).toList()
      : const <WinPattern>[];
  final winningCells = isBingo
      ? winningPatterns
          .expand((pattern) => pattern.cellIndexes)
          .toSet()
          .toList()
      : const <int>[];
  final oneAwayCells = includeOneAway && !isBingo
      ? scores
          .where((entry) => entry.$3.length == 1)
          .map((entry) => entry.$3.first)
          .toSet()
          .toList()
      : const <int>[];
  final patternSize = patterns.isEmpty ? 0 : patterns.first.cellIndexes.length;

  return GameResult(
    bestPattern: top.isEmpty ? null : top.first.$1,
    markedCount: markedTop,
    requiredCount: requiredPatternCount * patternSize,
    isBingo: isBingo,
    missingCellIndexes: missingTop.cast<int>(),
    oneAwayCellIndexes: oneAwayCells,
    winningCellIndexes: winningCells,
    winningPatterns: winningPatterns,
  );
}

List<int> _collectGoalOneAwayCellsForCountedPatterns(
  List<WinPattern> patterns,
  List<bool> marked,
  int requiredPatternCount,
) {
  if (requiredPatternCount <= 0 || patterns.length < requiredPatternCount) {
    return const [];
  }

  final oneAwayCells = <int>{};

  void choose(int start, int picked, Set<int> missingUnion) {
    if (picked == requiredPatternCount) {
      if (missingUnion.length == 1) {
        oneAwayCells.add(missingUnion.first);
      }
      return;
    }

    for (int i = start; i < patterns.length; i++) {
      final pattern = patterns[i];
      final nextMissing = Set<int>.from(missingUnion);
      for (final index in pattern.cellIndexes) {
        if (!_isCellMarkedForGame(index, marked)) {
          nextMissing.add(index);
        }
      }

      // Not a final one-away candidate anymore; prune branch.
      if (nextMissing.length > 1) {
        continue;
      }

      choose(i + 1, picked + 1, nextMissing);
    }
  }

  choose(0, 0, <int>{});
  return oneAwayCells.toList();
}

void _debugValidateGameRule(GameRule gameRule) {
  assert(() {
    final errors = validateGameRule(gameRule);
    if (errors.isNotEmpty) {
      throw StateError(
          'Invalid GameRule ${gameRule.name}: ${errors.join(' ')}');
    }
    return true;
  }());
}

GameResult _evaluateRequiredPatternGroups(
  GameRule gameRule,
  List<bool> marked, {
  required bool includeOneAway,
}) {
  final patternGroups = _requiredPatternGroups(gameRule);

  if (patternGroups.isEmpty) {
    return const GameResult(
      bestPattern: null,
      markedCount: 0,
      requiredCount: 0,
      isBingo: false,
      missingCellIndexes: [],
      oneAwayCellIndexes: [],
      winningCellIndexes: [],
    );
  }

  final bestCombination = _findBestNonOverlappingCombination(
    patternGroups,
    marked,
  );

  final isComplete = bestCombination?.isComplete ?? false;
  final oneAwayCellIndexes = includeOneAway && !isComplete
      ? _collectRequiredGroupOneAwayCells(gameRule, marked)
      : const <int>[];

  return GameResult(
    bestPattern: bestCombination?.patterns.first,
    markedCount: bestCombination?.markedCount ?? 0,
    requiredCount: bestCombination?.requiredCount ?? 0,
    isBingo: isComplete,
    missingCellIndexes: bestCombination?.missingCellIndexes ?? const [],
    oneAwayCellIndexes: oneAwayCellIndexes,
    winningCellIndexes: isComplete ? bestCombination!.cellIndexes : const [],
    winningPatterns: isComplete ? bestCombination!.patterns : const [],
  );
}

List<int> _collectRequiredGroupOneAwayCells(
    GameRule gameRule, List<bool> marked) {
  final patternGroups = _requiredPatternGroups(gameRule);
  if (patternGroups.isEmpty) {
    return const [];
  }

  final markedMask = _markedCellMask(marked);
  final oneAwayCells = <int>{};

  void visit(
    int groupIndex,
    int usedMask,
    List<WinPattern> selectedPatterns,
  ) {
    if (groupIndex == patternGroups.length) {
      final missingMask = usedMask & ~markedMask;
      if (_bitCount(missingMask) == 1) {
        oneAwayCells.add(_singleIndexFromMask(missingMask));
      }
      return;
    }

    final group = patternGroups[groupIndex];

    void chooseFromGroup(
      int start,
      int picked,
      int groupMask,
      List<_RequiredPatternCandidate> groupPatterns,
    ) {
      if (picked == group.requiredCount) {
        visit(
          groupIndex + 1,
          groupMask,
          [
            ...selectedPatterns,
            ...groupPatterns.map((candidate) => candidate.pattern),
          ],
        );
        return;
      }

      for (int i = start; i < group.candidates.length; i++) {
        final candidate = group.candidates[i];
        final overlapMask = candidate.cellMask & groupMask;
        if ((overlapMask & ~group.allowedSharedCellMask) != 0) {
          continue;
        }
        final otherPatterns = [
          ...selectedPatterns,
          ...groupPatterns.map((c) => c.pattern),
        ];
        if (!_smallXCandidateCombinesWith(candidate.pattern, otherPatterns)) {
          continue;
        }

        chooseFromGroup(
          i + 1,
          picked + 1,
          groupMask | candidate.cellMask,
          [...groupPatterns, candidate],
        );
      }
    }

    chooseFromGroup(0, 0, usedMask, []);
  }

  visit(0, 0, []);
  return oneAwayCells.toList();
}

List<WinPattern> selectWinningPatternsForDisplay(
  Map<String, List<dynamic>> cartela,
  GameRule gameRule,
) {
  final marked = List<bool>.from(
    cartela['marked'] ?? List<bool>.generate(25, (index) => false),
  );

  if (gameRule.name == diagonalGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      diagonalShapeGroup,
      defaultDiagonalCount,
    );
  }

  if (gameRule.requiresAllPatternGroups) {
    return _selectCompletedPatternsForRequiredGroups(gameRule, marked);
  }

  if (gameRule.name == lineTouchesFreeGameName) {
    return _selectCompletedLineTouchesFreePatterns(gameRule, marked);
  }
  if (gameRule.name == linesWithoutFreeGameName) {
    return _selectCompletedLinesWithoutFreePatterns(gameRule, marked);
  }
  if (gameRule.name == lineGameName) {
    return _selectCompletedLinePatterns(gameRule, marked);
  }
  if (gameRule.name == triangleGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      triangleShapeGroup,
      defaultTriangleCount,
    );
  }
  if (gameRule.name == triangle4x4GameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      triangle4x4ShapeGroup,
      defaultTriangle4x4Count,
    );
  }
  if (gameRule.name == smallOGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      smallOShapeGroup,
      defaultSmallOCount,
    );
  }
  if (gameRule.name == smallHGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      smallHShapeGroup,
      defaultSmallHCount,
    );
  }
  if (gameRule.name == smallTGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      smallTShapeGroup,
      defaultSmallTCount,
    );
  }
  if (gameRule.name == smallXGameName) {
    return _selectCompletedCountedPatterns(
      gameRule,
      marked,
      smallXShapeGroup,
      defaultSmallXCount,
    );
  }

  final completed = gameRule.patterns.where((pattern) {
    return pattern.cellIndexes
        .every((index) => _isCellMarkedForGame(index, marked));
  }).toList();

  if (completed.isEmpty) {
    return const [];
  }

  // Keep non-group games clean by drawing the first completed target pattern.
  return [completed.first];
}

/// Counts all cells marked on a cartela (index 12 FREE is always counted).
int countMarkedCellsForCartela(Map<String, List<dynamic>> cartela) {
  final marked = List<bool>.from(
    cartela['marked'] ?? List<bool>.generate(25, (index) => false),
  );
  var count = 0;
  for (int index = 0; index < marked.length; index++) {
    if (_isCellMarkedForGame(index, marked)) {
      count++;
    }
  }
  return count;
}

/// Counts all fully completed patterns for the selected game rule.
int countCompletedPatternsForGame(
  Map<String, List<dynamic>> cartela,
  GameRule gameRule,
) {
  final marked = List<bool>.from(
    cartela['marked'] ?? List<bool>.generate(25, (index) => false),
  );
  return gameRule.patterns
      .where(
        (pattern) => pattern.cellIndexes.every(
          (index) => _isCellMarkedForGame(index, marked),
        ),
      )
      .length;
}

List<WinPattern> _selectCompletedCountedPatterns(
  GameRule gameRule,
  List<bool> marked,
  String groupName,
  int defaultCount,
) {
  final requiredCount =
      gameRule.requiredPatternCounts[groupName] ?? defaultCount;
  final completed = gameRule.patterns.where((pattern) {
    return pattern.cellIndexes
        .every((index) => _isCellMarkedForGame(index, marked));
  }).toList();
  if (completed.isEmpty) {
    return const [];
  }
  final maxToDraw =
      completed.length < requiredCount ? completed.length : requiredCount;
  return completed.take(maxToDraw).toList();
}

List<WinPattern> _selectCompletedLineTouchesFreePatterns(
  GameRule gameRule,
  List<bool> marked,
) {
  return _selectCompletedCountedPatterns(
    gameRule,
    marked,
    lineTouchesFreeShapeGroup,
    defaultLineTouchesFreeCount,
  );
}

List<WinPattern> _selectCompletedLinesWithoutFreePatterns(
  GameRule gameRule,
  List<bool> marked,
) {
  final requiredCount =
      gameRule.requiredPatternCounts[linesWithoutFreeShapeGroup] ??
          defaultLinesWithoutFreeCount;
  final completed = gameRule.patterns.where((pattern) {
    return pattern.cellIndexes
        .every((index) => _isCellMarkedForGame(index, marked));
  }).toList();
  if (completed.isEmpty) {
    return const [];
  }
  final maxToDraw =
      completed.length < requiredCount ? completed.length : requiredCount;
  return completed.take(maxToDraw).toList();
}

List<WinPattern> _selectCompletedLinePatterns(
  GameRule gameRule,
  List<bool> marked,
) {
  final requiredCount =
      gameRule.requiredPatternCounts[lineShapeGroup] ?? defaultLineCount;
  final completed = gameRule.patterns.where((pattern) {
    return pattern.cellIndexes
        .every((index) => _isCellMarkedForGame(index, marked));
  }).toList();
  if (completed.isEmpty) {
    return const [];
  }
  final maxToDraw =
      completed.length < requiredCount ? completed.length : requiredCount;
  return completed.take(maxToDraw).toList();
}

List<WinPattern> _selectCompletedPatternsForRequiredGroups(
  GameRule gameRule,
  List<bool> marked,
) {
  final groupedPatterns = _requiredPatternGroups(gameRule)
      .map(
        (group) => _RequiredPatternGroup(
          candidates: group.candidates
              .where(
                (candidate) => candidate.pattern.cellIndexes.every(
                  (index) => _isCellMarkedForGame(index, marked),
                ),
              )
              .toList(),
          requiredCount: group.requiredCount,
          allowedSharedCellMask: group.allowedSharedCellMask,
        ),
      )
      .toList();

  List<_RequiredPatternCandidate> bestSelected = const [];
  int bestCellMask = 0;

  void visit(
    int groupIndex,
    List<_RequiredPatternCandidate> selected,
    int usedMask,
  ) {
    if (groupIndex == groupedPatterns.length) {
      final candidateCells = _cellIndexesFromMask(usedMask).length;
      final bestCells = _cellIndexesFromMask(bestCellMask).length;
      if (selected.length > bestSelected.length ||
          (selected.length == bestSelected.length &&
              candidateCells > bestCells)) {
        bestSelected = List<_RequiredPatternCandidate>.from(selected);
        bestCellMask = usedMask;
      }
      return;
    }

    final group = groupedPatterns[groupIndex];
    final int maxPick = group.requiredCount < group.candidates.length
        ? group.requiredCount
        : group.candidates.length;

    // Option to skip this group for progressive display.
    visit(groupIndex + 1, selected, usedMask);

    void choose(int start, int picked, List<_RequiredPatternCandidate> current,
        int mask) {
      if (picked > 0) {
        visit(groupIndex + 1, [...selected, ...current], mask);
      }
      if (picked == maxPick) {
        return;
      }

      for (int i = start; i < group.candidates.length; i++) {
        final candidate = group.candidates[i];
        final overlapMask = candidate.cellMask & mask;
        if ((overlapMask & ~group.allowedSharedCellMask) != 0) {
          continue;
        }
        final otherPatterns = [
          ...selected.map((c) => c.pattern),
          ...current.map((c) => c.pattern),
        ];
        if (!_smallXCandidateCombinesWith(candidate.pattern, otherPatterns)) {
          continue;
        }
        choose(
          i + 1,
          picked + 1,
          [...current, candidate],
          mask | candidate.cellMask,
        );
      }
    }

    choose(0, 0, const [], usedMask);
  }

  visit(0, const [], 0);
  return bestSelected.map((candidate) => candidate.pattern).toList();
}

String? findBestCartelaKeyForGame(
  Map<String, Map<String, List<dynamic>>> cartelas,
  GameRule gameRule,
) {
  String? bestCartelaKey;
  GameResult? bestResult;

  for (final entry in cartelas.entries) {
    final result = evaluateCartelaForGame(
      entry.value,
      gameRule,
      includeOneAway: false,
    );

    if (bestResult == null || isBetterGameResult(result, bestResult)) {
      bestResult = result;
      bestCartelaKey = entry.key;
    }
  }

  return bestCartelaKey;
}

List<_RequiredPatternGroup> _requiredPatternGroups(GameRule gameRule) {
  final groupNames = <String>[];

  for (final pattern in gameRule.patterns) {
    final groupName = pattern.patternGroup;
    if (groupName != null && !groupNames.contains(groupName)) {
      groupNames.add(groupName);
    }
  }

  final requiredPatternGroups = <_RequiredPatternGroup>[];

  for (final groupName in groupNames) {
    final patterns = gameRule.patterns
        .where((pattern) => pattern.patternGroup == groupName)
        .toList();
    final requiredCount = gameRule.requiredPatternCounts[groupName] ?? 1;
    final candidates = patterns
        .map(
          (pattern) => _RequiredPatternCandidate(
            pattern: pattern,
            cellMask: _cellMaskForIndexes(pattern.cellIndexes),
          ),
        )
        .toList();

    if (candidates.isNotEmpty) {
      final sharedCells = gameRule.groupAllowSharedCellIndexes[groupName] ??
          gameRule.allowSharedCellIndexes;
      requiredPatternGroups.add(
        _RequiredPatternGroup(
          candidates: candidates,
          requiredCount: requiredCount,
          allowedSharedCellMask: _cellMaskForIndexes(sharedCells),
        ),
      );
    }
  }

  return requiredPatternGroups;
}

_PatternCombination? _findBestNonOverlappingCombination(
  List<_RequiredPatternGroup> patternGroups,
  List<bool> marked,
) {
  _PatternCombination? bestCombination;
  final int markedMask = _markedCellMask(marked);

  void visit(
    int groupIndex,
    List<_RequiredPatternCandidate> selectedPatterns,
    int usedCellMask,
  ) {
    if (groupIndex == patternGroups.length) {
      final combination = _evaluatePatternCombination(
        selectedPatterns,
        markedMask,
      );

      if (bestCombination == null ||
          _isBetterPatternCombination(combination, bestCombination!)) {
        bestCombination = combination;
      }
      return;
    }

    final group = patternGroups[groupIndex];

    void chooseFromGroup(
      int startIndex,
      List<_RequiredPatternCandidate> groupPatterns,
      int groupUsedCellMask,
    ) {
      if (groupPatterns.length == group.requiredCount) {
        visit(
          groupIndex + 1,
          [...selectedPatterns, ...groupPatterns],
          groupUsedCellMask,
        );
        return;
      }

      for (int i = startIndex; i < group.candidates.length; i++) {
        final candidate = group.candidates[i];
        final overlapMask = candidate.cellMask & groupUsedCellMask;
        if ((overlapMask & ~group.allowedSharedCellMask) != 0) {
          continue;
        }
        final otherPatterns = [
          ...selectedPatterns.map((c) => c.pattern),
          ...groupPatterns.map((c) => c.pattern),
        ];
        if (!_smallXCandidateCombinesWith(candidate.pattern, otherPatterns)) {
          continue;
        }

        chooseFromGroup(
          i + 1,
          [...groupPatterns, candidate],
          groupUsedCellMask | candidate.cellMask,
        );
      }
    }

    chooseFromGroup(0, [], usedCellMask);
  }

  visit(0, [], 0);
  return bestCombination;
}

class _RequiredPatternGroup {
  const _RequiredPatternGroup({
    required this.candidates,
    required this.requiredCount,
    this.allowedSharedCellMask = 0,
  });

  final List<_RequiredPatternCandidate> candidates;
  final int requiredCount;
  final int allowedSharedCellMask;
}

class _RequiredPatternCandidate {
  const _RequiredPatternCandidate({
    required this.pattern,
    required this.cellMask,
  });

  final WinPattern pattern;
  final int cellMask;
}

_PatternCombination _evaluatePatternCombination(
  List<_RequiredPatternCandidate> candidates,
  int markedMask,
) {
  final int cellMask = candidates.fold<int>(
    0,
    (mask, candidate) => mask | candidate.cellMask,
  );
  final cellIndexes = _cellIndexesFromMask(cellMask);
  final missingCellIndexes = _cellIndexesFromMask(cellMask & ~markedMask);

  return _PatternCombination(
    patterns: candidates.map((candidate) => candidate.pattern).toList(),
    cellIndexes: cellIndexes,
    markedCount: cellIndexes.length - missingCellIndexes.length,
    requiredCount: cellIndexes.length,
    missingCellIndexes: missingCellIndexes,
  );
}

bool _isBetterPatternCombination(
  _PatternCombination candidate,
  _PatternCombination currentBest,
) {
  if (candidate.isComplete != currentBest.isComplete) {
    return candidate.isComplete;
  }

  if (candidate.isComplete) {
    return false;
  }

  if (candidate.missingCellIndexes.length !=
      currentBest.missingCellIndexes.length) {
    return candidate.missingCellIndexes.length <
        currentBest.missingCellIndexes.length;
  }

  return candidate.markedCount > currentBest.markedCount;
}

class _PatternCombination {
  const _PatternCombination({
    required this.patterns,
    required this.cellIndexes,
    required this.markedCount,
    required this.requiredCount,
    required this.missingCellIndexes,
  });

  final List<WinPattern> patterns;
  final List<int> cellIndexes;
  final int markedCount;
  final int requiredCount;
  final List<int> missingCellIndexes;

  bool get isComplete => markedCount == requiredCount;
}

bool isBetterGameResult(GameResult candidate, GameResult currentBest) {
  if (candidate.isBingo != currentBest.isBingo) {
    return candidate.isBingo;
  }

  if (candidate.isBingo) {
    return false; // Keep the earlier winning cartela on ties.
  }

  if (candidate.missingCellIndexes.length !=
      currentBest.missingCellIndexes.length) {
    return candidate.missingCellIndexes.length <
        currentBest.missingCellIndexes.length;
  }

  return candidate.markedCount > currentBest.markedCount;
}

bool _isCellMarkedForGame(int index, List<bool> marked) {
  if (index == 12) return true; // FREE center cell counts as marked.
  if (index < 0 || index >= marked.length) return false;
  return marked[index];
}
