# Digital Cartel Game Logic

This document explains the two core flows in the app:

1. Game rules, game names, and how each rule works.
2. How `assets/cartelas.json` is loaded, rendered, marked, and saved.

---

## 1. Game Rules and Supported Game Names

### Key files
- `lib/game_rules.dart`
- `lib/home_page.dart`
- `lib/cartela_card.dart`

### What the app uses
- `GameRule`: defines a bingo game rule.
- `WinPattern`: defines a named winning shape or pattern.
- `GameResult`: describes a card's progress for a selected rule.

### Rule behavior
- A `GameRule` contains:
  - `name`: the game title.
  - `patterns`: the winning shapes expressed as index lists.
  - optional rules to count multiple pattern groups.
- The engine calls `evaluateCartelaForGame(cartela, gameRule)` to determine if a card has bingo.

### Supported game names
The app supports over 35 game rules, including preset mixes.

#### Basic rules
- `Manual`
- `FULL-HOUSE`
- `Half House`
- `line`
- `Columns`
- `Rows`
- `Diagonal`
- `LIne touches free`
- `lines with out free`
- `Square`
- `Rectangule`
- `2 triangle`
- `4 by 4 triangle`
- `Pyramid`
- `BIG L Shape`
- `BIG T`
- `BIG H`
- `BIG N`
- `BIG Y`
- `BIG Cross`
- `RIGHT Shape`
- `small T shape and X shape`
- `small T`
- `small X`
- `small O`
- `small H`
- `small + (cross)`
- `small L`
- `Mixed Join`

#### Static mix presets
- `mix_01`
- `mix_02`
- `mix_03`
- `mix_04`
- `mix_05`
- `mix_06`
- `mix_07`
- `mix_08`
- `mix_09`
- `mix_10`
- `mix_11`
- `mix_12`
- `mix_13`
- `mix_14`

> This totals more than 35 game definitions when static mixes are included.

### What each rule means
- `Manual`: no automatic winning logic; manual marking only.
- `FULL-HOUSE`: all 25 cells must be marked.
- `Half House`: one of several 15-cell large-area patterns (rows, columns, triangles).
- `line`: basic completed line patterns.
- `Columns`: completed columns.
- `Rows`: completed rows.
- `Diagonal`: completed diagonal lines, usually with free center allowed.
- `LIne touches free`: lines that can include the free center.
- `lines with out free`: lines that exclude the free center.
- `Square`/`Rectangule`: square or rectangle shaped areas.
- `2 triangle`/`4 by 4 triangle`/`Pyramid`: triangular or pyramid shapes.
- `BIG *` / `right shape` / `small *`: large or small shape patterns.
- `Mixed Join` and `mix_xx`: combined preset game modes from multiple sub-shapes.

### How the engine chooses the best card
- `findBestCartelaKeyForGame(cartelas, gameRule)` evaluates every loaded card.
- It compares results and picks the card closest to winning.
- `sortCartelasByGameType(activeGameRule)` moves the best card to the top.

---

## 2. Cartela JSON Asset and Rendering Flow

### Cartela asset structure
- `assets/cartelas.json` is the source of all card definitions.
- Each card is keyed by a string number, for example:
  - `"1": { "B": [...], "I": [...], "N": [...], "G": [...], "O": [...] }`
- The `N` column contains a `"FREE"` center value in row 3.
- Example card columns:
  - `B`: 5 column values
  - `I`: 5 column values
  - `N`: 5 values including `"FREE"`
  - `G`: 5 values
  - `O`: 5 values

### Loading a card from JSON
- `fetchCartela(String cartelaNumber)` in `lib/home_page.dart` does:
  1. `rootBundle.loadString('assets/cartelas.json')`
  2. `json.decode(response)` into a map
  3. lookup by `cartelaNumber`
  4. create a runtime card map with `B`, `I`, `N`, `G`, `O`, and `marked`
  5. initialize `marked` as 25 false values
  6. call `_applyCalledNumbersToCartela(newCartela)` to preserve marked numbers already clicked elsewhere
  7. add the card to `cartelas`
  8. save state

### Applying saved state
- `loadGameState()` loads `SharedPreferences` from `_sessionStorageKey`.
- It also reloads the JSON asset and reconstructs cards from the original JSON data.
- Only the `marked` state is restored from saved session data.
- This keeps card values consistent with the asset while restoring progress.

### Marking behavior
- Each cell is rendered in `lib/cartela_card.dart` as a 5x5 grid.
- The center cell at index 12 is displayed as `FREE`.
- Tap handling uses `onCellMarkChanged(column, value, newState)`.
- In `home_page.dart`, `markNumberAcrossAllCartelas()` does:
  1. update `_calledNumberKeys` for the tapped cell
  2. loop every loaded cartela
  3. find matching values in the same column
  4. compute grid index: `rowIndex * 5 + columnIndex`
  5. set `cartela['marked'][cellIndex] = newMarkedState`
  6. sort cards using selected game rule
  7. save state and check for bingo celebration

### Rendering and UI feedback
- `CartelaCard.build()` computes:
  - `markedCount` from `cartela['marked']`
  - `GameResult gameResult = evaluateCartelaForGame(widget.cartela, widget.selectedGameRule)`
- UI uses game result to:
  - show bingo badge when `isBingo`
  - show one-away badge when `isOneAway`
  - highlight cells for one-away progress
  - draw winning pattern overlays when a win is identified

### End-to-end flow
1. User enters a card number and triggers search.
2. App loads `assets/cartelas.json` and finds the card data.
3. App creates a runtime card object with values and empty marks.
4. App applies existing called numbers to the card.
5. User taps a cell to mark/unmark it.
6. `markNumberAcrossAllCartelas()` updates every card with that same number.
7. The app re-evaluates cards for the selected game rule.
8. The UI updates the card grid, badges, and highlights.
9. App saves the updated session state.

---

## References
- `lib/game_rules.dart` — all rule definitions and evaluation logic
- `lib/home_page.dart` — asset loading, state restore, marking, and sorting
- `lib/cartela_card.dart` — rendering of the card and interaction UI
- `assets/cartelas.json` — the card database
