import 'package:flutter/material.dart';

class DecayCustomCard extends StatelessWidget {
  final dynamic item;
  const DecayCustomCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFCD412B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade300,
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
              width: 120, // Adjust the size as needed
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
                    height: 40), // Placeholder for spacing, adjust as needed
                // Spacer or SizedBox can be used here to push the text down
                Align(
                  alignment: Alignment
                      .bottomCenter, // Align the text to the bottom center
                  child: Text(
                    item['name'],
                    textAlign: TextAlign.center, // Center align the text
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
