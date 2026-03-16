import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Map<String, List<dynamic>>> cartelas =
      {}; // Holds cartelas by unique numbers
  final String appName = "Geez Bingo";
  bool isAutoRotate = true; // Track orientation state
  TextEditingController searchController =
      TextEditingController(); // Single search controller
  String searchAlert = ""; // Alert text for search result
  String lastClickedNumber = ""; // Track the last clicked cell value
  bool lastActionWasAdded = true; // Track if last action was add or remove
  bool useLineCounting = false; // Toggle between sorting algorithms
  bool sortingDisabled = false; // Toggle to disable sorting completely

  Future<void> fetchCartela(String cartelaNumber) async {
    try {
      // Load JSON data from the asset
      final String response =
          await rootBundle.loadString('assets/cartelas.json');
      final Map<String, dynamic> jsonData = json.decode(response);

      // Fetch the specific cartela by its number
      final Map<String, dynamic>? cartela = jsonData[cartelaNumber];

      if (cartela != null) {
        setState(() {
          // Update the cartelas map with the new data
          cartelas[cartelaNumber] = {
            'B': List<int>.from(cartela['B']),
            'I': List<int>.from(cartela['I']),
            'N': List<dynamic>.from(cartela['N']),
            'G': List<int>.from(cartela['G']),
            'O': List<int>.from(cartela['O']),
            'marked': List<bool>.generate(25, (index) => false),
          };
          searchAlert =
              "Cartela number $cartelaNumber loaded successfully."; // Success alert
        });
      } else {
        setState(() {
          searchAlert =
              "Cartela number $cartelaNumber not found."; // Error alert
        });
      }
    } catch (e) {
      // Handle potential errors
      print("Error fetching cartela: $e");
      setState(() {
        searchAlert =
            "Error fetching cartela data. Please try again."; // Error message
      });
    }
  }

  // Toggle orientation
  void toggleOrientation() {
    setState(() {
      isAutoRotate = !isAutoRotate;
      if (isAutoRotate) {
        SystemChrome.setPreferredOrientations([]); // Enable auto-rotate
      } else {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp]); // Portrait only
      }
    });
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
        title: const Text('Confirm Restore'),
        content: Text(
            'Are you sure you want to restore all ${cartelas.length} cartelas?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartelas.clear(); // Clear all added cartelas
                searchAlert = "All Cartelas restored."; // Show message
              });
            },
            child: const Text('Restore'),
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
        title: const Text('Confirm Reset'),
        content:
            const Text('Are you sure you want to reset all marked numbers?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                cartelas.forEach((key, cartela) {
                  cartela['marked'] = List<bool>.generate(
                      25, (index) => false); // Reset marked numbers
                });
                searchAlert =
                    "All marked numbers have been reset."; // Show message
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  // Mark/Unmark the same number across all cartelas
  void markNumberAcrossAllCartelas(
      String column, String value, bool newMarkedState) {
    setState(() {
      cartelas.forEach((cartelaNumber, cartela) {
        // Get the list for this column (B, I, N, G, or O)
        List<dynamic>? columnList = cartela[column];
        if (columnList != null) {
          // Find if this value exists in the column
          for (int rowIndex = 0; rowIndex < columnList.length; rowIndex++) {
            if (columnList[rowIndex]?.toString() == value) {
              // Calculate the cell index in the 25-cell grid
              int columnIndex = ['B', 'I', 'N', 'G', 'O'].indexOf(column);
              int cellIndex = rowIndex * 5 + columnIndex;
              // Mark/unmark this cell
              cartela['marked']?[cellIndex] = newMarkedState;
            }
          }
        }
      });

      // After marking, sort cartelas by marked count (most marked first)
      sortCartelasByMarkedCount();
    });
  }

  // Count completed bingo lines (rows, columns, diagonals, four corners)
  int countCompletedLines(Map<String, List<dynamic>> cartela) {
    int lines = 0;
    List<bool> marked = List<bool>.from(cartela['marked']!);

    // Helper function to check if a cell is effectively marked
    bool isEffectivelyMarked(int index) {
      // FREE space at N[2] (index 12) is always considered marked
      if (index == 12) return true;
      return marked[index];
    }

    // Check rows (5 possible)
    for (int row = 0; row < 5; row++) {
      bool rowComplete = true;
      for (int col = 0; col < 5; col++) {
        int index = row * 5 + col;
        if (!isEffectivelyMarked(index)) {
          rowComplete = false;
          break;
        }
      }
      if (rowComplete) lines++;
    }

    // Check columns (5 possible)
    for (int col = 0; col < 5; col++) {
      bool colComplete = true;
      for (int row = 0; row < 5; row++) {
        int index = row * 5 + col;
        if (!isEffectivelyMarked(index)) {
          colComplete = false;
          break;
        }
      }
      if (colComplete) lines++;
    }

    // Check main diagonal (top-left to bottom-right)
    bool mainDiagComplete = true;
    for (int i = 0; i < 5; i++) {
      int index = i * 5 + i;
      if (!isEffectivelyMarked(index)) {
        mainDiagComplete = false;
        break;
      }
    }
    if (mainDiagComplete) lines++;

    // Check anti-diagonal (top-right to bottom-left)
    bool antiDiagComplete = true;
    for (int i = 0; i < 5; i++) {
      int index = i * 5 + (4 - i);
      if (!isEffectivelyMarked(index)) {
        antiDiagComplete = false;
        break;
      }
    }
    if (antiDiagComplete) lines++;

    // Check four corners (B[0], B[4], O[0], O[4]) - unchanged as it doesn't include FREE space
    if (marked[0] && marked[4] && marked[20] && marked[24]) {
      lines++;
    }

    return lines;
  }

  // Show settings dialog
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sort toggle switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sort Cards',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: !sortingDisabled,
                    onChanged: (value) {
                      setState(() {
                        sortingDisabled = !value;
                      });
                      setDialogState(
                          () {}); // Rebuild dialog to show toggle change
                      // Trigger resorting immediately when toggle changes
                      if (!sortingDisabled) {
                        sortCartelasByMarkedCount();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Algorithm selection (only show when sorting is enabled)
              if (!sortingDisabled) ...[
                const SizedBox(height: 8),
                DropdownButtonFormField<bool>(
                  initialValue: useLineCounting,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: false,
                      child: Text('ብ በዝሒ ዝተፀወዐ'),
                    ),
                    DropdownMenuItem(
                      value: true,
                      child: Text('ብ በዝሒ መስመር'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      useLineCounting = value!;
                    });
                    setDialogState(
                        () {}); // Rebuild dialog to show dropdown change
                    // Trigger resorting immediately when algorithm changes
                    sortCartelasByMarkedCount();
                  },
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  // Move only the card with most marks to first position
  void sortCartelasByMarkedCount() {
    if (sortingDisabled || cartelas.length <= 1)
      return; // No sorting if disabled or 0/1 card

    // Find the card with the maximum count (marked cells or completed lines)
    String? maxCartelaKey;
    int maxCount = 0;

    cartelas.forEach((key, value) {
      int count;
      if (useLineCounting) {
        count = countCompletedLines(value);
      } else {
        count =
            (value['marked'] as List<bool>).where((marked) => marked).length;
      }

      if (count > maxCount) {
        maxCount = count;
        maxCartelaKey = key;
      }
    });

    // If we found a max card and it's not already first
    if (maxCartelaKey != null && cartelas.keys.first != maxCartelaKey) {
      // Get all entries
      var entries = cartelas.entries.toList();

      // Find the index of the max card
      int maxIndex = entries.indexWhere((entry) => entry.key == maxCartelaKey);

      if (maxIndex > 0) {
        // Remove the max card from its position
        var maxEntry = entries.removeAt(maxIndex);

        // Insert it at the beginning
        entries.insert(0, maxEntry);

        // Rebuild the map with new order
        cartelas = Map.fromEntries(entries);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/logo.webp',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),
              SizedBox(width: screenWidth < 360 ? 6 : 8),
              Flexible(
                child: Text(
                  appName,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.deepPurple,
          actions: [
            // Delete/Restore icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: restoreCartelas,
                child: Icon(
                  cartelas.isEmpty ? Icons.restore : Icons.delete,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
            ),
            // Refresh icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: resetMarkedNumbers,
                child: Icon(
                  Icons.refresh,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
            ),
            // 3-dot menu for settings (moved to last position)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: _showSettingsDialog,
                child: Icon(
                  Icons.more_vert,
                  color: Colors.red,
                  size: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Top row with last clicked number and total cards
          if (cartelas.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side: Total cards counter
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      'Total Cards: ${cartelas.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth < 360 ? 12 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Right side: Last clicked number with label
                  if (lastClickedNumber.isNotEmpty)
                    Row(
                      children: [
                        Text(
                          lastActionWasAdded ? 'Added: ' : 'Removed: ',
                          style: TextStyle(
                            color:
                                lastActionWasAdded ? Colors.black : Colors.red,
                            fontSize: screenWidth < 360 ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              lastClickedNumber,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth < 360 ? 12 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(
                        width:
                            110), // Placeholder for alignment (label + circle)
                ],
              ),
            ),

          cartelas.isEmpty
              ? const Center(child: Text("No Cartelas Added"))
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics:
                        const BouncingScrollPhysics(), // Smooth scroll effect
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isInLandscape ? 3 : 2,
                        crossAxisSpacing: isInLandscape ? 2 : 4,
                        mainAxisSpacing: isInLandscape ? 3 : 6,
                        childAspectRatio: isInLandscape ? 0.6 : 0.73,
                      ),
                      itemCount: cartelas.length,
                      itemBuilder: (context, index) {
                        var entry = cartelas.entries.elementAt(index);
                        // Count marked numbers for this card
                        int markedCount = (entry.value['marked'] as List<bool>)
                            .where((marked) => marked)
                            .length;
                        // First place only if it's index 0 AND has at least 4 marked
                        bool isFirstPlace = index == 0 && markedCount >= 4;

                        return Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isFirstPlace
                                  ? Colors.amber
                                  : Colors.deepPurpleAccent,
                              width: isFirstPlace ? 3 : 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isFirstPlace
                                ? [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.6),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]
                                : null,
                          ),
                          child: buildCartela(entry.key, entry.value,
                              isFirstPlace, isInLandscape, screenWidth),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCartelaDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddCartelaDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              "Add Cartela",
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
                      decoration: const InputDecoration(
                        hintText: "Search Cartela",
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
              child: const Text(
                "Cancel",
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

  Widget buildCartela(String cartelaNumber, Map<String, List<dynamic>> cartela,
      bool isFirstPlace, bool isInLandscape, double screenWidth) {
    bool isSingleCartela = cartelas.length == 1;

    // Count marked numbers for display
    int markedCount =
        (cartela['marked'] as List<bool>).where((marked) => marked).length;

    return Container(
      width: isInLandscape
          ? screenWidth * 0.25 // 25% of screen width in landscape
          : (isSingleCartela ? 180 : 120), // Current portrait behavior
      height: isInLandscape
          ? screenWidth *
              0.35 // Smaller height in landscape (35% of screen width)
          : null, // Auto height in portrait (current behavior)
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        border: Border.all(
          color: isFirstPlace ? Colors.amber : Colors.deepPurpleAccent,
          width: isFirstPlace ? 3 : 2,
        ),
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isFirstPlace
              ? [Colors.amber.shade100, Colors.amber.shade300]
              : [Colors.deepPurple.shade100, Colors.deepPurple.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isFirstPlace
                ? Colors.amber.withOpacity(0.5)
                : Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cartela number with reset and remove buttons in a compact layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              children: [
                // First place indicator
                if (isFirstPlace)
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 16,
                  ),
                if (isFirstPlace) const SizedBox(width: 2),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "NO=$cartelaNumber",
                        style: TextStyle(
                          fontSize: isInLandscape ? 11 : 13,
                          fontWeight: FontWeight.bold,
                          color: isFirstPlace
                              ? Colors.amber.shade900
                              : Colors.deepPurple,
                        ),
                      ),
                      // Show marked count
                      Text(
                        " ($markedCount)",
                        style: TextStyle(
                          fontSize: isInLandscape ? 9 : 11,
                          fontWeight: FontWeight.bold,
                          color: isFirstPlace
                              ? Colors.amber.shade900
                              : Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                ),
                // Delete button with reduced padding
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cartelas.remove(cartelaNumber);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.delete,
                      size: 16,
                      color: isFirstPlace
                          ? Colors.amber.shade900
                          : Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                // Refresh button with reduced padding
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cartela['marked'] =
                          List<bool>.generate(25, (index) => false);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.refresh,
                      size: 14,
                      color: isFirstPlace
                          ? Colors.amber.shade900
                          : Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['B', 'I', 'N', 'G', 'O'].map((label) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isInLandscape ? 12 : 14,
                      fontWeight: FontWeight.bold,
                      color: isFirstPlace
                          ? Colors.amber.shade900
                          : Colors.deepPurple,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // Use SingleChildScrollView to enable scrolling of the cartela
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enable vertical scroll
              child: GridView.builder(
                shrinkWrap:
                    true, // Prevents GridView from taking up excess space
                physics:
                    const NeverScrollableScrollPhysics(), // Disable grid scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: isInLandscape ? 1 : 4,
                  mainAxisSpacing: isInLandscape ? 2 : 6,
                  childAspectRatio: isInLandscape ? 0.9 : 1,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  String cellValue = getCellValue(index, cartela);
                  bool isMarked = cartela['marked']?[index] ?? false;
                  Color cellColor = (index == 12)
                      ? Colors.orange
                      : isMarked
                          ? Colors.orange
                          : Colors.white;

                  return GestureDetector(
                    onTap: () {
                      if (index != 12 && cellValue.isNotEmpty) {
                        // Get the column letter (B, I, N, G, O)
                        int columnIndex = index % 5;
                        String column = ['B', 'I', 'N', 'G', 'O'][columnIndex];

                        // Get current state and toggle it
                        bool currentState = cartela['marked']?[index] ?? false;
                        bool newState = !currentState;

                        // Update last clicked number and action
                        setState(() {
                          lastClickedNumber = cellValue;
                          lastActionWasAdded =
                              newState; // true if adding mark, false if removing
                        });

                        // Mark/unmark this number across ALL cartelas
                        markNumberAcrossAllCartelas(
                            column, cellValue, newState);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                            color: Colors.deepPurpleAccent, width: 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cellValue,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: isInLandscape ? 14 : 17,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getCellValue(int index, Map<String, List<dynamic>> cartela) {
    List<String> columns = ['B', 'I', 'N', 'G', 'O'];
    int columnIndex = index % 5; // Determine which column the number belongs to
    int rowIndex = index ~/ 5; // Determine which row the number belongs to

    if (columnIndex == 2 && rowIndex == 2) return "FREE"; // Center cell

    return cartela[columns[columnIndex]]?[rowIndex]?.toString() ?? "";
  }
}
