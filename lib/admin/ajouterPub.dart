import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjouterPub extends StatefulWidget {
  const AjouterPub({super.key});

  @override
  State<AjouterPub> createState() => _AjouterPubState();
}

class _AjouterPubState extends State<AjouterPub> {
   File? _imageFile;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String _name ='';
  String _price = '';
  String _localisation = '';
  String _description = '';
   String type = '';
  

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }
  late String section = '';

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images/$_name');
    final UploadTask task = firebaseStorageRef.putFile(_imageFile!);

    // Wait for the upload to complete and get the download URL
    final TaskSnapshot snapshot = await task.whenComplete(() {});
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    // Add the image download URL to Firestore
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('destination').add({
      'url': downloadUrl,
      'name':_name,
      'localisation': _localisation,
      'description': _description,
      'createdAt': FieldValue.serverTimestamp(),
      'postedBy': user!.uid,
      
       
    
    });

    setState(() {
      _imageFile = null;
      _name='';
      _localisation = '';
      _description = '';
      
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('une nouvelle publicationa été publié'),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 
                _imageFile == null
                    ? const Text('Aucune image sélectionnée.',style: TextStyle(color: Colors.white),)
                    : Image.file(_imageFile!),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 223, 243, 255),),
                  child: const Text('Choisir image',style: TextStyle(color: Colors.black),),
                ),
                
                 const SizedBox(height: 10.0),
                
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'nom',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Localisation',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer la localisation';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _localisation = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                                            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la description';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                 
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _uploadImage();
                      }
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 223, 243, 255),),
                    child: const Text('ajouter publication',style: TextStyle(color: Colors.black),),
                  ),
                ],
              ),
            ),
                  ],
                ),
          ),
    ),
  ),
    );
  }
}