import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/components/menu.dart';
import 'package:ebarber/screens/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser!;

  final _appointments = FirebaseFirestore.instance
      .collection('appointments')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("user_appointments")
      .orderBy('date', descending: false);

  modalDeletar({required String id}) {
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
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(user.uid)
                            .collection("user_appointments")
                            .doc(id)
                            .update({'appointmentStatus': 3});

                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Agendamento desmarcado com sucesso!')));
                      },
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
          Expanded(
            child: StreamBuilder(
              stream: _appointments.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Container(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: ListTile(
                          onLongPress: () {
                            modalDeletar(id: documentSnapshot.id);
                          },
                          visualDensity: VisualDensity(vertical: 4),
                          title: Text(
                            documentSnapshot['service']['serviceName'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF666666)),
                          ),
                          subtitle: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    "R\$ ${documentSnapshot['service']['servicePrice']},00",
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
                                Text(documentSnapshot['date'],
                                    style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4.0),
                                  child: Text("${documentSnapshot['hour']}h",
                                      style: TextStyle(
                                          color: Color(0xFF0DA6DF),
                                          fontWeight: FontWeight.bold)),
                                ),
                                if (documentSnapshot['appointmentStatus'] ==
                                    1) ...[
                                  const Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      "Marcado",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xFF1AD909),
                                  )
                                ] else if (documentSnapshot[
                                        'appointmentStatus'] ==
                                    2) ...[
                                  Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      "Encerrado",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xFF666666),
                                  )
                                ] else ...[
                                  const Chip(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    label: Text(
                                      "Cancelado",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.white),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 223, 13, 13),
                                  )
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
