// ignore_for_file: Unknown word.

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rust_toolkit/players_details_model.dart'; // Ensure this model is set up to parse the JSON correctly

class PlayerDetailsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const PlayerDetailsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PlayerDetailsPageState createState() => _PlayerDetailsPageState();
}

class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  final TextEditingController _controller = TextEditingController();
  Future<PlayerDetail>? _futurePlayerDetail;

  void _searchPlayer() {
    final playerId = _controller.text;
    if (playerId.isNotEmpty) {
      setState(() {
        _futurePlayerDetail = fetchPlayerDetails(playerId);
      });
    }
  }

  Future<PlayerDetail> fetchPlayerDetails(String playerId) async {
    final response = await http.get(
      Uri.parse('https://api.battlemetrics.com/players/$playerId'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjBhZTgyZWU4NjAyOTcyNmIiLCJpYXQiOjE3MDk0ODU4NDAsIm5iZiI6MTcwOTQ4NTg0MCwiaXNzIjoiaHR0cHM6Ly93d3cuYmF0dGxlbWV0cmljcy5jb20iLCJzdWIiOiJ1cm46dXNlcjo4MzAwOTgifQ.Y72asg0DYxFiedM8QVIhj7-bYpvaubAGe-Yfeset0ls', // Use your actual access token
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return PlayerDetail.fromJson(json['data']);
    } else {
      throw Exception('Failed to load player details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Player Details",
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter Player ID',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchPlayer,
                ),
              ),
              onSubmitted: (_) => _searchPlayer(),
            ),
          ),
          Expanded(
            child: _futurePlayerDetail == null
                ? const Center(
                    child: Text('Please enter a player ID to search.'))
                : FutureBuilder<PlayerDetail>(
                    future: _futurePlayerDetail,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        final player = snapshot.data!;
                        return ListView(
                          children: [
                            ListTile(
                              title: const Text('Name'),
                              subtitle: Text(player.name),
                            ),
                            ListTile(
                              title: const Text('First Seen'),
                              subtitle: Text(player.createdAt != null
                                  ? DateFormat('yyyy-MM-dd – kk:mm')
                                      .format(player.createdAt!)
                                  : 'Unknown'),
                            ),
                            ListTile(
                              title: const Text('Last Seen'),
                              subtitle: Text(player.updatedAt != null
                                  ? DateFormat('yyyy-MM-dd – kk:mm')
                                      .format(player.updatedAt!)
                                  : 'Unknown'),
                            ),
                            ListTile(
                              title: const Text('Positive Match'),
                              subtitle:
                                  Text(player.positiveMatch ? 'Yes' : 'No'),
                            ),
                            ListTile(
                              title: const Text('Private Profile'),
                              subtitle: Text(player.isPrivate ? 'Yes' : 'No'),
                            ),
                            ListTile(
                              title: const Text('Online'),
                              subtitle: Text(player.isOnline ? 'Yes' : 'No'),
                            ),
                            // Add more fields as needed
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
