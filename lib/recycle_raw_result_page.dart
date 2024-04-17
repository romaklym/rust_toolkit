// // recycle_results_page.dart
// // ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rust_toolkit/recyclable_model.dart';

class RecycleRawMaterialsResults extends StatelessWidget {
  final List<RecyclableItem> recyclableItems;

  const RecycleRawMaterialsResults({super.key, required this.recyclableItems});

  String formatNumber(String numberString) {
    final number = int.tryParse(numberString) ??
        0; // Convert the string to an int, defaulting to 0 if conversion fails
    final formatter = NumberFormat(
        '#,##0', 'en_US'); // Use #,##0 for space as thousand separator
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04; // 4% of screen width
    final double iconSize = size.width * 0.06; // 6% of screen width
    final double fontSize = size.width * 0.04; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recycled Raw Materials Results",
          style: TextStyle(
            fontSize: fontSize * 1.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade300,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.circleChevronLeft,
              color: Colors.white), // Customize icon here
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: ListView.builder(
                itemCount: recyclableItems.length,
                itemBuilder: (context, index) {
                  var item = recyclableItems[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        item.image,
                        width: iconSize * 2,
                      ),
                      Text(
                        item.name,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatNumber('${item.quantity}'),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: fontSize * 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: Text(
              "* Please note that there may be discrepancies in the results, as certain items offer a 50% chance of success upon recycling.",
              style: TextStyle(
                fontSize: fontSize * 0.75, // Adjust the font size as needed
                color: Colors.black54, // Adjust the text color as needed
              ),
              textAlign: TextAlign.center, // Center align text
            ),
          ),
        ],
      ),
      // backgroundColor: Colors.deepPurple.shade100,
    );
  }
}
