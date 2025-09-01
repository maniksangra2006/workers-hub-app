import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.business,
                      size: 60,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Workers Hub',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              'Our Mission',
              'We are dedicated to providing exceptional services that make your life easier and more convenient. Our platform connects you with trusted service providers who deliver quality work at competitive prices.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'What We Do',
              'Our app offers a wide range of services including home cleaning, maintenance, repairs, and professional services. We carefully vet all our service providers to ensure you receive the best possible experience.',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Our Values',
              '• Quality: We never compromise on service quality\n'
                  '• Trust: All providers are verified and insured\n'
                  '• Convenience: Book services with just a few taps\n'
                  '• Support: 24/7 customer support for your peace of mind\n'
                  '• Innovation: Constantly improving our platform',
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Contact Information',
              'Have questions or need support? We\'re here to help!\n\n'
                  '📧 Email: maniksangra2006@gmail.com\n'
                  '📞 Phone: +91 9697682875\n'
                  '🕒 Hours: Monday - Friday, 9 AM - 6 PM\n'
                   ,
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '© 2025 Workers Hub. All rights reserved.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
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
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}