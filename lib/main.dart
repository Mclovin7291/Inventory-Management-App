// Import Flutter package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(InventoryApp());
}

/// The root widget of the Inventory Management Application.
class InventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: InventoryHomePage(title: 'Inventory Home Page'),
    );
  }
}

/// The home page of the inventory management system.
class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _InventoryHomePageState createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _editingItemId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameController.clear();
    _quantityController.clear();
    _editingItemId = null;
  }

  Future<void> _showItemDialog({String? itemId, Map<String, dynamic>? itemData}) async {
    if (itemData != null) {
      _nameController.text = itemData['name'] ?? '';
      _quantityController.text = itemData['quantity']?.toString() ?? '';
      _editingItemId = itemId;
    } else {
      _resetForm();
    }

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_editingItemId != null ? 'Edit Item' : 'Add New Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                errorText: _nameController.text.isEmpty ? 'Name is required' : null,
              ),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(
                labelText: 'Quantity',
                errorText: _quantityController.text.isEmpty ? 'Quantity is required' : null,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _resetForm();
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
                try {
                  setState(() => _isLoading = true);
                  
                  final itemData = {
                    'name': _nameController.text,
                    'quantity': int.parse(_quantityController.text),
                    'timestamp': FieldValue.serverTimestamp(),
                  };

                  if (_editingItemId != null) {
                    await _firestore.collection('inventory').doc(_editingItemId).update(itemData);
                  } else {
                    await _firestore.collection('inventory').add(itemData);
                  }

                  _resetForm();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                } finally {
                  setState(() => _isLoading = false);
                }
              }
            },
            child: _isLoading 
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_editingItemId != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      setState(() => _isLoading = true);
      await _firestore.collection('inventory').doc(itemId).delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting item: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmDelete(String itemId) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteItem(itemId);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('inventory').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data?.docs ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No items found'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showItemDialog(),
                    child: Text('Add First Item'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showItemDialog(
                          itemId: items[index].id,
                          itemData: item,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _confirmDelete(items[index].id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}