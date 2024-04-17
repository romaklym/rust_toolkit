import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RaidToolsPage extends StatefulWidget {
  final dynamic selectedFoundation;
  final double health;
  const RaidToolsPage(
      {super.key, required this.selectedFoundation, required this.health});

  @override
  State<RaidToolsPage> createState() => _RaidToolsPageState();
}

class _RaidToolsPageState extends State<RaidToolsPage> {
  String formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')} hours ${minutes.toString().padLeft(2, '0')} minutes ${remainingSeconds.toString().padLeft(2, '0')} seconds';
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> tools = widget.selectedFoundation['raiding'] ?? [];
    final double fullHealth =
        double.tryParse(widget.selectedFoundation['health']) ??
            0.0; // Ensure `fullHealth` is a double

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Raid Tools for ${widget.selectedFoundation['name']}',
          style: const TextStyle(
            fontSize: 16,
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Image.asset(widget.selectedFoundation['image']),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: tools.length,
              itemBuilder: (context, index) {
                final tool = tools[index];
                int originalQuantity =
                    int.tryParse(tool['quantity'].toString()) ??
                        0; // Ensure `quantity` is an int
                int newQuantity =
                    ((widget.health / fullHealth) * originalQuantity).round();
                return newQuantity != 0
                    ? ListTile(
                        leading: Image.asset(tool['tool']),
                        title: Text('Quantity: $newQuantity'),
                        subtitle: Text(
                            'Time needed: ${formatTime(int.tryParse(tools[index]['time_in_sec']?.toString() ?? '0') ?? 0)}'),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Health: ${widget.health.toInt()}',
                style: const TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
