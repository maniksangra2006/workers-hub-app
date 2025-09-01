import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'service_detail_screen.dart';
import 'booking_screen.dart';
import 'custom_post_screen.dart';
import 'bookings_list_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'more_screen.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentLocation = "Getting location...";
  int _selectedIndex = 0;
  int cartItemCount = 0;
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  final List<Map<String, dynamic>> services = [
    {
      'name': 'Waterproofing',
      'image': 'assets/waterproofing.png',
      'icon': Icons.water_drop,
      'subcategories': [
        {'name': 'Roof Waterproofing', 'price': 2999},
        {'name': 'Bathroom Waterproofing', 'price': 1999},
        {'name': 'Terrace Waterproofing', 'price': 3999},
      ]
    },
    {
      'name': 'Painting Services',
      'image': 'assets/painting.png',
      'icon': Icons.brush,
      'subcategories': [
        {'name': 'Wall Painting', 'price': 499},
        {'name': 'Interior Painting', 'price': 899},
        {'name': 'Exterior Painting', 'price': 1299},
      ]
    },
    {
      'name': 'Termite Control',
      'image': 'assets/termite.png',
      'icon': Icons.bug_report,
      'subcategories': [
        {'name': 'Pre-Construction', 'price': 1999},
        {'name': 'Post-Construction', 'price': 999},
        {'name': 'Wooden Furniture', 'price': 599},
      ]
    },
    {
      'name': 'Pest Control',
      'image': 'assets/pest.png',
      'icon': Icons.pest_control,
      'subcategories': [
        {'name': 'General Pest Control', 'price': 799},
        {'name': 'Cockroach Control', 'price': 399},
        {'name': 'Rodent Control', 'price': 899},
      ]
    },
    {
      'name': 'Appliance & Mini Services',
      'image': 'assets/appliance.png',
      'icon': Icons.home_repair_service,
      'subcategories': [
        {'name': 'Refrigerator Repair', 'price': 299},
        {'name': 'Washing Machine Repair', 'price': 399},
        {'name': 'Microwave Repair', 'price': 249},
      ]
    },
    {
      'name': 'Room Cleaning',
      'image': 'assets/cleaning.png',
      'icon': Icons.cleaning_services,
      'subcategories': [
        {'name': '1 Bathroom', 'price': 519},
        {'name': '2 Bathrooms', 'price': 954},
        {'name': '3 Bathrooms', 'price': 1387},
      ]
    },
    {
      'name': 'Kitchen Cleaning',
      'image': 'assets/kitchen.png',
      'icon': Icons.kitchen,
      'subcategories': [
        {'name': 'Deep Kitchen Cleaning', 'price': 799},
        {'name': 'Chimney Cleaning', 'price': 499},
        {'name': 'Exhaust Fan Cleaning', 'price': 199},
      ]
    },
    {
      'name': 'AC Services',
      'image': 'assets/ac.png',
      'icon': Icons.ac_unit,
      'subcategories': [
        {'name': 'AC Maintenance', 'price': 50},
        {'name': 'AC Repair', 'price': 999},
        {'name': 'AC Installation', 'price': 1999},
      ]
    },
    {
      'name': 'Gardening Services',
      'image': 'assets/gardening.png',
      'icon': Icons.eco,
      'subcategories': [
        {'name': 'Garden Maintenance', 'price': 899},
        {'name': 'Plant Care', 'price': 599},
        {'name': 'Landscaping', 'price': 2499},
        {'name': 'Tree Pruning', 'price': 799},
      ]
    },
    {
      'name': 'Cooking Services',
      'image': 'assets/cooking.png',
      'icon': Icons.restaurant,
      'subcategories': [
        {'name': 'Home Chef', 'price': 1299},
        {'name': 'Party Catering', 'price': 2999},
        {'name': 'Meal Preparation', 'price': 899},
        {'name': 'Special Occasion Cooking', 'price': 1999},
      ]
    },
    {
      'name': 'Plumbing Services',
      'image': 'assets/plumbing.png',
      'icon': Icons.plumbing,
      'subcategories': [
        {'name': 'Pipe Repair', 'price': 599},
        {'name': 'Drain Cleaning', 'price': 399},
        {'name': 'Faucet Installation', 'price': 299},
        {'name': 'Water Heater Service', 'price': 899},
      ]
    },
    {
      'name': 'Electrical Services',
      'image': 'assets/electrical.png',
      'icon': Icons.electrical_services,
      'subcategories': [
        {'name': 'Wiring Installation', 'price': 799},
        {'name': 'Switch & Socket Repair', 'price': 199},
        {'name': 'Fan Installation', 'price': 399},
        {'name': 'Light Fixture Setup', 'price': 299},
      ]
    },
    {
      'name': 'Carpentry Services',
      'image': 'assets/carpentry.png',
      'icon': Icons.handyman,
      'subcategories': [
        {'name': 'Furniture Repair', 'price': 599},
        {'name': 'Cabinet Installation', 'price': 1299},
        {'name': 'Door Repair', 'price': 499},
        {'name': 'Custom Wood Work', 'price': 1999},
      ]
    },
    {
      'name': 'Beauty Services',
      'image': 'assets/beauty.png',
      'icon': Icons.face_retouching_natural,
      'subcategories': [
        {'name': 'Hair Cut & Style', 'price': 399},
        {'name': 'Facial Treatment', 'price': 599},
        {'name': 'Manicure & Pedicure', 'price': 299},
        {'name': 'Bridal Makeup', 'price': 2999},
      ]
    },
    {
      'name': 'Fitness Services',
      'image': 'assets/fitness.png',
      'icon': Icons.fitness_center,
      'subcategories': [
        {'name': 'Personal Training', 'price': 999},
        {'name': 'Yoga Sessions', 'price': 699},
        {'name': 'Physiotherapy', 'price': 799},
        {'name': 'Diet Consultation', 'price': 499},
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCartItemCount();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      isSearching = searchQuery.isNotEmpty;
    });
  }

  List<Map<String, dynamic>> _getFilteredServices() {
    if (searchQuery.isEmpty) {
      return services;
    }

    List<Map<String, dynamic>> filteredServices = [];

    for (var service in services) {
      // Check if service name matches
      if (service['name'].toLowerCase().contains(searchQuery)) {
        filteredServices.add(service);
      } else {
        // Check if any subcategory matches
        bool subcategoryMatches = false;
        for (var subcategory in service['subcategories']) {
          if (subcategory['name'].toLowerCase().contains(searchQuery)) {
            subcategoryMatches = true;
            break;
          }
        }
        if (subcategoryMatches) {
          filteredServices.add(service);
        }
      }
    }

    return filteredServices;
  }

  List<Map<String, dynamic>> _getFilteredSubcategories() {
    List<Map<String, dynamic>> filteredSubcategories = [];

    if (searchQuery.isEmpty) {
      return filteredSubcategories;
    }

    for (var service in services) {
      for (var subcategory in service['subcategories']) {
        if (subcategory['name'].toLowerCase().contains(searchQuery)) {
          filteredSubcategories.add({
            'name': subcategory['name'],
            'price': subcategory['price'],
            'serviceName': service['name'],
            'icon': service['icon'],
            'allSubcategories': service['subcategories'],
          });
        }
      }
    }

    return filteredSubcategories;
  }

  Future<void> _getCurrentLocation() async {
    try {
      PermissionStatus permission = await Permission.location.request();

      if (permission == PermissionStatus.granted) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            currentLocation = "${place.locality}, ${place.administrativeArea}";
          });
        }
      } else {
        setState(() {
          currentLocation = "Location permission denied";
        });
      }
    } catch (e) {
      setState(() {
        currentLocation = "Error getting location";
      });
    }
  }

  Future<void> _getCartItemCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('items')
          .get();

      setState(() {
        cartItemCount = cartSnapshot.docs.length;
      });
    }
  }

  void _showAllCategoriesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllCategoriesScreen(services: services),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0,
        title: Text(
          'Workers Hub',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          BookingsListScreen(),
          CartScreen(onCartUpdated: _getCartItemCount),
          _buildOffersScreen(),
          MoreScreen(), // Changed from ProfileScreen() to MoreScreen()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue[600],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart_outlined),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        cartItemCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer_outlined),
            label: 'Offers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // Search Bar
        Container(
          color: Colors.blue[600],
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search services...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                },
              )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Content based on search state
        Expanded(
          child: isSearching ? _buildSearchResults() : _buildDefaultContent(),
        ),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Satisfaction Banner
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay only after\nsatisfaction',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Home painting',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.thumb_up, color: Colors.white, size: 50),
              ],
            ),
          ),

          // All Categories
          _buildSectionHeader('All Categories'),
          _buildCategoriesGrid(services.take(8).toList()),

          // Custom Post Section
          _buildCustomPostSection(),

          // Popular Services
          _buildSectionHeader('Popular Services'),
          _buildPopularServicesGrid(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final filteredServices = _getFilteredServices();
    final filteredSubcategories = _getFilteredSubcategories();

    if (filteredServices.isEmpty && filteredSubcategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No results found for "$searchQuery"',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching for different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filteredServices.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Services (${filteredServices.length})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildCategoriesGrid(filteredServices),
          ],

          if (filteredSubcategories.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Specific Services (${filteredSubcategories.length})',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildSubcategoriesList(filteredSubcategories),
          ],
        ],
      ),
    );
  }

  Widget _buildSubcategoriesList(List<Map<String, dynamic>> subcategories) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: subcategories.length,
      itemBuilder: (context, index) {
        final subcategory = subcategories[index];
        return Container(
          margin: EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(subcategory['icon'], color: Colors.blue[600]),
              ),
              title: Text(
                subcategory['name'],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Category: ${subcategory['serviceName']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: Text(
                '₹${subcategory['price']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[600],
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceDetailScreen(
                      serviceName: subcategory['serviceName'],
                      subcategories: subcategory['allSubcategories'],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              _showAllCategoriesScreen();
            },
            child: Text('See All', style: TextStyle(color: Colors.blue[600])),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Map<String, dynamic>> servicesToShow) {
    return Container(
      height: servicesToShow.length <= 2 ? 160 : 320,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: servicesToShow.length,
        itemBuilder: (context, index) {
          final service = servicesToShow[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailScreen(
                    serviceName: service['name'],
                    subcategories: service['subcategories'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(service['icon'], size: 40, color: Colors.blue[600]),
                  SizedBox(height: 8),
                  Text(
                    service['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomPostSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Post for Customized service',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Create a post with customized\ndescription with additional instruction for\na service',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomPostScreen()),
              );
            },
            child: Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServicesGrid() {
    final popularServices = services.take(4).toList();
    return Container(
      height: 200,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: popularServices.length,
        itemBuilder: (context, index) {
          final service = popularServices[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceDetailScreen(
                    serviceName: service['name'],
                    subcategories: service['subcategories'],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(service['icon'], size: 30, color: Colors.blue[600]),
                  SizedBox(height: 8),
                  Text(
                    service['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOffersScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No offers available',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class AllCategoriesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> services;

  const AllCategoriesScreen({Key? key, required this.services}) : super(key: key);

  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
    });
  }

  List<Map<String, dynamic>> _getFilteredServices() {
    if (searchQuery.isEmpty) {
      return widget.services;
    }

    List<Map<String, dynamic>> filteredServices = [];

    for (var service in widget.services) {
      // Check if service name matches
      if (service['name'].toLowerCase().contains(searchQuery)) {
        filteredServices.add(service);
      } else {
        // Check if any subcategory matches
        bool subcategoryMatches = false;
        for (var subcategory in service['subcategories']) {
          if (subcategory['name'].toLowerCase().contains(searchQuery)) {
            subcategoryMatches = true;
            break;
          }
        }
        if (subcategoryMatches) {
          filteredServices.add(service);
        }
      }
    }

    return filteredServices;
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = _getFilteredServices();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0,
        title: Text(
          'All Categories',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.blue[600],
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Categories Grid
          Expanded(
            child: filteredServices.isEmpty
                ? _buildNoResultsFound()
                : _buildAllCategoriesGrid(filteredServices),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No categories found for "$searchQuery"',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          Text(
            'Try searching for different keywords',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCategoriesGrid(List<Map<String, dynamic>> services) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (searchQuery.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Found ${services.length} categories',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServiceDetailScreen(
                        serviceName: service['name'],
                        subcategories: service['subcategories'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(service['icon'], size: 40, color: Colors.blue[600]),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          service['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${service['subcategories'].length} services',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}