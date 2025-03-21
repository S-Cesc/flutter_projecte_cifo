import 'package:flutter/material.dart';

class Meals4pillsScreen extends StatefulWidget {
  const Meals4pillsScreen({super.key});

  @override
  State<Meals4pillsScreen> createState() => _Meals4pillsScreenState();
} // Meals4pillsScreen 

class _Meals4pillsScreenState extends State<Meals4pillsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals4Pills'),
      ), // AppBar
      body: Center(
        child: Text('Meals4Pills'),
      ), // Center
    ); // Scaffold
  } // build

} // _Meals4pillsScreenState
