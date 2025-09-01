import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final double basePrice; // starting price
  final List<String> images;
  final Map<String, dynamic>? options; // e.g., {"Interior": 1499, "Exterior": 1999}

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.basePrice,
    required this.images,
    this.options,
  });

  factory Service.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Service(
      id: doc.id,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      categoryId: d['categoryId'] ?? '',
      basePrice: (d['basePrice'] ?? 0).toDouble(),
      images: List<String>.from(d['images'] ?? []),
      options: d['options'] != null ? Map<String, dynamic>.from(d['options']) : null,
    );
  }
}