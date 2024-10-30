import 'package:app1/pages/FoodListingPage.dart';
import 'map_tracking.dart';
import 'package:app1/pages/PlaceholderWidget.dart'; // Assuming this is your "More" page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void navigateToPage(String page) {
    Widget newPage;

    switch (page) {
      case 'Food':
        newPage = FoodListingPage();
        break;
      case 'Map':
        newPage = MapTrackingPage();
        break;
      case 'More':
        newPage = PlaceholderWidget(); // Your "More" page
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavigationCard("Food", Icons.food_bank),
              const SizedBox(height: 20),
              _buildNavigationCard("Map", Icons.map_outlined),
              const SizedBox(height: 20),
              _buildNavigationCard("More", Icons.more_horiz),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () => navigateToPage(title),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 20),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
