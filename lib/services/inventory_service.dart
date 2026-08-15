import 'package:admin_module/models/inventory_model.dart';
import 'package:admin_module/shared/services/supabase_service.dart';

class InventoryService {
  static Future<List<InventoryModel>> fetchInventory() async {
    try {
      final data =
          await SupabaseService.instance.fetchTable('inventory_assets');
      if (data.isEmpty) return _fallbackInventory();
      return data.map((row) => InventoryModel.fromJson(row)).toList();
    } catch (e) {
      return _fallbackInventory();
    }
  }

  static List<InventoryModel> _fallbackInventory() {
    return [
      InventoryModel.fromJson({
        'id': '1',
        'item_name': 'Dell Latitude 5420 Laptop',
        'category': 'Electronics',
        'location': 'CSE Department Office',
        'quantity': 15,
        'purchase_date': '2025-08-20T00:00:00Z',
        'status': 'In Use',
      }),
      InventoryModel.fromJson({
        'id': '2',
        'item_name': 'Classroom Projector (Epson)',
        'category': 'Electronics',
        'location': 'ECE Block - Room 204',
        'quantity': 1,
        'purchase_date': '2024-07-15T00:00:00Z',
        'status': 'Under Maintenance',
      }),
      InventoryModel.fromJson({
        'id': '3',
        'item_name': 'Wooden Student Desks',
        'category': 'Furniture',
        'location': 'Central Warehouse',
        'quantity': 50,
        'purchase_date': '2026-06-10T00:00:00Z',
        'status': 'In Stock',
      }),
    ];
  }
}
