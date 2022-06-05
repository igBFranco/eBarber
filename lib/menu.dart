import 'package:ebarber/home.dart';
import 'package:ebarber/services.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0DA6DF)),
            child: Text(
              'Olá, ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
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
                MaterialPageRoute(builder: (context) => Home()),
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
            title: Text(
              'Sobre a Barbearia',
              style: TextStyle(
                  color: Color(0xFF0DA6DF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 350,
          ),
          ListTile(
            visualDensity: VisualDensity(vertical: 4),
            trailing: Image.asset('assets/images/logoMenu.png'),
            title: Text(
              'Sair',
              style: TextStyle(
                  color: Color(0xFFFF0101),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
