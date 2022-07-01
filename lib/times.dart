import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'home.dart';

class Times extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;
  final String serviceTime;
  const Times(
      {Key? key,
      required this.serviceId,
      required this.serviceName,
      required this.servicePrice,
      required this.serviceTime})
      : super(key: key);

  @override
  State<Times> createState() => _TimesState();
}

class _TimesState extends State<Times> {
  List<bool> isSelected = [
    false,
    false,
    false,
  ];
  DateTime? _myDate;
  String date = "Selecione uma data";
  List<String> barbers = [
    "Felipe",
    "Alan",
    "Luigi",
  ];

  String barber = "";

  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');

  final user = FirebaseAuth.instance.currentUser!;

  confirm() {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              'Confirmar Agendamento?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 200,
              width: 200,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    "Segunda,\n06 de junho de 2022",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "8:30",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Color(0xFF0DA6DF),
                      ),
                      minimumSize: Size(80, 35)),
                ),
              ]),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                      child: Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 223, 13, 13)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addAppointment();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Text('Confirmar'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 90, 223, 13)),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  addAppointment() async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(user.uid)
        .collection("user_appointments")
        .add({
      'service': {
        'serviceId': widget.serviceId,
        'serviceName': widget.serviceName,
        'servicePrice': widget.servicePrice,
      },
      'status': 1,
      'barber': barber,
      'date': date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Horários',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Color(0xFF0DA6DF),
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            //decoration: BoxDecoration(
            //    color: Color(0xFFBCBFC1),
            //    borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              title: Text(
                widget.serviceName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF666666)),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Column(
                    children: [
                      Text("R\$${widget.servicePrice},00",
                          style: TextStyle(
                              color: Color(0xFF0DA6DF),
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Text("${widget.serviceTime}min"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Divider(),
                  SizedBox(
                    child: Text("Selecione o Profissional:",
                        style: GoogleFonts.lexend(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF0DA6DF)),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Center(
                        child: ToggleButtons(
                          isSelected: isSelected,
                          selectedColor: Colors.white,
                          fillColor: Color(0xFF0DA6DF),
                          color: Color(0xFF0DA6DF),
                          borderWidth: 1,
                          borderColor: Color(0xFF0DA6DF),
                          selectedBorderColor: Color(0xFF0DA6DF),
                          borderRadius: BorderRadius.circular(5),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                barbers[0],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                barbers[1],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                barbers[2],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                          onPressed: (int newIndex) {
                            setState(() {
                              for (int index = 0;
                                  index < isSelected.length;
                                  index++) {
                                if (index == newIndex) {
                                  isSelected[index] = true;
                                  barber = barbers[index];
                                } else {
                                  isSelected[index] = false;
                                }
                              }
                              print(barber);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF0DA6DF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            onPressed: () async {
                              _myDate = await showDatePicker(
                                  context: context,
                                  initialDate: _myDate ?? DateTime.now(),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2025));

                              setState(() {
                                date =
                                    DateFormat('dd/MM/yyyy').format(_myDate!);
                              });
                            },
                            child: Text(
                              "Selecionar Data",
                              style: TextStyle(fontSize: 16),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            date,
                            style: GoogleFonts.lexend(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xFF666666)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF0DA6DF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              onPressed: () async {
                                await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                              },
                              child: Text(
                                "Selecionar Hora",
                                style: TextStyle(fontSize: 16),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              date,
                              style: GoogleFonts.lexend(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFF666666)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        confirm();
                      },
                      child: Text(
                        "Agendar",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
