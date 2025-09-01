class Category {
  final String id;
  final String name;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory Category.fromDoc(Map<String, dynamic> doc, String id) {
    return Category(
      id: id,
      name: doc['name'] ?? '',
      icon: doc['icon'] ?? '',
    );
  }
}