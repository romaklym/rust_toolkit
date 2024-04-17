class Server {
  final String id;
  final String name;
  final String ip;
  final int players;
  final int maxPlayers;

  Server({
    required this.id,
    required this.name,
    required this.ip,
    required this.players,
    required this.maxPlayers,
  });

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      id: json['id'],
      name: json['attributes']['name'],
      ip: json['attributes']['ip'],
      players: json['attributes']['players'],
      maxPlayers: json['attributes']['maxPlayers'],
    );
  }
}
