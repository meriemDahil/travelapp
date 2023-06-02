import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Future<QuerySnapshot> fetchUsers() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        
        .get();

    return querySnapshot;
  }

  Future<void> deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: FutureBuilder<QuerySnapshot>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot userSnapshot = snapshot.data!.docs[index];
                Map<String, dynamic> userData =
                    userSnapshot.data() as Map<String, dynamic>;
                String username = userData['username'];
                String firstname = userData['firstname'];

                return ListTile(
                  title: Row(
                    children: [
                      CircleAvatar(backgroundImage :NetworkImage("https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg"),radius: 14,),
                      SizedBox(width: 20,), Text('Email: $username'),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(40,0, 0, 5),
                    child: Text('Nom d\' utilisateur: $firstname'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'Voulez-vous vraiment supprimer $username ?'),
                            actions: [
                              TextButton(
                                child: Text('Annuler'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Supprimer'),
                                onPressed: () async {
                                  await deleteUser(userSnapshot.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('Aucun utilisateur trouvé.'),
            );
          }
        },
      ),
    );
  }
}
