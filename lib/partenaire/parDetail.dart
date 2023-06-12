import 'dart:async';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/Formulaire.dart';

class ParDetails extends StatefulWidget {
  final String description;
  final String imageurl;
  final String name;
  final String location;
  final String price;
  final String type;
  final String docId;

  ParDetails({
    Key? key,
    required this.description,
    required this.imageurl,
    required this.location,
    required this.name,
    required this.price,
    required this.type,
    required this.docId,
  }) : super(key: key);

  @override
  State<ParDetails> createState() => _ParDetailsState();
}

class _ParDetailsState extends State<ParDetails> {
  late final String com;
  final commentaire = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!.email;

  Future<void> addUserDetails(String com, String userId) async {
    final id = widget.docId;
    final parentDocRef = FirebaseFirestore.instance.collection(widget.type).doc(id);

    final subCollectionRef = parentDocRef.collection('commentaire');
    await subCollectionRef.add({
      'comment': com,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  late bool isLiked = false;
  late int likeCount = likeCount;

  Future<QuerySnapshot> fetchPendingPartnerAccounts() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(widget.type)
        .doc(widget.docId)
        .collection('commentaire')
        .get();

    return querySnapshot;
  }

  @override
  void initState() {
    super.initState();
    print("hello");
  }

  void dispose() {
    super.dispose();
    commentaire.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 320,
                  width: double.infinity,
                  decoration: BoxDecoration(),
                  child: Image.network(widget.imageurl, fit: BoxFit.fill),
                ),
              ),
              Positioned(
                top: 300,
                child: SingleChildScrollView(
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ),
                               IconButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder :(context)=> const Formulaire(),)); }, icon: Icon(Icons.message,size: 30,   color: Color.fromARGB(255, 191, 191, 191),),),
                               // IconButton(onPressed: (){ }, icon: const Icon(Icons.message_rounded,size: 30,color: Colors.black54, )),
                                LikeButton(
                                  size: 40.0,
                                  circleColor: CircleColor(start: Colors.redAccent[400]!, end: Colors.redAccent[700]!),
                                  bubblesColor: BubblesColor(
                                    dotPrimaryColor: Colors.redAccent[700]!,
                                    dotSecondaryColor: Colors.redAccent[400]!,
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    return Icon(
                                      Icons.favorite,
                                      color: isLiked ? Colors.redAccent[700] : Colors.grey,
                                      size: 30.0,
                                    );
                                  },
                                  likeCount: 57,
                                  countBuilder: (int? count, bool isLiked, String text) {
                                    var color = isLiked ? Colors.redAccent[700] : Colors.grey;
                                    Widget result;
                                    if (count == 0) {
                                      result = Text(
                                        "love",
                                        style: TextStyle(color: color),
                                      );
                                    } else {
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    }
                                    return result;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_pin),
                                Expanded(
                                  child: Text(
                                    widget.location,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 4, 129, 56),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.description,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                              ),
                            ),
                          const SizedBox(   height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0.0),
                              child: Container(
                                height:120,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.grey.shade800,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child: TextField(
                                    controller: commentaire,
                                    decoration: const InputDecoration(
                                      hintText: 'Ajouter un commentaire',
                                      border: InputBorder.none,
                                    ),
                                    onSubmitted: (value) {
                                      com = commentaire.text.trim();
                                      print(widget.type);
                                      addUserDetails(com, user!);
                                    },
                                  ),
                                ),
                              ),
                            ),
                           
                           // SizedBox(height: 0,),
                            FutureBuilder<QuerySnapshot>(
                              future: fetchPendingPartnerAccounts(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                  // Display the list of non-confirmed partner accounts
                                  return Padding(
                                    padding : EdgeInsets.all(4),
                                    child: ListView.builder(
                                      shrinkWrap:true,
                                      //physics: const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot accountSnapshot = snapshot.data!.docs[index];
                                        Map<String, dynamic> accountData =
                                            accountSnapshot.data() as Map<String, dynamic>;
                                        String comment = accountData['comment'];
                                        String userId = accountData['userId'];
                                                        
                                        return Card(
                                          child: SizedBox(
                                            height: 80,
                                            //width: MediaQuery.of(context).size.width,
                                           // padding: const EdgeInsets.all(5),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                
                                            //  mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  
                                                  Padding(
                                                    padding: const EdgeInsets.all(2),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            CircleAvatar(backgroundImage :NetworkImage('https://www.shutterstock.com/image-vector/default-avatar-profile-flat-icon-260nw-1742219921.jpg'),radius: 20,),
                                                            const SizedBox(width: 10,height: 20,),
                                                              Text(userId,
                                                              style: const TextStyle(
                                                                color: Colors.black54,
                                                                fontSize: 13.0,
                                                                fontWeight: FontWeight.w500,
                                                              ),),
                                                          ]),
                                                                   Padding(
                                                                     padding: const EdgeInsets.all(7.0),
                                                                     child: Text(
                                                                                 comment,
                                                                                 style: const TextStyle(
                                                                                 color: Colors.black,
                                                                                 fontSize: 15.0,
                                                                                 fontWeight: FontWeight.w500,
                                                                                ),
                                                                         ),
                                                                   ),
                                                                ],
                                                              ),
                                                    
                                                       
                                                     
                                    
                                                  ),
                                                  
                                                        
                                                ],
                                                
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: Text('Aucun commentaire trouvé.'),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }
}
