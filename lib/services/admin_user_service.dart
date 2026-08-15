import '../shared/services/supabase_service.dart';

class AdminUserService {
  static Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final users = await SupabaseService.instance.fetchTable('users');
      return users.isNotEmpty ? users : _fallbackUsers();
    } catch (e) {
      print('Error fetching users: $e');
      return _fallbackUsers();
    }
  }

  static Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    try {
      final users = await SupabaseService.instance.fetchTable(
        'users',
        filter: 'id.eq.$userId',
      );
      return users.isNotEmpty ? users.first : null;
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  static Future<bool> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      return await SupabaseService.instance.updateData('users', data, userId);
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      return await SupabaseService.instance.deleteData('users', userId);
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }

  static Future<bool> updateUserRole(String userId, String role) async {
    try {
      return await SupabaseService.instance.updateData('users', {
        'role': role,
      }, userId);
    } catch (e) {
      print('Error updating user role: $e');
      return false;
    }
  }

  static List<Map<String, dynamic>> _fallbackUsers() => [
      {
        'id': 'admin-001',
        'email': 'admin@ksrce.edu.in',
        'name': 'Admin User',
        'role': 'admin',
        'status': 'Active',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];
}
