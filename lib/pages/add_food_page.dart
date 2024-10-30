import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart'; // Import Geolocator

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  double? _latitude; // New variable for latitude
  double? _longitude; // New variable for longitude
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectImage({required bool fromGallery}) async {
    final pickedFile = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = basename(image.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('food_images/$fileName');

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Request permission to access location
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text("Location retrieved successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _submitFood(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adding food item...")),
      );

      String name = _nameController.text;
      String description = _descriptionController.text;
      int quantity = int.tryParse(_quantityController.text) ?? 1;

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to upload image")),
          );
          return;
        }
      }

      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('food_items').add({
          'name': name,
          'description': description,
          'quantity': quantity,
          'imageUrl': imageUrl ?? '',
          'timestamp': FieldValue.serverTimestamp(),
          'uploaderId': userId,
          'latitude': _latitude, // Store latitude
          'longitude': _longitude, // Store longitude
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food item added successfully!")),
        );
        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to add food item")),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    setState(() {
      _selectedImage = null;
      _latitude = null; // Clear latitude
      _longitude = null; // Clear longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Food"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildTextField(
                    _nameController,
                    "Food Name",
                    "Please enter a food name",
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    _descriptionController,
                    "Description",
                    "Please enter a description",
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    _quantityController,
                    "Quantity",
                    "Please enter a quantity",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _selectedImage != null
                      ? Image.file(_selectedImage!, height: 150)
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200], // Lighter background
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'No image selected.',
                            style: TextStyle(color: Colors.black54), // Darker text color
                          ),
                        ),
                  _buildImagePickerButtons(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text("Get Current Location"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => _submitFood(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String labelText,
    String validationText, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationText;
        }
        return null;
      },
    );
  }

  Widget _buildImagePickerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => _selectImage(fromGallery: true),
          icon: const Icon(Icons.photo_library, color: Colors.white),
          label: const Text("Select from Gallery"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () => _selectImage(fromGallery: false),
          icon: const Icon(Icons.camera, color: Colors.white),
          label: const Text("Take a Photo"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
