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
      backgroundColor: const Color.fromARGB(255, 251, 249, 233) ,
    appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 247, 155),
       leading:IconButton(icon: const Icon(Icons.arrow_left, color: Colors.black),
        onPressed: () async 
        {Navigator.pop(context);},
        ),
    
      title: const Text('Travel App',style: TextStyle(color: Colors.black),),
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
    body:  Padding(
      padding: const  EdgeInsets.fromLTRB(8, 40, 8, 20),
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
                    style:  ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 247, 155),),
                    child: const Text('Continue',style: TextStyle(color: Colors.black,letterSpacing: 0.7),),
                  ),
        ],
      ),
    ),
    );
  }
}