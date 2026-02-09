import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class InventoryService extends ChangeNotifier {
  static final InventoryService _instance = InventoryService._internal();
  
  factory InventoryService() {
    return _instance;
  }

  InventoryService._internal();

  final List<InventoryItem> _items = [];

  List<InventoryItem> get items => List.unmodifiable(_items);

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  int get totalItems => _items.length;
}
