import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentService {
  late Razorpay _razorpay;
  BuildContext? context;

  PaymentService() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  // Initialize payment
  void openCheckout({
    required double amount,
    required String orderId,
    required String description,
    required BuildContext context,
  }) {
    this.context = context;

    var options = {
      'key': 'YOUR_RAZORPAY_KEY_ID', // Replace with your Razorpay key
      'amount': (amount * 100).toInt(), // Amount in paise
      'name': 'Home Service App',
      'description': description,
      'order_id': orderId,
      'prefill': {
        'contact': FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
        'email': FirebaseAuth.instance.currentUser?.email ?? '',
      },
      'theme': {
        'color': '#2196F3' // Blue theme
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Payment successful
    _savePaymentToFirestore(
      paymentId: response.paymentId!,
      status: 'success',
    );

    _showPaymentResult(
      title: 'Payment Successful!',
      message: 'Payment ID: ${response.paymentId}',
      isSuccess: true,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Payment failed
    _savePaymentToFirestore(
      paymentId: response.code.toString(),
      status: 'failed',
      errorMessage: response.message,
    );

    _showPaymentResult(
      title: 'Payment Failed',
      message: 'Error: ${response.message}',
      isSuccess: false,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // External wallet selected
    _showPaymentResult(
      title: 'External Wallet',
      message: 'Selected wallet: ${response.walletName}',
      isSuccess: false,
    );
  }

  void _savePaymentToFirestore({
    required String paymentId,
    required String status,
    String? errorMessage,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('payments').add({
        'userId': user.uid,
        'paymentId': paymentId,
        'status': status,
        'errorMessage': errorMessage,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  void _showPaymentResult({
    required String title,
    required String message,
    required bool isSuccess,
  }) {
    if (context != null) {
      showDialog(
        context: context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (isSuccess) {
                    // Navigate to booking confirmation or clear cart
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Create order on your backend (optional)
  static Future<String> createOrder({
    required double amount,
    required String currency,
  }) async {
    // In a real app, you would call your backend API to create an order
    // For now, returning a dummy order ID
    return 'order_${DateTime.now().millisecondsSinceEpoch}';
  }
}
