import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/components/menu_adm.dart';
import 'package:ebarber/screens/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeAdm extends StatefulWidget {
  const HomeAdm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeAdmState();
  }
}

class HomeAdmState extends State<HomeAdm> {
  DateTime? _myDate;
  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  final user = FirebaseAuth.instance.currentUser!;

  modalDeletar(
      {required String id, required dateId, required hour, required clientId}) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Alterar status do Agendamento',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF0DA6DF)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                             await FirebaseFirestore.instance
                                .collection('times')
                                .doc(dateId)
                                .collection('appointment')
                                .doc(id)
                                .update({'appointmentStatus': 2});

                            // await FirebaseFirestore.instance
                            //     .collection('appointments')
                            //     .doc(clientId)
                            //     .collection("user_appointments")
                            //     .doc(id)
                            //     .update({'appointmentStatus': 2});

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Agendamento concluído com sucesso!')));
                            Navigator.pop(context);
                          },
                          child: Text('Concluir'),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF1AD909)),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseFirestore.instance
                                .collection('times')
                                .doc(dateId)
                                .update({
                              '$hour': {
                                'status': "1",
                              },
                            });

                            await FirebaseFirestore.instance
                                .collection('times')
                                .doc(dateId)
                                .collection('appointment')
                                .doc(id)
                                .update({'appointmentStatus': 3});

                            // await FirebaseFirestore.instance
                            //     .collection('appointments')
                            //     .doc(clientId)
                            //     .collection("user_appointments")
                            //     .doc(id)
                            //     .update({'appointmentStatus': 3});

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Agendamento desmarcado com sucesso!')));
                            Navigator.pop(context);
                          },
                          child: Text('Desmarcar'),
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 223, 13, 13)),
                        ),
                      ],
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
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Color(0xFF0DA6DF),
        actions: [
          IconButton(
            onPressed: () async {
              _myDate = await showDatePicker(
                  locale: const Locale('pt', 'BR'),
                  context: context,
                  initialDate: _myDate ?? DateTime.now(),
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025));
              setState(() {
                date = DateFormat('dd-MM-yyyy').format(_myDate!);
              });
              print(date);
            },
            icon: Icon(Icons.date_range),
            tooltip: "Filtrar Agendamentos",
          )
        ],
      ),
      drawer: const MenuAdm(),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text("Agendamentos do dia",
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
              stream: FirebaseFirestore.instance
                  .collection('times')
                  .doc(date)
                  .collection('appointment')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 15),
                            child: ListTile(
                              onLongPress: () {
                                modalDeletar(
                                    id: documentSnapshot.id,
                                    hour: documentSnapshot['hour'],
                                    dateId: documentSnapshot['dateId'],
                                    clientId: documentSnapshot['clientId']);
                              },
                              visualDensity: VisualDensity(vertical: 4),
                              title: Text(
                                documentSnapshot['service']['serviceName'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF666666)),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                            "R\$ ${documentSnapshot['service']['servicePrice']},00",
                                            style: TextStyle(
                                                color: Color(0xFF0DA6DF),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                            "Barber: ${documentSnapshot['barber']}",
                                            style: TextStyle(
                                                color: Color(0xFF0DA6DF),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 3.0),
                                        child: Text(
                                            "Client: ${documentSnapshot['client']}",
                                            style: TextStyle(
                                                color: Color(0xFF0DA6DF),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: SizedBox(
                                height: 220,
                                child: Column(
                                  children: [
                                    Text(documentSnapshot['date'],
                                        style: TextStyle(
                                            color: Color(0xFF666666),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                          "${documentSnapshot['hour']}h",
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
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Color(0xFF1AD909),
                                      )
                                    ] else if (documentSnapshot[
                                            'appointmentStatus'] ==
                                        2) ...[
                                      const Chip(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        label: Text(
                                          "Encerrado",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
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
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                        backgroundColor:
                                            Color.fromARGB(255, 223, 13, 13),
                                      )
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(),
                        ],
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
