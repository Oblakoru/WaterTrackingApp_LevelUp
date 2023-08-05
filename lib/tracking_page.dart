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
  int dailyGoal = 0;

  // ta gleda kakšne so spremembe v textfieldu
  final textEditingController = TextEditingController();
  final goalEditingController = TextEditingController();

  //Box v katerem se shranjujejo meritve za določen dan - ključ je datum
  Box<int> waterBox = Hive.box('merjenjeVode');
  Box<int> allTimeBox = Hive.box('allTimeBox');
  Box goalBox = Hive.box('goalBox');

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

    if (!goalBox.containsKey('goal')) {
      goalBox.put('goal', 2000);
      dailyGoal = 2000;
    } else {
      pridobiGoal();
    }

    //če še ni ključa za današnji datum ga ustvari
    if (!waterBox.containsKey(pridobiDanasnjiDatum())) {
      waterBox.put(pridobiDanasnjiDatum(), 0);
      print(pridobiDanasnjiDatum());
    } else {
      kolicinaSpiteVode = danesSpitaVoda()!;
    }
  }

  @override
  void didPop() {
    // This is called when the user navigates back to this page.
    // Reset the state here.
    setState(() {
      kolicinaSpiteVode = danesSpitaVoda()!;
      allTimeBox.values.forEach((intake) {
        _sumOfIntakes += intake;
      });
    });
  }

  void izracunVse() {
    _sumOfIntakes = 0;
    allTimeBox.values.forEach((intake) {
      _sumOfIntakes += intake;
    });
  }

  void pridobiGoal() {
    if (goalBox.containsKey('goal')) {
      setState(() {
        dailyGoal = goalBox.get('goal');
      });
    }
  }

  void nastaviGoal() {
    if (goalEditingController.text != '') {
      goalBox.put('goal', int.parse(goalEditingController.text));
      pridobiGoal();
      print(dailyGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
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
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/health-potion.png",
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "$kolicinaSpiteVode/$dailyGoal ml",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                width: 300,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                  tween: Tween<double>(
                    begin: 0,
                    end: kolicinaSpiteVode / dailyGoal,
                  ),
                  builder: (context, value, _) =>
                      LinearProgressIndicator(value: value, color: Colors.blue, backgroundColor: Colors.grey, minHeight: 15,),
                ),
                //child: TweenAnimationBuilder<double>(
                //  duration: const Duration(milliseconds: 500),
                //  curve: Curves.linear,
                //  tween: Tween<double>(
                //    begin: 0,
                //    end: kolicinaSpiteVode / dailyGoal,
                //  ),
                //  builder: (context, value, _) => LinearProgressIndicator(
                //    minHeight: 15,
                //    value: kolicinaSpiteVode / dailyGoal,
                //    backgroundColor: Colors.grey,
                //    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                //  ),
                //),
              ),
              const SizedBox(
                height: 20,
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
                  style: ElevatedButton.styleFrom(fixedSize: Size(200, 50)),
                  child: const Text("Dodaj količino!")),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Spremeni cilj"),
                                  content: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: goalEditingController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                        hintText: "Vnesi svoj cilj!"),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          nastaviGoal();
                                          print(dailyGoal);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Submit",
                                        ))
                                  ],
                                ));
                      },
                      child: const Text("Spremeni cilj")),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () => setState(() {
                            kolicinaSpiteVode = 0;
                            _sumOfIntakes = 0;
                            waterBox.clear();
                            allTimeBox.clear();
                          }),
                      //onPressed: () => setState(() {
                      //      kolicinaSpiteVode = 0;
                      //      _sumOfIntakes = 0;
                      //      waterBox.get(waterBox.keys.last);
                      //      waterBox.deleteAt(allTimeBox.length - 1);
                      //      allTimeBox.add(allTimeBox.length - 1);
                      //    }),
                      child: const Text("Reset")),
                ],
              ),
              Padding( // this is new
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
            ),
            ],
          ),
        ),
      )),
    );
  }
}
