import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'main.dart';

class ZgodovinaPage extends StatelessWidget {
  ZgodovinaPage({super.key});

   final Box<int> waterBox = Hive.box('merjenjeVode');
   final Box<int> allTimeBox = Hive.box('allTimeBox');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(145, 200, 228, 1.0),
        title: const Text('Zgodovina'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: waterBox.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("${waterBox.getAt(index).toString()} ml " , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              subtitle: Text('${DateFormat('dd-MM-yyyy').format(DateTime.parse(waterBox.keyAt(index)))}',),
              leading: Icon(Icons.water_drop, color: Colors.blueAccent,),
            );
          },
        ),
      ),
    );
  }
}