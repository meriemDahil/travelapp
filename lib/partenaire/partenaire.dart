import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/partenaire/mesService.dart';
import 'package:travel_app/partenaire/message.dart';
import 'package:travel_app/partenaire/ajouterService.dart';
import 'package:travel_app/screens/home/profilUser.dart';

class ParCamping extends StatefulWidget {
  const ParCamping({Key? key}) : super(key: key);

  @override
  State<ParCamping> createState() => _ParCampingState();
}

class _ParCampingState extends State<ParCamping> {
  final user = FirebaseAuth.instance.currentUser!;

  int index = 0;

  final screens = [  Services(),  AjouterService(), Message(),      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Color.fromARGB(255, 4, 0, 71),
        ),
        backgroundColor:Color.fromARGB(255, 223, 243, 255),
        title: const Text(
          'Nguidik',
          style: TextStyle(color: Colors.black,fontFamily: 'Lobster'),
        ),
        centerTitle: true,
        elevation:  1.0,
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
                color: Color.fromARGB(255, 4, 0, 71),
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
        selectedItemColor: Color.fromARGB(255, 0, 0, 0),
        unselectedItemColor: Color.fromARGB(255, 148, 145, 137),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'services',
           
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'publier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'messages',
          ),
        ],
        
      ),
     
    );
  }
}
