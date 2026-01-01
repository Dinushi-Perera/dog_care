import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'education_screen.dart';
import 'login_screen.dart'; // Import LoginScreen

// Product, ProductReview, CartItem, and CustomerProfile classes remain unchanged
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String brand;
  final String type;
  final String age;
  final List<ProductReview> reviews;
  final String imageUrl;
  final double averageRating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.brand,
    required this.type,
    required this.age,
    required this.reviews,
    required this.imageUrl,
    required this.averageRating,
  });
}

class ProductReview {
  final String id;
  final String customerName;
  final String review;
  final double rating;
  final DateTime date;

  ProductReview({
    required this.id,
    required this.customerName,
    required this.review,
    required this.rating,
    required this.date,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CustomerProfile {
  final String id;
  final String name;
  final String address;
  final String telephone;
  final String email;
  final String profileImageUrl;

  CustomerProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.telephone,
    required this.email,
    required this.profileImageUrl,
  });

  // Factory constructor to create CustomerProfile from Firestore data
  factory CustomerProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomerProfile(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      address: data['address'] ?? 'No address provided',
      telephone: data['phone'] ?? 'No phone provided',
      email: data['email'] ?? 'No email provided',
      profileImageUrl: data['profileImageUrl'] ?? 'https://example.com/default.jpg',
    );
  }
}

// Main App with Bottom Navigation
class PetStoreApp extends StatefulWidget {
  const PetStoreApp({super.key});

  @override
  _PetStoreAppState createState() => _PetStoreAppState();
}

class _PetStoreAppState extends State<PetStoreApp> {
  int _currentIndex = 0;
  List<CartItem> cartItems = [];

  // Sample products with reviews (unchanged)
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Royal Canin Puppy Food',
      description: 'Complete and balanced nutrition for puppies.',
      price: 2500.00,
      brand: 'Royal Canin',
     

 type: 'Dry Food',
      age: 'Puppy',
      averageRating: 4.5,
      reviews: [
        ProductReview(
          id: '1',
          customerName: 'Nimal Silva',
          review: 'මගේ බලු පැටියා ගොඩක් කැමතියි. ගුණාත්මක ආහාරයක්.',
          rating: 5.0,
          date: DateTime(2024, 6, 15),
        ),
        ProductReview(
          id: '2',
          customerName: 'Priya Fernando',
          review: 'Very good quality food. My puppy loves it and has grown healthy.',
          rating: 4.0,
          date: DateTime(2024, 6, 10),
        ),
      ],
      imageUrl: 'assets/roual_canin.jpg',
    ),
    Product(
      id: '2',
      name: 'Pedigree Adult Dog Food',
      description: 'Healthy and delicious food for adult dogs.',
      price: 2000.00,
      brand: 'Pedigree',
      type: 'Dry Food',
      age: 'Adult',
      averageRating: 4.2,
      reviews: [
        ProductReview(
          id: '3',
          customerName: 'Sunil Jayawardena',
          review: 'මගේ බල්ලා මේකට ගොඩක් කැමතියි. මිල ගණනත් සාධාරණයි.',
          rating: 4.0,
          date: DateTime(2024, 6, 12),
        ),
      ],
      imageUrl: 'assets/pedigree.jpg',
    ),
    Product(
      id: '3',
      name: 'Whiskas Cat Food',
      description: 'Complete and balanced nutrition for cats.',
      price: 2500.00,
      brand: 'Whiskas',
      type: 'Dry Food',
      age: 'Adult',
      averageRating: 4.3,
      reviews: [
        ProductReview(
          id: '4',
          customerName: 'Ayesha Rodrigo',
          review: 'My cat really enjoys this food. Good quality and nutrition.',
          rating: 4.5,
          date: DateTime(2024, 6, 8),
        ),
      ],
      imageUrl: 'assets/whiskas.jpg',
    ),
  ];

  void _addToCart(Product product, int quantity) {
    setState(() {
      int existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += quantity;
      } else {
        cartItems.add(CartItem(product: product, quantity: quantity));
      }
    });
  }

  int get _cartItemCount {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      ProductCatalogPage(
        products: products,
        cartItems: cartItems,
        onAddToCart: _addToCart,
      ),
      CartScreen(cartItems: cartItems),
      ReviewsPage(products: products),
      EducationScreen(),
      ProfilePage(), // No need to pass profile, as it will be fetched dynamically
    ];

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Reviews',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Education',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Product Catalog Page (unchanged)
class ProductCatalogPage extends StatefulWidget {
  final List<Product> products;
  final List<CartItem> cartItems;
  final Function(Product, int) onAddToCart;

  const ProductCatalogPage({
    required this.products,
    required this.cartItems,
    required this.onAddToCart,
    super.key,
  });

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  String? _selectedBrand;
  String? _selectedType;
  String? _selectedAge;

