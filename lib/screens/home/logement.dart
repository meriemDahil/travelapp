import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Logement extends StatefulWidget {
  @override
  _logementState createState() => _logementState();
}

class _logementState extends State<Logement> {
  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    _getImagesFromFirebaseStorage();
  }

  Future<void> _getImagesFromFirebaseStorage() async {
    try {
      // Get a reference to the Firebase storage bucket
      final Reference storageRef = FirebaseStorage.instance.ref();

      // Get a reference to the folder containing the images
      final folderRef = storageRef.child('logement');

      // Get a list of all the files in the folder
      final ListResult result = await folderRef.listAll();

      // Loop through each file and get its download URL
      for (final Reference ref in result.items) {
        final String downloadUrl = await ref.getDownloadURL();

        // Add the download URL to the list of image URLs
        setState(() {
          _imageUrls.add(downloadUrl);
        });
      }

      // Add the image URLs to Firestore
      await _addImageUrlsToFirestore();
    } catch (e) {
      debugPrint('Error getting images from Firebase Storage: $e');
    }
  }
  String description="";
  String? localisation;
  String?name;



  Future<void> _addImageUrlsToFirestore() async {
    final firestoreInstance = FirebaseFirestore.instance;
    for (String url in _imageUrls) {
      await firestoreInstance.collection('logement').add({'url': url,'description':description,'localisation':localisation,'name':name});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: _imageUrls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final imageUrl = _imageUrls[index];
          return Image.network(
            imageUrl,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
