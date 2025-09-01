import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, installing, or using this mobile application, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our app.',
            ),

            _buildSection(
              '2. Use of the App',
              'You may use our app for lawful purposes only. You agree not to use the app:\n'
                  '• In any way that violates applicable laws or regulations\n'
                  '• To transmit or send unsolicited commercial communications\n'
                  '• To impersonate any person or entity\n'
                  '• To upload malicious code or harmful content',
            ),

            _buildSection(
              '3. User Accounts',
              'To access certain features, you may need to create an account. You are responsible for:\n'
                  '• Maintaining the confidentiality of your account credentials\n'
                  '• All activities that occur under your account\n'
                  '• Notifying us immediately of any unauthorized use\n'
                  '• Providing accurate and complete information',
            ),

            _buildSection(
              '4. Services',
              'Our app connects you with service providers. We act as a platform and are not directly responsible for the services provided by third parties. However, we strive to ensure quality by vetting our service providers.',
            ),

            _buildSection(
              '5. Payments',
              'All payments are processed securely through our platform. By making a payment, you agree to our pricing and payment terms. Refunds are handled according to our Return Policy.',
            ),

            _buildSection(
              '6. Privacy',
              'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.',
            ),

            _buildSection(
              '7. Intellectual Property',
              'The app and its content are protected by copyright, trademark, and other intellectual property laws. You may not reproduce, distribute, or create derivative works without our written permission.',
            ),

            _buildSection(
              '8. Limitation of Liability',
              'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the app.',
            ),

            _buildSection(
              '9. Termination',
              'We may terminate or suspend your account and access to the app at our sole discretion, without prior notice, for conduct that violates these Terms.',
            ),

            _buildSection(
              '10. Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify users of significant changes via the app or email. Continued use after changes constitutes acceptance.',
            ),

            _buildSection(
              '11. Contact Us',
              'If you have any questions about these Terms, please contact us at:\n\n'
                  'Email: legal@yourapp.com\n'
                  'Phone: +1 (555) 123-4567\n'
                  'Address: 123 Business St, City, State 12345',
            ),

            const SizedBox(height: 32),
            Center(
              child: Text(
                'By using this app, you acknowledge that you have read and understood these Terms and Conditions.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
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
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}