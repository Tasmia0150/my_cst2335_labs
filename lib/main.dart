import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_cst2335_labs/dao/shopping_dao.dart';
import 'package:my_cst2335_labs/database.dart';
import 'package:my_cst2335_labs/entity/shopping_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

abstract class ShoppingStorage {
  Future<List<ShoppingItem>> findAllItems();
  Future<void> insertItem(ShoppingItem item);
  Future<void> deleteItem(ShoppingItem item);
}

class DatabaseStorage implements ShoppingStorage {
  late ShoppingDao _dao;
  late ShoppingDatabase _database;

  DatabaseStorage() {
    _initialize();
  }

  Future<void> _initialize() async {
    _database = await $FloorShoppingDatabase
        .databaseBuilder('shopping_database.db')
        .build();
    _dao = _database.shoppingDao;
  }

  @override
  Future<List<ShoppingItem>> findAllItems() => _dao.findAllItems();

  @override
  Future<void> insertItem(ShoppingItem item) => _dao.insertItem(item);

  @override
  Future<void> deleteItem(ShoppingItem item) => _dao.deleteItem(item);
}

class SharedPrefStorage implements ShoppingStorage {
  static const String _key = 'shopping_items';

  @override
  Future<List<ShoppingItem>> findAllItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((item) => ShoppingItem(
      id: item['id'],
      name: item['name'],
      quantity: item['quantity'],
    )).toList();
  }

  @override
  Future<void> insertItem(ShoppingItem item) async {
    final items = await findAllItems();
    final maxId = items.fold<int>(
        0, (max, e) => e.id != null && e.id! > max ? e.id! : max);
    final newId = maxId + 1;
    final newItem = ShoppingItem(id: newId, name: item.name, quantity: item.quantity);
    items.add(newItem);
    await _saveItems(items);
  }

  @override
  Future<void> deleteItem(ShoppingItem item) async {
    final items = await findAllItems();
    items.removeWhere((t) => t.id == item.id);
    await _saveItems(items);
  }

  Future<void> _saveItems(List<ShoppingItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = items.map((item) => {
      'id': item.id,
      'name': item.name,
      'quantity': item.quantity,
    }).toList();
    await prefs.setString(_key, json.encode(jsonList));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ShoppingStorage _storage;
  List<ShoppingItem> items = [];
  ShoppingItem? selectedItem;
  bool _isLoading = true;

  late TextEditingController _itemController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
    _quantityController = TextEditingController();
    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    _storage = kIsWeb ? SharedPrefStorage() : DatabaseStorage();
    await _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final loadedItems = await _storage.findAllItems();
      setState(() {
        items = loadedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading items: $e')),
      );
    }
  }

  Future<void> _addItem() async {
    final name = _itemController.text.trim();
    final quantity = int.tryParse(_quantityController.text);

    if (name.isEmpty || quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid name and quantity')),
      );
      return;
    }

    try {
      final newItem = ShoppingItem(name: name, quantity: quantity);
      await _storage.insertItem(newItem);
      await _loadItems();
      _itemController.clear();
      _quantityController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item: $e')),
      );
    }
  }

  Future<void> _deleteItem(ShoppingItem item) async {
    try {
      await _storage.deleteItem(item);
      await _loadItems();
      if (selectedItem?.id == item.id) {
        setState(() => selectedItem = null);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final isTabletLandscape = (width > height) && (width > 720);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Input fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: "Item name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      hintText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Add Item"),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Responsive layout
            Expanded(
              child: isTabletLandscape
                  ? Row(
                children: [
                  Expanded(flex: 1, child: _buildList()),
                  const VerticalDivider(),
                  Expanded(flex: 2, child: _buildDetailPage()),
                ],
              )
                  : selectedItem == null
                  ? _buildList()
                  : _buildDetailPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return items.isEmpty
        ? const Center(child: Text('No items in the list'))
        : ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text('Quantity: ${item.quantity}'),
          selected: selectedItem?.id == item.id,
          selectedTileColor: Colors.blue[100],
          onTap: () => setState(() => selectedItem = item),
        );
      },
    );
  }

  Widget _buildDetailPage() {
    if (selectedItem == null) {
      return const Center(child: Text("Select an item to view details"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Item Details",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildDetailRow("Name:", selectedItem!.name),
          _buildDetailRow("Quantity:", selectedItem!.quantity.toString()),
          _buildDetailRow("Database ID:", selectedItem!.id.toString()),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _deleteItem(selectedItem!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text("DELETE", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => setState(() => selectedItem = null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text("CLOSE", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}