import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences pref;
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var sun;

  void onoff() {
    setState(() {
      if (sun == Brightness.dark) {
        sun = Brightness.light;
      } else {
        sun = Brightness.dark;
      }
      saveTheme();
    });
  }

  var counter = 0;
  var sum = 0;
  var salovat = "";
  var index = 0;
  double currentValue = 33;

  List salovatlar = ["SubhanAlloh", "Alhamdulillah", "Allohu Akbar"];

  void add() {
    if (counter == currentValue.toInt()) {
      if (salovatlar.length > 1) {
        index++;
      }
      counter = 0;
    }
    if (index >= salovatlar.length) {
      salovat = "";
      index = 0;
      return;
    }
    salovat = salovatlar[index];
    saveSalovat();
    counter++;
    sum++;
    saveDate();
  }

  void replay() {
    counter = 0;
    sum = 0;
    index = 0;
    if (salovatlar.isNotEmpty) {
      salovat = salovatlar[index];
    } else {
      salovat = "";
    }
    saveSalovat();
    saveDate();
  }

  void changeSalovat(int tartibRaqam) {
    index = tartibRaqam;
    counter = 0;
    salovat = salovatlar[tartibRaqam];
    saveSalovat();
  }

  void showModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String newSalovat = "";
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  onChanged: (value) {
                    newSalovat = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Salovat kiriting",
                    labelStyle: TextStyle(fontFamily: "Regular"),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade900,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    setState(() {
                      salovatlar.add(newSalovat);
                      saveSalovatlar();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text(
                    "Qo'shish",
                    style:
                        TextStyle(color: Colors.white, fontFamily: "Regular"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> saveSalovatlar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("salovatlar", salovatlar.cast<String>());
  }

  Future<void> loadSalovatlar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? saveSalovatlar = prefs.getStringList("salovatlar");
    if (saveSalovatlar != null) {
      setState(() {
        salovatlar = saveSalovatlar;
      });
    }
  }

  Future<void> saveDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("summa", sum);
    prefs.setInt("counter", counter);
  }

  Future<void> loadDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      sum = prefs.getInt("summa") ?? 0;
      counter = prefs.getInt("counter") ?? 0;
    });
  }

  Future<void> saveSalovat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("salovat", salovat);
  }

  Future<void> loadSalovat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      salovat = prefs.getString("salovat") ?? "";
    });
  }

  void saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', sun == Brightness.dark);
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;

    setState(() {
      sun = isDark ? Brightness.dark : Brightness.light;
    });
  }

  void delete(int index) {
    setState(() {
      salovatlar.removeAt(index);
      saveSalovatlar();
      if (salovatlar.length < 1) {
        replay();
      }
    });
  }

  void showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Salovatni o'chirish"),
          content: Text("Haqiqatdan ham bu salovatni o'chirmoqchimisiz?"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Yo'q")),
            TextButton(
                onPressed: () {
                  delete(index);
                  Navigator.of(context).pop();
                },
                child: Text("Ha")),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadSalovatlar();
    loadDate();
    loadTheme();
    loadSalovat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: sun,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 50,
          shadowColor: Colors.black,
          backgroundColor: Colors.green.shade900,
          // centerTitle: true,
          title: const Text(
            "Tasbeh",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Bold",
              fontSize: 28,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                onoff();
              },
              icon: sun == Brightness.dark
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  replay();
                });
              },
              icon: const Icon(Icons.replay),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                showModal();
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/fon.jpeg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 200,
                    child: Text(
                      "$salovat",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontFamily: "Regular",
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(65),
                      border: Border.all(
                        width: 5,
                        color: Colors.green.shade500,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${counter}/${currentValue.toInt()}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "Jami: $sum",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              activeColor: Colors.green.shade900,
              value: currentValue,
              min: 1,
              max: 100,
              label: currentValue.toString(),
              onChanged: (value) {
                setState(() {
                  if (value >= counter) {
                    currentValue = value;
                  } else {
                    currentValue = value;
                    counter = 0;
                  }
                  // if (currentValue == 100) {
                  //   counter = 0;
                  // }
                });
              },
            ),
            Container(
              height: 150,
              child: GridView.builder(
                itemCount: salovatlar.length,
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      showDeleteDialog(index);
                    },
                    onTap: () {
                      setState(() {
                        changeSalovat(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${salovatlar[index]}",
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: "Regular"),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/img.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        fixedSize: const Size(150, 150),
                      ),
                      onPressed: () {
                        setState(() {
                          add();
                          // add2();
                        });
                      },
                      child: Text(
                        "${counter}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
