import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Map<String, List<dynamic>>> cartelas =
      {}; // Holds cartelas by unique numbers
  final String appName = "Friends Bingo";
  bool isAutoRotate = true; // Track orientation state
  TextEditingController searchController =
      TextEditingController(); // Single search controller
  String searchAlert = ""; // Alert text for search result

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

  // Restore all cartelas
  void restoreCartelas() {
    setState(() {
      cartelas.clear(); // Clear all added cartelas
      searchAlert = "All Cartelas removed."; // Show message
    });
  }

  // Reset marked numbers for all cartelas
  void resetMarkedNumbers() {
    setState(() {
      cartelas.forEach((key, cartela) {
        cartela['marked'] =
            List<bool>.generate(25, (index) => false); // Reset marked numbers
      });
      searchAlert = "All marked numbers have been reset."; // Show message
    });
  }

  // Mark/Unmark the same number across all cartelas
  void markNumberAcrossAllCartelas(String column, String value, bool newMarkedState) {
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

  // Move only the card with most marks to first position
  void sortCartelasByMarkedCount() {
    if (cartelas.length <= 1) return; // No need to sort if 0 or 1 card
    
    // Find the card with the maximum marked count
    String? maxCartelaKey;
    int maxMarkedCount = 0;
    
    cartelas.forEach((key, value) {
      int count = (value['marked'] as List<bool>).where((marked) => marked).length;
      if (count > maxMarkedCount) {
        maxMarkedCount = count;
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
    // Get screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    
    // Responsive sizing
    double logoSize = screenWidth < 360 ? 28 : (screenWidth < 400 ? 32 : 36);
    double titleFontSize = screenWidth < 360 ? 14 : (screenWidth < 400 ? 16 : 18);
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
            // Rotation icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GestureDetector(
                onTap: toggleOrientation,
                child: AnimatedRotation(
                  turns: isAutoRotate ? 0 : 0.5,
                  duration: const Duration(milliseconds: 500),
                  child: Icon(
                    Icons.screen_rotation,
                    color: Colors.red,
                    size: iconSize,
                  ),
                ),
              ),
            ),
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
            // Refresh icony
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
          ],
        ),
      ),
      body: Column(
        children: [
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.73,
                      ),
                      itemCount: cartelas.length,
                       itemBuilder: (context, index) {
                         var entry = cartelas.entries.elementAt(index);
                         // Count marked numbers for this card
                         int markedCount = (entry.value['marked'] as List<bool>).where((marked) => marked).length;
                         // First place only if it's index 0 AND has at least 4 marked
                         bool isFirstPlace = index == 0 && markedCount >= 4;
                         
                         return Container(
                           margin: const EdgeInsets.all(2),
                           decoration: BoxDecoration(
                             border: Border.all(
                               color: isFirstPlace ? Colors.amber : Colors.deepPurpleAccent,
                               width: isFirstPlace ? 3 : 1,
                             ),
                             borderRadius: BorderRadius.circular(16),
                             boxShadow: isFirstPlace ? [
                               BoxShadow(
                                 color: Colors.amber.withOpacity(0.6),
                                 spreadRadius: 2,
                                 blurRadius: 8,
                                 offset: const Offset(0, 0),
                               ),
                             ] : null,
                           ),
                           child: buildCartela(entry.key, entry.value, isFirstPlace),
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
        child: Icon(Icons.add),
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
                      child: Text("ADD"),
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

  Widget buildCartela(
      String cartelaNumber, Map<String, List<dynamic>> cartela, bool isFirstPlace) {
    bool isSingleCartela = cartelas.length == 1;
    
    // Count marked numbers for display
    int markedCount = (cartela['marked'] as List<bool>).where((marked) => marked).length;

    return Container(
      width: isSingleCartela ? 180 : 120,
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
                if (isFirstPlace)
                  const SizedBox(width: 2),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        "NO=$cartelaNumber",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isFirstPlace ? Colors.amber.shade900 : Colors.deepPurple,
                        ),
                      ),
                      // Show marked count
                      Text(
                        " ($markedCount)",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isFirstPlace ? Colors.amber.shade900 : Colors.deepPurple,
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
                      color: isFirstPlace ? Colors.amber.shade900 : Colors.deepPurple,
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
                      color: isFirstPlace ? Colors.amber.shade900 : Colors.deepPurple,
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isFirstPlace ? Colors.amber.shade900 : Colors.deepPurple,
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 6,
                  childAspectRatio:
                      1, // Adjusted ratio to ensure proper sizing
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
                        
                        // Mark/unmark this number across ALL cartelas
                        markNumberAcrossAllCartelas(column, cellValue, newState);
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
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
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
