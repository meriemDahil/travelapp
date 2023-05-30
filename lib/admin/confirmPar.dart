/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/admin/admin.dart';
import 'package:travel_app/admin/ajouterPub.dart';
import 'package:travel_app/screens/home/profilUser.dart';

class ConfirmPar extends StatefulWidget {
  const ConfirmPar({super.key});

  @override
  State<ConfirmPar> createState() => _ConfirmParState();
}

class _ConfirmParState extends State<ConfirmPar> {
  final user = FirebaseAuth.instance.currentUser!;

Future<List<QueryDocumentSnapshot>> fetchPendingPartnerAccounts() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('userType', isEqualTo: 'partenaire')
      .where('confirmationStatus', isEqualTo: false)
      .get();

  return querySnapshot.docs;
}

  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    
      
    );
  }
}
*/import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/admin/admin.dart';
import 'package:travel_app/admin/ajouterPub.dart';
import 'package:travel_app/screens/home/profilUser.dart';

class ConfirmPar extends StatefulWidget {
  const ConfirmPar({Key? key}) : super(key: key);

  @override
  State<ConfirmPar> createState() => _ConfirmParState();
}

class _ConfirmParState extends State<ConfirmPar> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<QuerySnapshot> fetchPendingPartnerAccounts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'partenaire')
        .where('confirmationStatus', isEqualTo: false)
        .get();

    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: FutureBuilder<QuerySnapshot>(
        future: fetchPendingPartnerAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Display the list of non-confirmed partner accounts
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot accountSnapshot = snapshot.data!.docs[index];
                Map<String, dynamic> accountData =
                    accountSnapshot.data() as Map<String, dynamic>;
                String username = accountData['username'];
                String firstname = accountData['firstname'];
               

                return  Card(
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 7, 3,3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CircleAvatar(radius: 20,backgroundImage: NetworkImage('https://img.myloview.com/posters/default-avatar-profile-in-trendy-style-for-social-media-user-icon-400-228654852.jpg'),),
                                     SizedBox(width: 15),
                                    Column(
                                      children: [
                                    Text(
                                      'Email: $username',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                       
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                      Text(
                                      'Nom d\' utilisateur: $firstname',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                       
                                      ),
                                    ),
                                  ],
                                ),
                                 ],
                                    ),
                              ),
                             
                            
                              
                            ],
                          ),
                        SizedBox(width: 30,height: 50,),
                            Align(alignment: Alignment.bottomLeft,
                              child: ElevatedButton(onPressed: ()async{ await FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(accountSnapshot.id)
                                                          .update({'confirmationStatus': true});
                                                            await Future.delayed(Duration(seconds: 2));
                                                          setState(() {});},
                                                          child: Text('confirmer',style: TextStyle(color: Colors.black,letterSpacing: 0.7),),
                                                          style: ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 167, 211, 255),
                                                          ),
                                                          ),
                            ),
                        ],
                      
                     ),
                    ),
                  
                );
              },
            );
          } else {
            // Display a message when there are no pending partner accounts
            return Center(
              child: Text('No pending partner accounts.'),
            );
          }
        },
      ),
    );
  }
}
