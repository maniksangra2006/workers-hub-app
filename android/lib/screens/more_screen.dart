import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the external About Us screen
import 'about_us_screen.dart'; // Adjust the path as needed

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue[600],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      user?.email ?? 'Guest User',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: () => _navigateToProfile(context),
                  ),
                ],
              ),
            ),

            // Account Section
            _buildSection(context, 'Account', [
              _buildListItem(context, 'My Posts', Icons.post_add_outlined, () => _navigateToMyPosts(context)),
              _buildListItem(context, 'Refer and Earn', Icons.share_outlined, () => _navigateToReferEarn(context)),
              _buildListItem(context, 'Settings', Icons.settings_outlined, () => _navigateToSettings(context)),
            ]),

            // Support Section
            _buildSection(context, 'Support', [
              _buildListItem(context, 'About Us', Icons.info_outline, () => _navigateToAboutUs(context)),
              _buildListItem(context, 'Terms and Conditions', Icons.description_outlined, () => _navigateToTerms(context)),
              _buildListItem(context, 'Privacy Policy', Icons.privacy_tip_outlined, () => _navigateToPrivacyPolicy(context)),
              _buildListItem(context, 'Return Policy', Icons.policy_outlined, () => _navigateToReturnPolicy(context)),
            ]),

            // Account Actions Section
            _buildSection(context, 'Account', [
              _buildListItem(context, 'Logout', Icons.logout, () => _showLogoutDialog(context), textColor: Colors.red),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, String title, IconData icon, VoidCallback onTap, {Color? textColor}) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? Colors.blue[600]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.black87,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Navigation functions
  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileScreen()),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SettingsScreen()),
    );
  }

  void _navigateToMyPosts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MyPostsScreen()),
    );
  }

  void _navigateToAboutUs(BuildContext context) {
    // Navigate to the external about_us_screen.dart
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AboutUsScreen()),
    );
  }

  void _navigateToTerms(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TermsConditionsScreen()),
    );
  }

  void _navigateToReturnPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReturnPolicyScreen()),
    );
  }

  void _navigateToPrivacyPolicy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PrivacyPolicyScreen()),
    );
  }

  void _navigateToReferEarn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReferEarnScreen()),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                Navigator.of(context).pop();
                await FirebaseAuth.instance.signOut();
                // Navigate to login screen or handle logout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// Settings Screen
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() => _isDarkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Dark mode ${value ? 'enabled' : 'disabled'}')),
              );
            },
            secondary: Icon(_isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.blue[600]),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive app notifications'),
            value: _notificationsEnabled,
            onChanged: (value) => setState(() => _notificationsEnabled = value),
            secondary: Icon(Icons.notifications, color: Colors.blue[600]),
          ),
        ],
      ),
    );
  }
}

// My Posts Screen
class MyPostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: userId == null
          ? const Center(child: Text('Please login to view your posts'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text('Error loading posts', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.post_add_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No Posts Yet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Text('You haven\'t created any posts yet.', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final post = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(post['title'] ?? 'Untitled Post'),
                  subtitle: Text(post['description'] ?? ''),
                  trailing: Text(_formatDate(post['createdAt'])),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unknown';
    try {
      final date = timestamp is Timestamp ? timestamp.toDate() : DateTime.parse(timestamp.toString());
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) return '${difference.inDays}d ago';
      if (difference.inHours > 0) return '${difference.inHours}h ago';
      if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Unknown';
    }
  }
}

// Refer and Earn Screen
class ReferEarnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final referralCode = user?.uid?.substring(0, 8).toUpperCase() ?? 'GUEST123';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Refer and Earn'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.card_giftcard, size: 50, color: Colors.green[600]),
            ),
            const SizedBox(height: 16),
            Text(
              'Refer Friends & Earn Rewards',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSection('How it Works',
                '1. Share your referral code with friends\n'
                    '2. When they sign up and make their first booking\n'
                    '3. You both get rewards!'),
            _buildSection('Your Referral Code', referralCode),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Copy referral code to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Referral code copied to clipboard!')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Referral Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Share referral code
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sharing referral code...')),
                );
              },
              icon: const Icon(Icons.share),
              label: const Text('Share with Friends'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Privacy Policy Screen
class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600])),
            const SizedBox(height: 24),
            _buildSection('Information We Collect', 'We collect information you provide directly to us, such as when you create an account, make a booking, or contact us.'),
            _buildSection('How We Use Your Information', 'We use the information we collect to provide, maintain, and improve our services, process transactions, and communicate with you.'),
            _buildSection('Information Sharing', 'We do not sell, trade, or rent your personal information to third parties without your consent.'),
            _buildSection('Data Security', 'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.'),
            _buildSection('Contact Us', 'If you have any questions about this Privacy Policy, please contact us at  maniksangra2006@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Terms & Conditions Screen
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
            Text('Terms and Conditions', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600])),
            const SizedBox(height: 24),
            _buildSection('1. Acceptance of Terms', 'By using this app, you agree to these terms and conditions.'),
            _buildSection('2. Use of Service', 'You may use our app for lawful purposes only.'),
            _buildSection('3. User Accounts', 'You are responsible for maintaining account security.'),
            _buildSection('4. Contact Us', 'For questions about these terms, contact us at maniksangra2006@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Return Policy Screen
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
            Text('Return & Refund Policy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[600])),
            const SizedBox(height: 24),
            _buildSection('Refund Eligibility', 'You may be eligible for a refund if service was not provided as described or if there were quality issues.'),
            _buildSection('Refund Process', '1. Contact support within 24 hours\n2. Provide details about the issue\n3. We\'ll review within 48 hours\n4. Refunds processed in 5-7 business days'),
            _buildSection('Cancellation Policy', '• Free cancellation up to 4 hours before service\n• Late cancellations may incur fees'),
            _buildSection('Contact for Refunds', 'Email: maniksangra2006@gmail.com\nPhone: +91 9697682875'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Profile Screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _emailController.text = user.email ?? '';

        // Try to load additional data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phone'] ?? '';
        } else {
          _nameController.text = user.displayName ?? '';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await user.updateDisplayName(_nameController.text);

        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[100],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.blue[600],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              enabled: _isEditing,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              enabled: false,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            if (_isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600]),
                    child: const Text('Save'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}