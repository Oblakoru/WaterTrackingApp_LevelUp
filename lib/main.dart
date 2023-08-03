import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kapljica/tracking_page.dart';

void main() async {

  //init hive
  await Hive.initFlutter();

  // open box - represenrs the database
  Box<int> waterBox = await Hive.openBox('merjenjeVode');
  Box<int> allTimeBox = await Hive.openBox('allTimeBox');
 // Box themeBox = await Hive.openBox('themeBox');




  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kapljica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        //primaryColor: Color,
        //useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(246, 244, 235, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(145, 200, 228, 1.0),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LevelUp",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 40,
            ),
            Image.asset(
              "images/mana-potion.png",
              height: 200,
            ),
            const SizedBox(
              height: 25,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "LevelUp je aplikacija, ki ti bo pomagala spiti dovolj vode",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) {return const MeritvePage();}
              )),
              style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
              child: const Text("Začnimo!"),
            ),
          ],
        ),
      ),
    );
  }
}
