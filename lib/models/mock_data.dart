import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/department_model.dart';
import '../models/course_model.dart';
import '../models/regulation_model.dart';
import '../models/misc_models.dart';
import '../models/academic_schedule_model.dart';

import '../services/department_service.dart';

export '../models/user_model.dart';
export '../models/department_model.dart';
export '../models/course_model.dart';
export '../models/regulation_model.dart';
export '../models/misc_models.dart';
export '../models/academic_schedule_model.dart';

final List<UserModel> _initialUsers = [];
final List<DepartmentModel> _initialDepartments = [];
final List<CourseModel> _initialCourses = [];
final List<SubjectModel> _initialSubjects = [];
final List<RegulationModel> _initialRegulations = [];
final List<AcademicCycleModel> _initialAcademicCycles = [];
final List<AuditLogModel> _initialAuditLogs = [];
final List<ReportModel> _initialReports = [];
final List<MedicalAlertModel> _initialMedicalAlerts = [];
final List<EventModel> _initialEvents = [];
final List<AcademicEventModel> _initialAcademicEvents = [];
final List<HolidayModel> _initialHolidays = [];
final List<AcademicMilestoneModel> _initialMilestones = [];
const AcademicScheduleDocModel? _initialScheduleDoc = null;

// Notifiers and Providers

class UsersNotifier extends StateNotifier<List<UserModel>> {

  UsersNotifier([List<UserModel>? initial]) : super(initial ?? []) {
    loadUsersFromSupabase();
  }
  bool isLoading = false;
  String? errorMessage;
  bool isConnectedToSupabase = false;

  Future<void> loadUsersFromSupabase() async {
    isLoading = true;
    errorMessage = null;
    state = [];
    state = _initialUsers;
    isConnectedToSupabase = false;
    isLoading = false;
  }

  Future<void> addUser(UserModel user) async {
    isLoading = true;
    errorMessage = null;
    state = [user, ...state];
    isLoading = false;
  }

  Future<void> updateUser(UserModel user) async {
    state = [
      for (final u in state)
        if (u.id == user.id) user else u,
    ];
  }

  Future<void> deleteUser(String id) async {
    state = state.where((u) => u.id != id).toList();
  }
}

final usersProvider = StateNotifierProvider<UsersNotifier, List<UserModel>>((
  ref,
) => UsersNotifier());

class DepartmentsNotifier extends StateNotifier<List<DepartmentModel>> {
  DepartmentsNotifier([List<DepartmentModel>? initial])
    : super(initial ?? _initialDepartments) {
    loadDepartments();
  }

  Future<void> loadDepartments() async {
    try {
      final data = await DepartmentService.fetchDepartments();
      if (data.isNotEmpty) {
        state = data
            .map(
              (json) => DepartmentModel(
                id:
                    json['id']?.toString() ??
                    json['code']?.toString() ??
                    'DEPT',
                name:
                    json['name']?.toString() ??
                    json['department_name']?.toString() ??
                    'Department',
                code: json['code']?.toString() ?? 'DEPT',
                hod:
                    json['hod']?.toString() ??
                    json['hod_name']?.toString() ??
                    'HOD',
                intakeCapacity:
                    int.tryParse(
                      json['capacity']?.toString() ??
                          json['intake_capacity']?.toString() ??
                          '60',
                    ) ??
                    60,
                status: json['status']?.toString() ?? 'Active',
              ),
            )
            .toList();
      }
    } catch (_) {}
  }

  Future<void> addDepartment(DepartmentModel dept) async {
    state = [...state, dept];
  }

  Future<void> updateDepartment(DepartmentModel dept) async {
    state = [
      for (final d in state)
        if (d.id == dept.id) dept else d,
    ];
  }

  Future<void> deleteDepartment(String id) async {
    state = state.where((d) => d.id != id).toList();
  }
}

final departmentsProvider =
    StateNotifierProvider<DepartmentsNotifier, List<DepartmentModel>>((ref) => DepartmentsNotifier());

class CoursesNotifier extends StateNotifier<List<CourseModel>> {
  CoursesNotifier([List<CourseModel>? initial])
    : super(initial ?? _initialCourses);

