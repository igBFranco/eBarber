import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appointment;
  final DateTime date;
  final String barber;
  final String status;

  Appointment(this.appointment,
      {required this.date, required this.barber, required this.status});

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _appointmentFromJson(json);

  Map<String, dynamic> toJson() => _appointmentToJson(this);

  @override
  String toString() => 'Appointment<$appointment>';
}

Appointment _appointmentFromJson(Map<String, dynamic> json) {
  return Appointment(json['appointment'] as String,
      date: (json['date'] as Timestamp).toDate(),
      barber: json['barber'] as String,
      status: json['status'] as String);
}

Map<String, dynamic> _appointmentToJson(Appointment instance) =>
    <String, dynamic>{
      'appointment': instance.appointment,
      'date': instance.date,
      'barber': instance.barber,
      'status': instance.status,
    };
