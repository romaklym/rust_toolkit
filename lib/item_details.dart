// ignore_for_file: library_private_types_in_public_api, use_super_parameters, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemDetailPage extends StatefulWidget {
  final dynamic item;

  const ItemDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> ingredientWidgets =
        widget.item['ingredients'].map<Widget>((ingredient) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(ingredient['image'], width: 50),
            const SizedBox(width: 10), // Added spacing between image and text
            Expanded(
                child: Text('x${ingredient['quantity'] * quantity}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ))),
          ],
        ),
      );
    }).toList();

    List<Widget> researchWidgets =
        widget.item['research'].map<Widget>((research) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Image.asset(research['image_tool'], width: 50),
            const SizedBox(width: 25),
            Image.asset(research['image'], width: 50),
            const SizedBox(width: 10),
            Expanded(
                child: Text('x${research['quantity']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ))),
          ],
        ),
      );
    }).toList();

    List<Widget> infoWidgets = widget.item['info'].map<Widget>((info) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Text(
              '${info['information']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Text('- ${info['count']} minutes',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ))),
          ],
        ),
      );
    }).toList();

    List<Widget> recycleWidgets = widget.item['recycle'].map<Widget>((recycle) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Image.asset(recycle['image'], width: 50),
            const SizedBox(width: 10),
            Expanded(
                child: Text('x${recycle['quantity']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ))),
          ],
        ),
      );
    }).toList();

    List<Widget> lootWidgets = widget.item['loot'].map<Widget>((loot) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: <Widget>[
            Text(loot['container'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                )),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                '-  ${loot['chance']}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.item['name'],
            style: const TextStyle(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(widget.item['image'], fit: BoxFit.cover),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    width: 150, // Make TextField smaller
                    child: TextField(
                      style: const TextStyle(
                        color: Colors
                            .white, // This changes the text color inside the TextField
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white), // Custom red color
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        // Label style
                        labelStyle: TextStyle(
                          color: Colors
                              .white, // Label color when TextField is not focused
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      ),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          quantity = int.tryParse(value) ?? 1;
                        });
                      },
                    )),
                const SizedBox(height: 20),
                const Text(
                  "Craft",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ), // Spacing before ingredients list
                ...ingredientWidgets,
                const SizedBox(height: 20),
                const Text(
                  "Research",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...researchWidgets,
                const SizedBox(height: 20),
                const Text(
                  "Recycle",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...recycleWidgets,
                const SizedBox(height: 20),
                const Text(
                  "Info",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...infoWidgets,
                const SizedBox(height: 20),
                const Text(
                  "Loot",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...lootWidgets,
              ],
            ),
          ),
        ),
        backgroundColor: const Color(0xFFCD412B));
  }
}
