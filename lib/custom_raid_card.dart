import 'package:flutter/material.dart';

class CustomRaidCard extends StatelessWidget {
  final dynamic item;
  final bool isSelected;
  const CustomRaidCard(
      {super.key, required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.04;
    final double fontSize = size.width * 0.03;
    final double imageSize = size.width * 0.24;

    return Container(
      padding: EdgeInsets.all(padding),
      margin: EdgeInsets.all(padding / 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFCD412B) : Colors.grey,
        borderRadius: BorderRadius.circular(padding),
        boxShadow: [
          BoxShadow(
            color: isSelected ? Colors.red.shade300 : Colors.grey,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -25, // Adjust the position as needed
            top: -30, // Adjust the position as needed
            child: Image.asset(
              item['image'],
              width: imageSize, // Adjust the size as needed
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            // Use Positioned.fill to make the child fill the available space
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // Space out children
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center children horizontally
              children: <Widget>[
                const SizedBox(
                    height: 10), // Placeholder for spacing, adjust as needed
                // Spacer or SizedBox can be used here to push the text down
                Align(
                  alignment:
                      Alignment.center, // Align the text to the bottom center
                  child: Text(
                    item['name'],
                    textAlign: TextAlign.center, // Center align the text
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
