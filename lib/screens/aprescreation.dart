

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
/*
class AfterCreation extends StatefulWidget {
  @override
  _AfterCreationState createState() => _AfterCreationState();
}

class _AfterCreationState extends State<AfterCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Images'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('destination').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              String imageUrl = docs[index]['url'];
              return Image.network(
                imageUrl,
                
              );
            },
          );
        },
      ),
    );
  }
}
*/
class AfterCreation extends StatefulWidget {
  @override
  _AfterCreationState createState() => _AfterCreationState();
}

class _AfterCreationState extends State<AfterCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Images'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('destination')
            .where('localisation', isEqualTo: 'Oran ')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<DocumentSnapshot> docs = snapshot.data!.docs;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              String imageUrl = docs[index]['url'];
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
