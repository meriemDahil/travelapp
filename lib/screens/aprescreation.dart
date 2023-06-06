import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/detailvoyage.dart';
import 'package:travel_app/screens/home/recommandation/detail.dart';

class AfterCreation extends StatefulWidget {
  @override
  _AfterCreationState createState() => _AfterCreationState();
}

class _AfterCreationState extends State<AfterCreation> {
  Future<List<dynamic>> combineDataFromCollections() async {
    List<dynamic> combinedData = [];

    // Retrieve camping data
    QuerySnapshot campingSnapshot = await FirebaseFirestore.instance
        .collection('Camping')
        
        .get();
    List<dynamic> campingData =
        campingSnapshot.docs.map((doc) => doc.data()).toList();
    combinedData.addAll(campingData);

  /*  // Retrieve destination data
    QuerySnapshot destinationSnapshot = await FirebaseFirestore.instance
        .collection('destination')
       
        .get();
    List<dynamic> destinationData =
        destinationSnapshot.docs.map((doc) => doc.data()).toList();
    combinedData.addAll(destinationData);
*/
    // Retrieve logement data
    QuerySnapshot logementSnapshot = await FirebaseFirestore.instance
        .collection('logement')
      
        .get();
    List<dynamic> logementData =
        logementSnapshot.docs.map((doc) => doc.data()).toList();
    combinedData.addAll(logementData);
    // Retrieve destination data
    QuerySnapshot destinationSnapshot = await FirebaseFirestore.instance
        .collection('destination')
        .where('location' , isEqualTo: 'Oran')
      
        .get();
    List<dynamic> destinationData =
        destinationSnapshot.docs.map((doc) => doc.data()).toList();
    combinedData.addAll(destinationData);


    // Retrieve transport data
    QuerySnapshot transportSnapshot = await FirebaseFirestore.instance
        .collection('transport')
        
        .get();
    List<dynamic> transportData =
        transportSnapshot.docs.map((doc) => doc.data()).toList();
    combinedData.addAll(transportData);

    return combinedData;
  }
String description = "";
  final String _name="";
  final String _location="";
  final String _price="";
  final String type="";

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 223, 243, 255),
      leading: IconButton(
        icon: const Icon(Icons.arrow_left, color: Colors.black),
        onPressed: () async {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Nguidik',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 6, 30),
          fontFamily: 'Lobster',
          letterSpacing: 0.7,
        ),
      ),
      centerTitle: true,
      elevation: 2.0,
    ),
    body: FutureBuilder<List<dynamic>>(
      future: combineDataFromCollections(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          List<dynamic> combinedData = snapshot.data!;
          combinedData.shuffle(); // Shuffle the data randomly

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Set the desired number of columns
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.0,
            ),
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              dynamic item = combinedData[index];

              // Extract relevant information from the item
              String name = item['name'];
              String location = item['location'];
              String url = item['url'];
             
              String ?section = item['type'];
               if (section != null){
              print(section);
               }
               else{
              section= 'destination';
              print(section);
               }
              // Create a GridTile to display the item
              return GestureDetector(
                onTap:  () async {
                debugPrint('true');
                final firestoreInstance = FirebaseFirestore.instance;
                final snapshot = await firestoreInstance
                    .collection(section!)
                    .where('url', isEqualTo: url)
                    .get();
                    
                try {
                 if (section != 'destination'){
                  if (snapshot.docs.isNotEmpty) {
                    final doc = snapshot.docs.first;
                    final docId = doc.id; 
                    print(docId);
                    final description = doc.get('description');
                    final imageurl = doc.get('url');
                    final name = doc.get('name');
                    final location = doc.get('location');
                    final type = doc.get('type');
    
                 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailVoyage(
                          description: description,
                          imageurl: imageurl,
                          name: name,
                          location: location,
                          price: _price,
                          type:type,
                           docId: docId,
                          
                        ),
                      ),
                    );
                  }}
                  else{
                        final firestoreInstance = FirebaseFirestore.instance;
              final snapshot = await firestoreInstance
                  .collection('destination')
                 .where('url', isEqualTo: url).get();
               

               
    
              try {
                if (snapshot.docs.isNotEmpty) {
                  final doc = snapshot.docs.first;
                  final description = doc.get('description');
                  final imageurl = doc.get('url');
                  final name = doc.get('name');
                  final localisation = doc.get('location');
                
    
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
                 }catch (e) {
                debugPrint('Error retrieving data from Firestore: $e');
              }
                  }
              } catch (e) {
                debugPrint('Error retrieving data from Firestore: $e');
              }
            
        },
        
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 2, 1, 0),
                    child: Container(
                        height:MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: NetworkImage(
                              url,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.fromLTRB(5, 2, 1, 0),
                   child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                 ),
                         
                           Padding(
                             padding: const EdgeInsets.fromLTRB(5, 2, 1, 0),
                             child: Text(
                                   location,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                           ),
                  ],
                ),
              );
            },
          );
        } else {
          return SizedBox(); // Return an empty SizedBox if there is no data
        }
      },
    ),
  );
}

  }

