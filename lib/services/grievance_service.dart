import 'package:admin_module/models/grievance_model.dart';
import 'package:admin_module/shared/services/supabase_service.dart';

class GrievanceService {
  static Future<List<GrievanceModel>> fetchGrievances() async {
    try {
      final data = await SupabaseService.instance.fetchTable('grievances');
      return data.map((row) => GrievanceModel.fromJson(row)).toList();
    } catch (e) {
      print('Error fetching grievances: $e');
      return [];
    }
  }

  static Future<GrievanceModel?> createGrievance(GrievanceModel grievance) async {
    try {
      final inserted = await SupabaseService.instance.insertData('grievances', grievance.toJson());
      if (inserted != null) {
        return GrievanceModel.fromJson(inserted);
      }
    } catch (e) {
      print('Error creating grievance: $e');
    }
    return null;
  }
}
