// ignore_for_file: non_constant_identifier_names

class Item {
  final String name;
  final String image;
  final String description;
  final String category;
  final List<Map<String, dynamic>> info;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> research;
  final List<Map<String, dynamic>> raiding;
  final List<Map<String, dynamic>> recycle;
  final List<Map<String, dynamic>> loot;
  final List<Map<String, dynamic>> recycleAll;

  Item({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.info,
    required this.ingredients,
    required this.research,
    required this.recycle,
    required this.raiding,
    required this.loot,
    required this.recycleAll,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        name: json['name'],
        image: json['image'],
        description: json['description'],
        category: json['category'],
        info: List<Map<String, dynamic>>.from(json['info']),
        ingredients: List<Map<String, dynamic>>.from(json['ingredients']),
        research: List<Map<String, dynamic>>.from(json['research']),
        raiding: List<Map<String, dynamic>>.from(json['raiding']),
        recycle: List<Map<String, dynamic>>.from(json['recycle']),
        loot: List<Map<String, dynamic>>.from(json['loot']),
        recycleAll: List<Map<String, dynamic>>.from(json['recycle_all']));
  }
}
