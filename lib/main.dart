import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box ismBox;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  ismBox = await Hive.openBox("ismlarQutisi");
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive '),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Ism kiriting..."),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () {
              setState(() {
                if (txtController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("TextField bosh bo'lmasligi kerak")));
                }
                else{
                  ismBox.add(txtController.text);
                  txtController.clear();
                }
              });
            },
            child: Text("Saqlash"),
            color: Colors.orange,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: ismBox.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    color: Colors.green,
                    margin: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(ismBox.getAt(index)),
                        InkWell(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("O'chirish"),
                                    content:
                                        Text("Rostan ham o'chirmoqchimisiz?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yo'q")),
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              ismBox.deleteAt(index);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text("Ha")),
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
