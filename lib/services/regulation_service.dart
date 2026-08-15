import 'package:flutter/foundation.dart';
import '../shared/services/supabase_service.dart';

class RegulationService {
  static Future<List<Map<String, dynamic>>> fetchRegulations() async {
    try {
      final regulations = await SupabaseService.instance.fetchTable(
        'regulations',
      );
      return regulations.isNotEmpty ? regulations : _fallbackRegulations();
    } catch (e) {
      debugPrint('Error fetching regulations: $e');
      return _fallbackRegulations();
    }
  }

  static Future<Map<String, dynamic>?> fetchRegulationById(
    String regulationId,
  ) async {
    try {
      final regulations = await SupabaseService.instance.fetchTable(
        'regulations',
        filter: 'id.eq.$regulationId',
      );
      return regulations.isNotEmpty ? regulations.first : null;
    } catch (e) {
      debugPrint('Error fetching regulation by ID: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchRegulationsByYear(
    String academicYear,
  ) async {
    try {
      final regulations = await SupabaseService.instance.fetchTable(
        'regulations',
        filter: 'academic_year.eq.$academicYear',
      );
      return regulations.isNotEmpty ? regulations : _fallbackRegulations();
    } catch (e) {
      debugPrint('Error fetching regulations for year: $e');
      return _fallbackRegulations();
    }
  }

  static Future<bool> createRegulation(
    Map<String, dynamic> regulationData,
  ) async {
    try {
      final result = await SupabaseService.instance.insertData(
        'regulations',
        regulationData,
      );
      return result != null;
    } catch (e) {
      debugPrint('Error creating regulation: $e');
      return false;
    }
  }

  static Future<bool> updateRegulation(
    String regulationId,
    Map<String, dynamic> data,
  ) async {
    try {
      return await SupabaseService.instance.updateData(
        'regulations',
        data,
        regulationId,
      );
    } catch (e) {
      debugPrint('Error updating regulation: $e');
      return false;
    }
  }

  static Future<bool> deleteRegulation(String regulationId) async {
    try {
      return await SupabaseService.instance.deleteData(
        'regulations',
        regulationId,
      );
    } catch (e) {
      debugPrint('Error deleting regulation: $e');
      return false;
    }
  }

  static List<Map<String, dynamic>> _fallbackRegulations() => [
      {
        'id': 'reg-001',
        'code': 'R2023',
        'name': 'Regulation 2023',
        'academic_year': '2023-2024',
        'min_attendance': 75,
        'min_passing_marks': 40,
        'status': 'Active',
      },
      {
        'id': 'reg-002',
        'code': 'R2024',
        'name': 'Regulation 2024',
        'academic_year': '2024-2025',
        'min_attendance': 75,
        'min_passing_marks': 40,
        'status': 'Active',
      },
    ];
}
