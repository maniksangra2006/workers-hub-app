class CustomPost {
  final String id;
  final String userId;
  final String description;
  final DateTime when;
  final String address;
  final double lat;
  final double lng;

  CustomPost({
    required this.id,
    required this.userId,
    required this.description,
    required this.when,
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'description': description,
    'when': when,
    'address': address,
    'lat': lat,
    'lng': lng,
    'createdAt': DateTime.now(),
  };
}
