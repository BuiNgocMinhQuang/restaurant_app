import 'package:flutter/material.dart';

class ManagerNotifications extends StatefulWidget {
  const ManagerNotifications({super.key});

  @override
  State<ManagerNotifications> createState() => _ManagerNotificationsState();
}

class _ManagerNotificationsState extends State<ManagerNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thong bao"),
      ),
      body: Container(),
    );
  }
}
