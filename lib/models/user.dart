import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/models/appointment.dart';

class User {
  String uid;
  String email;
  String name;
  String phone;
  List<Appointment> appointments;

  User(
      {required this.uid,
      required this.email,
      required this.name,
      required this.phone,
      required this.appointments});

  factory User.fromSnapshot(DocumentSnapshot snapshot) {
    final newUser = User.fromJson(snapshot.data() as Map<String, dynamic>);
    newUser.uid = snapshot.reference.id;
    return newUser;
  }

  factory User.fromJson(Map<String, dynamic> json) => _userFromJson(json);
  Map<String, dynamic> toJson() => _userToJson(this);

  @override
  String toString() => 'User<$name>';
}

User _userFromJson(Map<String, dynamic> json) {
  return User(
      uid: json['uid'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      appointments:
          _convertAppointments(json['appointments'] as List<dynamic>));
}

List<Appointment> _convertAppointments(List<dynamic> appointmentMap) {
  final appointments = <Appointment>[];

  for (final appointment in appointmentMap) {
    appointments.add(Appointment.fromJson(appointment as Map<String, dynamic>));
  }
  return appointments;
}

Map<String, dynamic> _userToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'name': instance.name,
      'phone': instance.phone,
      'appointments': _appointmentList(instance.appointments),
    };

List<Map<String, dynamic>>? _appointmentList(List<Appointment>? appointments) {
  if (appointments == null) {
    return null;
  }
  final appointmentMap = <Map<String, dynamic>>[];
  appointments.forEach((appointment) {
    appointmentMap.add(appointment.toJson());
  });
  return appointmentMap;
}
