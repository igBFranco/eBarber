import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final TextEditingController _phoneController = TextEditingController();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future createNewUserOnDatabase([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot == null) {
      await _users.doc(user.uid).set({
        "name": user.displayName,
        "email": user.email,
        "phone": _phoneController.text
      });
    }
    _phoneController.text = '';
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  modalTelefone() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Digite seu número de telefone para mantermos contato!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        createNewUserOnDatabase();
                      },
                      child: Text('Salvar telefone'),
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

  final user = FirebaseAuth.instance.currentUser!;
  createUser() {
    if (user != null) {
      if (user.metadata.creationTime!
              .difference(user.metadata.lastSignInTime!)
              .abs() <
          Duration(seconds: 1)) {
        print('Creating new user in Database');
        modalTelefone();
      } else {
        print('user already created');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(microseconds: 1), () => createUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
