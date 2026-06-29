# 🎲 Digital Cartel — Full Game Logic Documentation

This document explains **every game** in the app, the **rules** to win, **how bingo is detected**, **how a single tap marks ALL cartelas at once**, and the **complete game flow**.

---

## 1. 📇 The Cartela (Bingo Card) Structure

Every card is a **5×5 grid = 25 cells** (indexes `0` to `24`):

```
Index map:       Columns:
 0  1  2  3  4   B  I  N  G  O
 5  6  7  8  9   B  I  N  G  O
10 11 12 13 14   B  I  N  G  O   ← index 12 is FREE (always marked)
15 16 17 18 19   B  I  N  G  O
20 21 22 23 24   B  I  N  G  O
```

- The **center cell (N3 / index 12)** is permanently `FREE` → always counts as marked.
- The `marked` list is a `List<bool>` of length 25 (`true` = marked, `false` = unmarked).
- Card data is loaded from `assets/cartelas.json` (thousands of cards keyed by number: `"1"`, `"2"`, …).

---

## 2. 🕹️ All Game Names, Rules & Winning Patterns

The app exposes **~30 base games + 14 static mix presets** (over 35 total definitions in `availableGameRules`).

### 🅰️ Basic Single-Pattern Games

| # | Game Name | What You Need to Win (Bingo Rule) |
|---|-----------|----------------------------------|
| 1 | **Manual** | No auto-detection. The user marks manually; nothing is highlighted as bingo automatically. Default fallback. |
| 2 | **FULL-HOUSE** | All **25 cells** must be marked. |
| 3 | **Half House** | Any **one of 10 large 15-cell areas** must be complete. The 10 areas: Top 3 rows, Bottom 3 rows, Left 3 columns, Right 3 columns, Middle 3 rows, Middle 3 columns, Left Triangle, Right Triangle, Top-Right Triangle, Top-Left Triangle. |

### 🅱️ Line / Direction Games (often have a **count** — how many of the same shape are needed)

| # | Game Name | Winning Pattern | Allowed Count |
|---|-----------|----------------|---------------|
| 4 | **line** | Any of the 12 lines: 5 rows + 5 columns + 2 diagonals. | 1–7 (default 1) |
| 5 | **Columns** | A full column (any of the 5). | 1–4 (default 1) |
| 6 | **Rows** | A full row (any of the 5). | 1–4 (default 1) |
| 7 | **Diagonal** | The two diagonals. With count 1 → any one diagonal. With count 2 → both diagonals (FREE center cell 12 is **shared** between them, allowed overlap). | 1–2 (default 1) |
| 8 | **LIne touches free** | The 4 lines that pass through the FREE center: middle column (N), middle row, and the 2 diagonals. | 1–4 (default 1) |
| 9 | **lines with out free** | Any row or column that does **not** pass through FREE. Row 3, Column 3, and the diagonals are excluded. | 1–4 (default 1) |

### 🅲️ Block / Square Games

