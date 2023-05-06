
import 'package:travel_app/screens/home/cr%C3%A9erVoyage.dart';
import 'package:travel_app/screens/home/listprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';



class profilUser extends StatefulWidget  {
  const profilUser({super.key});

  @override
  State<profilUser> createState() => _profilUserState();
}

class _profilUserState extends State<profilUser> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future signOut() async{
     try{
      debugPrint('you signed out');
      return _auth.signOut();
      }
      catch(e){
       return null;
      }
     }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(icon: const Icon(Icons.arrow_left, color: Colors.black),
        onPressed: () async 
       // {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  Home())); },
       // {Get.back();},
        {Navigator.pop(context);},
        ),
        backgroundColor : Colors.white, 
        title: const Text('Travel App',style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
      ),

      body:SingleChildScrollView(
        child:  Container(
          padding:   const EdgeInsets.all(25.0),
          child: Center(
            child: Column(children:  [
            Stack(
              children: [ const CircleAvatar(radius:45.0,
                backgroundImage:NetworkImage("https://lastfm.freetls.fastly.net/i/u/770x0/13f370ec1fcca1dca240abb85fcbb914.jpg"),
                ),
              
               Positioned(
                bottom: 0,
                right: 0,
                 child: SizedBox(
                           child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(100),color: Colors.white,),
                            child: IconButton(icon:const Icon(Icons.photo_camera,size: 20, ),onPressed: (){},),
                           ),
                           ),
               ),
              ],
            ),
            const SizedBox(height: 20.0,),
            Text(user.email!),
            const SizedBox(height: 20.0,),
            SizedBox(
              width: 180,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor:  Colors.black,side: BorderSide.none, shape: const StadiumBorder()),
              onPressed:(){},
              child: const Text('Edit Profile',style: TextStyle(color: Colors.white,letterSpacing: 0.6,fontSize: 18.0,),) 
                ),
            ),
            const Divider(),
            ListProfile(title: "Setting", icon: Icons.settings, onPressed:(){}, endicon:true, textcolor: Colors.black),
            ListProfile(title: "Profile", icon: Icons.person, onPressed:(){}, endicon:true, textcolor: Colors.black),
            ListProfile(title: "Crée un voyage ", icon: Icons.luggage, onPressed:(){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const CreVoyage()));
            }, endicon:true, textcolor: Colors.black),
            ListProfile(title: "Notification ", icon: Icons.notifications, onPressed:(){}, endicon:true, textcolor: Colors.black),
            ListProfile(title: "Log out", icon: Icons.logout,
             onPressed:() async
            { 
               await _auth.signOut();
              // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const authentication()));
              Navigator.pop(context);
            },
               endicon:false, textcolor: Colors.red),
            ]
            ),
          ),
        )
      ),
    );
  }
}