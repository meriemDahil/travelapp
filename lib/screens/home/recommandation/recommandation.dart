
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/aprescreation.dart';
import 'package:travel_app/screens/home/recommandation/detail.dart';

import 'package:firebase_storage/firebase_storage.dart';

class Recommandation extends StatefulWidget {
  const Recommandation({Key? key}) : super(key: key);

  @override
  _RecommandationState createState() => _RecommandationState();
}

class _RecommandationState extends State<Recommandation> with SingleTickerProviderStateMixin {
  final List<String> _imageUrls = [];
  late Timer _timer; // Declare the timer variable
  late AnimationController _animationController; 
   String des="";
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Do something every second
    });

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    
    _getImagesFromFirebaseStorage();
  }

  Future<void> _getImagesFromFirebaseStorage() async {
    try {
      // Get a reference to the Firebase storage bucket
      final Reference storageRef = FirebaseStorage.instance.ref();

      // Get a reference to the folder containing the images
      final folderRef = storageRef.child('images');

      // Get a list of all the files in the folder
      final ListResult result = await folderRef.listAll();

      // Loop through each file and get its download URL
      for (final Reference ref in result.items) {
        final String downloadUrl = await ref.getDownloadURL();
        

        // Add the download URL to the list of image URLs
        
        setState(() {
          _imageUrls.add(downloadUrl);
        });
      await _addImageUrlsToFirestore();
      }
    } catch (e) {
      debugPrint('Error getting images from Firebase Storage: $e');
    }
  }

  String description = "";
  final String _localisation="";
  final String _name="";

  Future<void> _addImageUrlsToFirestore() async {
  final firestoreInstance = FirebaseFirestore.instance;
  for (final url in _imageUrls) {
    // Check if a document with the same URL already exists
    final snapshot =
        await firestoreInstance.collection('destination').where('url', isEqualTo: url).get();

    if (snapshot.docs.isEmpty) {
      // Add the new document to the collection
      await firestoreInstance.collection('destination').add({
        'url': url,
        'description': description,
        'localisation': _localisation,
        'name': _name
      });
    }
    final document = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      if (document.exists && document.data()!.containsKey('créérVoyage')) {
          
        
      } else {
        print('field  doesnt exist');
      }

  }
}

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: GridView.builder(
      itemCount: _imageUrls.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
      final imageUrl = _imageUrls[index];
      return GestureDetector(
        onTap: () async {
          debugPrint('true');
                final firestoreInstance = FirebaseFirestore.instance;
              final snapshot = await firestoreInstance
                  .collection('destination')
                 .where('url', isEqualTo: imageUrl).get();
               

               
    
              try {
                if (snapshot.docs.isNotEmpty) {
                  final doc = snapshot.docs.first;
                  final description = doc.get('description');
                  final imageurl = doc.get('url');
                  final name = doc.get('name');
                  final localisation = doc.get('localisation');
                
    
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        description: description,
                        imageurl: imageurl,
                        name: name,
                        localisation: localisation,
                      ),
                    ),
                  );
                }
                
              } catch (e) {
                debugPrint('Error retrieving data from Firestore: $e');
              }
            
        },
        
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Stack(
                 
              children: [
                Container(
                  height:200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
         
                      image: NetworkImage(
                        
                        imageUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('destination')
                      .where('url', isEqualTo: imageUrl)
                      .get()
                      .then((snapshot) => snapshot.docs.first),
                     
                      
    
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final name = data['name'];
                    final localisation = data['localisation'];
                    
                    return Positioned(
                      left: 5,
                      bottom: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_pin,size: 18,color: Colors.white,),
                              Text(
                                localisation,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                     
                     
                  },
                ),
              ],
            ),
          ),
        
      );
      },
    ),
    ),

  );
}
@override
  void dispose() {
  
    _timer?.cancel(); // cancel the timer
    _animationController.dispose(); // stop listening to the animation
    _addImageUrlsToFirestore();
    super.dispose();
  }

}
  