import 'package:flutter/material.dart';
import 'package:travel_app/screens/home/profilUser.dart';
import 'package:travel_app/screens/home/recommandation/voyage.dart';

class CreVoyage extends StatefulWidget {
  const CreVoyage({super.key});

  @override
  State<CreVoyage> createState() => _CreVoyageState();
}

class _CreVoyageState extends State<CreVoyage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 243, 255) ,
    appBar: AppBar(
      backgroundColor: Color.fromARGB(255, 223, 243, 255),
       leading:IconButton(icon: const Icon(Icons.arrow_left, color: Colors.black),
        onPressed: () async 
        {Navigator.pop(context);},
        ),
    
      title: const Text('Nguidik',style: TextStyle(color: Color.fromARGB(255, 0, 6, 30),fontFamily : 'Lobster',letterSpacing: 0.7),),
           centerTitle: true,
            elevation: 2.0,
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
    body:  Padding(
      padding: const  EdgeInsets.fromLTRB(8, 40, 8, 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding:const EdgeInsets.all(15),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              ),
              child: const Text('La fonctionnalité de création d\'un voyage permet aux voyageurs de planifier leur voyage en entrant leur destination ainsi que les dates de départ et de retour. Les utilisateurs peuvent bénéficier de la réception de notifications concernant les activités qu\'ils peuvent faire pendant leur voyage, notamment les festivals et autres événements sur place. De plus, la fonctionnalité permet de garder une trace de tous les partenaires que les utilisateurs ont contactés pendant leur voyage. Enfin, à la fin de leur voyage, les utilisateurs reçoivent un rappel pour évaluer leur expérience.'
              ,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500,letterSpacing: 0.7),),
            ),
             ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Voyage()));
                       
                      },
                      style:  ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 14, 0, 69),),
                      child: const Text('Continue',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),letterSpacing: 0.7),),
                    ),
          ],
        ),
      ),
    ),
    );
  }
}