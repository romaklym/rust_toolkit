class Player {
  final String id;
  final String name;
  // Consider adding more fields as necessary, based on the API response

  Player({required this.id, required this.name});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['attributes']['name'],
      // Initialize more fields as necessary
    );
  }
}
