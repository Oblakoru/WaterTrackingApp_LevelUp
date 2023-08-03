import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kapljica/main.dart';
import 'package:kapljica/nastavitve_page.dart';
//import 'package:file/file.dart';

class MeritvePage extends StatefulWidget {
  const MeritvePage({super.key});

  @override
  State<MeritvePage> createState() => _MeritvePageState();
}

class _MeritvePageState extends State<MeritvePage> {
  @override
  void onDestroy() {
    // Close all open boxes
    Hive.close();
    super.dispose();
  }

  int kolicinaSpiteVode = 0;
  int _sumOfIntakes = 0;

  // ta gleda kakšne so spremembe v textfieldu
  final textEditingController = TextEditingController();
  //Box v katerem se shranjujejo meritve za določen dan - ključ je datum
  Box<int> waterBox = Hive.box('merjenjeVode');
  Box<int> allTimeBox = Hive.box('allTimeBox');

  //Box themeBox = Hive.box('themeBox');

  //funkcija za pridobivanje datuma
  String pridobiDanasnjiDatum() {
    DateTime now = new DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return date.toString();
  }

  // funkcija za pridobivanje količine spite tekočine za določen datum
  int? danesSpitaVoda() {
    if (waterBox.containsKey(pridobiDanasnjiDatum())) {
      return waterBox.get(pridobiDanasnjiDatum());
    } else {
      return 0;
    }
  }

  // ob zagonu strani se izračuna vsota vseh vnosov ter ustvari novi ključ za današnji datum
  @override
  void initState() {
    super.initState();

    //izračun vsote vseh vnosov
    allTimeBox.values.forEach((intake) {
      _sumOfIntakes += intake;
    });

    //če še ni ključa za današnji datum ga ustvari
    if (!waterBox.containsKey(pridobiDanasnjiDatum())) {
      waterBox.put(pridobiDanasnjiDatum(), 0);
      print(pridobiDanasnjiDatum());
    } else {
      kolicinaSpiteVode = danesSpitaVoda()!;
    }
  }

  void izracunVse() {
    _sumOfIntakes = 0;
    allTimeBox.values.forEach((intake) {
      _sumOfIntakes += intake;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromRGBO(246, 244, 235, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(145, 200, 228, 1.0),
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
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/health-potion.png",
                height: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Količina spite vode danes: $kolicinaSpiteVode ml",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                "Lifetime: $_sumOfIntakes ml",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    decoration: TextDecoration.underline),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                child: TextField(
                  controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Vnesi količino vode',
                    suffixIcon: IconButton(
                      onPressed: () => textEditingController.clear(),
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (text) {
                    //kolicinaSpiteVode = int.parse(text);
                    print(text);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  //onPressed: () => setState(() => kolicinaSpiteVode += 250),
                  onPressed: () => {
                        setState(() {
                          try {
                            kolicinaSpiteVode +=
                                int.parse(textEditingController.text);
                            waterBox.put(
                                pridobiDanasnjiDatum(), kolicinaSpiteVode);
                            allTimeBox
                                .add(int.parse(textEditingController.text));
                            _sumOfIntakes +=
                                int.parse(textEditingController.text);
                            print(pridobiDanasnjiDatum());
                          } catch (e) {
                            print("Ojoj!");
                          }
                        })
                      },
                  child: Text("Dodaj količino!"),
                  style: ElevatedButton.styleFrom(fixedSize: Size(200, 50))),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () => setState(() {
                        kolicinaSpiteVode = 0;
                        _sumOfIntakes = 0;
                        waterBox.clear();
                        allTimeBox.clear();
                      }),
                  child: const Text("Reset")),
            ],
          ),
        ),
      )),
    );
  }
}