  void addCourse(CourseModel course) {
    state = [...state, course];
  }

  void deleteCourse(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final coursesProvider =
    StateNotifierProvider<CoursesNotifier, List<CourseModel>>((ref) => CoursesNotifier());

class SubjectsNotifier extends StateNotifier<List<SubjectModel>> {
  SubjectsNotifier([List<SubjectModel>? initial])
    : super(initial ?? _initialSubjects);

  void addSubject(SubjectModel subject) {
    state = [...state, subject];
  }

  void deleteSubject(String id) {
    state = state.where((s) => s.id != id).toList();
  }
}

final subjectsProvider =
    StateNotifierProvider<SubjectsNotifier, List<SubjectModel>>((ref) => SubjectsNotifier());

class RegulationsNotifier extends StateNotifier<List<RegulationModel>> {
  RegulationsNotifier([List<RegulationModel>? initial])
    : super(initial ?? _initialRegulations) {
    loadRegulations();
  }

  Future<void> loadRegulations() async {
    state = _initialRegulations;
  }

  Future<void> addRegulation(RegulationModel reg) async {
    state = [...state, reg];
  }

  Future<void> deleteRegulation(String id) async {
    state = state.where((r) => r.id != id).toList();
  }
}

final regulationsProvider =
    StateNotifierProvider<RegulationsNotifier, List<RegulationModel>>((ref) => RegulationsNotifier());

class AcademicCyclesNotifier extends StateNotifier<List<AcademicCycleModel>> {
  AcademicCyclesNotifier([List<AcademicCycleModel>? initial])
    : super(initial ?? _initialAcademicCycles);

  void addCycle(AcademicCycleModel cycle) {
    state = [...state, cycle];
  }

  void deleteCycle(String id) {
    state = state.where((c) => c.id != id).toList();
  }
}

final academicCyclesProvider =
    StateNotifierProvider<AcademicCyclesNotifier, List<AcademicCycleModel>>((
      ref,
    ) => AcademicCyclesNotifier());

class AuditLogsNotifier extends StateNotifier<List<AuditLogModel>> {
  AuditLogsNotifier([List<AuditLogModel>? initial])
    : super(initial ?? _initialAuditLogs);
}

final auditLogsProvider =
    StateNotifierProvider<AuditLogsNotifier, List<AuditLogModel>>((ref) => AuditLogsNotifier());

class ReportsNotifier extends StateNotifier<List<ReportModel>> {
  ReportsNotifier([List<ReportModel>? initial])
    : super(initial ?? _initialReports);

  void addReport(ReportModel report) {
    state = [report, ...state];
  }
}

final reportsProvider =
    StateNotifierProvider<ReportsNotifier, List<ReportModel>>((ref) => ReportsNotifier());

class MedicalAlertsNotifier extends StateNotifier<List<MedicalAlertModel>> {
  MedicalAlertsNotifier([List<MedicalAlertModel>? initial])
    : super(initial ?? _initialMedicalAlerts);

  void addAlert(MedicalAlertModel alert) {
    state = [alert, ...state];
  }

  void deleteAlert(String id) {
    state = state.where((a) => a.id != id).toList();
  }
}

final medicalAlertsProvider =
    StateNotifierProvider<MedicalAlertsNotifier, List<MedicalAlertModel>>((
      ref,
    ) => MedicalAlertsNotifier());

class EventsNotifier extends StateNotifier<List<EventModel>> {
  EventsNotifier([List<EventModel>? initial])
    : super(initial ?? _initialEvents);

  void addEvent(EventModel event) {
    state = [event, ...state];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final eventsProvider = StateNotifierProvider<EventsNotifier, List<EventModel>>((
  ref,
) => EventsNotifier());

class AcademicEventsNotifier extends StateNotifier<List<AcademicEventModel>> {
  AcademicEventsNotifier([List<AcademicEventModel>? initial])
    : super(initial ?? _initialAcademicEvents);

  void addEvent(AcademicEventModel event) {
    state = [...state, event];
  }

  void updateEvent(AcademicEventModel event) {
    state = [
      for (final e in state)
        if (e.id == event.id) event else e,
    ];
  }

  void deleteEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void toggleStatus(String id) {
    state = [
      for (final e in state)
        if (e.id == id)
          e.copyWith(
            status: e.status == 'Completed'
                ? 'Upcoming'
                : e.status == 'Upcoming'
                ? 'Ongoing'
                : 'Completed',
          )
        else
          e,
    ];
  }
}

final academicEventsProvider =
    StateNotifierProvider<AcademicEventsNotifier, List<AcademicEventModel>>((
      ref,
    ) => AcademicEventsNotifier());

class AcademicHolidaysNotifier extends StateNotifier<List<HolidayModel>> {
  AcademicHolidaysNotifier([List<HolidayModel>? initial])
    : super(initial ?? _initialHolidays);
}

final academicHolidaysProvider =
    StateNotifierProvider<AcademicHolidaysNotifier, List<HolidayModel>>((ref) => AcademicHolidaysNotifier());

class AcademicMilestonesNotifier
    extends StateNotifier<List<AcademicMilestoneModel>> {
  AcademicMilestonesNotifier([List<AcademicMilestoneModel>? initial])
    : super(initial ?? _initialMilestones);
}

final academicMilestonesProvider =
    StateNotifierProvider<
      AcademicMilestonesNotifier,
      List<AcademicMilestoneModel>
    >((ref) => AcademicMilestonesNotifier());

class AcademicScheduleDocNotifier
    extends StateNotifier<AcademicScheduleDocModel?> {
  AcademicScheduleDocNotifier([AcademicScheduleDocModel? initial])
    : super(initial ?? _initialScheduleDoc);

  void uploadPdf(String pdfFileName, String fileSize, String uploadedBy) {
    state = AcademicScheduleDocModel(
      id: 'DOC-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Academic Calendar 2025-26 (Approved)',
      pdfUrl: 'assets/docs/$pdfFileName',
      pdfFileName: pdfFileName,
      fileSize: fileSize,
      uploadedBy: uploadedBy,
      uploadedAt: DateTime.now().toString().split(' ')[0],
      academicYear: '2025-2026',
    );
  }

  void deletePdf() {
    state = null;
  }
}

final academicScheduleDocProvider =
    StateNotifierProvider<
      AcademicScheduleDocNotifier,
      AcademicScheduleDocModel?
    >((ref) => AcademicScheduleDocNotifier());

// ── Academic Schedule Filter Providers (used by AcademicScheduleScreen) ───────

final academicScheduleSearchQueryProvider =
    StateProvider<String>((ref) => '');

final academicScheduleDeptFilterProvider =
    StateProvider<String>((ref) => 'ALL');

final academicScheduleSemFilterProvider =
    StateProvider<String>((ref) => 'ALL');

final academicScheduleCategoryFilterProvider =
    StateProvider<String>((ref) => 'ALL');

final academicScheduleStatusFilterProvider =
    StateProvider<String>((ref) => 'ALL');

/// Derived provider: returns filtered list of AcademicEventModel
final filteredAcademicEventsProvider =
    Provider<List<AcademicEventModel>>((ref) {
  final events = ref.watch(academicEventsProvider);
  final search = ref.watch(academicScheduleSearchQueryProvider).toLowerCase();
  final dept = ref.watch(academicScheduleDeptFilterProvider);
  final sem = ref.watch(academicScheduleSemFilterProvider);
  final category = ref.watch(academicScheduleCategoryFilterProvider);
  final status = ref.watch(academicScheduleStatusFilterProvider);

  return events.where((e) {
    if (search.isNotEmpty &&
        !e.title.toLowerCase().contains(search) &&
        !e.description.toLowerCase().contains(search) &&
        !e.venue.toLowerCase().contains(search)) {
      return false;
    }
    if (dept != 'ALL' && e.department != dept) return false;
    if (sem != 'ALL' && e.semester != sem) return false;
    if (category != 'ALL' && e.category != category) return false;
    if (status != 'ALL' && e.status != status) return false;
    return true;
  }).toList();
});
