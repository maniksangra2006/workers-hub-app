import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Center(child: Text('Not signed in'));
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        final pending = docs.where((d) => d['status'] == 'pending').toList();
        final confirmed = docs.where((d) => d['status'] == 'confirmed').toList();
        final completed = docs.where((d) => d['status'] == 'completed').toList();

        return DefaultTabController(
          length: 3,
          child: Column(children: [
            const TabBar(tabs: [Tab(text: 'Pending'), Tab(text: 'Present'), Tab(text: 'Completed')]),
            Expanded(
              child: TabBarView(children: [
                _list(pending),
                _list(confirmed),
                _list(completed),
              ]),
            )
          ]),
        );
      },
    );
  }

  Widget _list(List<QueryDocumentSnapshot<Map<String, dynamic>>> items) {
    if (items.isEmpty) return const Center(child: Text('No items'));
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 0),
      itemBuilder: (c, i) {
        final d = items[i].data();
        return ListTile(
          leading: const Icon(Icons.home_repair_service_outlined),
          title: Text(d['serviceName'] ?? ''),
          subtitle: Text('Status: ${d['status']} • When: ${d['scheduledAt'].toDate()}'),
          trailing: Text('₹${(d['amount'] as num).toString()}'),
        );
      },
    );
  }
}
