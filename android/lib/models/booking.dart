class Booking {
  final String id;
  final String userId;
  final String serviceId;
  final String serviceName;
  final String status; // pending, confirmed, completed, canceled
  final DateTime scheduledAt;
  final double amount;
  final String address;
  final double lat;
  final double lng;

  Booking({
    required this.id,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.scheduledAt,
    required this.amount,
    required this.address,
    required this.lat,
    required this.lng,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'status': status,
    'scheduledAt': scheduledAt,
    'amount': amount,
    'address': address,
    'lat': lat,
    'lng': lng,
    'createdAt': DateTime.now(),
  };
}
