import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AjouterService extends StatefulWidget {
  const AjouterService({Key? key});

  @override
  State<AjouterService> createState() => _AjouterServiceState();
}

class _AjouterServiceState extends State<AjouterService> {
  File? _imageFile;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String _name ='';
  String _price = '';
  String _location = '';
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
        FirebaseStorage.instance.ref().child('$section/$fileName');
    final UploadTask task = firebaseStorageRef.putFile(_imageFile!);

    // Wait for the upload to complete and get the download URL
    final TaskSnapshot snapshot = await task.whenComplete(() {});
    final String downloadUrl = await snapshot.ref.getDownloadURL();

    // Add the image download URL to Firestore
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection(section).add({
      'url': downloadUrl,
      'name':_name,
      'price': _price,
      'location': _location,
      'description': _description,
      'createdAt': FieldValue.serverTimestamp(),
      'postedBy': user!.uid,
      'type': type,
       
    
    });

    setState(() {
      _imageFile = null;
      _price = '';
      _location = '';
      _description = '';
      type='';
      
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('un nouveau service a été publié'),
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
                  const Text('Dans quelle section voulez-vous la partager ? ', textAlign: TextAlign.justify,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
                  const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                    onPressed: () {
                    section = 'transport';
                    type='transport';
                    
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 200, 220, 255),),
                    child: const Icon(Icons.directions_bus_rounded,color: Colors.black,),
                  ),
                     ElevatedButton(
                    onPressed: () {
                    section ='Camping';
                    type='Camping';
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 194, 255, 185),),
                    child: const Icon(Icons.forest,color: Colors.black,),
                  ),
                     ElevatedButton(
                    onPressed: () {
                     section ='logement';
                     type ='logement';
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 122, 93, 0),),
                    child: const Icon(Icons.home,),
                  ),
                     ElevatedButton(
                    onPressed: () {
                      section = 'voyageOrganisé';
                      type = 'voyageOrganisé';
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 255, 192, 192),),
                    child: const Text('   voyage \nOrganisé',style: TextStyle(color: Colors.black,letterSpacing: 0.7),),
                  ),
                    ElevatedButton(
                    onPressed: () {
                     section ='particuliers';
                     type ='particuliers';
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 130, 69, 130),),
                    child: const Text('Particulier'),
                  ),
                 ],),
                _imageFile == null
                    ? const Text('Aucune image sélectionnée.',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),)
                    : Image.file(_imageFile!),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  style:  ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 188, 229, 255),minimumSize: Size(40, 40)),
                  child: const Text('choisir image',style: TextStyle(color: Colors.black,fontSize: 16, letterSpacing: 0.6),),
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
                            return 'Veuillez entrer votre nom';
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
                      decoration:const InputDecoration(
                        labelText: 'numéro téléphone',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                       
                        // Validate phone number input
                      },
                      onChanged: (value) {
                        // Handle phone number input changes
                      },
                    ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Prix',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le prix';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _price = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Localisation/destination',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre localisation';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _location = value;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                                            validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
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
                    style:  ElevatedButton.styleFrom(backgroundColor:  Color.fromARGB(255, 188, 229, 255),minimumSize: Size(40, 40)),
                    child: const Text('Partager',style: TextStyle(color: Colors.black,fontSize: 16, letterSpacing: 0.6),),
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
  }}
