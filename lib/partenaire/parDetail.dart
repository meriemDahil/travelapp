import 'dart:async';
import 'package:like_button/like_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

 late final String com  ;
 final  commentaire = TextEditingController() ;
 final user =FirebaseAuth.instance.currentUser!.email;
 

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
late bool isLiked=false;
late int likeCount=likeCount;


@override
  void initState() {
    // TODO: implement initState
    super.initState();
      print("helllllllllllllllllllo");
 
  }

void dispose() {
   
    super.dispose();
   // commentaire.dispose();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 320,
                  width: double.maxFinite,
                  decoration: const BoxDecoration(),
                  child:  Image.network(widget.imageurl, fit: BoxFit.fill),
                ),
              ),
              Positioned(
                top: 300,
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                              ),
                            ),
                           LikeButton(
                                size: 40.0,
                                circleColor:
                                    CircleColor(start: Colors.redAccent[400]!, end: Colors.redAccent[700]!),
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
                                likeCount: 13,
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
                        const SizedBox(height: 5.0,),
                        Row(
                          children: [
                            const Icon(Icons.location_pin),
                            Text(
                              widget.location,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 4, 129, 56),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Text(
                          widget.description,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 20,),
                          Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child:Container(
                        height: 150,
                      decoration: BoxDecoration(color: Colors.transparent,
                          border: Border.all(color: Colors.grey.shade800,),
                           borderRadius: BorderRadius.circular(12),
                      ),
                          
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                 controller: commentaire,
                                  
                                  decoration: const InputDecoration(
                                    hintText: 'commentaires',
                                     border: InputBorder.none,
                                    
                                    
                                  ),
                                  onSubmitted: (value) {
                                    com = commentaire.text.trim();
                                     print(widget.type);
                                      
                                    addUserDetails(com,user!);
                                    
                                  },
                                 
                      
                            ) ,
                          ),
                          ),
      
                        ),
                     
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
