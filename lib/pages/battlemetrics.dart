// ignore_for_file: library_private_types_in_public_api, use_super_parameters, avoid_print
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rust_toolkit/player_model.dart';
import 'package:rust_toolkit/server_model.dart';

class BattleMetrics extends StatefulWidget {
  const BattleMetrics({super.key});

  @override
  State<BattleMetrics> createState() => _BattleMetricsState();
}

class _BattleMetricsState extends State<BattleMetrics> {
  final ScrollController _scrollController = ScrollController();

  final List<dynamic> _servers = [];
  String? _nextPageUrl;

  Future<void> fetchServers({String? nextPageUrl}) async {
    final url = nextPageUrl ??
        'https://api.battlemetrics.com/servers?filter[game]=rust&sort=rank';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjM1NjJlNTdjOGQxZmM4MmUiLCJpYXQiOjE3MDk0MDY5NTEsIm5iZiI6MTcwOTQwNjk1MSwiaXNzIjoiaHR0cHM6Ly93d3cuYmF0dGxlbWV0cmljcy5jb20iLCJzdWIiOiJ1cm46dXNlcjo4MzAwOTgifQ.wiNdQqP3qgO8QliVGcuiUTjExdWgZ_ULHshrhbFoemE'
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> serversData = data['data'];
      final List<Server> fetchedServers =
          serversData.map((json) => Server.fromJson(json)).toList();

      setState(() {
        _servers.addAll(fetchedServers);
        _nextPageUrl = data['links']['next'];
      });
    } else {
      AlertDialog(
          title: Text(
              'Failed to load servers with status code: ${response.statusCode}'));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchServers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _nextPageUrl != null) {
        fetchServers(nextPageUrl: _nextPageUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.circleChevronLeft,
              color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "BattleMetrics - Rust Servers",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFCD412B),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _servers.length,
        itemBuilder: (context, index) {
          final server = _servers[index];
          return ListTile(
            title: Text(server.name),
            subtitle: Text(
                'Players: ${server.players}/${server.maxPlayers}, serverId: ${server.id}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServerDetailsPage(serverId: server.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class ServerDetailsPage extends StatefulWidget {
  final String serverId;

  const ServerDetailsPage({Key? key, required this.serverId}) : super(key: key);

  @override
  _ServerDetailsPageState createState() => _ServerDetailsPageState();
}

class _ServerDetailsPageState extends State<ServerDetailsPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Player> _players = [];
  String? _nextPageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPlayers();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_nextPageUrl != null &&
        !_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      fetchPlayers(nextPageUrl: _nextPageUrl);
    }
  }

  Future<void> fetchPlayers({String? nextPageUrl}) async {
    if (_isLoading) return;
    _isLoading = true;

    final url = nextPageUrl ??
        'https://api.battlemetrics.com/players?filter[servers]=${widget.serverId}&page[size]=100'; // Adjust page[size] as needed
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbiI6IjM1NjJlNTdjOGQxZmM4MmUiLCJpYXQiOjE3MDk0MDY5NTEsIm5iZiI6MTcwOTQwNjk1MSwiaXNzIjoiaHR0cHM6Ly93d3cuYmF0dGxlbWV0cmljcy5jb20iLCJzdWIiOiJ1cm46dXNlcjo4MzAwOTgifQ.wiNdQqP3qgO8QliVGcuiUTjExdWgZ_ULHshrhbFoemE', // Use your actual token here
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Player> newPlayers =
          List<Player>.from(data['data'].map((x) => Player.fromJson(x)));

      setState(() {
        _players.addAll(newPlayers);
        _nextPageUrl =
            data['links']['next']; // Update the next page URL for pagination
      });
    } else {
      // Handle error
      print('Failed to load players');
    }

    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serverId),
        backgroundColor: const Color(0xFFCD412B),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _players.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_players[index].name),
            subtitle: Text(_players[index].id),
            // Display additional player details here
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