| # | Game Name | Winning Pattern | Allowed Count |
|---|-----------|----------------|---------------|
| 10 | **Square** (named "Square" but it's 2×2) | Any 2×2 block (16 positions). | 1–4 (default 3) |
| 11 | **Rectangule** | Any 3×2 (3 rows × 2 cols) vertical rectangle OR any 2×3 horizontal rectangle. | 1–3 (default 2) |

### 🅳️ Triangle / Pyramid Games

| # | Game Name | Winning Pattern | Allowed Count |
|---|-----------|----------------|---------------|
| 12 | **2 triangle** | A 3×3 right-triangle shape (6 cells, half-square). The 3×3 block slides to any of 9 positions, and each position has 4 rotations → 36 triangles. | 1–2 (default 2) |
| 13 | **4 by 4 triangle** | A 4×4 half-square (10 cells, "staircase" triangle). 4 positions × 4 rotations. | 1–2 (default 2) |
| 14 | **Pyramid** | 9-cell pyramid shape (4 orientations: top, bottom, left, right) that can slide. | 1 (fixed) |

### 🅴️ Big Letter Shapes (single fixed patterns)

Each of these has a small set of fixed patterns. They are **non-counted** — typically one full shape.

| # | Game Name | Winning Pattern |
|---|-----------|----------------|
| 15 | **BIG L Shape** | 4 L's covering 9 cells each: Top-Left, Top-Right, Bottom-Left, Bottom-Right. |
| 16 | **BIG T** | 4 T's (13 cells each) at Top, Bottom, Left, Right. |
| 17 | **BIG H** | 2 H's (13 cells each): B-O Sides (full B column + full O column + middle row) and Top-N-Bottom (top row + full N column + bottom row). |
| 18 | **BIG N** | 2 N's (13 cells each): Top-heavy N and Side-heavy N. |
| 19 | **BIG Y** | 4 Y's (7 cells each): Top, Right, Bottom, Left orientations. |
| 20 | **BIG Cross** | Center cross (9 cells): full N column + middle row. |
| 21 | **RIGHT Shape** | 4 right-angle triangles (9 cells each) at Left, Top, Right, Bottom sides. |

### 🅵️ Small Letter Shapes (3×3 sliding patterns)

These patterns slide across the 5×5 grid inside any 3×3 sub-block.

| # | Game Name | Winning Pattern | Allowed Count |
|---|-----------|----------------|---------------|
| 22 | **small T shape and X shape** | A small T **and** a small X in the same card. (Combined game.) | 1 each |
| 23 | **small T** | A 3×3 mini-T (5 cells: top row + center stem, 4 rotations × 9 positions). | 1–4 (default 1) |
| 24 | **small X** | A 3×3 mini-X (5 cells: 4 corners + center, 9 positions). **Two X's can't share a cell or cross their diagonals.** | 1–2 (max 2) |
| 25 | **small O** | A 3×3 hollow ring of 8 cells (no center). | 1 (fixed) |
| 26 | **small H** | A 3×3 mini-H (7 cells). Two rotations: B-O Sides, Top-N-Bottom. | 1–2 (default 1) |
| 27 | **small + (cross)** | A 3×3 mini-`+` (5 cells: middle row + middle column of a 3×3 block). | 1–2 (max 2) |
| 28 | **small L** | A 3×3 mini-L (3 cells: 16 positions). | 1–5 (default 4) |

### 🅶️ Mixed / Combined Game

| # | Game Name | What it is |
|---|-----------|-----------|
| 29 | **Mixed Join** | Container rule — combines several sub-games; you can pick which ones. |
| 30 | **ትእዛዝ (Tiezaz)** | A special combined game made of Cross / + + Square (rectangle) + L Shape. |

### 🅷️ Static Mix Presets (`mix_01` … `mix_14`)

These are **14 pre-built combined games**. Each `mix_xx` is a fixed list of sub-games + counts. To win, **all sub-games must be completed at the same time** (`requiresAllPatternGroups = true`). When a part has `allowOverlap: true`, the sub-patterns may share cells.

| Preset | Sub-games combined |
|--------|-------------------|
| `mix_01` | 1 Row + 1 Column + 1 Diagonal (overlap allowed) |
| `mix_02` | 1 Column + 1 Row (overlap allowed) |
| `mix_03` | 1 Diagonal + 2 small L |
| `mix_04` | 2 Diagonals + 1 Row (overlap allowed) |
| `mix_05` | 1 BIG T + 1 Square |
| `mix_06` | 1 small T + 1 Square |
| `mix_07` | 1 BIG T + 1 Diagonal (overlap allowed) |
| `mix_08` | 1 small T + 1 Diagonal |
| `mix_09` | 1 small Cross + 1 Square + 1 small L |
| `mix_10` | 1 small O + 1 line |
| `mix_11` | 2 lines + 1 Square (overlap allowed) |
| `mix_12` | 1 Pyramid + 1 line |
| `mix_13` | 1 RIGHT Shape + 1 Square |
| `mix_14` | 1 BIG L + 1 small L |

> All these static mixes plus the 30 base games = **44+ total playable rules** in the catalog.

---

## 3. ✅ How Bingo Is Detected (Win Logic)

The function `evaluateCartelaForGame(cartela, gameRule)` returns a `GameResult` with these fields:

- `isBingo` → **true** when the selected game's required pattern(s) is fully marked.
- `winningCellIndexes` → the cells forming the winning pattern (drawn as a colored overlay).
- `winningPatterns` → the completed `WinPattern` objects.
- `oneAwayCellIndexes` → cells that, if marked next, would complete the pattern (highlighted as **"one away"**).
- `missingCellIndexes` → cells still needed to complete the best pattern.

### Detection steps (per game):
1. Look at the card's `marked` list (with FREE center cell `index 12` always treated as `true` — see `_isCellMarkedForGame`).
2. For each `WinPattern` defined by the game rule, count how many of its `cellIndexes` are marked.
3. **Single-pattern games** (FULL-HOUSE, Half House, BIG shapes, Pyramid, etc.):
   - Compare marked count to required count → if equal → `isBingo = true`.
4. **Counted pattern games** (Rows, Columns, lines, Diagonal, Square, small shapes, etc.):
   - Compute completed patterns. If `completed.length >= requiredPatternCount` → `isBingo = true`.
5. **Multi-group games** (`requiresAllPatternGroups = true` — Square, Rectangule, Triangles, Tiezaz, mixes, small T, small X, etc.):
   - For each *group*, find the best non-overlapping combination of patterns (using `groupAllowSharedCellIndexes` for allowed overlap, e.g. the FREE center for the two diagonals).
   - If **all** required groups can be completed at the same time → `isBingo = true`.
6. The **best (least-missing) pattern** is tracked to drive the **"one away"** highlight.

The UI in `lib/cartela_card.dart` reacts to the result:
- 🟡 **BINGO badge** appears when `isBingo` is true.
- 🔵 **"One Away" badge + blinking cell highlights** when the card is one cell away from a pattern.
- 🟢 **Colored overlay** painted on top of the winning cells.
- 📳 **Vibration** triggers the moment bingo first appears.

---

## 4. 🔁 "One Mark → All Cartelas" (Master Marking Flow)

This is the **core mechanic of the app**. A single tap updates **every loaded cartela simultaneously** because the caller calls one number at a time, and the same number can exist on many players' cards.

Implementation: `markNumberAcrossAllCartelas(column, value, newMarkedState)` in `lib/home_page.dart`:

```
1. setState(() {
2.   a. Update _calledNumberKeys set:  e.g. 'B:7'  → added or removed
3.   b. For EACH cartela in cartelas:
4.        Look in the matching column ('B','I','N','G','O')
5.        If the value (e.g. 7) exists in that column,
6.        compute cellIndex = row * 5 + columnIndex
7.        set cartela['marked'][cellIndex] = newMarkedState
8.   c. Re-sort the cartelas so the "best" card goes to the top.
9. });
10. Check if any cartela now has bingo → trigger celebration.
11. Save session state to SharedPreferences.
```

Key points:
- `_calledNumberKeys` is the **master called-number set** (key format `"B:7"`, `"I:22"`, etc.).
- A **single tap** updates **all cartelas at once** for that column + value.
- The FREE center cell (index 12) is **always** counted as marked (`_isCellMarkedForGame`).
- New cartelas loaded later automatically receive marks for numbers already called (`_applyCalledNumbersToCartela`).
- Conversely, when a tap **un-marks** a number, it's removed from `_calledNumberKeys` AND removed from every cartela.

### Reuse / "Winning Cartela" Highlight
- The card closest to bingo is detected by `findBestCartelaKeyForGame(cartelas, gameRule)`.
- The function `isBetterGameResult` ranks cards as follows:
  1. **Bingo wins** (ties keep the earlier winning card).
  2. Otherwise, **fewer missing cells** wins.
  3. If still tied, **more marked cells** wins.
- `sortCartelasByMarkedCount()` (or by "line count" when `useLineCounting = true`) moves the **best cartela to the top** of the list.
- The best card gets a **gold border + first-place styling** in the UI.
- `countCompletedLines(cartela)` counts rows + columns + 2 diagonals + 4 corners for tiebreaking.

---

## 5. 🎬 End-to-End Game Flow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. STARTUP                                                  │
│    loadGameState() → restores cartelas, called numbers,     │
│    game rule, pattern counts, and language.                 │
│    Also rebuilds _calledNumberKeys from saved cartelas.     │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 2. ADD A CARTELA                                            │
│    User types a cartela number → onSearch() → fetchCartela()│
│    → loads JSON from assets/cartelas.json                   │
│    → creates runtime card with empty `marked` list          │
│    → applies already-called numbers                         │
│    → saves session                                          │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 3. SELECT A GAME                                            │
│    User picks a game from the picker.                       │
│    If the game supports multiple patterns                   │
│    (Rows, Square, mix_xx, etc.), the user chooses the count │
│    (e.g. "3 Rows").                                         │
│    activeGameRule = buildActiveGameRule(...) → re-evaluates │
│    every card immediately.                                  │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 4. CALL NUMBERS                                             │
│    User taps a cell on any cartela.                         │
│    markNumberAcrossAllCartelas(col, val, newState)          │
│      → updates _calledNumberKeys                            │
│      → marks the same number on EVERY loaded cartela       │
│      → re-sorts cards (best card on top)                    │
│      → checks for new bingo → shows BINGO celebration       │
│        (animated overlay, vibration)                        │
│      → saves session                                        │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 5. UI FEEDBACK (per cartela)                                │
│    CartelaCard.build():                                     │
│      - markedCount (badge in header)                        │
│      - evaluateCartelaForGame(...)                          │
│        • show BINGO badge if isBingo                        │
│        • show "one away" badge + blink cells if isOneAway   │
│        • draw colored overlay for winning cells             │
│      - vibrate once when bingo first appears                │
└─────────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────────┐
│ 6. END OF ROUND / RESET                                     │
│    "Reset Marked Numbers" → clears all marks + called keys  │
│    "Restore Cartelas"      → removes all cartelas           │
│    "Save state" persists in SharedPreferences under         │
│    'bingo_session_v1' so closing the app keeps progress.    │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. 🧠 Quick Reference Cheat Sheet

| Concept | File | Key function |
|---------|------|-------------|
| All game definitions | `lib/game_rules.dart` | `availableGameRules`, `staticMixPresets` |
| Build a game's rules | `lib/game_rules.dart` | `buildActiveGameRule(...)` |
| Detect bingo | `lib/game_rules.dart` | `evaluateCartelaForGame(cartela, gameRule)` |
| Pick winning overlay | `lib/game_rules.dart` | `selectWinningPatternsForDisplay(...)` |
| One mark → all cards | `lib/home_page.dart` | `markNumberAcrossAllCartelas(col, val, state)` |
| Sort best card on top | `lib/home_page.dart` | `sortCartelasByMarkedCount()` |
| Render the 5×5 grid | `lib/cartela_card.dart` | `CartelaCard.build()` |
| Card database | `assets/cartelas.json` | (JSON keyed by card number) |

---

## 7. 📊 Summary Counts

- **30 base game rules** (single + counted + multi-group + big shapes + small shapes).
- **14 static mix presets** (mix_01 … mix_14).
- **44+ total playable rules** in the catalog.
- **All shapes are evaluated as a set of cell-indexes** on a 5×5 grid (indexes 0..24).
- **FREE center** (index 12) is always treated as marked.
- **One tap on any cartela = mark the same column+value on ALL loaded cartelas.**
- **Best (winning) cartela is auto-sorted to the top** and styled with a gold border.
- **Bingo triggers a celebration animation + vibration.** The winning cells get a colored overlay and a "BINGO" badge.

> Tip: The exhaustive game logic source is in `lib/game_rules.dart`. The session/marking flow is in `lib/home_page.dart`. The card renderer is in `lib/cartela_card.dart`.
