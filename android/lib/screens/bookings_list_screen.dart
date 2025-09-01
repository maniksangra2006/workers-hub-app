import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'qr_payment_screen.dart';

class BookingsListScreen extends StatefulWidget {
  @override
  _BookingsListScreenState createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends State<BookingsListScreen> {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: userId == null
          ? Center(child: Text('Please login to view bookings'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  SizedBox(height: 16),
                  Text('Error loading bookings'),
                  TextButton(
                    onPressed: () => setState(() {}),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No Bookings Yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Book a service to see it here',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final booking = doc.data() as Map<String, dynamic>;

              return _buildBookingCard(doc.id, booking);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(String docId, Map<String, dynamic> booking) {
    final status = booking['status'] ?? 'pending';
    final scheduledDateTime = booking['scheduledDateTime'] as Timestamp?;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking['subcategoryName'] ?? 'Service',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            SizedBox(height: 8),

            Text(
              booking['serviceName'] ?? '',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            SizedBox(height: 12),

            // Booking details
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[500]),
                SizedBox(width: 8),
                Text(booking['customerName'] ?? ''),
              ],
            ),
            SizedBox(height: 4),

            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[500]),
                SizedBox(width: 8),
                Text(booking['customerPhone'] ?? ''),
              ],
            ),
            SizedBox(height: 4),

            if (scheduledDateTime != null)
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                  SizedBox(width: 8),
                  Text(DateFormat('dd MMM yyyy, hh:mm a').format(scheduledDateTime.toDate())),
                ],
              ),
            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${booking['price']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                Text(
                  'ID: ${booking['bookingId'] ?? docId.substring(0, 8).toUpperCase()}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),

            // Action buttons based on status
            SizedBox(height: 12),
            _buildActionButtons(docId, booking, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        displayText = 'Pending';
        break;
      case 'completed':
        color = Colors.blue;
        displayText = 'Completed';
        break;
      case 'payment_pending':
        color = Colors.red;
        displayText = 'Payment Due';
        break;
      case 'paid':
        color = Colors.green;
        displayText = 'Paid';
        break;
      default:
        color = Colors.grey;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButtons(String docId, Map<String, dynamic> booking, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _markAsCompleted(docId),
                child: Text('Mark as Done'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _cancelBooking(docId),
                child: Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        );

      case 'completed':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _proceedToPayment(docId, booking),
            icon: Icon(Icons.qr_code),
            label: Text('Show QR for Payment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        );

      case 'payment_pending':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _proceedToPayment(docId, booking),
            icon: Icon(Icons.qr_code),
            label: Text('Show Payment QR'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
          ),
        );

      case 'paid':
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green[600], size: 20),
              SizedBox(width: 8),
              Text(
                'Payment Completed',
                style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );

      default:
        return SizedBox();
    }
  }

  Future<void> _markAsCompleted(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docId)
          .update({
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service marked as completed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cancelBooking(String docId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Yes, Cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('bookings')
            .doc(docId)
            .update({
          'status': 'cancelled',
          'updatedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking cancelled successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error cancelling booking: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _proceedToPayment(String docId, Map<String, dynamic> booking) async {
    try {
      // Update status to payment_pending
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(docId)
          .update({
        'status': 'payment_pending',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Navigate to QR payment screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QRPaymentScreen(
            bookingId: docId,
            booking: booking,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error proceeding to payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
