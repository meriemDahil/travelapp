
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/admin/admin.dart';
import 'package:travel_app/admin/confirmPar.dart';
import 'package:travel_app/partenaire/partenaire.dart';
import 'package:travel_app/screens/authentication/authentication.dart';
import 'package:travel_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String uid = FirebaseAuth.instance.currentUser!.uid;
          print(FirebaseAuth.instance.currentUser);

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final data = snapshot.data!.data();
                if (data is Map && data.containsKey('userType')) {
                  final userType = data['userType'];
                  if (userType == 'voyageur') {
                    return Home();
                  } else if (userType == 'partenaire') {
                    return ParCamping();
                  }
                  else if (userType == 'admin') {
                    return Admin();
                  } else {
                    return Text('User type not found');
                  }
                } else {
                  return Text('User not found');
                }
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        } else {
          return authentication();
        }
      },
    );
  }
}


/*class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
         
                       return Home();
                      
                      // return ParCamping();
                      }
                   
         else {
            return const authentication();
          }
        },
      ),
    );
  }
}
*/