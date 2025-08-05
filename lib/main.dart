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
  ShoppingItem? selectedItem;
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
        actions: [
          if (selectedItem != null)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => setState(() => selectedItem = null),
            ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _reactiveLayout(context),
        ),
      ),
    );
  }

  Widget _reactiveLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = (size.width > size.height) && (size.width > 720);

    if (isTablet) {
      return Row(
        children: [
          Expanded(
            flex: 4,
            child: _buildListPage(),
          ),
          Expanded(
            flex: 6,
            child: _buildDetailsPage(),
          ),
        ],
      );
    } else {
      return selectedItem == null ? _buildListPage() : _buildDetailsPage();
    }
  }

  Widget _buildDetailsPage() {
    if (selectedItem == null) {
      return Center(child: Text("Select an item"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Item Name: ${selectedItem!.name}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text("Quantity: ${selectedItem!.quantity}",
              style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text("Database ID: ${selectedItem!.id}",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _itemDao.deleteItem(selectedItem!);
              setState(() {
                items.remove(selectedItem);
                selectedItem = null;
              });
            },
            child: Text("Delete"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
          if (MediaQuery.of(context).size.width <= 720) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() => selectedItem = null),
              child: Text("Close"),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListPage() {
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
                backgroundColor: WidgetStateProperty.all(Colors.white70),
                foregroundColor: WidgetStateProperty.all(Colors.purple),
              ),
              child: const Text("Add Item"),
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
              return ListTile(
                onTap: () => setState(() => selectedItem = items[rowNumber]),
                title: Text("${rowNumber + 1}: ${items[rowNumber].name}"),
                subtitle: Text("Quantity: ${items[rowNumber].quantity}"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete item'),
                        content: const Text('Do you want to delete this item?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              _itemDao.deleteItem(items[rowNumber]);
                              setState(() {
                                items.removeAt(rowNumber);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
