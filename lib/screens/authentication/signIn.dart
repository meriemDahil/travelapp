import 'package:travel_app/screens/authentication/forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignIn extends StatefulWidget {

final VoidCallback showregister;
const SignIn({super.key , required this.showregister});


  @override
  State<SignIn> createState() => _SignInState();
 
}

class _SignInState extends State<SignIn> {
final FirebaseAuth _auth =FirebaseAuth.instance;
final _emailController =TextEditingController();
final _password =TextEditingController();

 Future signInEmailpw() async {
try{
UserCredential result = await _auth.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _password.text.trim());
 User? user  = result.user;
 return user;
}
catch(e)
{
  debugPrint(e.toString());
}
 }


  @override
  void dispose() {
   
    super.dispose();
    _emailController.dispose();
    _password.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey.shade300,
      
      body:Container(
         decoration: const BoxDecoration(
               image: DecorationImage(
              image: AssetImage('assets/capcarbon.jpg'),
              fit: BoxFit.cover,
              ),
              ),
        child: Center(child:SingleChildScrollView(
          
          child: SafeArea(
            child:Column(
              children: <Widget>[
              
             const SizedBox(height: 20.0,),
             const  Text('Explore Your Favorite Journey ',
             style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
          ),
          ),
          const Text('With us ',
             style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.7,
          ),
          ),
          const SizedBox(height: 20.0,),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  
                decoration: BoxDecoration(color: Colors.grey.shade50,
                    border: Border.all(color: Colors.white,),
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
              decoration: BoxDecoration(color: Colors.grey.shade50,
                  border: Border.all(color: Colors.white,),
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
                const SizedBox(height: 8.0,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal:25.0),
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const forgetPassword()));
                            },
                             child: const Text('forget password',style:TextStyle(
                                             fontWeight: FontWeight.w600,
                                             fontSize: 15.0,
                                             color: Colors.white,
                                             letterSpacing: 0.7,
                                             ),
                                             ),
                           ),
                     ],
                   ),
                 ),
                const SizedBox(height: 10.0,),
                 Padding(padding: const  EdgeInsets.symmetric(horizontal: 25.0),
                 child:GestureDetector(
                  onTap: signInEmailpw,
                   child: Container(
                   padding:   const EdgeInsets.all(20.0),
                     decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 216, 247, 217),
                     ),
                     
                     child:const  Center(
                      child:Text('Sign In',
                     style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                     
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
                    const Text('You don\'t have an account',style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    letterSpacing: 0.7,
                    color: Colors.white,
                   
                    ),
                    ),
                     GestureDetector(
                      onTap: widget.showregister,
                       child: const Text(' Register here',style:TextStyle(
                                       fontWeight: FontWeight.w500,
                                       fontSize: 15.0,
                                       color:  Color.fromARGB(255, 216, 247, 217),
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