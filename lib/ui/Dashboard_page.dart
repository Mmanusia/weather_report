import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dashboard aplikasi",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.red)
        ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ini app bar"),
        ),
      ),
    );
  }
}
