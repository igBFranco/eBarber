import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebarber/models/user.dart';
import 'package:flutter/material.dart';
import 'package:ebarber/repository/data_repository.dart';

class UserTest extends StatefulWidget {
  const UserTest({Key? key}) : super(key: key);

  @override
  State<UserTest> createState() => _UserTestState();
}

class _UserTestState extends State<UserTest> {
  final DataRepository repository = DataRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: repository.getStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data?.docs ?? []);
          }),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      // 2
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

// 3
  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    // 4
    final user = User.fromSnapshot(snapshot);

    return ListTile();
  }
}
