import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'home.dart';

class Test extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String servicePrice;
  final String serviceTime;
  const Test(
      {Key? key,
      required this.serviceId,
      required this.serviceName,
      required this.servicePrice,
      required this.serviceTime})
      : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final CollectionReference _services =
      FirebaseFirestore.instance.collection('services');

  final CollectionReference _teste =
      FirebaseFirestore.instance.collection('teste');

  final user = FirebaseAuth.instance.currentUser!;

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
      'barber': "barber",
      'date': "date"
    });
  }

  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        userEmail: user.email,
        userName: user.displayName,
        userId: user.uid,
        serviceId: widget.serviceId,
        serviceName: widget.serviceName,
        serviceDuration: int.parse(widget.serviceTime),
        servicePrice: int.parse(widget.servicePrice),
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        bookingStart: DateTime(now.year, now.month, now.day, 8, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return FirebaseFirestore.instance.collection('appointments').snapshots();
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    await FirebaseFirestore.instance
        .collection('teste')
        .doc(user.uid)
        .collection("user_appointments")
        .add(newBooking.toJson());

    print('${newBooking.toJson()} has been uploaded');
    print(converted);
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    DateTime first = now;
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));
    return converted;
  }

  List<DateTimeRange> pauseSlots = [
    DateTimeRange(
        start: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 12, 0),
        end: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 13, 0))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione uma data'),
      ),
      body: Center(
        child: BookingCalendar(
          bookingService: mockBookingService,
          convertStreamResultToDateTimeRanges: convertStreamResultMock,
          getBookingStream: getBookingStreamMock,
          uploadBooking: uploadBookingMock,
          pauseSlots: pauseSlots,
          hideBreakTime: false,
          bookedSlotColor: Color(0xFFFF0101),
          bookedSlotText: "Agendado",
          availableSlotColor: Color(0xFFe1e2e3),
          availableSlotText: "Livre",
          selectedSlotText: "Selecionado",
          selectedSlotColor: Color(0xFF0DA6DF),
          pauseSlotText: 'Almoço',
          bookingButtonText: "Agendar",
          bookingButtonColor: Color(0xFF0DA6DF),
          bookingGridCrossAxisCount: 3,
        ),
      ),
    );
  }
}



