import 'package:ebarber/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebarber/screens/times.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Services extends StatefulWidget {
  const Services({Key? key}) : super(key: key);

  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agendar',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Color(0xFF0DA6DF),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text("Serviços",
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
              stream: _services.snapshots(),
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
                            height: 80,
                            child: ListTile(
                              title: Text(
                                documentSnapshot['name'],
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF666666)),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                      "R\$ ${documentSnapshot['price'].toString()},00",
                                      style: TextStyle(
                                          color: Color(0xFF0DA6DF),
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      "${documentSnapshot['time'].toString()}min")
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Times(
                                              serviceId: documentSnapshot.id,
                                              serviceName:
                                                  documentSnapshot['name'],
                                              servicePrice:
                                                  documentSnapshot['price']
                                                      .toString(),
                                              serviceTime:
                                                  documentSnapshot['time']
                                                      .toString(),
                                            )),
                                  );
                                },
                                child: Text("Agendar"),
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
      /*floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
