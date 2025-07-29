import 'package:flutter/material.dart';
import 'package:my_cst2335_labs/dao/shopping_dao.dart';
import 'package:my_cst2335_labs/database.dart';
import 'package:my_cst2335_labs/entity/shopping_item.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Shopping List App'),
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
  List<ShoppingItem> items = [];

  late ShoppingDao _itemDao;
  late var dbItems;

  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
    setUpDatabase();
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> setUpDatabase() async {
    final database =
    await $FloorShoppingDatabase.databaseBuilder('shopping_database.db').build();

    _itemDao = database.shoppingDao;
    dbItems = await _itemDao.findAllItems();

    setState(() {
      items = dbItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListPage(),
        ),
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
                  labelText: "Type the item name here",
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
                  var item = _itemController.text.trim();
                  int? quantity = int.tryParse(_quantityController.text);

                  if (item.isNotEmpty && quantity != null) {
                    var addItem = ShoppingItem(
                      ShoppingItem.ID++,
                      item,
                      quantity,
                    );
                    items.add(addItem);

                    _itemDao.insertItem(addItem);
                  } else {
                    final snackBar = SnackBar(
                      content: Text('Empty or Invalid Item name/Quantity.'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  _itemController.clear();
                  _quantityController.clear();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white70),
                foregroundColor: MaterialStateProperty.all(Colors.purple),
              ),
              child: const Text("Click here"),
            ),
          ],
        ),

        const SizedBox(height: 12),

        items.isEmpty
            ? const Text('There are no items in the list')
            : Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, rowNumber) {
              return GestureDetector(
                onLongPress: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Delete item'),
                      content: const Text(
                        'Do you want to delete this item?',
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            _itemDao.deleteItem(items[rowNumber]);

                            setState(() {
                              items.removeAt(rowNumber);
                            });
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white70,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.blue,
                            ),
                          ),
                          child: const Text("Yes"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white70,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.blue,
                            ),
                          ),
                          child: const Text("No"),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${rowNumber + 1}: ${items[rowNumber].name} quantity: ${items[rowNumber].quantity}",
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
