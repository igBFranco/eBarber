import 'package:ebarber/screens/home.dart';
import 'package:ebarber/screens/home_adm.dart';
import 'package:ebarber/screens/perfil.dart';
import 'package:ebarber/provider/google_sign_in.dart';
import 'package:ebarber/screens/services.dart';
import 'package:ebarber/screens/services_adm.dart';
import 'package:ebarber/screens/users_adm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuAdm extends StatefulWidget {
  const MenuAdm({Key? key}) : super(key: key);

  @override
  State<MenuAdm> createState() => _MenuAdmState();
}

class _MenuAdmState extends State<MenuAdm> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 250,
            child: DrawerHeader(
              child: Column(
                children: [
                  SizedBox(
                      width: 100,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(user.photoURL!),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Olá,\n',
                          style: TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: user.displayName!,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Perfil()),
                                  );
                                },
                              style: TextStyle(
                                  color: Color(0xFF0DA6DF),
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Home',
              style: TextStyle(
                  color: Color(0xFF0DA6DF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeAdm()),
              );
            },
          ),
          ListTile(
            title: Text(
              'Novo Agendamento',
              style: TextStyle(
                  color: Color(0xFF0DA6DF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Services()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'Lista de Serviços',
              style: TextStyle(
                  color: Color(0xFF0DA6DF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServicesAdm()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text(
              'Usuários',
              style: TextStyle(
                  color: Color(0xFF0DA6DF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersAdm()),
              );
              //Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 250,
          ),
          ListTile(
            visualDensity: VisualDensity(vertical: 4),
            trailing: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset('assets/images/logoMenu.png'),
            ),
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sair',
                style: TextStyle(
                    color: Color(0xFFFF0101),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              modalSair();
            },
          ),
        ],
      ),
    );
  }

  modalSair() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Deseja realmente sair?',
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
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.logout();
                        Navigator.pop(context);
                      },
                      child: Text('Sair'),
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
}
