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
      content: Text('Image uploaded successfully.'),
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
                  const Text('Dans quelle section voulez-vous la partager ? ', textAlign: TextAlign.justify,),
                  const SizedBox(height: 10.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                    onPressed: () {
                    section = 'transport';
                    type='transport';
                    
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  Colors.blueAccent,),
                    child: const Icon(Icons.directions_bus_rounded),
                  ),
                     ElevatedButton(
                    onPressed: () {
                    section ='Camping';
                    type='Camping';
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 145, 249, 149),),
                    child: const Icon(Icons.forest),
                  ),
                     ElevatedButton(
                    onPressed: () {
                     section ='logement';
                     type ='logement';
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 85, 67, 7),),
                    child: const Icon(Icons.home),
                  ),
                     ElevatedButton(
                    onPressed: () {
                      section = 'agenceDeVoyage';
                      type = 'agenceDeVoyage';
                     
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 250, 104, 158),),
                    child: const Text('   agence \n de voyage'),
                  ),
                    ElevatedButton(
                    onPressed: () {
                     section ='autre';
                     type ='autre';
                    },
                    style:  ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 189, 219, 16),),
                    child: const Text('autre'),
                  ),
                 ],),
                _imageFile == null
                    ? const Text('No image selected.')
                    : Image.file(_imageFile!),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 22, 59),),
                  child: const Text('Pick Image'),
                ),
                
                 const SizedBox(height: 10.0),
                
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
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
                        labelText: 'Phone Number',
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
                          labelText: 'Price',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
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
                          labelText: 'Location',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter location';
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
                        return 'Please enter description';
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
                    style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 1, 22, 59),),
                    child: const Text('Upload Service'),
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
