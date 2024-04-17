import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final dynamic item;
  final Function onFavoriteToggle;
  const CustomCard(
      {super.key, required this.item, required this.onFavoriteToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.deepPurple,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            right: -28, // Adjust the position as needed
            top: -50, // Adjust the position as needed
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
                    height: 10), // Placeholder for spacing, adjust as needed
                // Spacer or SizedBox can be used here to push the text down
                Align(
                  alignment: Alignment
                      .bottomCenter, // Align the text to the bottom center
                  child: Column(
                    children: [
                      Text(
                        item['name'],
                        textAlign: TextAlign.center, // Center align the text
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                      // Row(
                      //   children: [
                      //     IconButton(
                      //       icon: const FaIcon(FontAwesomeIcons.squareMinus),
                      //       onPressed: () {},
                      //       iconSize: 15,
                      //       color: Colors.white,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {},
                      //       child: Container(
                      //         color: Colors
                      //             .transparent, // Makes the entire area clickable
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 16 / 2, vertical: 16 / 4),
                      //         child: const Text(
                      //           '3',
                      //           style: TextStyle(
                      //               fontSize: 16, color: Colors.white),
                      //         ),
                      //       ),
                      //     ),
                      //     IconButton(
                      //       icon: const FaIcon(FontAwesomeIcons.squarePlus),
                      //       onPressed: () {},
                      //       iconSize: 15,
                      //       color: Colors.white,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -15, // Padding from the top edge
            left: -15, // Padding from the left edge
            child: IconButton(
              icon: Icon(
                item['isFavorited'] ? Icons.favorite : Icons.favorite_border,
                color: item['isFavorited']
                    ? Colors.red
                    : Colors
                        .white, // Changed color to white for visibility against the background
              ),
              onPressed: () => onFavoriteToggle(item),
            ),
          ),
        ],
      ),
    );
  }
}
