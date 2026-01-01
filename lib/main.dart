import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'product_catalog.dart';
import 'cart_screen.dart';
import 'education_screen.dart';
import 'home_screen.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  try{
    await Firebase.initializeApp();
    print('✅Firebase initialized successfully');
    
  }
  catch (e) {
    print('❌Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Care App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/products': (context) => PetStoreApp(), // Updated to use PetStoreApp
        '/education': (context) => EducationScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/cart') {
          final args = settings.arguments as List<CartItem>?;
          return MaterialPageRoute(
            builder: (context) => CartScreen(cartItems: args ?? []),
          );
        }
        return null;
      },
    );
  }
}