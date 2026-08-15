class InventoryModel {
  final String id;
  final String itemName;
  final String category;
  final String location;
  final int quantity;
  final DateTime purchaseDate;
  final String status;

  InventoryModel({
    required this.id,
    required this.itemName,
    required this.category,
    required this.location,
    required this.quantity,
    required this.purchaseDate,
    required this.status,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> data) {
    return InventoryModel(
      id: data['id']?.toString() ?? '',
      itemName: data['itemName'] ?? data['item_name'] ?? 'Unnamed Item',
      category: data['category'] ?? 'Uncategorized',
      location: data['location'] ?? 'Unknown Location',
      quantity: data['quantity'] ?? 0,
      purchaseDate: data['purchaseDate'] != null
          ? DateTime.tryParse(data['purchaseDate']) ?? DateTime.now()
          : (data['purchase_date'] != null
              ? DateTime.tryParse(data['purchase_date']) ?? DateTime.now()
              : DateTime.now()),
      status: data['status'] ?? 'In Stock',
    );
  }
}
