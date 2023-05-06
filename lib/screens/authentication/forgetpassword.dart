import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class forgetPassword extends StatefulWidget {
  const forgetPassword({super.key});

  @override
  State<forgetPassword> createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController =TextEditingController();

  Future passwordreset() async{
try{
await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
}
on FirebaseAuthException catch(e)
{
  debugPrint(e.toString());
  showDialog(
   context: context,
   builder: (context){
    return AlertDialog(content: Text(e.message.toString()),
     actions: <Widget>[
          TextButton(
            child:const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],);
   });
}
  }
  @override
  void dispose() {
   
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 119, 138, 152),),
      
      body:  Container(
        decoration: const BoxDecoration(
               image: DecorationImage(
              image: AssetImage('assets/capcarbon.jpg'),
              fit: BoxFit.cover,
              ),
              ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal:25.0),
            child: Text('Enter Your Email And We Will Send You Reset password link',
            style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,
            ),
          ),
          const  SizedBox(height: 10.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  
                decoration: BoxDecoration(color: Colors.grey.shade200,
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
      
          const  SizedBox(height: 10.0),
          ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 216, 247, 217),side: BorderSide.none, shape: const StadiumBorder()),
          
          onPressed:passwordreset,
          child: const Text('Reset Password',style: TextStyle(color: Colors.black,letterSpacing: 0.6,fontSize: 16.0,),) 
            ),
      
          ],
        ),
      ),
    );
  }
}