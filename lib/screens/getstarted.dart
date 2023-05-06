import 'package:flutter/material.dart';
import 'package:travel_app/screens/authentication/RegisterPartenaire.dart';
import 'package:travel_app/wrapper.dart';
class GetStarted extends StatefulWidget {
  const GetStarted({super.key});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Container(
            decoration: const BoxDecoration(
                 image: DecorationImage(
                image: AssetImage('assets/capcarbon.jpg'),
                fit: BoxFit.cover,
                ),
                ),
          child: Center(
            child: SafeArea(
              child:Column(
                children:  [   
              const SizedBox(height: 230.0,),
               const Text('Explore Your Favorite Journey ',
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
            const SizedBox(height: 10.0,),
             const Padding(
               padding: EdgeInsets.all(15.0),
               child: Text('S\'inscrire En Tant que. ',
                 style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.7,
                      fontFamily: 'Roboto',
                               ),
                               ),
             ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                
                children: [
                  GestureDetector(
                     onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const RegisterPartenaire(),));
              },
                    child: const Text('Partenaire ',
                                     style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        fontFamily: 'Roboto',
                                  ),
                                  ),
                  ),
              GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const Wrapper(),));
              },
                child: const Text('Voyageur. ',
                   style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.7,
                        fontFamily: 'Roboto',
                ),
                ),
              ),
                  
                  
                ],
                  
              ),
            )
      
                ],
      
                
             ),
             ),
              ),
        ),
      ),
    );
  }
}