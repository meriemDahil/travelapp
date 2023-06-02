import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/screens/aprescreation.dart';

import 'package:travel_app/screens/home/profilUser.dart';
class Voyage extends StatefulWidget {
  const Voyage({super.key});

  @override
  State<Voyage> createState() => _VoyageState();
}

class _VoyageState extends State<Voyage> {

  final _formKey = GlobalKey<FormState>();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  String _destination = '';

 void initState() {
    super.initState();
  }
  
   Future<void> addUserDetails(DateTime startDate,DateTime endDate,String destination ) async {
   
  final userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
  print(FirebaseAuth.instance.currentUser!.uid); // creates a new document with a random ID
  await userRef.set({
    "créérVoyage": {
      'depart': startDate,
      'retour': endDate,
      'destination':destination,
    },
   
  }, SetOptions(merge: true)); // merges the new data with any existing data in the document
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
       backgroundColor: Colors.white,
       leading:IconButton(icon: const Icon(Icons.arrow_left, color: Colors.black),
        onPressed: () async 
        {Navigator.pop(context);},
        ),
    
      title: const Text('Nguidik',style: TextStyle(color: Color.fromARGB(255, 0, 6, 30),fontFamily : 'Lobster',letterSpacing: 0.7),),
           centerTitle: true,
            elevation: 0.0,
            actions: [
             TextButton(
                onPressed: () async{
                // go to user profile
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const profilUser()));
                },
                child: const Icon(Icons.person, color: Colors.black,)
                ),
                ],
    ),
      body: SingleChildScrollView(
        child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
           
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Destination',
                labelStyle: TextStyle(color: Colors.black,letterSpacing: 0.8, fontSize: 30,fontWeight: FontWeight.w500,),
                 focusedBorder: UnderlineInputBorder(
                 borderSide: BorderSide(color: Colors.black),
                 ),
                  enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                 ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a destination';
                  }
                  return null;
                },
                onSaved: (value) {
                  _destination = value!;
                },
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  const Text('Date de Départ: ' ,style: TextStyle(color: Colors.black,letterSpacing: 0.8, fontSize: 25,fontWeight: FontWeight.w500,),),
                  Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color.fromARGB(255, 16, 27, 45),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: const Color.fromARGB(255, 16, 27, 45),
                        ),
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                          child: Text(DateFormat('yyyy-MM-dd').format(_startDate) ),
                          onPressed: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                              _startDate = selectedDate;
                             } );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  const Text('Date de Retour: ',style: TextStyle(color: Colors.black,letterSpacing: 0.8, fontSize: 25,fontWeight: FontWeight.w500,),),
              Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color.fromARGB(255, 16, 27, 45),
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          primary: const Color.fromARGB(255, 16, 27, 45),
                        ),
                      ),
                      dialogBackgroundColor: Colors.white,
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        return TextButton(
                          child:  Text(DateFormat('yyyy-MM-dd').format(_endDate)),
                          onPressed: () async {
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: _startDate,
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                             setState(() {
                            _endDate = selectedDate;
                        });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              
                 
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                     print(FirebaseAuth.instance.currentUser!.uid);
                   addUserDetails(_startDate, _endDate,_destination);
                   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  AfterCreation()));

                   
                  }
                },
                style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 22, 59), shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  fixedSize:const Size(170, 50)),
                child: const Text('OK',style: TextStyle(color: Colors.white,letterSpacing: 0.8, fontSize: 15,fontWeight: FontWeight.w500,),),
              ),
           
            ],
          ),
        ),
        ),
      ),
    );
  }
}