import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/models.dart';
import 'service_detail_screen.dart';

class ServiceListScreen extends StatelessWidget {
  final String? categoryId;
  final String title;
  final String? query;

  const ServiceListScreen.category({super.key, required this.categoryId, required this.title}) : query = null;
  const ServiceListScreen.search({super.key, required this.query})
      : categoryId = null,
        title = 'Search Results';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<Service>>(
        future: _load(),
        builder: (c, s) {
          if (!s.hasData) return const Center(child: CircularProgressIndicator());
          final list = s.data!;
          if (list.isEmpty) return const Center(child: Text('No services found'));
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (c, i) {
              final sv = list[i];
              return ListTile(
                title: Text(sv.name),
                subtitle: Text('Starts from ₹${sv.basePrice.toStringAsFixed(0)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: sv))),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Service>> _load() async {
    if (categoryId != null) {
      return FirestoreService.instance.getServicesByCategory(categoryId!);
    }
// very basic search by name contains (client-side demo)
    final all = await FirestoreService.instance.getServicesByCategory('ALL');
    if (query == null || query!.isEmpty) return all;
    return all.where((s) => s.name.toLowerCase().contains(query!.toLowerCase())).toList();
  }
}