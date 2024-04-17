import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rust_toolkit/eco_raid_items_page.dart';

class EcoRaiding extends StatefulWidget {
  const EcoRaiding({super.key});

  @override
  State<EcoRaiding> createState() => _EcoRaidingState();
}

class _EcoRaidingState extends State<EcoRaiding> {
  List<dynamic> _foundations = [];
  List<dynamic> _filteredFoundations = [];
  dynamic _selectedFoundation;
  int _selectedFoundationIndex = -1;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  String _decayTimeMessage = '';
  final TextEditingController _hpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFoundations();
  }

  Future<void> _loadFoundations() async {
    final String response =
        await rootBundle.loadString('assets/eco_raiding.json');
    final List<dynamic> data = await json.decode(response);
    final Set<String> categorySet = <String>{};
    for (var foundation in data) {
      categorySet.add(foundation['category']);
    }
    final List<String> dynamicCategories = [
      'All',
      ...categorySet.toList()..sort()
    ];
    setState(() {
      _foundations = data;
      _filteredFoundations = _foundations;
      _categories = dynamicCategories;
    });
  }

  void _filterFoundationsByCategory(String selectedCategory) {
    List<dynamic> filtered;
    if (selectedCategory == 'All') {
      filtered = _foundations;
    } else {
      filtered = _foundations
          .where((item) => item['category'] == selectedCategory)
          .toList();
    }
    setState(() {
      _selectedCategory = selectedCategory;
      _filteredFoundations = filtered;
      // Removed the line that clears the _hpController to retain its value
    });
  }

  void _updateSelectedFoundation(dynamic foundation, int index) {
    setState(() {
      _selectedFoundation = foundation;
      _selectedFoundationIndex = index;
      _decayTimeMessage = '';
    });
  }

  bool _validateHpInput(String input) {
    final hpInput = double.tryParse(input);
    if (hpInput == null ||
        hpInput <= 0 ||
        _selectedFoundation == null ||
        hpInput > double.parse(_selectedFoundation['health'])) {
      return false;
    }
    return true;
  }

  void _calculateDecayTime() {
    if (!_validateHpInput(_hpController.text)) {
      setState(() {
        _decayTimeMessage = "Please enter a valid health value";
      });
      return;
    }

    final currentHp = double.parse(_hpController.text.isNotEmpty
        ? _hpController.text
        : _selectedFoundation['health']);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EcoRaidResultsPage(
        selectedFoundation: _selectedFoundation,
        enteredHealth: currentHp,
      ),
    ));
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}h ${minutes.toString().padLeft(2, '0')}m ${remainingSeconds.toString().padLeft(2, '0')}s';
  }

  Duration calculateDecayTime(
      double currentHp, double fullHealth, int decayHours) {
    final double decayRate = fullHealth / (decayHours * 60.0);
    final double decayTimeLeft = currentHp / decayRate;
    return Duration(minutes: decayTimeLeft.round());
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
              selectedColor: const Color(0xFFCD412B),
              label: Text(
                category,
                style: TextStyle(
                    color: _selectedCategory == category
                        ? Colors.white
                        : Colors.black),
              ),
              selected: _selectedCategory == category,
              onSelected: (bool selected) {
                _filterFoundationsByCategory(category);
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
        appBar: AppBar(
          title: const Text(
            "Eco-Raiding",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFCD412B),
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.circleChevronLeft,
                color: Colors.white), // Customize icon here
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildCategorySelector(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: TextField(
                  controller: _hpController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Current health',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ), // Label color
                    filled:
                        true, // Fill color needs to be enabled for `fillColor` to work
                    fillColor:
                        Colors.white, // Background color of the text field
                    contentPadding: const EdgeInsets.all(
                        16), // Padding inside the text field
                    enabledBorder: OutlineInputBorder(
                      // Border style when text field is enabled
                      borderSide: const BorderSide(
                          color: Color(0xFFCD412B), width: 2.0),
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Border style when text field is focused
                      borderSide: const BorderSide(
                          color: Color(0xFFCD412B), width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    errorBorder: OutlineInputBorder(
                      // Border style when text field has an error
                      borderSide: const BorderSide(
                          color: Color(0xFFCD412B), width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      // Border style when text field has an error and is focused
                      borderSide: const BorderSide(
                          color: Color(0xFFCD412B), width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (value) {
                    _calculateDecayTime();
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: _filteredFoundations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final foundation = _filteredFoundations[index];
                      final isSelected = _selectedFoundationIndex == index;
                      return Card(
                        color:
                            isSelected ? const Color(0xFFCD412B) : Colors.grey,
                        child: InkWell(
                          onTap: () =>
                              _updateSelectedFoundation(foundation, index),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                foundation['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (_decayTimeMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      _decayTimeMessage,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Color(0xFFCD412B)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: _selectedFoundation != null
            ? FloatingActionButton(
                backgroundColor: const Color(0xFFCD412B),
                onPressed: _calculateDecayTime,
                child: const FaIcon(
                  FontAwesomeIcons.circleArrowRight,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
