class InventoryItem {
  final String id;
  final String name;
  final String category;
  final double quantity;
  final String unit;
  final DateTime dateAdded;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.dateAdded,
  });
}
