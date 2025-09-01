import 'package:flutter/material.dart';

class ReturnPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Policy'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Return & Refund Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: January 1, ${DateTime.now().year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              'Service Satisfaction Guarantee',
              'We stand behind the quality of services provided through our platform. If you\'re not completely satisfied with a service, we\'re here to make it right.',
            ),

            _buildSection(
              'Refund Eligibility',
              'You may be eligible for a refund if:\n'
                  '• Service was not provided as described\n'
                  '• Service provider failed to show up without notice\n'
                  '• Service quality was significantly below standards\n'
                  '• Service was cancelled by the provider last minute\n'
                  '• Technical issues prevented service completion',
            ),

            _buildSection(
              'Refund Process',
              '1. Contact our support team within 24 hours of service completion\n'
                  '2. Provide details about the issue and any supporting evidence\n'
                  '3. Our team will review your case within 48 hours\n'
                  '4. If approved, refunds are processed within 5-7 business days\n'
                  '5. Refunds are issued to the original payment method',
            ),

            _buildSection(
              'Partial Refunds',
              'In some cases, we may offer partial refunds for:\n'
                  '• Services that were partially completed\n'
                  '• Minor issues that didn\'t significantly impact service quality\n'
                  '• Delayed services that were eventually completed satisfactorily',
            ),

            _buildSection(
              'Non-Refundable Situations',
              'Refunds may not be available for:\n'
                  '• Services completed to your satisfaction\n'
                  '• Changes in your requirements after service booking\n'
                  '• Issues caused by factors outside service provider\'s control\n'
                  '• Services cancelled by you with less than 4 hours notice\n'
                  '• Disputes about service pricing that were agreed upon beforehand',
            ),

            _buildSection(
              'Cancellation Policy',
              '• Free cancellation up to 4 hours before scheduled service\n'
                  '• Cancellations within 4 hours may incur a 25% fee\n'
                  '• No-show by customer results in full charge\n'
                  '• Emergency cancellations will be reviewed case by case',
            ),

            _buildSection(
              'Dispute Resolution',
              'If you have concerns about a service:\n'
                  '1. First, try to resolve the issue directly with the service provider\n'
                  '2. If unresolved, contact our support team immediately\n'
                  '3. We will mediate between you and the provider\n'
                  '4. Our decision on refunds and disputes is final',
            ),

            _buildSection(
              'How to Request a Refund',
              'To request a refund:\n'
                  '• Email: support@yourapp.com\n'
                  '• Phone: +1 (555) 123-4567\n'
                  '• In-app: Use the "Report Issue" feature\n\n'
                  'Please include:\n'
                  '• Booking reference number\n'
                  '• Date and time of service\n'
                  '• Detailed description of the issue\n'
                  '• Photos or videos if applicable',
            ),

            _buildSection(
              'Processing Time',
              '• Initial response: Within 24 hours\n'
                  '• Investigation: 2-5 business days\n'
                  '• Refund processing: 5-7 business days\n'
                  '• Bank processing: Additional 3-5 business days',
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Need Help?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Our customer support team is available 24/7 to assist you with any questions about our return policy or to help process your refund request.',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _contactSupport(context),
                icon: const Icon(Icons.support_agent),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _contactSupport(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('support@yourapp.com'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('+1 (555) 123-4567'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue, size: 20),
                SizedBox(width: 8),
                Text('Available 24/7'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}