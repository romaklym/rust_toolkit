import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rust_toolkit/custom_card.dart';
import 'package:rust_toolkit/global_data.dart';
import 'package:rust_toolkit/item_details.dart';

class Crafting extends StatefulWidget {
  const Crafting({super.key});

  @override
  State<Crafting> createState() => _CraftingState();
}

class _CraftingState extends State<Crafting> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  String _selectedCategory = 'All'; // Default category
  List<String> _categories = ['All', 'Weapons', 'Tools', 'Items'];
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
    _scrollController.addListener(() {
      // Show the back to top button when scrolling down, otherwise hide it
      if (_scrollController.offset >= 400 && !_showBackToTopButton) {
        setState(() => _showBackToTopButton = true);
      } else if (_scrollController.offset < 400 && _showBackToTopButton) {
        setState(() => _showBackToTopButton = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _loadItems();
  // }

  Future<void> _loadItems() async {
    final globalData = GlobalData();
    if (globalData.getItems().isEmpty) {
      final String response = await rootBundle.loadString('assets/items.json');
      final data = await json.decode(response);
      final itemsWithFavorites = data
          .map((item) => {
                ...item,
                'isFavorited': false,
              })
          .toList();
      globalData.updateItems(itemsWithFavorites);
    }
    _items = globalData.getItems();

    // Dynamically extract categories from items
    final Set<String> categorySet = <String>{};
    for (var item in _items) {
      categorySet.add(item['category']);
    }

    // Always include "All" and sort the categories (if needed)
    final List<String> dynamicCategories = [
      'All',
      ...categorySet.toList()..sort()
    ];

    setState(() {
      _categories = dynamicCategories;
      _items = globalData.getItems();
      _filteredItems = _items;
    });
  }

  void _filterItems(String query) {
    List<dynamic> filtered = _items;
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((item) => item['category'] == _selectedCategory)
          .toList();
    }
    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        final nameLower = item['name'].toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
    }
    setState(() => _filteredItems = filtered);
  }

  void _toggleFavorite(dynamic item) {
    setState(() {
      item['isFavorited'] = !item['isFavorited'];
      GlobalData().updateItems(_items);
      // Sort items by isFavorited status, moving favorited items to the top
      _items.sort((a, b) {
        // Convert booleans to integers for comparison: true (favorited) items get higher priority
        int aValue = a['isFavorited'] ? 1 : 0;
        int bValue = b['isFavorited'] ? 1 : 0;
        return bValue.compareTo(aValue);
      });

      _filterItems(_searchController.text); // Reapply any active search filter
    });
  }

  Widget _buildCategorySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          return Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: ChoiceChip(
              checkmarkColor: Colors.white,
              selectedColor: Colors.deepPurple.shade300,
              label: Text(
                category,
                style: TextStyle(
                    color: _selectedCategory == category
                        ? Colors.white
                        : Colors.black),
              ),
              selected: _selectedCategory == category,
              onSelected: (bool selected) {
                setState(() {
                  _selectedCategory = category;
                  _filterItems(_searchController.text); // Refilter items
                });
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildCategorySelector(), // Category selector added here
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: const OutlineInputBorder(),
                  suffixIcon: _searchController.text.isEmpty
                      ? IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Implement search functionality if needed
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController
                                  .clear(); // Clear the text field content
                              _filterItems(
                                  ''); // Optionally reapply the filter if you want immediate UI update
                            });
                          },
                        ),
                ),
                onChanged: (value) {
                  setState(() {
                    _filterItems(value);
                  });
                },
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    // When user starts scrolling, unfocus any focused input fields (this hides the keyboard)
                    if (notification is UserScrollNotification &&
                        notification.direction != ScrollDirection.idle) {
                      FocusScope.of(context).unfocus();
                    }
                    return true; // Return true to indicate the notification is handled
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 24.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ItemDetailPage(item: item),
                          ));
                        },
                        child: CustomCard(
                          item: item,
                          onFavoriteToggle: _toggleFavorite,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _showBackToTopButton
            ? FloatingActionButton(
                backgroundColor: Colors.grey,
                onPressed: _scrollToTop,
                child: const FaIcon(
                  FontAwesomeIcons.arrowUp,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