  void _showAddToCartDialog(Product product) {
    int selectedQuantity = 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add to Cart'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Price: Rs ${product.price.toStringAsFixed(2)}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Quantity:', style: TextStyle(fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          IconButton(
                            onPressed: selectedQuantity > 1
                                ? () {
                                    setDialogState(() {
                                      selectedQuantity--;
                                    });
                                  }
                                : null,
                            icon: const Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('$selectedQuantity', style: const TextStyle(fontSize: 16)),
                          ),
                          IconButton(
                            onPressed: () {
                              setDialogState(() {
                                selectedQuantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: Rs ${(product.price * selectedQuantity).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onAddToCart(product, selectedQuantity);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$selectedQuantity x ${product.name} added to cart!'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = widget.products;

    if (_selectedBrand != null) {
      filteredProducts = filteredProducts.where((product) => product.brand == _selectedBrand).toList();
    }
    if (_selectedType != null) {
      filteredProducts = filteredProducts.where((product) => product.type == _selectedType).toList();
    }
    if (_selectedAge != null) {
      filteredProducts = filteredProducts.where((product) => product.age == _selectedAge).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Store - Products', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildFilterDropdown(
                    hintText: 'Select Brand',
                    value: _selectedBrand,
                    items: widget.products.map((product) => product.brand).toSet().toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBrand = value;
                      });
                    },
                  ),
                  _buildFilterDropdown(
                    hintText: 'Select Type',
                    value: _selectedType,
                    items: widget.products.map((product) => product.type).toSet().toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                  ),
                  _buildFilterDropdown(
                    hintText: 'Select Age',
                    value: _selectedAge,
                    items: widget.products.map((product) => product.age).toSet().toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAge = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hintText),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              product.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                ),
                const SizedBox(height: 5),
                Text(
                  product.description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: Rs ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductReviewDetailPage(product: product),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text('${product.averageRating}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Text('(${product.reviews.length})', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddToCartDialog(product),
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reviews Page (unchanged)
class ReviewsPage extends StatelessWidget {
  final List<Product> products;

  const ReviewsPage({required this.products, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.teal,
                child: Icon(Icons.pets, color: Colors.white),
              ),
              title: Text(product.name),
              subtitle: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  Text('${product.averageRating} (${product.reviews.length} reviews)'),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductReviewDetailPage(product: product),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Product Review Detail Page (unchanged)
class ProductReviewDetailPage extends StatelessWidget {
  final Product product;

  const ProductReviewDetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    Text(' ${product.averageRating}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(' (${product.reviews.length} reviews)', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: product.reviews.length,
              itemBuilder: (context, index) {
                final review = product.reviews[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(review.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < review.rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review.review),
                        const SizedBox(height: 8),
                        Text(
                          '${review.date.day}/${review.date.month}/${review.date.year}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

// Profile Page with Dynamic Firestore Data
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? fullName;
  String? email;
  int? phoneNumber;
  String? address;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String usermail = user.email ?? '';
      
      var snapshot = await FirebaseFirestore.instance
          .collection('registerUser')
          .where('email', isEqualTo: usermail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data();
        setState(() {
          fullName = userData['name']; // Changed from 'fullName' to 'name'
          email = userData['email'];
          phoneNumber = int.tryParse(userData['phone']?.toString() ?? '0'); // Changed from 'phoneNumber' to 'phone' and handle string conversion
          address = userData['address'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          fullName = 'Unknown User';
          email = 'No Email';
          phoneNumber = 0;
          address = 'No Address';
        });
      }
    } else {
      setState(() {
        isLoading = false;
        fullName = 'Guest';
        email = 'No Email';
        phoneNumber = 0;
        address = 'No Address';
      });
    }
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to edit profile screen
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.teal[100],
                      child: const Icon(Icons.person, size: 80, color: Colors.teal),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal Information',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          const Divider(),
                          _buildProfileItem(Icons.person, 'Name', fullName ?? 'Unknown'),
                          _buildProfileItem(Icons.email, 'Email', email ?? 'No Email'),
                          _buildProfileItem(Icons.phone, 'Phone Number', phoneNumber?.toString() ?? 'No Phone'),
                          _buildProfileItem(Icons.location_on, 'Address', address ?? 'No Address'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Settings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.history, color: Colors.teal),
                            title: const Text('Order History'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // TODO: Navigate to order history
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.teal),
                            title: const Text('Wishlist'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // TODO: Navigate to wishlist
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings, color: Colors.teal),
                            title: const Text('Settings'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // TODO: Navigate to settings
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Logout', style: TextStyle(color: Colors.red)),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Are you sure you want to logout?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _signOut(context),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Wrapper to handle authentication state
class PetStoreAppWrapper extends StatelessWidget {
  const PetStoreAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Store App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const PetStoreApp();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}