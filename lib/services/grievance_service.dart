import 'package:admin_module/models/grievance_model.dart';
import 'package:admin_module/shared/services/supabase_service.dart';

class GrievanceService {
  static Future<List<GrievanceModel>> fetchGrievances() async {
    try {
      final data = await SupabaseService.instance.fetchTable('grievances');
      if (data.isEmpty) return _fallbackGrievances();
      return data.map((row) => GrievanceModel.fromJson(row)).toList();
    } catch (e) {
      return _fallbackGrievances();
    }
  }

  static List<GrievanceModel> _fallbackGrievances() {
    return [
      GrievanceModel.fromJson({
        'id': '1',
        'grievance_id': 'GRV-2026-001',
        'submitted_by': 'S. Priya (23CSE045)',
        'category': 'Academic',
        'details':
            'Internal marks for subject CS8591 are not updated correctly in the portal.',
        'submission_date': '2026-08-10T14:30:00Z',
        'status': 'Open',
        'assigned_to': 'Dr. Ramesh (HOD-CSE)',
      }),
      GrievanceModel.fromJson({
        'id': '2',
        'grievance_id': 'GRV-2026-002',
        'submitted_by': 'K. Arjun (24ECE012)',
        'category': 'Hostel',
        'details':
            'Water purifier in B-Block is not functional for the past 3 days.',
        'submission_date': '2026-08-12T09:00:00Z',
        'status': 'In Progress',
        'assigned_to': 'Mr. John Doe (Warden)',
      }),
      GrievanceModel.fromJson({
        'id': '3',
        'grievance_id': 'GRV-2026-003',
        'submitted_by': 'Faculty ID: F-IT-04',
        'category': 'Transport',
        'details':
            'Bus route #5 is consistently arriving 15 minutes late in the morning.',
        'submission_date': '2026-08-14T11:20:00Z',
        'status': 'Resolved',
        'assigned_to': 'Transport Manager',
      }),
    ];
  }
}
