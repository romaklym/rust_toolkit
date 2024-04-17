class PlayerDetail {
  final String id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool positiveMatch;
  final bool isPrivate;
  final bool isOnline;

  PlayerDetail({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    required this.positiveMatch,
    required this.isPrivate,
    required this.isOnline,
  });

  factory PlayerDetail.fromJson(Map<String, dynamic> json) {
    var isOnline = false;
    if (json['relationships'] != null &&
        json['relationships']['servers'] != null &&
        json['relationships']['servers']['data'] != null &&
        json['relationships']['servers']['data'].isNotEmpty &&
        json['relationships']['servers']['data'][0]['meta'] != null) {
      isOnline = json['relationships']['servers']['data'][0]['meta']
              ['online'] ??
          false;
    }

    return PlayerDetail(
      id: json['id'],
      name: json['attributes']['name'],
      createdAt: json['attributes']['createdAt'] != null
          ? DateTime.parse(json['attributes']['createdAt'])
          : null,
      updatedAt: json['attributes']['updatedAt'] != null
          ? DateTime.parse(json['attributes']['updatedAt'])
          : null,
      positiveMatch: json['attributes']['positiveMatch'] ?? false,
      isPrivate: json['attributes']['private'] ?? false,
      isOnline: isOnline,
    );
  }
}
