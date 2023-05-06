import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/home/camping.dart';
import 'package:travel_app/screens/home/logement.dart';
import 'package:travel_app/screens/home/profilUser.dart';
import 'package:travel_app/screens/home/recommandation/recommandation.dart';
import 'package:travel_app/screens/home/transport.dart';


class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin{
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController ;
  @override
  void initState() { 
    super.initState();
     _tabController = TabController(length: 4, vsync: this);

  }
  @override
void dispose() {
  _tabController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    
    return  Scaffold
    (
      
      appBar: 
          AppBar(
          

            backgroundColor : Colors.white, 
            title: const Text('Travel App',style: TextStyle(color: Colors.black),),
           centerTitle: true,
            elevation: 0.0,
            actions: [
             TextButton(
                onPressed: () async{
                  // go to profil user
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const profilUser()));
                /*  await _auth.signOut();
                   utilisateur =user.email!;
                   debugPrint(utilisateur);*/
                },
                child: const Icon(Icons.person, color: Colors.black,)
                ),
                ],
          bottom: TabBar(
             controller: _tabController,
             labelColor: Colors.black,
             unselectedLabelColor: Colors.grey,
             indicatorSize: TabBarIndicatorSize.label,
             indicator: CircleIndicator(color: Colors.black, radius: 4.0),
             labelStyle: const TextStyle(fontWeight: FontWeight.w500,letterSpacing: 0.7,),
             isScrollable: true,
            tabs: const [
              Tab(text: 'Recommandation',),
              Tab(text: 'transport',),
              Tab(text: 'Camping' ),
              Tab(text: 'logement',),
            ]
            ),
           
 
      ),
      body: SafeArea(
        child: Container(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                  const Recommandation(),
                  const Transport(),
                  const Camping(),
                  Logement(),
        
                ]),
              ),
      )
       
      );
  
  }
}
class CircleIndicator extends Decoration{
 late  final color;
 late final radius;

    CircleIndicator({required this.color,required this.radius});
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    
    return CircleTab(color: color, radius: radius);
  }


}
class CircleTab extends BoxPainter {
  late final Color color;
  late final double radius;

  CircleTab({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint();
    paint.color = color;
    paint.isAntiAlias = true;
    final Offset position = Offset(configuration.size!.width/2 -radius/2 , configuration.size!.height-radius);

    canvas.drawCircle(offset+position, radius, paint);
  }
}
