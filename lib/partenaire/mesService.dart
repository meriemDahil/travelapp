import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/partenaire/ajouterService.dart';
import 'package:travel_app/partenaire/parDetail.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
   List<String> collection = [ 'Camping ', 'transport'];

  @override
  Widget build(BuildContext context) {
    final currentUserUid = _auth.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 22, 59),
        title: const Text('Mes Publication'),
      ),
      body: Column(
        children: [
          FutureBuilder<DocumentSnapshot>(
            future: _firestore
                .collection('Camping')
                .where('postedBy', isEqualTo: currentUserUid)
                .get()
                .then((querySnapshot) => querySnapshot.docs.first),
            builder: (context, docSnapshot) {
              print(currentUserUid);
              if (!docSnapshot.hasData) {
                return const SizedBox.shrink();
              }
              final data = docSnapshot.data!.data() as Map<String, dynamic>;
              final price = data['price'] ?? '';
              final location = data['location'] ?? '';
              final name = data['name'] ?? '';
              final imageUrl = data['url'] ?? '';
              final type = data['type'] ?? '';
              return GestureDetector(
                onTap: () async {
                    final firestoreInstance = FirebaseFirestore.instance;
                  final snapshot = await firestoreInstance
                      .collection('Camping')
                      .where('url', isEqualTo: imageUrl)
                      .get();
    
                  try {
                    if (snapshot.docs.isNotEmpty) {
                      final doc = snapshot.docs.first;
                      final docId = doc.id; 
                      final description = doc.get('description');
                      final imageurl = doc.get('url');
                      final name = doc.get('name');
                      final location = doc.get('location');
                      final price= doc.get('price');
                       final type= doc.get('type');
                    

    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>ParDetails(
                            description: description,
                            imageurl: imageurl,
                            name: name,
                            location: location,
                            price :price,
                            type: type,
                            docId: docId,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint('Error retrieving data from Firestore: $e');
                  }
                
            
            
                },
                child: Card(
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              child:Row(
                  children: [
                    Container(
                    
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'name: $name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Price: $price',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Location: $location',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                            )
                ),
              );
            },
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _firestore
                .collection('transport')
                .where('postedBy', isEqualTo: currentUserUid)
                .get()
                .then((querySnapshot) => querySnapshot.docs.first),
            builder: (context, docSnapshot) {
              print(currentUserUid);
              if (!docSnapshot.hasData) {
                return const SizedBox.shrink();
              }
              final data = docSnapshot.data!.data() as Map<String, dynamic>;
              final price = data['price'] ?? '';
              final location = data['location'] ?? '';
              final name = data['name'] ?? '';
              final imageUrl = data['url'] ?? '';
               final type = data['type'] ?? '';
              return GestureDetector(
                onTap: () async {
                    final firestoreInstance = FirebaseFirestore.instance;
                  final snapshot = await firestoreInstance
                      .collection('transport')
                      .where('url', isEqualTo: imageUrl)
                      .get();
    
                  try {
                    if (snapshot.docs.isNotEmpty) {
                      final doc = snapshot.docs.first;
                      final docId = doc.id; 
                      final description = doc.get('description');
                      final imageurl = doc.get('url');
                      final name = doc.get('name');
                      final location = doc.get('location');
                      final price= doc.get('price');
                    

    
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>ParDetails(
                            description: description,
                            imageurl: imageurl,
                            name: name,
                            location: location,
                            price :price,
                            type: type,
                            docId: docId,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint('Error retrieving data from Firestore: $e');
                  }
                
            
            
                },
                child: Card(
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              child:Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                      
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'name: $name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Price: $price',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Location: $location',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                            )
                ),
              );
            },
          ),
        ],
      ),
          
        
  );
      
    
  }
}
