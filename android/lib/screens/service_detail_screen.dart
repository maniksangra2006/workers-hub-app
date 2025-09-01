import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;
  final List<Map<String, dynamic>> subcategories;

  ServiceDetailScreen({
    required this.serviceName,
    required this.subcategories,
  });

  Future<void> addToCart(BuildContext context, String serviceName, String subcategoryName, int price) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login to add items to cart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Check if item already exists in cart
      final existingItem = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .where('serviceName', isEqualTo: serviceName)
          .where('subcategoryName', isEqualTo: subcategoryName)
          .get();

      if (existingItem.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item already in cart!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Add to cart
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .add({
        'serviceName': serviceName,
        'subcategoryName': subcategoryName,
        'price': price,
        'addedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'VIEW CART',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to cart (assuming it's in bottom navigation)
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Service Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Column(
              children: [
                Icon(Icons.home_repair_service, size: 60,
                    color: Colors.blue[600]),
                SizedBox(height: 12),
                Text(
                  serviceName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Professional ${serviceName.toLowerCase()} services',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Subcategories List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Service info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subcategory['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Professional service with quality guarantee',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${subcategory['price']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  addToCart(
                                    context,
                                    serviceName,
                                    subcategory['name'],
                                    subcategory['price'],
                                  );
                                },
                                icon: Icon(Icons.shopping_cart_outlined),
                                label: Text('Add to Cart'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue[600],
                                  side: BorderSide(color: Colors.blue[600]!),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookingScreen(
                                        serviceName: serviceName,
                                        subcategoryName: subcategory['name'],
                                        price: subcategory['price'],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.calendar_today),
                                label: Text('Book Now'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}