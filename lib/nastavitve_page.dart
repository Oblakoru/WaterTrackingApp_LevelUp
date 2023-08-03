import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'main.dart';

class NastavitvePage extends StatelessWidget {
  NastavitvePage({super.key});

   final Box<int> waterBox = Hive.box('merjenjeVode');
   final Box<int> allTimeBox = Hive.box('allTimeBox');

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(145, 200, 228, 1.0),
        title: const Text('Nastavitve'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                  child: Text(
                "LevelUp",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              )),
            ),
            ListTile(
              title: const Text("Domov"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const MyApp();
                    },
                  ),
                );
              },
              leading: const Icon(
                Icons.home,
                color: Colors.lightBlueAccent,
              ),
            ),
            ListTile(
              title: Text("Zgodovina"),
              onTap: () => print("Zgodovina"),
              leading: const Icon(
                Icons.favorite,
                color: Colors.pinkAccent,
              ),
            ),
            ListTile(
              title: const Text("Nastavitve"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return NastavitvePage();
                    },
                  ),
                );
              },
              leading: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Center(
        
        child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
          ElevatedButton(onPressed: () {
            waterBox.clear();
            allTimeBox.clear();
            print("Izbrisano");
          }, child: const Text("Ponastavi vse"))
        ],),
      ),
    );
  }
}