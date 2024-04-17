// recycle_calculator.dart
// ignore_for_file: use_super_parameters, l_private_types_in_public_api, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rust_toolkit/recyclable_model.dart';
import 'package:rust_toolkit/recycle_raw_result_page.dart';
import 'package:rust_toolkit/recycle_result_page.dart';
import 'item_model.dart'; // Ensure this is the correct path to your Item model

class RecycleCalculatorPage extends StatefulWidget {
  const RecycleCalculatorPage({Key? key}) : super(key: key);

  @override
  _RecycleCalculatorPageState createState() => _RecycleCalculatorPageState();
}

class _RecycleCalculatorPageState extends State<RecycleCalculatorPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Item> _allItems = [];
  List<Item> _searchResults = [];
  final Map<Item, int> _itemsToRecycle = {};
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final String data = await rootBundle.loadString('assets/recycle.json');
    final List<dynamic> jsonData = json.decode(data);

    setState(() {
      _allItems = jsonData.map((item) => Item.fromJson(item)).toList();
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

  void _addItemToRecycle(Item item) {
    if (!_itemsToRecycle.containsKey(item)) {
      _itemsToRecycle[item] = 1;
    } else {
      _itemsToRecycle[item] = _itemsToRecycle[item]! + 1;
    }

    setState(() {});
  }

  void _removeItemFromRecycle(Item item) {
    if (_itemsToRecycle.containsKey(item) && _itemsToRecycle[item]! > 1) {
      _itemsToRecycle[item] = _itemsToRecycle[item]! - 1;
    } else {
      _itemsToRecycle.remove(item);
    }

    setState(() {});
  }

  void _calculateRecyclables() {
    List<RecyclableItem> recyclableItems = [];

    _itemsToRecycle.forEach((item, quantity) {
      for (var component in item.recycle) {
        final String image = component['image'];
        final String name = component['name'];
        final double convQuantity = component['quantity'];
        final int count = convQuantity.toInt() * quantity;

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

  void _calculateRawMaterialsRecyclables() {
    List<RecyclableItem> recyclableItems = [];

    _itemsToRecycle.forEach((item, quantity) {
      for (var component in item.recycleAll) {
        final String image = component['image'];
        final String name = component['name'];
        final double convQuantity = component['quantity'];
        final int count = convQuantity.toInt() * quantity;

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
          RecycleRawMaterialsResults(recyclableItems: recyclableItems),
    ));
  }

  void _showEditQuantityDialog(Item item, int currentQuantity) {
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

  void _updateItemQuantity(Item item, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        _itemsToRecycle[item] = newQuantity;
      });
    } else {
      _removeItemFromRecycle(item);
    }
  }

  Widget _buildRecycleList() {
    final double bottomPadding = _itemsToRecycle.isNotEmpty ? 76.0 : 20.0;
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    return ListView.builder(
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: _itemsToRecycle.length, // Define the item count
      itemBuilder: (context, index) {
        final entry = _itemsToRecycle.entries.elementAt(index);
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
    final double bottomPadding = _itemsToRecycle.isNotEmpty ? 76.0 : 20.0;
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
            _itemsToRecycle.containsKey(item) ? _itemsToRecycle[item]! : 0;

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
        floatingActionButton: _itemsToRecycle.isNotEmpty
            ? SpeedDial(
                icon: FontAwesomeIcons.arrowRight,
                iconTheme: IconThemeData(color: Colors.white, size: iconSize),
                activeIcon: FontAwesomeIcons.xmark,
                backgroundColor: Colors.deepPurple.shade300,
                spaceBetweenChildren: 0.5,
                overlayOpacity: 0.4,
                children: [
                  SpeedDialChild(
                    child: const FaIcon(FontAwesomeIcons.recycle,
                        color: Colors.deepPurple),
                    label: 'Recycle',
                    labelStyle: TextStyle(color: Colors.deepPurple.shade500),
                    onTap: _calculateRecyclables,
                  ),
                  SpeedDialChild(
                    child: const FaIcon(FontAwesomeIcons.barsStaggered,
                        color: Colors.deepPurple),
                    label: 'Recycle to Raw Materials',
                    labelStyle: TextStyle(color: Colors.deepPurple.shade500),
                    onTap: _calculateRawMaterialsRecyclables,
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
