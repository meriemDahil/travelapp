import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/admin/ajouterPub.dart';
import 'package:travel_app/screens/home/profilUser.dart';

import 'confirmPar.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 0;

 final screens = [
    ConfirmPar(), // Replace with the appropriate widget
    AjouterPub(),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        backgroundColor: Color.fromARGB(255, 167, 211, 255),
       
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () async {
                // go to profil user
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const profilUser()));
                /*  await _auth.signOut();
                   utilisateur =user.email!;
                   debugPrint(utilisateur);*/
              },
              child: const Icon(
                Icons.person,
                color: Colors.black,
              ))
        ],
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int index) {
          setState(() {
            this.index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Vérifier Compte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'publier',
          ),
        ],
      ),
    );
  }
}