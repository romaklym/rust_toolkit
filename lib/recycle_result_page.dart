// // recycle_results_page.dart
// // ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rust_toolkit/recyclable_model.dart';

class RecycleResultsPage extends StatelessWidget {
  final List<RecyclableItem> recyclableItems;

  const RecycleResultsPage({super.key, required this.recyclableItems});

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
          "Recycled Results",
          style: TextStyle(
            fontSize: fontSize * 1.4,
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
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: ListView.builder(
          itemCount: recyclableItems.length,
          itemBuilder: (context, index) {
            var item = recyclableItems[index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      // backgroundColor: Colors.deepPurple.shade100,
    );
  }
}
