class ConstructionItem {
  final String name;
  final String image;
  final String description;
  final String category;
  final int decayTimer; // in hours
  final int health;

  ConstructionItem({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.decayTimer,
    required this.health,
  });

  factory ConstructionItem.fromJson(Map<String, dynamic> json) {
    return ConstructionItem(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      decayTimer: int.parse(json['decay_timer']),
      health: int.parse(json['health']),
    );
  }
}
