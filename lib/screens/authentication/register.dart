import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Register extends StatefulWidget {
 final VoidCallback showlogin;

  const Register({super.key, required this.showlogin});

  @override
  State<Register> createState() => _RegisterState();
 
}

class _RegisterState extends State<Register> {
final FirebaseAuth _auth =FirebaseAuth.instance;
 final _emailController =TextEditingController();
 final _password =TextEditingController();
 final _confirmpassword = TextEditingController();
 final _nameController =TextEditingController();
 final _usernameController =TextEditingController();
 final _ageController = TextEditingController();
 String userType='voyageur';
 bool confirmationStatus =false;

 String error ="wrong confirm password";
 Future register() async {

try{
if (confirmpw()){
UserCredential result = await _auth.createUserWithEmailAndPassword(email: _emailController.text
.trim(), password: _password.text.trim());
 User? user  = result.user;
 addUserDetails(
  _nameController.text.trim(),
  _emailController.text.trim(),
 _usernameController.text.trim(), 
 userType,
 confirmationStatus,
 );
 
 return user;
 
}
}catch(e)
 {debugPrint(e.toString());}
}

 bool confirmpw(){
  if (_confirmpassword.text.trim()==_password.text.trim()) 
  { return true;} 
  else 
  { return false;}
 }
 Future<void> addUserDetails(String firstname, String username, String email,String userType, bool confirmationStatus) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid); // creates a new document with a random ID
  await userRef.set({
    "firstname": firstname,
    "email": email,
    "username": username,
    'userType': userType,
    'confirmationStatus': confirmationStatus
  }, SetOptions(merge: true)); // merges the new data with any existing data in the document
}


  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _password.dispose();
    _confirmpassword.dispose();
    _ageController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  backgroundColor:Colors.white,
      
      body:Container(
          decoration: const BoxDecoration(
               image: DecorationImage(
              image: AssetImage('assets/capcarbon.jpg'),
              fit: BoxFit.cover,
              ),
              ),
        child: Center(
          child: SingleChildScrollView(  
                child: SafeArea(
                  child:Column(
                    children: <Widget>[   
                 // const SizedBox(height: 50.0,),
                   const  Text('Explore Your Favorite Journey ',
                   style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        fontFamily: 'Roboto',
                ),
                ),
                const Text('With us ',
                   style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        fontFamily: 'Roboto',
                ),
                ),
                const SizedBox(height: 20.0,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        
                      decoration: BoxDecoration(color: Colors.transparent,
                          border: Border.all(color: Colors.grey.shade800,),
                           borderRadius: BorderRadius.circular(12),
                      ),
                          
                            child:   Padding(
                              padding:const  EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                controller: _usernameController,
                                  decoration:const InputDecoration(
                                    hintText: 'Full Name',
                                    
                                    border: InputBorder.none,
                                  ),
                                 
                    
                            ) ,
                          ),
                          ),
                    
                      ),
                      const SizedBox(height: 10.0,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        
                      decoration: BoxDecoration(color: Colors.transparent,
                          border: Border.all(color: Colors.grey.shade800,),
                           borderRadius: BorderRadius.circular(12),
                      ),
                          
                            child:   Padding(
                              padding:const  EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                controller: _nameController,
                                  decoration:const InputDecoration(
                                    hintText: 'User name',
                                    border: InputBorder.none,
                                  ),
                                 
                    
                            ) ,
                          ),
                          ),
                    
                      ),
                       
                const SizedBox(height: 10.0,),
               
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        
                      decoration: BoxDecoration(color: Colors.transparent,
                          border: Border.all(color: Colors.grey.shade800,),
                           borderRadius: BorderRadius.circular(12),
                      ),
                          
                            child:   Padding(
                              padding:const  EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                controller: _emailController,
                                  decoration:const InputDecoration(
                                    hintText: 'Email',
                                    border: InputBorder.none,
                                  ),
                                 
                    
                            ) ,
                          ),
                          ),
                    
                      ),
                      const SizedBox(height: 10.0,),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:Container(
                    decoration: BoxDecoration(color: Colors.transparent,
                        border: Border.all(color: Colors.grey.shade800,),
                         borderRadius: BorderRadius.circular(12),
                    ),
                        
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                               controller: _password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'password',
                                  border: InputBorder.none,
                                  
                                ),
                               
                    
                          ) ,
                        ),
                        ),
                      ),
                       const SizedBox(height: 10.0,),
                       Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:Container(
                    decoration: BoxDecoration(color: Colors.transparent,
                        border: Border.all(color: Colors.grey.shade800,),
                         borderRadius: BorderRadius.circular(12),
                    ),
                        
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextField(
                               controller: _confirmpassword,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'confirm password',
                                  border: InputBorder.none,
                                  
                                ),
                               
                    
                          ) ,
                        ),
                        ),
                      ),
                    
                      const SizedBox(height: 15.0,),
                       Padding(padding: const  EdgeInsets.symmetric(horizontal: 25.0),
                          child:GestureDetector(
                           onTap: () async {
                            userType = 'partenaire';
                            
                          },
                            child: Container(
                            padding:   const EdgeInsets.all(10.0),
                             
                              child:const  Center(
                                child:Text('Sign up as a partener',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.8,
                              
                              ),
                              
                              
                              ),
                                        ),
                                        ),
                          ),
                        
                          ),
           
          
                    
                          Padding(padding: const  EdgeInsets.symmetric(horizontal: 25.0),
                          child:GestureDetector(
                            onTap: register,
                            child: Container(
                            padding:   const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                color: const Color.fromARGB(255, 216, 247, 217),
                              ),
                              
                              child:const  Center(
                                child:Text('Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.8,
                              
                              ),
                              
                              ),
                                        ),
                                        ),
                          ),
                        
                          ),
                          const  SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:  <Widget> [
                            const Text('Already have an account?',style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              letterSpacing: 0.7,
                              fontFamily: 'Roboto',
                              color: Color.fromARGB(255, 216, 247, 217),
                            
                              ),
                              ),
                              GestureDetector(
                                onTap: widget.showlogin,
                                child:  const Text('  login here',style:TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                                ),
                                                ),
                              ),
                            ],
                          ),
                        
                        
                          ],
                          ),
                          ),
                  ),
            ),
              
          ),
          
                );
              }
            }