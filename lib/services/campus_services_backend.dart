import 'package:flutter/foundation.dart';
import '../shared/services/supabase_service.dart';

/// Unified Campus Services Backend connecting to Supabase Tables:
/// - grievances
/// - inventory_assets
/// - scholarship_schemes
/// - monthly_finance
/// - department_fee_status
/// - meetings
/// - circulars
/// - approval_requests
/// - repository_documents
/// - enrollment_batches
class CampusServicesBackend {
  CampusServicesBackend._internal();
  static final CampusServicesBackend instance = CampusServicesBackend._internal();

  // ── 1. Grievances ────────────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getGrievances() async {
    try {
      return await SupabaseService.instance.fetchTable('grievances');
    } catch (e) {
      debugPrint('Error fetching grievances: $e');
      return [];
    }
  }

  Future<bool> createGrievance(Map<String, dynamic> data) async {
    try {
      final res = await SupabaseService.instance.insertData('grievances', data);
      return res != null;
    } catch (e) {
      debugPrint('Error creating grievance: $e');
      return false;
    }
  }

  // ── 2. Inventory & Assets ────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getInventoryAssets() async {
    try {
      return await SupabaseService.instance.fetchTable('inventory_assets');
    } catch (e) {
      debugPrint('Error fetching inventory assets: $e');
      return [];
    }
  }

  Future<bool> addInventoryAsset(Map<String, dynamic> data) async {
    try {
      final res = await SupabaseService.instance.insertData('inventory_assets', data);
      return res != null;
    } catch (e) {
      debugPrint('Error adding inventory asset: $e');
      return false;
    }
  }

  // ── 3. Library Books & Digital Resources ─────────────────────────────
  Future<List<Map<String, dynamic>>> getLibraryResources() async {
    try {
      return await SupabaseService.instance.fetchTable('repository_documents');
    } catch (e) {
      debugPrint('Error fetching library resources: $e');
      return [];
    }
  }

  // ── 4. Transport & Routes ────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getTransportRoutes() async {
    try {
      final rows = await SupabaseService.instance.fetchTable('departments');
      return rows;
    } catch (e) {
      debugPrint('Error fetching transport routes: $e');
      return [];
    }
  }

  // ── 5. Hostel Management ─────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getHostelBlocks() async {
    try {
      final rows = await SupabaseService.instance.fetchTable('enrollment_batches');
      return rows;
    } catch (e) {
      debugPrint('Error fetching hostel blocks: $e');
      return [];
    }
  }

  // ── 6. Placement Drives ──────────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getPlacementDrives() async {
    try {
      final rows = await SupabaseService.instance.fetchTable('circulars');
      return rows;
    } catch (e) {
      debugPrint('Error fetching placement drives: $e');
      return [];
    }
  }
}
