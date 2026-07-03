import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_i18n.dart';
import 'app_version.dart';
import 'cartela_card.dart';
import 'game_rules.dart';
import 'main.dart' show darkModeNotifier;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static const String _sessionStorageKey = 'bingo_session_v1';
  Map<String, Map<String, List<dynamic>>> cartelas =
      {}; // Holds cartelas by unique numbers
  TextEditingController searchController =
      TextEditingController(); // Single search controller
  String searchAlert = ""; // Alert text for search result
  List<String> recentNumbers = []; // Track the last 3 marked/unmarked numbers
  bool lastActionWasAdded = true; // Track if last action was add or remove
  bool useLineCounting = false; // Toggle between sorting algorithms
  bool sortingDisabled = false; // Toggle to disable sorting completely
  GameRule selectedGameRule = defaultGameRule;
  Set<String> selectedTiezazPatternGroups = {...defaultTiezazPatternGroups};
  int selectedRectangleCount = defaultRectangleCount;
  int selectedRectanguleCount = defaultRectanguleCount;
  int selectedColumnsCount = defaultColumnsCount;
  int selectedRowsCount = defaultRowsCount;
  int selectedDiagonalCount = defaultDiagonalCount;
  int selectedLineTouchesFreeCount = defaultLineTouchesFreeCount;
  int selectedLinesWithoutFreeCount = defaultLinesWithoutFreeCount;
  int selectedLineCount = defaultLineCount;
  int selectedTriangleCount = defaultTriangleCount;
  int selectedTriangle4x4Count = defaultTriangle4x4Count;
  int selectedSmallLCount = defaultSmallLShapeCount;
  int selectedSmallCrossCount = defaultSmallCrossCount;
  int selectedSmallOCount = defaultSmallOCount;
  int selectedSmallHCount = defaultSmallHCount;
  int selectedSmallTCount = defaultSmallTCount;
  int selectedSmallXCount = defaultSmallXCount;
  late final AnimationController _bingoOverlayController;
  bool _showBingoCelebration = false;
  bool _hadAnyBingo = false;
  late AppLanguage _activeLanguage;
  String _gamePickerSearchQuery = '';
  final Set<String> _calledNumberKeys = <String>{};
  Map<String, dynamic>? _cartelasJsonCache;
  bool _masterLocked = false;
  AppI18n get i18n => AppI18n(_activeLanguage);

  bool _matchesGamePickerSearch(int catalogIndex, String gameName) {
    final query = _gamePickerSearchQuery.trim();
    if (query.isEmpty) {
      return true;
    }
    final indexText = catalogIndex.toString();
    if (RegExp(r'^\d+$').hasMatch(query)) {
      return indexText == query || indexText.startsWith(query);
    }
    return AppI18n.catalogDisplayName(gameName).contains(query);
  }

  GameRule get activeGameRule => buildActiveGameRule(
        selectedGameRule,
        selectedTiezazPatternGroups,
        rectangleCount: selectedRectangleCount,
        rectanguleCount: selectedRectanguleCount,
        columnsCount: selectedColumnsCount,
        rowsCount: selectedRowsCount,
        diagonalCount: selectedDiagonalCount,
        lineTouchesFreeCount: selectedLineTouchesFreeCount,
        linesWithoutFreeCount: selectedLinesWithoutFreeCount,
        lineCount: selectedLineCount,
        triangleCount: selectedTriangleCount,
        triangle4x4Count: selectedTriangle4x4Count,
        smallLCount: selectedSmallLCount,
        smallCrossCount: selectedSmallCrossCount,
        smallOCount: selectedSmallOCount,
        smallHCount: selectedSmallHCount,
        smallTCount: selectedSmallTCount,
        smallXCount: selectedSmallXCount,
      );

  @override
  void initState() {
    super.initState();
    _activeLanguage = widget.language;
    _bingoOverlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    loadGameState();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.language != widget.language &&
        widget.language != _activeLanguage) {
      _activeLanguage = widget.language;
    }
  }

  @override
  void dispose() {
    _bingoOverlayController.dispose();
    searchController.dispose();
    super.dispose();
  }

  String _calledKey(String column, String value) => '$column:$value';

  void _applyCalledNumbersToCartela(Map<String, List<dynamic>> cartela) {
    final columns = ['B', 'I', 'N', 'G', 'O'];
    final marked = List<bool>.filled(25, false);

    for (int columnIndex = 0; columnIndex < columns.length; columnIndex++) {
      final column = columns[columnIndex];
      final values = cartela[column];
      if (values == null) continue;
      for (int rowIndex = 0; rowIndex < values.length; rowIndex++) {
        final value = values[rowIndex]?.toString();
        if (value == null || value.isEmpty) continue;
        if (_calledNumberKeys.contains(_calledKey(column, value))) {
          marked[rowIndex * 5 + columnIndex] = true;
        }
      }
    }
    cartela['marked'] = marked;
  }

  void _rebuildCalledNumbersFromCartelas() {
    _calledNumberKeys.clear();
    final columns = ['B', 'I', 'N', 'G', 'O'];

    for (final cartela in cartelas.values) {
      final marked =
          List<bool>.from(cartela['marked'] ?? List<bool>.filled(25, false));
      for (int index = 0; index < marked.length; index++) {
        if (!marked[index]) continue;
        final rowIndex = index ~/ 5;
        final columnIndex = index % 5;
        final column = columns[columnIndex];
        final value = cartela[column]?[rowIndex]?.toString();
        if (value == null || value.isEmpty) continue;
        _calledNumberKeys.add(_calledKey(column, value));
      }
    }
  }

  Future<void> saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final session = <String, dynamic>{
        'cartelas': cartelas,
        'recentNumbers': recentNumbers,
        'lastActionWasAdded': lastActionWasAdded,
        'useLineCounting': useLineCounting,
        'sortingDisabled': sortingDisabled,
        'selectedGameRuleName': selectedGameRule.name,
        'selectedTiezazPatternGroups': selectedTiezazPatternGroups.toList(),
        'selectedRectangleCount': selectedRectangleCount,
        'selectedRectanguleCount': selectedRectanguleCount,
        'selectedColumnsCount': selectedColumnsCount,
        'selectedRowsCount': selectedRowsCount,
        'selectedDiagonalCount': selectedDiagonalCount,
        'selectedLineTouchesFreeCount': selectedLineTouchesFreeCount,
        'selectedLinesWithoutFreeCount': selectedLinesWithoutFreeCount,
        'selectedLineCount': selectedLineCount,
        'selectedTriangleCount': selectedTriangleCount,
        'selectedTriangle4x4Count': selectedTriangle4x4Count,
        'selectedSmallLCount': selectedSmallLCount,
        'selectedSmallCrossCount': selectedSmallCrossCount,
        'selectedSmallOCount': selectedSmallOCount,
        'selectedSmallHCount': selectedSmallHCount,
        'selectedSmallTCount': selectedSmallTCount,
        'selectedSmallXCount': selectedSmallXCount,
        'calledNumbers': _calledNumberKeys.toList(),
        'heldCardKeys': <String>[],
      };
      await prefs.setString(_sessionStorageKey, jsonEncode(session));
    } catch (e) {
      debugPrint('Failed to save game session: $e');
    }
  }

  Future<void> clearSavedGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionStorageKey);
    } catch (e) {
      debugPrint('Failed to clear saved session: $e');
    }
  }

  Future<void> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_sessionStorageKey);
      if (raw == null || raw.isEmpty) {
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return;
      }

      _cartelasJsonCache ??=
          json.decode(await rootBundle.loadString('assets/cartelas.json'))
              as Map<String, dynamic>;
      final Map<String, dynamic> jsonData = _cartelasJsonCache!;

      final restoredCartelas = <String, Map<String, List<dynamic>>>{};
      final rawCartelas = decoded['cartelas'];
      if (rawCartelas is Map<String, dynamic>) {
        for (final entry in rawCartelas.entries) {
          final key = entry.key;
          final runtimeCartela = entry.value;
          if (!jsonData.containsKey(key) || runtimeCartela is! Map) {
            continue;
          }
          final base = jsonData[key];
          if (base is! Map<String, dynamic>) {
            continue;
          }

          final runtimeMarked = runtimeCartela['marked'];
          List<bool> marked = List<bool>.filled(25, false);
          if (runtimeMarked is List && runtimeMarked.length == 25) {
            marked = runtimeMarked.map((e) => e == true).toList();
          }

          restoredCartelas[key] = {
            'B': List<int>.from(base['B']),
            'I': List<int>.from(base['I']),
            'N': List<dynamic>.from(base['N']),
            'G': List<int>.from(base['G']),
            'O': List<int>.from(base['O']),
            'marked': marked,
          };
        }
      }

      if (!mounted) return;
      setState(() {
        cartelas = restoredCartelas;
        final savedRecent = decoded['recentNumbers'];
        if (savedRecent is List) {
          recentNumbers = savedRecent.cast<String>();
        } else {
          final legacy = decoded['lastClickedNumber'] as String?;
          recentNumbers = (legacy != null && legacy.isNotEmpty) ? [legacy] : [];
        }
        lastActionWasAdded =
            (decoded['lastActionWasAdded'] as bool?) ?? lastActionWasAdded;
        useLineCounting = (decoded['useLineCounting'] as bool?) ?? useLineCounting;
        sortingDisabled =
            (decoded['sortingDisabled'] as bool?) ?? sortingDisabled;

        final selectedRuleName = decoded['selectedGameRuleName'] as String?;
        if (selectedRuleName != null) {
          if (selectedRuleName == mixedJoinGameName) {
            final savedMixPresetId = decoded['selectedMixPresetId'] as String?;
            final legacyPreset = staticMixPresetById(savedMixPresetId);
            selectedGameRule = legacyPreset != null
                ? staticMixPresetGameRules.firstWhere(
                    (rule) => rule.name == legacyPreset.id,
                  )
                : defaultGameRule;
          } else if (selectedRuleName == tiezazGameName) {
            selectedGameRule = defaultGameRule;
          } else {
            selectedGameRule = availableGameRules.firstWhere(
              (rule) => rule.name == selectedRuleName,
              orElse: () => defaultGameRule,
            );
          }
        }

        final savedGroups = decoded['selectedTiezazPatternGroups'];
        if (savedGroups is List) {
          final restoredGroups = savedGroups
              .whereType<String>()
              .where(defaultTiezazPatternGroups.contains)
              .toSet();
          if (restoredGroups.isNotEmpty) {
            selectedTiezazPatternGroups = restoredGroups;
          }
        }

        selectedRectangleCount =
            (decoded['selectedRectangleCount'] as int?) ?? selectedRectangleCount;
        selectedRectanguleCount = (decoded['selectedRectanguleCount'] as int?) ??
            selectedRectanguleCount;
        selectedColumnsCount =
            (decoded['selectedColumnsCount'] as int?) ?? selectedColumnsCount;
        selectedRowsCount = (decoded['selectedRowsCount'] as int?) ?? selectedRowsCount;
        selectedDiagonalCount =
            (decoded['selectedDiagonalCount'] as int?) ?? selectedDiagonalCount;
        selectedLineTouchesFreeCount =
            (decoded['selectedLineTouchesFreeCount'] as int?) ??
                selectedLineTouchesFreeCount;
        selectedLinesWithoutFreeCount =
            (decoded['selectedLinesWithoutFreeCount'] as int?) ??
                selectedLinesWithoutFreeCount;
        selectedLineCount = (decoded['selectedLineCount'] as int?) ?? selectedLineCount;
        selectedTriangleCount =
            (decoded['selectedTriangleCount'] as int?) ?? selectedTriangleCount;
        selectedTriangle4x4Count = (decoded['selectedTriangle4x4Count'] as int?) ??
            selectedTriangle4x4Count;
        selectedSmallLCount =
            (decoded['selectedSmallLCount'] as int?) ?? selectedSmallLCount;
        selectedSmallCrossCount =
            (decoded['selectedSmallCrossCount'] as int?) ?? selectedSmallCrossCount;
        selectedSmallOCount =
            (decoded['selectedSmallOCount'] as int?) ?? selectedSmallOCount;
        if (selectedSmallOCount > maxSmallOCount) {
          selectedSmallOCount = maxSmallOCount;
        }
        selectedSmallHCount =
            (decoded['selectedSmallHCount'] as int?) ?? selectedSmallHCount;
        selectedSmallTCount =
            (decoded['selectedSmallTCount'] as int?) ?? selectedSmallTCount;
        selectedSmallXCount =
            (decoded['selectedSmallXCount'] as int?) ?? selectedSmallXCount;
        if (selectedSmallXCount > maxSmallXCount) {
          selectedSmallXCount = maxSmallXCount;
        }
        final savedCalled = decoded['calledNumbers'];
        if (savedCalled is List) {
          _calledNumberKeys
            ..clear()
            ..addAll(savedCalled.whereType<String>());
        } else {
          _rebuildCalledNumbersFromCartelas();
        }
      });

      if (!sortingDisabled) {
        sortCartelasByMarkedCount();
      }
      _checkForBingoCelebration();
    } catch (e) {
      debugPrint('Failed to load game session: $e');
    }
  }

  Future<void> fetchCartela(String cartelaNumber) async {
    try {
      // Load JSON data from the asset (cached after first load)
      _cartelasJsonCache ??=
          json.decode(await rootBundle.loadString('assets/cartelas.json'))
              as Map<String, dynamic>;
      final Map<String, dynamic> jsonData = _cartelasJsonCache!;

      if (!mounted) return;

      // Fetch the specific cartela by its number
      final Map<String, dynamic>? cartela = jsonData[cartelaNumber];

      if (cartela != null) {
        setState(() {
          // Update the cartelas map with the new data
          final newCartela = <String, List<dynamic>>{
            'B': List<int>.from(cartela['B']),
            'I': List<int>.from(cartela['I']),
            'N': List<dynamic>.from(cartela['N']),
            'G': List<int>.from(cartela['G']),
            'O': List<int>.from(cartela['O']),
            'marked': List<bool>.generate(25, (index) => false),
          };
          _applyCalledNumbersToCartela(newCartela);
          cartelas[cartelaNumber] = newCartela;
          sortCartelasByMarkedCount();
          searchAlert =
              "Cartela number $cartelaNumber loaded successfully."; // Success alert
        });
        await saveGameState();
      } else {
        setState(() {
          searchAlert =
              "Cartela number $cartelaNumber not found."; // Error alert
        });
      }
    } catch (e) {
      // Handle potential errors
      debugPrint("Error fetching cartela: $e");
      setState(() {
        searchAlert =
            "Error fetching cartela data. Please try again."; // Error message
      });
    }
  }

  // Add cartela logic
  void onSearch() {
    String cartelaNumber = searchController.text.trim();
    if (cartelaNumber.isNotEmpty) {
      setState(() {
        searchAlert = ""; // Clear previous alert
      });
      fetchCartela(cartelaNumber); // Start the search
    }
  }

  // Restore all cartelas with confirmation
  void restoreCartelas() {
    if (cartelas.isEmpty) {
      setState(() {
        searchAlert = "No cartelas to restore.";
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(i18n.t('confirm_restore')),
        content: Text(
            'Are you sure you want to restore all ${cartelas.length} cartelas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(i18n.t('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartelas.clear(); // Clear all added cartelas
                _calledNumberKeys.clear();
                searchAlert = "All Cartelas restored."; // Show message
              });
              clearSavedGameState();
            },
            child: Text(i18n.t('restore')),
          ),
        ],
      ),
    );
  }

  // Reset marked numbers for all cartelas with confirmation
  void resetMarkedNumbers() {
    if (cartelas.isEmpty) {
      setState(() {
        searchAlert = "No cartelas to reset.";
      });
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(i18n.t('confirm_reset')),
        content:
            const Text('Are you sure you want to reset all marked numbers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(i18n.t('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartelas.forEach((key, cartela) {
                  cartela['marked'] = List<bool>.generate(
                      25, (index) => false); // Reset marked numbers
                });
                _calledNumberKeys.clear();
                searchAlert =
                    "All marked numbers have been reset."; // Show message
                sortCartelasByMarkedCount();
              });
              saveGameState();
            },
            child: Text(i18n.t('reset')),
          ),
        ],
      ),
    );
  }

  // Mark/Unmark the same number across all cartelas
  void markNumberAcrossAllCartelas(
      String column, String value, bool newMarkedState) {
    final key = _calledKey(column, value);
    final columnIndex = ['B', 'I', 'N', 'G', 'O'].indexOf(column);
    setState(() {
      if (newMarkedState) {
        _calledNumberKeys.add(key);
      } else {
        _calledNumberKeys.remove(key);
      }
      for (final cartela in cartelas.values) {
        final columnList = cartela[column];
        if (columnList == null) continue;
        for (int rowIndex = 0; rowIndex < columnList.length; rowIndex++) {
          if (columnList[rowIndex]?.toString() == value) {
            cartela['marked']?[rowIndex * 5 + columnIndex] = newMarkedState;
          }
        }
      }
    });
    sortCartelasByMarkedCount();
    _checkForBingoCelebration();
    saveGameState();
  }

  bool _hasAnyBingoForRule(GameRule gameRule) {
    for (final cartela in cartelas.values) {
      final result = evaluateCartelaForGame(
        cartela,
        gameRule,
        includeOneAway: false,
      );
      if (result.isBingo) {
        return true;
      }
    }
    return false;
  }

  Future<void> _checkForBingoCelebration() async {
    final hasAnyBingo = _hasAnyBingoForRule(activeGameRule);

    if (!hasAnyBingo) {
      _hadAnyBingo = false;
      if (_showBingoCelebration && mounted) {
        setState(() {
          _showBingoCelebration = false;
        });
      }
      await saveGameState();
      return;
    }

    if (_hadAnyBingo) {
      await saveGameState();
      return;
    }
    _hadAnyBingo = true;

    if (!mounted) return;
    setState(() {
      _showBingoCelebration = true;
    });

    for (int i = 0; i < 3; i++) {
      await _bingoOverlayController.forward(from: 0);
      if (!mounted) return;
      await _bingoOverlayController.reverse();
      if (!mounted) return;
    }

    if (!mounted) return;
    setState(() {
      _showBingoCelebration = false;
    });
    await saveGameState();
  }

  // Sort mode enum: 0=by lines, 1=by lines no-free, 2=by count, 3=by count no-free, 4=by rectangle, 5=no sort
  int _sortMode = 0;

  void _applySortMode(int mode) {
    setState(() {
      _sortMode = mode;
      sortingDisabled = false;
      // 0 = by lines, 1 = by count; all others disabled
      useLineCounting = (mode == 0);
    });
    sortCartelasByMarkedCount();
    saveGameState();
  }

  // Show settings as a full-height right-side drawer
  void _showSettingsDialog() {
    const sortOptions = [
      (Icons.menu, Color(0xFFFFB300), 'ብመስመር ምስራዕ', true),
      (Icons.format_list_numbered, Color(0xFF1A8FE3), 'ብበዝሒ ምስራዕ', true),
      (Icons.menu, Color(0xFFFFB300), 'ብመስመር F-ዘይነካ', false),
      (Icons.format_list_bulleted, Color(0xFF1A8FE3), 'ብ ስኴር', false),
      (Icons.format_list_bulleted, Color(0xFF1A8FE3), 'ብ ስኴር F ዘይነካ', false),
      (Icons.grid_view, Color(0xFF1A8FE3), 'ብ ሬክታንጓል', false),
    ];
    final pageCtx = context;

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (dlg) => ValueListenableBuilder<bool>(
        valueListenable: darkModeNotifier,
        builder: (dlg, isDark, _) {
          final Color bg = isDark
              ? const Color(0xFF1E1E2E)
              : Colors.white;
          final Color textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
          final Color subColor = isDark ? Colors.white70 : Colors.black54;
          final Color dividerColor = isDark ? Colors.white24 : Colors.black12;
          final Color checkboxBorder = isDark ? Colors.white54 : Colors.black38;
          return StatefulBuilder(
            builder: (dlg, set) {
              return GestureDetector(
                onTap: () => Navigator.pop(dlg),
                behavior: HitTestBehavior.opaque,
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: SafeArea(
                      child: Material(
                        color: bg,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(dlg).size.width * 0.55,
                            maxHeight: MediaQuery.of(dlg).size.height,
                          ),
                          child: SingleChildScrollView(
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Sort options
                                ...List.generate(sortOptions.length, (i) {
                                  final o = sortOptions[i];
                                  final sel = _sortMode == i;
                                  return Opacity(
                                    opacity: o.$4 ? 1.0 : 0.35,
                                    child: InkWell(
                                      onTap: o.$4
                                          ? () {
                                              set(() {});
                                              _applySortMode(i);
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        child: Row(
                                          children: [
                                            Icon(o.$1,
                                                color: o.$2, size: 20),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(o.$3,
                                                  style: TextStyle(
                                                    color: textColor,
                                                    fontSize: 14,
                                                    fontWeight: sel
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  )),
                                            ),
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: checkboxBorder,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: sel
                                                    ? const Color(0xFF1A8FE3)
                                                    : Colors.transparent,
                                              ),
                                              child: sel
                                                  ? const Icon(Icons.check,
                                                      color: Colors.white,
                                                      size: 14)
                                                  : null,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                Divider(
                                    color: dividerColor, height: 1),
                                // Clear all cards
                                _drawerAction(
                                  Icons.delete_forever,
                                  Colors.red,
                                  'ኩሎም ካርዲ ኣውጣድ',
                                  textColor,
                                  () {
                                    Navigator.pop(dlg);
                                    setState(() {
                                      cartelas.clear();
                                      recentNumbers.clear();
                                      _calledNumberKeys.clear();
                                    });
                                    clearSavedGameState();
                                  },
                                ),
                                // Reset all marks
                                _drawerAction(
                                  Icons.refresh,
                                  Colors.orange,
                                  'Reset/ ሰርዝ',
                                  textColor,
                                  () {
                                    Navigator.pop(dlg);
                                    setState(() {
                                      for (final c in cartelas.values) {
                                        c['marked'] =
                                            List<bool>.filled(25, false);
                                      }
                                      recentNumbers.clear();
                                      _calledNumberKeys.clear();
                                      sortCartelasByMarkedCount();
                                    });
                                    saveGameState();
                                  },
                                ),
                                // Contact Me
                                _drawerAction(
                                  Icons.chat_bubble_outline,
                                  Colors.amber,
                                  'Contact Me',
                                  textColor,
                                  () {
                                    Navigator.pop(dlg);
                                    showDialog(
                                      context: pageCtx,
                                      builder: (d2) => AlertDialog(
                                        backgroundColor: bg,
                                        title: Text('Contact Me',
                                            style: TextStyle(
                                                color: textColor)),
                                        content: Text(
                                          '${AppVersion.developerPhone}\n© ${AppVersion.developerCredit}',
                                          style: TextStyle(
                                              color: subColor),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(d2),
                                            child: const Text('OK',
                                                style: TextStyle(
                                                    color: Color(
                                                        0xFF1A8FE3))),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(AppVersion.label,
                                      style: TextStyle(
                                          color: subColor,
                                          fontSize: 11)),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _drawerAction(
      IconData icon, Color iconColor, String label, Color textColor,
      VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(color: textColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  /// Home status card: Amharic label only (second line of bilingual catalog).
  String _gameNameWithCountForHome(String gameName) {
    final label = AppI18n.catalogDisplayName(gameName);
    if (!gameSupportsPatternCount(gameName)) {
      return label;
    }
    final count = _selectedCountForGame(gameName);
    return '$label ($count)';
  }

  String _activeGameDisplayName() {
    return _gameNameWithCountForHome(selectedGameRule.name);
  }

  double _adaptiveFontSize(String text, double baseSize, double minSize) {
    final lineCount = '\n'.allMatches(text).length + 1;
    final len = text.length;
    if (len <= 16 && lineCount <= 1) return baseSize;
    if (len <= 28 && lineCount <= 2) return baseSize - 1;
    if (len <= 44 && lineCount <= 3) return baseSize - 2;
    return minSize;
  }

  Widget _buildAdaptiveWrapText(
    String text, {
    required double baseFontSize,
    double? minFontSize,
    int maxLines = 5,
    Color? color,
    FontWeight? fontWeight,
    TextAlign textAlign = TextAlign.start,
  }) {
    final min = minFontSize ?? (baseFontSize - 3).clamp(9.0, baseFontSize);
    final size = _adaptiveFontSize(text, baseFontSize, min);
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: size,
        height: 1.3,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }

  void _refreshGameSelection(StateSetter setModalState) {
    if (!sortingDisabled) {
      sortCartelasByMarkedCount();
    }
    _checkForBingoCelebration();
    setModalState(() {});
  }

  int _selectedCountForGame(String gameName) {
    switch (gameName) {
      case rectangleGameName:
        return selectedRectangleCount;
      case rectanguleGameName:
        return selectedRectanguleCount;
      case columnsGameName:
        return selectedColumnsCount;
      case rowsGameName:
        return selectedRowsCount;
      case diagonalGameName:
        return selectedDiagonalCount;
      case lineTouchesFreeGameName:
        return selectedLineTouchesFreeCount;
      case linesWithoutFreeGameName:
        return selectedLinesWithoutFreeCount;
      case lineGameName:
        return selectedLineCount;
      case triangleGameName:
        return selectedTriangleCount;
      case triangle4x4GameName:
        return selectedTriangle4x4Count;
      case smallCrossGameName:
        return selectedSmallCrossCount;
      case smallTGameName:
        return selectedSmallTCount;
      case smallXGameName:
        return selectedSmallXCount;
      case smallLShapeGameName:
        return selectedSmallLCount;
      case smallHGameName:
        return selectedSmallHCount;
      case smallOGameName:
        return selectedSmallOCount;
      default:
        return 1;
    }
  }


  bool _isGamePickerAtDefaults() {
    return selectedGameRule.name == defaultGameRule.name &&
        selectedRectangleCount == defaultRectangleCount &&
        selectedRectanguleCount == defaultRectanguleCount &&
        selectedColumnsCount == defaultColumnsCount &&
        selectedRowsCount == defaultRowsCount &&
        selectedDiagonalCount == defaultDiagonalCount &&
        selectedLineTouchesFreeCount == defaultLineTouchesFreeCount &&
        selectedLinesWithoutFreeCount == defaultLinesWithoutFreeCount &&
        selectedLineCount == defaultLineCount &&
        selectedTriangleCount == defaultTriangleCount &&
        selectedTriangle4x4Count == defaultTriangle4x4Count &&
        selectedSmallLCount == defaultSmallLShapeCount &&
        selectedSmallCrossCount == defaultSmallCrossCount &&
        selectedSmallOCount == defaultSmallOCount &&
        selectedSmallHCount == defaultSmallHCount &&
        selectedSmallTCount == defaultSmallTCount &&
        selectedSmallXCount == defaultSmallXCount &&
        selectedTiezazPatternGroups.length ==
            defaultTiezazPatternGroups.length &&
        selectedTiezazPatternGroups
            .containsAll(defaultTiezazPatternGroups);
  }

  void _resetAllGamePickerChoices(StateSetter setModalState) {
    if (_isGamePickerAtDefaults()) {
      return;
    }
    setState(() {
      selectedGameRule = defaultGameRule;
      selectedRectangleCount = defaultRectangleCount;
      selectedRectanguleCount = defaultRectanguleCount;
      selectedColumnsCount = defaultColumnsCount;
      selectedRowsCount = defaultRowsCount;
      selectedDiagonalCount = defaultDiagonalCount;
      selectedLineTouchesFreeCount = defaultLineTouchesFreeCount;
      selectedLinesWithoutFreeCount = defaultLinesWithoutFreeCount;
      selectedLineCount = defaultLineCount;
      selectedTriangleCount = defaultTriangleCount;
      selectedTriangle4x4Count = defaultTriangle4x4Count;
      selectedSmallLCount = defaultSmallLShapeCount;
      selectedSmallCrossCount = defaultSmallCrossCount;
      selectedSmallOCount = defaultSmallOCount;
      selectedSmallHCount = defaultSmallHCount;
      selectedSmallTCount = defaultSmallTCount;
      selectedSmallXCount = defaultSmallXCount;
      selectedTiezazPatternGroups = {...defaultTiezazPatternGroups};
    });
    _refreshGameSelection(setModalState);
  }

  static const Color _gamePickerSelectedColor = Colors.deepPurple;
  static final Color _gamePickerSelectedFill =
      Colors.deepPurple.withValues(alpha: 0.18);
  static final Color _gamePickerSelectedBorder =
      Colors.deepPurple.withValues(alpha: 0.85);

  void _showGameSelectionModal() {
    setState(() => _gamePickerSearchQuery = '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.85,
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          i18n.t('choose_game_type'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: i18n.t('game_picker_reset_all'),
                        icon: Icon(
                          Icons.restart_alt,
                          color: _isGamePickerAtDefaults()
                              ? Colors.grey.shade400
                              : _gamePickerSelectedColor,
                        ),
                        onPressed: _isGamePickerAtDefaults()
                            ? null
                            : () =>
                                _resetAllGamePickerChoices(setModalState),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(i18n.t('done')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: i18n.t('game_picker_search_hint'),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _gamePickerSearchQuery = value);
                      setModalState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...availableGameRules.asMap().entries.where((entry) {
                        return _matchesGamePickerSearch(
                          entry.key + 1,
                          entry.value.name,
                        );
                      }).map((entry) {
                        final int catalogIndex = entry.key + 1;
                        final GameRule gameRule = entry.value;
                        final bool isSelected =
                            selectedGameRule.name == gameRule.name;
                        return Column(
                          key: ValueKey('game_rule_$catalogIndex'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              selected: isSelected,
                              selectedTileColor: _gamePickerSelectedFill,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: isSelected
                                    ? BorderSide(
                                        color: _gamePickerSelectedBorder,
                                        width: 2,
                                      )
                                    : BorderSide.none,
                              ),
                              leading: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? _gamePickerSelectedColor
                                    : Colors.grey,
                              ),
                              title: Text(
                                i18n.gameCatalogListLabel(
                                  catalogIndex,
                                  gameRule.name,
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? _gamePickerSelectedColor
                                      : null,
                                ),
                              ),
                              onTap: () {
                                if (isSelected) {
                                  setState(() {
                                    selectedGameRule = defaultGameRule;
                                  });
                                } else {
                                  setState(() {
                                    selectedGameRule = gameRule;
                                  });
                                }
                                if (!sortingDisabled) {
                                  sortCartelasByMarkedCount();
                                }
                                _checkForBingoCelebration();
                                setModalState(() {});
                              },
                            ),
                            if (isSelected &&
                                gameRule.name == rectangleGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(rectangleGameName)}'),
                                        selected:
                                            selectedRectangleCount == count,
                                        onSelected: (_) {
                                          if (selectedRectangleCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedRectangleCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == rectanguleGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(rectanguleGameName)}'),
                                        selected:
                                            selectedRectanguleCount == count,
                                        onSelected: (_) {
                                          if (selectedRectanguleCount ==
                                              count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedRectanguleCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == columnsGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(columnsGameName)}'),
                                        selected: selectedColumnsCount == count,
                                        onSelected: (_) {
                                          if (selectedColumnsCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedColumnsCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == rowsGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(rowsGameName)}'),
                                        selected: selectedRowsCount == count,
                                        onSelected: (_) {
                                          if (selectedRowsCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedRowsCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == diagonalGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(diagonalGameName)}'),
                                        selected:
                                            selectedDiagonalCount == count,
                                        onSelected: (_) {
                                          if (selectedDiagonalCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedDiagonalCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == lineTouchesFreeGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(lineTouchesFreeGameName)}'),
                                        selected:
                                            selectedLineTouchesFreeCount ==
                                                count,
                                        onSelected: (_) {
                                          if (selectedLineTouchesFreeCount ==
                                              count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedLineTouchesFreeCount =
                                                count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == linesWithoutFreeGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(linesWithoutFreeGameName)}'),
                                        selected:
                                            selectedLinesWithoutFreeCount ==
                                                count,
                                        onSelected: (_) {
                                          if (selectedLinesWithoutFreeCount ==
                                              count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedLinesWithoutFreeCount =
                                                count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == lineGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children:
                                        [1, 2, 3, 4, 5, 6, 7].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(lineGameName)}'),
                                        selected: selectedLineCount == count,
                                        onSelected: (_) {
                                          if (selectedLineCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedLineCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == triangleGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(triangleGameName)}'),
                                        selected:
                                            selectedTriangleCount == count,
                                        onSelected: (_) {
                                          if (selectedTriangleCount == count) {
                                            return;
                                          }
                                          setState(() {
                                            selectedTriangleCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == triangle4x4GameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(triangle4x4GameName)}'),
                                        selected:
                                            selectedTriangle4x4Count == count,
                                        onSelected: (_) {
                                          if (selectedTriangle4x4Count ==
                                              count) {
                                            return;
                                          }
                                          setState(() {
                                            selectedTriangle4x4Count = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == smallCrossGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(smallCrossGameName)}'),
                                        selected:
                                            selectedSmallCrossCount == count,
                                        onSelected: (_) {
                                          if (selectedSmallCrossCount ==
                                              count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedSmallCrossCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == smallTGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(smallTGameName)}'),
                                        selected: selectedSmallTCount == count,
                                        onSelected: (_) {
                                          if (selectedSmallTCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedSmallTCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == smallXGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(smallXGameName)}'),
                                        selected: selectedSmallXCount == count,
                                        onSelected: (_) {
                                          if (selectedSmallXCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedSmallXCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected &&
                                gameRule.name == smallLShapeGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2, 3, 4, 5].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(smallLShapeGameName)}'),
                                        selected: selectedSmallLCount == count,
                                        onSelected: (_) {
                                          if (selectedSmallLCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedSmallLCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            if (isSelected && gameRule.name == smallHGameName)
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 4,
                                    children: [1, 2].map((count) {
                                      return ChoiceChip(
                                        label: Text(
                                            '$count ${i18n.gameDisplayName(smallHGameName)}'),
                                        selected: selectedSmallHCount == count,
                                        onSelected: (_) {
                                          if (selectedSmallHCount == count) {
                                            return;
                                          }

                                          setState(() {
                                            selectedSmallHCount = count;
                                          });
                                          if (!sortingDisabled) {
                                            sortCartelasByMarkedCount();
                                          }
                                          _checkForBingoCelebration();
                                          setModalState(() {});
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Existing caller kept; full sort by selected algorithm.
  void sortCartelasByMarkedCount() {
    sortCartelasByGameType(activeGameRule);
  }

  // Sort all cartelas descending by either total marked cells or completed patterns.
  void sortCartelasByGameType(GameRule gameRule) {
    if (sortingDisabled || cartelas.length <= 1) {
      return; // No sorting if disabled or 0/1 card
    }

    final entries = cartelas.entries.toList();

    // Preserve original order for equal scores (stable tie-breaker).
    final originalIndex = <String, int>{};
    for (int i = 0; i < entries.length; i++) {
      originalIndex[entries[i].key] = i;
    }

    entries.sort((a, b) {
      final int scoreA;
      final int scoreB;
      if (useLineCounting) {
        // "By lines" always counts standard bingo lines: rows + columns + diagonals.
        scoreA = countCompletedPatternsForGame(a.value, lineGameRule);
        scoreB = countCompletedPatternsForGame(b.value, lineGameRule);
      } else {
        scoreA = countMarkedCellsForCartela(a.value);
        scoreB = countMarkedCellsForCartela(b.value);
      }

      if (scoreA != scoreB) {
        return scoreB.compareTo(scoreA); // Descending.
      }
      // Keep original order for ties.
      return originalIndex[a.key]!.compareTo(originalIndex[b.key]!);
    });

    cartelas = Map.fromEntries(entries);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    // Get screen dimensions for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    bool isInLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Responsive sizing
    double logoSize = screenWidth < 360 ? 28 : (screenWidth < 400 ? 32 : 36);
    double titleFontSize =
        screenWidth < 360 ? 14 : (screenWidth < 400 ? 16 : 18);
    double iconSize = screenWidth < 360 ? 20 : 22;
    double appBarHeight = screenWidth < 360 ? 50 : 56;
    final GameRule currentGameRule = activeGameRule;

    return Scaffold(
      backgroundColor:
          darkModeNotifier.value ? Colors.black : Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.webp',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),
              SizedBox(width: screenWidth < 360 ? 6 : 8),
              Flexible(
                child: Text(
                  i18n.t('app_name'),
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: darkModeNotifier.value
              ? const Color(0xFF1A1A2E)
              : const Color(0xFF1A8FE3),
          actions: [
            // Master lock/unlock all cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => setState(() => _masterLocked = !_masterLocked),
                child: Icon(
                  _masterLocked ? Icons.lock : Icons.lock_open,
                  color: _masterLocked ? Colors.orange : Colors.white,
                  size: iconSize,
                ),
              ),
            ),
            // Dark/light mode toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () {
                  darkModeNotifier.value = !darkModeNotifier.value;
                },
                child: Icon(
                  darkModeNotifier.value ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
            // Game type menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: _showGameSelectionModal,
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
            // 3-dot settings menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: _showSettingsDialog,
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
        children: [
          // Top row with last clicked number and total cards
          if (cartelas.isNotEmpty)
            Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A8FE3),
                            borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAdaptiveWrapText(
                                currentGameRule.name == 'Manual'
                                    ? '${cartelas.length} ካርቴላ'
                                    : '${cartelas.length} ${i18n.t('cards')}',
                                baseFontSize: screenWidth < 360 ? 13 : 15,
                                minFontSize: 11,
                                maxLines: 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                              if (currentGameRule.name != 'Manual') ...[
                                const SizedBox(height: 6),
                                _buildAdaptiveWrapText(
                                  _activeGameDisplayName(),
                                  baseFontSize: screenWidth < 360 ? 11 : 13,
                                  minFontSize: 9,
                                  maxLines: 6,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                  // Right side: Last 3 marked numbers as colored circles
                  if (recentNumbers.isNotEmpty)
                    Flexible(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 6,
                        runSpacing: 4,
                        children: recentNumbers.indexed.map((e) {
                          final int idx = e.$1;
                          final String n = e.$2;
                          final double ballSize =
                              screenWidth < 360 ? 34 : 40;
                          // Newest ball (idx 0) reflects add/remove action color
                          final bool isNewest = idx == 0;
                          final Color ballColor = isNewest && !lastActionWasAdded
                              ? const Color(0xFFE53935) // red = removed
                              : const Color(0xFF1A8FE3); // blue = added
                          final Color shadowColor = isNewest && !lastActionWasAdded
                              ? const Color(0x44E53935)
                              : const Color(0x441A8FE3);
                          return Container(
                            width: ballSize,
                            height: ballSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ballColor,
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor,
                                  offset: const Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              n,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth < 360 ? 12 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

          cartelas.isEmpty
                  ? Center(child: Text(i18n.t('no_cartelas_added')))
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics:
                        const BouncingScrollPhysics(), // Smooth scroll effect
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isInLandscape ? 3 : 2,
                        crossAxisSpacing: isInLandscape ? 2 : 4,
                        mainAxisSpacing: isInLandscape ? 3 : 6,
                        childAspectRatio: isInLandscape ? 0.6 : 0.73,
                      ),
                      itemCount: cartelas.length,
                      itemBuilder: (context, index) {
                        var entry = cartelas.entries.elementAt(index);
                            final gameResult = evaluateCartelaForGame(
                              entry.value,
                              currentGameRule,
                              includeOneAway: true,
                            );
                            final int lineCount = countCompletedPatternsForGame(
                              entry.value,
                              lineGameRule,
                            );
                            // Gold highlight only when the top cartela has bingo.
                            final bool isFirstPlace =
                                index == 0 && gameResult.isBingo;

                        return Container(
                              key: ValueKey(entry.key),
                          margin: const EdgeInsets.all(2),
                          decoration: isFirstPlace
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withValues(alpha: 0.6),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                )
                              : null,
                              child: CartelaCard(
                                cartelaNumber: entry.key,
                                cartela: entry.value,
                                totalCartelas: cartelas.length,
                                isFirstPlace: isFirstPlace,
                                isInLandscape: isInLandscape,
                                screenWidth: screenWidth,
                                selectedGameRule: currentGameRule,
                                language: _activeLanguage,
                                isDarkMode: darkModeNotifier.value,
                                lineCount: lineCount,
                                gameResult: gameResult,
                                masterLocked: _masterLocked,
                                onRemove: () {
                                  setState(() {
                                    cartelas.remove(entry.key);
                                    sortCartelasByMarkedCount();
                                  });
                                  _checkForBingoCelebration();
                                },
                                onReset: () {
                                  setState(() {
                                    entry.value['marked'] = List<bool>.generate(
                                        25, (index) => false);
                                    sortCartelasByMarkedCount();
                                  });
                                  _checkForBingoCelebration();
                                },
                                onCellMarkChanged: (column, value, newState) {
                                  setState(() {
                                    lastActionWasAdded = newState;
                                    recentNumbers = [
                                      value,
                                      ...recentNumbers.where((n) => n != value),
                                    ].take(3).toList();
                                  });
                                  markNumberAcrossAllCartelas(
                                      column, value, newState);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
          if (_showBingoCelebration)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _bingoOverlayController,
                  builder: (context, child) {
                    final alpha = 0.18 + (_bingoOverlayController.value * 0.32);
                    return Container(
                      color: Colors.green.withValues(alpha: alpha),
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: 0.55 + (_bingoOverlayController.value * 0.45),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.greenAccent,
                        size: 108,
                      ),
                      SizedBox(height: 12),
                      Text(
                        i18n.t('bingo'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCartelaDialog,
        backgroundColor: const Color(0xFF1A8FE3),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddCartelaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              i18n.t('add_cartela'),
              style: TextStyle(
                fontSize: 16, // Further reduced title font size
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Builder(
            builder: (context) {
              // Get screen width for responsiveness
              double screenWidth = MediaQuery.of(context).size.width;

              return Container(
                width: screenWidth * 0.55, // Even smaller dialog width
                padding: const EdgeInsets.symmetric(
                    vertical: 8), // Reduced padding for more compactness
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Search Field
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: i18n.t('search_cartela'),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 6, horizontal: 10), // Smaller padding
                      ),
                      onSubmitted: (value) {
                        onSearch();
                        searchController
                            .clear(); // Clear the input after search
                      },
                    ),
                    const SizedBox(height: 8), // Reduced space between elements
                    // Search Button
                    ElevatedButton(
                      onPressed: () {
                        onSearch();
                        searchController
                            .clear(); // Clear the input after search
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 184, 182, 187),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(6), // Smaller radius
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6), // Smaller padding
                        minimumSize: Size(
                            screenWidth * 0.45, 36), // Even smaller button size
                      ),
                      child: const Text("ADD"),
                    ),
                    const SizedBox(height: 8),
                    // Alert for search result
                    if (searchAlert.isNotEmpty)
                      Text(
                        searchAlert,
                        style: TextStyle(
                          color: searchAlert.contains('not found')
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12, // Smaller font size for alert
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(6), // Smaller border radius
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 6, horizontal: 10), // Reduced padding
                minimumSize:
                    const Size(80, 36), // Even smaller cancel button size
              ),
              child: Text(
                i18n.t('cancel'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
