import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> words = [];
  List<int> quantity = [];

  var myFontSize = 30.0;
  var imageSource = "images/question-mark.png";
  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(12), child: ListPage()),
      ),
    );
  }

  Widget ListPage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: TextField(
                controller: _itemController,
                decoration: const InputDecoration(
                  hintText: "Item name",
                  border: OutlineInputBorder(),
                  labelText: "Type the item here",
                ),
              ),
            ),

            Flexible(
              child: TextField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  hintText: "Item quantity",
                  border: OutlineInputBorder(),
                  labelText: "Type the quantity here",
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  words.add(_itemController.value.text);
                  quantity.add(int.parse(_quantityController.value.text));
                  _itemController.clear();
                  _quantityController.clear();
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white70),
                foregroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              child: Text("Click here"),
            ),
          ],
        ),

        SizedBox(height: 12),

        words.isEmpty
            ? Text('There are no items in the list')
            : Expanded(
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, rowNumber) {
              return GestureDetector(
                onTap: () {},
                // onDoubleTap: () {
                //   setState(() {
                //     words.removeAt(rowNumber);
                //   });
                //  },
                onLongPress: () {
                  showDialog<String>(
                    context: context,
                    builder:
                        (BuildContext context) => AlertDialog(
                      title: const Text('Delete item'),
                      content: const Text(
                        'Do you want to delete this item?',
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              words.removeAt(rowNumber);
                              quantity.removeAt(rowNumber);
                            });
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white70,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.blue,
                            ),
                          ),
                          child: Text("Yes"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Colors.white70,
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Colors.blue,
                            ),
                          ),
                          child: Text("No"),
                        ),
                      ],
                    ),
                  );
                },
                // onHorizontalDragUpdate: (details) {
                //   if (((details.primaryDelta!) * (details.primaryDelta!)) >
                //       100.0) {
                //     setState(() {
                //       words.removeAt(rowNumber);
                //     });
                //   }
                // },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${rowNumber + 1}: ${words[rowNumber]} quantity: ${quantity[rowNumber]}",
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}