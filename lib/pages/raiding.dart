// ignore_for_file: collection_methods_unrelated_type

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rust_toolkit/item_raid_model.dart';
import 'package:rust_toolkit/recyclable_model.dart';
import 'package:rust_toolkit/recycle_result_page.dart';

class Raiding extends StatefulWidget {
  const Raiding({super.key});

  @override
  State<Raiding> createState() => _RaidingState();
}

class _RaidingState extends State<Raiding> {
  final TextEditingController _searchController = TextEditingController();
  List<RaidItem> _allItems = [];
  // final List<dynamic> _items = [];
  // List<dynamic> _filteredItems = [];
  List<RaidItem> _searchResults = [];
  final Map<RaidItem, int> _itemsToRaid = {};
  bool isChecked = false;
  // String _selectedCategory = 'All';
  // final List<String> _categories = [
  //   'All',
  //   'Twig',
  //   'Wood',
  //   'Stone',
  //   'Metal',
  //   'Armor',
  //   'Doors',
  //   'Deployable',
  // ];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final String data = await rootBundle.loadString('assets/raiding.json');
    final List<dynamic> jsonData = json.decode(data);

    setState(() {
      _allItems = jsonData.map((item) => RaidItem.fromJson(item)).toList();
    });
  }

  void _searchItem(String query) {
    final results = _allItems.where((item) {
      final nameLower = item.name.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      _searchResults = results;
    });
  }

  // void _filterItems(String query) {
  //   List<dynamic> filtered = _items;
  //   if (_selectedCategory != 'All') {
  //     filtered = filtered
  //         .where((item) => item['category'] == _selectedCategory)
  //         .toList();
  //   }
  //   if (query.isNotEmpty) {
  //     filtered = filtered.where((item) {
  //       final nameLower = item['name'].toLowerCase();
  //       final queryLower = query.toLowerCase();
  //       return nameLower.contains(queryLower);
  //     }).toList();
  //   }
  //   setState(() => _filteredItems = filtered);
  // }

  void _addItemToRecycle(RaidItem item) {
    if (!_itemsToRaid.containsKey(item)) {
      _itemsToRaid[item] = 1;
    } else {
      _itemsToRaid[item] = _itemsToRaid[item]! + 1;
    }

    setState(() {});
  }

  void _removeItemFromRecycle(RaidItem item) {
    if (_itemsToRaid.containsKey(item) && _itemsToRaid[item]! > 1) {
      _itemsToRaid[item] = _itemsToRaid[item]! - 1;
    } else {
      _itemsToRaid.remove(item);
    }

    setState(() {});
  }

  void _calculateRecyclables() {
    List<RecyclableItem> recyclableItems = [];

    _itemsToRaid.forEach((item, quantity) {
      for (var component in item.raiding) {
        final String image = component['tool'];
        final String name = component['quantity'];
        final int convQuantity = component['sulfur'];
        final int count = convQuantity * quantity;

        // Find an existing recyclable item with the same name and image, if any
        var existingItem = recyclableItems.firstWhere(
          (recyclable) => recyclable.name == name && recyclable.image == image,
          orElse: () => RecyclableItem(name: name, image: image, quantity: 0),
        );

        // If it doesn't exist, add a new item
        if (existingItem.quantity == 0) {
          recyclableItems
              .add(RecyclableItem(name: name, image: image, quantity: count));
        } else {
          // If it exists, just update its quantity
          existingItem.quantity += count;
        }
      }
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          RecycleResultsPage(recyclableItems: recyclableItems),
    ));
  }

  // void _calculateRawMaterialsRecyclables() {
  //   List<RecyclableItem> recyclableItems = [];

  //   _itemsToRaid.forEach((item, quantity) {
  //     for (var component in item.raiding) {
  //       final String image = component['image'];
  //       final String name = component['name'];
  //       final double convQuantity = component['quantity'];
  //       final int count = convQuantity.toInt() * quantity;

  //       // Find an existing recyclable item with the same name and image, if any
  //       var existingItem = recyclableItems.firstWhere(
  //         (recyclable) => recyclable.name == name && recyclable.image == image,
  //         orElse: () => RecyclableItem(name: name, image: image, quantity: 0),
  //       );

  //       // If it doesn't exist, add a new item
  //       if (existingItem.quantity == 0) {
  //         recyclableItems
  //             .add(RecyclableItem(name: name, image: image, quantity: count));
  //       } else {
  //         // If it exists, just update its quantity
  //         existingItem.quantity += count;
  //       }
  //     }
  //   });

  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (context) =>
  //         RecycleRawMaterialsResults(recyclableItems: recyclableItems),
  //   ));
  // }

  void _showEditQuantityDialog(RaidItem item, int currentQuantity) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    final TextEditingController quantityController =
        TextEditingController(text: '$currentQuantity');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Quantity',
            style: TextStyle(color: Colors.deepPurple),
          ),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: TextStyle(
                color: Colors.deepPurple,
                fontSize: fontSize,
              ), // Label color
              filled:
                  true, // Fill color needs to be enabled for `fillColor` to work
              fillColor: Colors.white, // Background color of the text field
              contentPadding:
                  EdgeInsets.all(padding), // Padding inside the text field
              enabledBorder: OutlineInputBorder(
                // Border style when text field is enabled
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 2.0),
                borderRadius: BorderRadius.circular(padding), // Rounded corners
              ),
              focusedBorder: OutlineInputBorder(
                // Border style when text field is focused
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 2.0),
                borderRadius: BorderRadius.circular(padding),
              ),
              errorBorder: OutlineInputBorder(
                // Border style when text field has an error
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 2.0),
                borderRadius: BorderRadius.circular(padding),
              ),
              focusedErrorBorder: OutlineInputBorder(
                // Border style when text field has an error and is focused
                borderSide:
                    const BorderSide(color: Colors.deepPurple, width: 2.0),
                borderRadius: BorderRadius.circular(padding),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final int newQuantity =
                    int.tryParse(quantityController.text) ?? currentQuantity;
                _updateItemQuantity(item, newQuantity);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _updateItemQuantity(RaidItem item, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        _itemsToRaid[item] = newQuantity;
      });
    } else {
      _removeItemFromRecycle(item);
    }
  }

  Widget _buildRecycleList() {
    final double bottomPadding = _itemsToRaid.isNotEmpty ? 76.0 : 20.0;
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    return ListView.builder(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: _itemsToRaid.length, // Define the item count
      itemBuilder: (context, index) {
        final entry = _itemsToRaid.entries.elementAt(index);
        return ListTile(
          leading: Image.asset(
            entry.key.image,
            width: iconSize * 1.6,
          ),
          title: Text(
            entry.key.name,
            style: TextStyle(fontSize: fontSize, color: Colors.black54),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.squareMinus),
                onPressed: () => _removeItemFromRecycle(entry.key),
                iconSize: iconSize,
                color: Colors.deepPurple,
              ),
              GestureDetector(
                onTap: () => _showEditQuantityDialog(entry.key, entry.value),
                child: Container(
                  color: Colors.transparent, // Makes the entire area clickable
                  padding: EdgeInsets.symmetric(
                      horizontal: padding / 2, vertical: padding / 4),
                  child: Text(
                    '${entry.value}',
                    style: TextStyle(fontSize: fontSize, color: Colors.black54),
                  ),
                ),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.squarePlus),
                onPressed: () => _addItemToRecycle(entry.key),
                iconSize: iconSize,
                color: Colors.deepPurple,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final double bottomPadding = _itemsToRaid.isNotEmpty ? 76.0 : 20.0;
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    return ListView.builder(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        final int currentQuantity =
            _itemsToRaid.containsKey(item) ? _itemsToRaid[item]! : 0;

        return ListTile(
          leading: Image.asset(
            item.image,
            width: iconSize * 1.6,
          ),
          title: Text(
            item.name,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black54,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.squareMinus),
                onPressed: () => _removeItemFromRecycle(item),
                iconSize: iconSize,
                color: Colors.deepPurple,
              ),
              GestureDetector(
                onTap: () => _showEditQuantityDialog(item, currentQuantity),
                child: Container(
                  color: Colors.transparent, // Makes the entire area clickable
                  padding: EdgeInsets.symmetric(
                      horizontal: padding / 2, vertical: padding / 4),
                  child: Text(
                    '$currentQuantity',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.squarePlus),
                onPressed: () => _addItemToRecycle(item),
                iconSize: iconSize,
                color: Colors.deepPurple,
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildCategorySelector() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: _categories.map((category) {
  //         return Padding(
  //           padding: const EdgeInsets.only(left: 6.0),
  //           child: ChoiceChip(
  //             checkmarkColor: Colors.white,
  //             selectedColor: Colors.deepPurple.shade300,
  //             label: Text(
  //               category,
  //               style: TextStyle(
  //                   color: _selectedCategory == category
  //                       ? Colors.white
  //                       : Colors.black),
  //             ),
  //             selected: _selectedCategory == category,
  //             onSelected: (bool selected) {
  //               setState(() {
  //                 _selectedCategory = category;
  //                 _filterItems(_searchController.text); // Refilter items
  //               });
  //             },
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Column(
          children: [
            // _buildCategorySelector(), // Category selector added here
            // const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(padding),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Items',
                  labelStyle: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: fontSize,
                  ), // Label color
                  filled:
                      true, // Fill color needs to be enabled for `fillColor` to work
                  fillColor: Colors.white, // Background color of the text field
                  contentPadding:
                      EdgeInsets.all(padding), // Padding inside the text field
                  enabledBorder: OutlineInputBorder(
                    // Border style when text field is enabled
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius:
                        BorderRadius.circular(padding), // Rounded corners
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Border style when text field is focused
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(padding),
                  ),
                  errorBorder: OutlineInputBorder(
                    // Border style when text field has an error
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(padding),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    // Border style when text field has an error and is focused
                    borderSide:
                        const BorderSide(color: Colors.deepPurple, width: 2.0),
                    borderRadius: BorderRadius.circular(padding),
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? IconButton(
                          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass),
                          onPressed: () {},
                          iconSize: fontSize,
                          color: Colors.deepPurple,
                        )
                      : IconButton(
                          icon: const FaIcon(FontAwesomeIcons.xmark),
                          onPressed: () {
                            setState(() {
                              _searchController
                                  .clear(); // Clear the text field content
                            });
                          },
                          iconSize: fontSize,
                          color: Colors.deepPurple,
                        ),
                ),
                onChanged: _searchItem,
              ),
            ),
            Expanded(
              child: _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : _buildRecycleList(),
            ),
          ],
        ),
        floatingActionButton: _itemsToRaid.isNotEmpty
            ? FloatingActionButton(
                backgroundColor: Colors.deepPurple.shade300,
                onPressed: _calculateRecyclables,
                child: FaIcon(
                  FontAwesomeIcons.explosion,
                  color: Colors.white,
                  size: iconSize * 1.2,
                ),
              )
            : null,
      ),
    );
  }
}


  // List<dynamic> _foundations = [];
  // List<dynamic> _filteredFoundations = [];
  // dynamic _selectedFoundation;
  // int _selectedFoundationIndex = -1;
  // String _selectedCategory = 'All';
  // List<String> _categories = ['All'];
  // String _decayTimeMessage = '';
  // final TextEditingController _hpController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   _loadFoundations();
  // }

  // Future<void> _loadFoundations() async {
  //   final String response = await rootBundle.loadString('assets/raiding.json');
  //   final List<dynamic> data = await json.decode(response);
  //   final Set<String> categorySet = <String>{};
  //   for (var foundation in data) {
  //     categorySet.add(foundation['category']);
  //   }
  //   final List<String> dynamicCategories = [
  //     'All',
  //     ...categorySet.toList()..sort()
  //   ];
  //   setState(() {
  //     _foundations = data;
  //     _filteredFoundations = _foundations;
  //     _categories = dynamicCategories;
  //   });
  // }

  // void _filterFoundationsByCategory(String selectedCategory) {
  //   List<dynamic> filtered;
  //   if (selectedCategory == 'All') {
  //     filtered = _foundations;
  //   } else {
  //     filtered = _foundations
  //         .where((item) => item['category'] == selectedCategory)
  //         .toList();
  //   }
  //   setState(() {
  //     _selectedCategory = selectedCategory;
  //     _filteredFoundations = filtered;
  //   });
  // }

  // void _updateSelectedFoundation(dynamic foundation, int index) {
  //   setState(() {
  //     _selectedFoundation = foundation;
  //     _selectedFoundationIndex = index;
  //     _decayTimeMessage = '';
  //   });
  // }

  // bool _validateHpInput(String input) {
  //   final hpInput = double.tryParse(input);
  //   if (hpInput == null ||
  //       hpInput <= 0 ||
  //       _selectedFoundation == null ||
  //       hpInput > double.parse(_selectedFoundation['health'])) {
  //     return false;
  //   }
  //   return true;
  // }

  // void _calculateDecayTime() {
  //   if (!_validateHpInput(_hpController.text)) {
  //     setState(() {
  //       _decayTimeMessage = "Please enter a valid HP value.";
  //     });
  //     return;
  //   }
  //   final currentHp = double.parse(_hpController.text);
  //   final fullHealth = double.parse(_selectedFoundation['health']);
  //   final decayHours = int.parse(_selectedFoundation['decay_hours']);
  //   final Duration decayTime =
  //       calculateDecayTime(currentHp, fullHealth, decayHours);

  //   setState(() {
  //     final hours = decayTime.inHours;
  //     final minutes = decayTime.inMinutes % 60;
  //     _decayTimeMessage = "Decay time: ${hours}h ${minutes}m";
  //   });
  // }

  // Duration calculateDecayTime(
  //     double currentHp, double fullHealth, int decayHours) {
  //   final double decayRate = fullHealth / (decayHours * 60.0);
  //   final double decayTimeLeft = currentHp / decayRate;
  //   return Duration(minutes: decayTimeLeft.round());
  // }

  // void _navigateToRaidToolsPage() {
  //   final fullHealth = double.parse(_selectedFoundation['health']);
  //   // Hide the keyboard
  //   FocusScope.of(context).unfocus();

  //   // Validate health input
  //   double enteredHealth = _hpController.text.isEmpty
  //       ? fullHealth
  //       : double.tryParse(_hpController.text) ?? fullHealth;
  //   double maxHealth = double.parse(_selectedFoundation['health']);

  //   if (enteredHealth > maxHealth) {
  //     // Show an alert dialog if the entered health is greater than the maximum allowed
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text("Invalid Health Value"),
  //           content: Text(
  //               "Please enter a valid health value that is less than or equal to $maxHealth."),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text("OK"),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Dismiss the dialog
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // Navigate if the health value is valid
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => RaidToolsPage(
  //           selectedFoundation: _selectedFoundation,
  //           health: enteredHealth,
  //         ),
  //       ),
  //     );
  //   }
  // }

  // Widget _buildCategorySelector() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: _categories.map((category) {
  //         return Padding(
  //           padding: const EdgeInsets.only(left: 6.0),
  //           child: ChoiceChip(
  //             checkmarkColor: Colors.white,
  //             selectedColor: const Color(0xFFCD412B),
  //             label: Text(
  //               category,
  //               style: TextStyle(
  //                   color: _selectedCategory == category
  //                       ? Colors.white
  //                       : Colors.black),
  //             ),
  //             selected: _selectedCategory == category,
  //             onSelected: (bool selected) {
  //               _filterFoundationsByCategory(category);
  //             },
  //           ),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   final double padding = size.width * 0.04; // 4% of screen width
  //   final double fontSize = size.width * 0.03;

  //   return GestureDetector(
  //     onTap: () {
  //       FocusScope.of(context).requestFocus(FocusNode());
  //     },
  //     child: Scaffold(
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.only(right: padding),
  //               child: _buildCategorySelector(),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(top: padding, bottom: padding),
  //               child: TextField(
  //                 controller: _hpController,
  //                 keyboardType:
  //                     const TextInputType.numberWithOptions(decimal: true),
  //                 inputFormatters: [
  //                   FilteringTextInputFormatter.allow(
  //                       RegExp(r'^\d+\.?\d{0,2}')),
  //                 ],
  //                 decoration: InputDecoration(
  //                   labelText: 'Current health',
  //                   labelStyle: const TextStyle(
  //                     color: Colors.black,
  //                   ), // Label color
  //                   filled:
  //                       true, // Fill color needs to be enabled for `fillColor` to work
  //                   fillColor:
  //                       Colors.white, // Background color of the text field
  //                   contentPadding: const EdgeInsets.all(
  //                       16), // Padding inside the text field
  //                   enabledBorder: OutlineInputBorder(
  //                     // Border style when text field is enabled
  //                     borderSide: const BorderSide(
  //                         color: Color(0xFFCD412B), width: 2.0),
  //                     borderRadius: BorderRadius.circular(8), // Rounded corners
  //                   ),
  //                   focusedBorder: OutlineInputBorder(
  //                     // Border style when text field is focused
  //                     borderSide: const BorderSide(
  //                         color: Color(0xFFCD412B), width: 2.0),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   errorBorder: OutlineInputBorder(
  //                     // Border style when text field has an error
  //                     borderSide: const BorderSide(
  //                         color: Color(0xFFCD412B), width: 2.0),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   focusedErrorBorder: OutlineInputBorder(
  //                     // Border style when text field has an error and is focused
  //                     borderSide: const BorderSide(
  //                         color: Color(0xFFCD412B), width: 2.0),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                 ),
  //                 onSubmitted: (value) {
  //                   _calculateDecayTime();
  //                   FocusScope.of(context).requestFocus(FocusNode());
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //               child: NotificationListener<ScrollNotification>(
  //                 onNotification: (ScrollNotification notification) {
  //                   // When user starts scrolling, unfocus any focused input fields (this hides the keyboard)
  //                   if (notification is UserScrollNotification &&
  //                       notification.direction != ScrollDirection.idle) {
  //                     FocusScope.of(context).unfocus();
  //                   }
  //                   return true; // Return true to indicate the notification is handled
  //                 },
  //                 child: GridView.builder(
  //                   gridDelegate:
  //                       const SliverGridDelegateWithFixedCrossAxisCount(
  //                     crossAxisCount: 2,
  //                     childAspectRatio: 3 / 2,
  //                   ),
  //                   itemCount: _filteredFoundations.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final foundation = _filteredFoundations[index];
  //                     final isSelected = _selectedFoundationIndex == index;
  //                     final item = _filteredFoundations[index];
  //                     return GestureDetector(
  //                       child: CustomRaidCard(
  //                         item: item,
  //                         isSelected: isSelected,
  //                       ),
  //                       onTap: () =>
  //                           _updateSelectedFoundation(foundation, index),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ),
  //             if (_decayTimeMessage.isNotEmpty)
  //               Padding(
  //                 padding: EdgeInsets.all(padding),
  //                 child: Text(
  //                   _decayTimeMessage,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, fontSize: fontSize),
  //                 ),
  //               ),
  //           ],
  //         ),
  //       ),
  //       floatingActionButton: _selectedFoundation != null
  //           ? FloatingActionButton(
  //               backgroundColor: const Color(0xFFCD412B),
  //               onPressed: _navigateToRaidToolsPage,
  //               child: const FaIcon(
  //                 FontAwesomeIcons.circleArrowRight,
  //                 color: Colors.white,
  //               ),
  //             )
  //           : null,
  //     ),
  //   );
  // }
