import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicesAdm extends StatefulWidget {
  const ServicesAdm({Key? key}) : super(key: key);

  @override
  _ServicesAdmState createState() => _ServicesAdmState();
}

class _ServicesAdmState extends State<ServicesAdm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
      _timeController.text = documentSnapshot['time'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Serviço'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                  ),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  controller: _timeController,
                  decoration: const InputDecoration(
                    labelText: 'Tempo',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Adicionar' : 'Atualizar'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final int? price = int.tryParse(_priceController.text);
                    final int? time = int.tryParse(_timeController.text);
                    if (name != null && price != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _services
                            .add({"name": name, "price": price, "time": time});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _services.doc(documentSnapshot!.id).update(
                            {"name": name, "price": price, "time": time});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _priceController.text = '';
                      _timeController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(String serviceId) async {
    await _services.doc(serviceId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Serviço deletado com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Serviços',
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
              child: Row(
                children: [
                  Text("Serviços",
                      style: GoogleFonts.lexend(
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF0DA6DF)),
                      )),
                ],
              ),
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
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _createOrUpdate(documentSnapshot);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _deleteProduct(documentSnapshot.id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 223, 13, 13),
                                      ),
                                    ),
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
        onPressed: () => _createOrUpdate(),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xFF1AD909),
      ),
    );
  }
}
