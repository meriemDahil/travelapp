import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String description;
  final String imageurl;
  final String name;
  final String localisation;

  const DetailScreen({
    Key? key,
    required this.description,
    required this.imageurl,
    required this.name,
    required this.localisation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: 320,
                width: double.maxFinite,
                decoration: const BoxDecoration(),
                child: Image.network(
                  imageurl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 300,
              child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Row(
                          children: [
                            const Icon(Icons.location_pin),
                            Text(
                              localisation,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 4, 129, 56),
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0,),
                        Text(
                          description,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.7,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          height:300,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              
                              image: AssetImage("assets/Capture d’écran 2023-06-01 194731.jpg"),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* Center(
        child: Column(
          children: [
            Text(description),
            Image.network(imageurl),
          ],
        ),
      ),*/