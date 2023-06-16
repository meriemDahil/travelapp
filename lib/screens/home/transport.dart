import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../partenaire/parDetail.dart';
class Transport extends StatefulWidget {
  const Transport({super.key});

  @override
  State<Transport> createState() => _TransportState();
}

class _TransportState extends State<Transport> with TickerProviderStateMixin{


 
  final List<String> _imageUrls = [];


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
      final folderRef = storageRef.child('transport');

      // Get a list of all the files in the folder
      final ListResult result = await folderRef.listAll();

      // Loop through each file and get its download URL
      for (final Reference ref in result.items) {
        final String downloadUrl = await ref.getDownloadURL();
       
        
        setState(() {
          _imageUrls.add(downloadUrl);
        });
     
      }
    } catch (e) {
      debugPrint('Error getting images from Firebase Storage: $e');
    }
  }

  String description = "";
  final String _name="";
  final String _location="";
  final String _price="";
  final String type="";
  final String postedBy="";
  final FirebaseAuth _auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _auth.currentUser!.uid;
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
                    .collection('transport')
                    .where('url', isEqualTo: imageUrl)
                    .get();
    
                try {
                  if (snapshot.docs.isNotEmpty) {
                    final doc = snapshot.docs.first;
                    final docId = doc.id; 
                    print(docId);
                    final description = doc.get('description');
                    final imageurl = doc.get('url');
                    final name = doc.get('name');
                    final location = doc.get('location');
                    final type = doc.get('type');
                    final postedBy =doc.get('postedBy');
    
                 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParDetails(
                          description: description,
                          imageurl: imageurl,
                          name: name,
                          location: location,
                          price: _price,
                          type:type,
                           docId: docId,
                           postedBy : postedBy,
                          
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
            child: Container(
              child: Column(
                 
              children: [
                Flexible(
                  child: Container(
                      height:MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: NetworkImage(
                            imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ),
                
                const SizedBox(height: 5),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('transport')
                      .where('url', isEqualTo: imageUrl)
                      .get()
                      .then((snapshot) => snapshot.docs.first),
                
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final data = snapshot.data!.data() as Map<String, dynamic>;
                    final name = data['name'];
                    final location = data['location'] ?? '';
                     final price = data['price'] ?? '';
                    return   Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                         
                    
                          children: [
                             Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                         
                           Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                         
                          ],
                        );
                    
                      })
                         ], ),
            ),
          ),
        );
                  },
                ),
              
            ),
          );
         
      
      }
 
}
