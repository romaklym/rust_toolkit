import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

class EcoRaidResultsPage extends StatelessWidget {
  final dynamic selectedFoundation;
  final double enteredHealth;

  const EcoRaidResultsPage({
    super.key,
    required this.selectedFoundation,
    required this.enteredHealth,
  });

  @override
  Widget build(BuildContext context) {
    final tools = selectedFoundation['eco_raiding'] as List<dynamic>? ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eco-Raid Results for ${selectedFoundation['name']}',
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
      body: ListView.builder(
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          final timeInSeconds = double.parse(tool['time_in_sec']);
          final adjustedTime = timeInSeconds *
              (enteredHealth / double.parse(selectedFoundation['health']));
          final formattedTime = formatTime(adjustedTime.toInt());

          return ListTile(
            leading: Image.asset(tool['tool'], width: 50, height: 50),
            title: Text('Quantity: ${tool['quantity']}'),
            subtitle: Text('Adjusted time: $formattedTime'),
          );
        },
      ),
    );
  }

  String formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours}h ${minutes}m ${remainingSeconds}s';
  }
}
