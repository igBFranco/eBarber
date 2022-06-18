import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/menu.dart';
import 'package:ebarber/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final TextEditingController _phoneController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final user = FirebaseAuth.instance.currentUser!;

  Future createNewUserOnDatabase([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot == null) {
      await _users.doc(user.uid).set({
        "name": user.displayName,
        "email": user.email,
        "phone": _phoneController.text
      });
    }
    _phoneController.text = '';
    Navigator.pop(context);
  }

  modalDeletar() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Deseja desmarcar o agendamento?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 223, 13, 13)),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Desmarcar'),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF0DA6DF)),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  teste() {
    if (user != null) {
      if (user.metadata.creationTime!
              .difference(user.metadata.lastSignInTime!)
              .abs() <
          Duration(seconds: 1)) {
        print('Creating new user in Database');
        createNewUserOnDatabase();
      } else {
        print('user already created');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 2), () => teste());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Color(0xFF0DA6DF),
      ),
      drawer: Menu(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text("Meus Agendamentos",
                  style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF0DA6DF)),
                  )),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: ListTile(
              onLongPress: () {
                modalDeletar();
              },
              visualDensity: VisualDensity(vertical: 4),
              title: Text(
                "Cabelo",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666)),
              ),
              subtitle: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text("R\$ 30,00",
                        style: TextStyle(
                            color: Color(0xFF0DA6DF),
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              trailing: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Text("06/06/2022",
                        style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text("8:30h",
                          style: TextStyle(
                              color: Color(0xFF0DA6DF),
                              fontWeight: FontWeight.bold)),
                    ),
                    Chip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Text(
                        "Marcado",
                        style: TextStyle(fontSize: 13, color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF1AD909),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Services()),
          )
        },
        tooltip: 'Menu',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF1AD909),
      ),
    );
  }
}
