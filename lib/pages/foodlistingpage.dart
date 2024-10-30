import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'food_detail_page.dart';

class FoodListingPage extends StatelessWidget {
  const FoodListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Food'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor, // Theme consistency
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('food_items')
          .orderBy('timestamp', descending: true) // Sorted by newest items
          .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var foodData = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      foodData['imageUrl'],
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 70, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    foodData['name'],
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Quantity: ${foodData['quantity']}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(foodData),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
