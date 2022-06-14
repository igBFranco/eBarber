import 'package:ebarber/menu.dart';
import 'package:ebarber/models/task.dart';
import 'package:ebarber/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  static final titleController = TextEditingController();
  static final descriptionController = TextEditingController();

  final list = [];

  void remove(index) {
    setState(() {
      list.removeAt(index);
    });
  }

  save() {
    Task task = Task(titleController.text, descriptionController.text);
    setState(() {
      list.add(task);
    });

    titleController.clear();
    descriptionController.clear();

    Navigator.of(context).pop();
  }

  add() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Adicionar nova Tarefa'),
            content: SizedBox(
              height: 200,
              width: 200,
              child: Column(children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                )
              ]),
            ),
            actions: [
              Center(
                child: RaisedButton(
                  onPressed: () {
                    save();
                  },
                  child: Text('Salvar'),
                  color: Color(0xFFFE6847),
                ),
              ),
            ],
          );
        });
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
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.all(15),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 80,
                    //decoration: BoxDecoration(
                    //    color: Color(0xFFBCBFC1),
                    //    borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(list[index].title),
                      subtitle: Text(list[index].description),
                      trailing: IconButton(
                          onPressed: () {
                            remove(index);
                          },
                          icon: Icon(Icons.delete)),
                      iconColor: Color(0xFFFE6847),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemCount: list.length),
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
        ),
        backgroundColor: Color(0xFF1AD909),
      ),
    );
  }
}
