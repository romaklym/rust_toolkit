// ignore_for_file: non_constant_identifier_names

class RaidItem {
  final String name;
  final String image;
  final String health;
  final String category;
  final String decay_hours;
  final List<Map<String, dynamic>> raiding;
  final List<Map<String, dynamic>> eco_raiding_hard_side;
  final List<Map<String, dynamic>> eco_raiding_soft_side;

  RaidItem({
    required this.name,
    required this.image,
    required this.health,
    required this.category,
    required this.decay_hours,
    required this.raiding,
    required this.eco_raiding_hard_side,
    required this.eco_raiding_soft_side,
  });

  factory RaidItem.fromJson(Map<String, dynamic> json) {
    return RaidItem(
      name: json['name'],
      image: json['image'],
      health: json['health'],
      category: json['category'],
      decay_hours: json['decay_hours'],
      raiding: List<Map<String, dynamic>>.from(json['raiding']),
      eco_raiding_hard_side:
          List<Map<String, dynamic>>.from(json['eco_raiding_hard_side']),
      eco_raiding_soft_side:
          List<Map<String, dynamic>>.from(json['eco_raiding_soft_side']),
    );
  }
}
