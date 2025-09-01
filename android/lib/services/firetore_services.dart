import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save booking to Firestore
  static Future<String> saveBooking(Map<String, dynamic> bookingData) async {
    try {
      final docRef = await _firestore.collection('bookings').add({
        ...bookingData,
        'userId': _auth.currentUser?.uid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  // Save custom post to Firestore
  static Future<String> saveCustomPost(Map<String, dynamic> postData) async {
    try {
      final docRef = await _firestore.collection('custom_posts').add({
        ...postData,
        'userId': _auth.currentUser?.uid,
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to save custom post: $e');
    }
  }

  // Add to cart
  static Future<void> addToCart({
    required String serviceName,
    required String subcategoryName,
    required int price,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .add({
        'serviceName': serviceName,
        'subcategoryName': subcategoryName,
        'price': price,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  // Remove from cart
  static Future<void> removeFromCart(String itemId) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .doc(itemId)
          .delete();
    }
  }

  // Get cart items
  static Stream<QuerySnapshot> getCartItems() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }

  // Get user bookings
  static Stream<QuerySnapshot> getUserBookings({String? status}) {
    final user = _auth.currentUser;
    if (user != null) {
      Query query = _firestore
          .collection('bookings')
          .where('userId', isEqualTo: user.uid)
          .orderBy('timestamp', descending: true);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots();
    }
    return const Stream.empty();
  }

  // Update booking status
  static Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    }
    return null;
  }

  // Save user profile
  static Future<void> saveUserProfile(Map<String, dynamic> profileData) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        ...profileData,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}