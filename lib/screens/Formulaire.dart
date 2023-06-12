import 'package:flutter/material.dart';

class Formulaire extends StatefulWidget {
  const Formulaire({Key? key}) : super(key: key);

  @override
  _FormulaireState createState() => _FormulaireState();
}

class _FormulaireState extends State<Formulaire> {
  String? _name;
  String? _surname;
  int _age = 0;
  int _numPeople = 0;
  String? _questionnaire;

  final TextEditingController _numPeopleController = TextEditingController();

  @override
  void dispose() {
    _numPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 167, 211, 255),
        title: const Text(
          'Nguidik',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 6, 30),
            fontFamily: 'Lobster',
            letterSpacing: 0.7,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Nom'),
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Prenom'),
                onChanged: (value) {
                  setState(() {
                    _surname = value;
                  });
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _age = int.tryParse(value) ?? 0;
                  });
                },
              ),
              Row(
           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nombre de personne                          ',style: TextStyle(fontSize: 17, color: Colors.black54),),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_numPeople > 0) {
                          _numPeople--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_numPeople'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numPeople++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Divider(thickness: 1,color: Colors.black45,),
                 Row(
           //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nombre d\'enfants                                 ',style: TextStyle(fontSize: 17, color: Colors.black54),),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_numPeople > 0) {
                          _numPeople--;
                        }
                      });
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_numPeople'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numPeople++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Divider(thickness: 1,color: Colors.black45,),
              TextField(
                decoration: const InputDecoration(labelText: 'Est-ce que vous avez des questions'),
                onChanged: (value) {
                  setState(() {
                    _questionnaire = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 188, 229, 255),
                  minimumSize: const Size(40, 40),
                ),
                onPressed: () {
                  // Do something with the form data
                  print('Name: $_name');
                  print('Surname: $_surname');
                  print('Age: $_age');
                  print('Number of People: $_numPeople');
                  print('Questionnaire: $_questionnaire');
                },
                child: const Text(
                  'Réserver',
                  style: TextStyle(color: Colors.black, fontSize: 16, letterSpacing: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
