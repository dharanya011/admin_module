import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router/route_names.dart';
import '../pages/academic_config_screen.dart';
import '../pages/academic_schedule_screen.dart';
import '../pages/academic_year_screen.dart';
import '../pages/approval_workflow_screen.dart';
import '../pages/attendance_screen.dart';
import '../pages/audit_logs_screen.dart';
import '../pages/backup_restore_screen.dart';
import '../pages/department_list_screen.dart';
import '../pages/digital_repository_screen.dart';
import '../pages/event_management_screen.dart';
import '../pages/examination_management_screen.dart';
import '../pages/grievance_management_screen.dart';

import '../pages/hostel_management_screen.dart';
import '../pages/hr_payroll_screen.dart';
import '../pages/inventory_assets_screen.dart';
import '../pages/library_management_screen.dart';
import '../pages/marks_screen.dart';
import '../pages/my_profile_screen.dart';
import '../pages/notification_management_screen.dart';
import '../pages/placement_management_screen.dart';
import '../pages/programmes_screen.dart';
import '../pages/programmes_subjects_screen.dart';
import '../pages/regulations_screen.dart';
import '../pages/results_screen.dart';
import '../pages/roles_permissions_screen.dart';
import '../pages/super_admin_dashboard_screen.dart';
import '../pages/system_settings_screen.dart';
import '../pages/transport_management_screen.dart';
import '../pages/user_detail_screen.dart';
import '../pages/user_edit_form.dart';
import '../pages/user_list_screen.dart';
import '../widgets/app_scaffold.dart';
import 'dashboard_screen.dart';

// Global navigator keys for GoRouter
final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteNames.dashboard,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppScaffold(child: child, currentLocation: state.uri.path);
      },
      routes: [
        // 1. Overview
        GoRoute(
          path: RouteNames.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),

        // 2. Academic Management
        GoRoute(
          path: RouteNames.academicYear,
          builder: (context, state) => const AcademicYearScreen(),
        ),
        GoRoute(
          path: RouteNames.departments,
          builder: (context, state) => const DepartmentListScreen(),
        ),
        GoRoute(
          path: RouteNames.programmesSubjects,
          builder: (context, state) => const ProgrammesSubjectsScreen(),
        ),
        GoRoute(
          path: RouteNames.programmes,
          builder: (context, state) => const ProgrammesScreen(),
        ),
        GoRoute(
          path: RouteNames.regulations,
          builder: (context, state) => const RegulationsScreen(),
        ),
        GoRoute(
          path: RouteNames.academicConfig,
          builder: (context, state) => const AcademicConfigScreen(),
        ),
        GoRoute(
          path: RouteNames.timetable,
          builder: (context, state) => const AcademicScheduleScreen(),
        ),
        GoRoute(
          path: RouteNames.academicSchedule,
          builder: (context, state) => const AcademicScheduleScreen(),
        ),

        // 3. User Management
        GoRoute(
          path: RouteNames.users,
          builder: (context, state) => const UserListScreen(),
        ),
        GoRoute(
          path: RouteNames.students,
          builder: (context, state) => const UserListScreen(),
        ),
        GoRoute(
          path: RouteNames.faculty,
          builder: (context, state) => const UserListScreen(),
        ),
        GoRoute(
          path: RouteNames.userDetail,
          builder: (context, state) => UserDetailScreen(
            userId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(
          path: RouteNames.userEdit,
          builder: (context, state) => UserEditForm(
            userId: state.pathParameters['id'] ?? '',
          ),
        ),

        // 4. Academic Operations
        GoRoute(
          path: RouteNames.attendance,
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          path: RouteNames.marks,
          builder: (context, state) => const MarksScreen(),
        ),
        GoRoute(
          path: RouteNames.examinations,
          builder: (context, state) => const ExaminationManagementScreen(),
        ),
        GoRoute(
          path: '/admin/hall-ticket',
          redirect: (context, state) => RouteNames.examinations,
        ),
        GoRoute(
          path: RouteNames.results,
          builder: (context, state) => const ResultsScreen(),
        ),

        // 5. Finance & HR
        GoRoute(
          path: RouteNames.hr,
          builder: (context, state) => const HrPayrollScreen(),
        ),

        // 6. Campus Services
        GoRoute(
          path: RouteNames.library,
          builder: (context, state) => const LibraryManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.hostel,
          builder: (context, state) => const HostelManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.transport,
          builder: (context, state) => const TransportManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.placement,
          builder: (context, state) => const PlacementManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.eventManagement,
          builder: (context, state) => const EventManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.inventoryAssets,
          builder: (context, state) => const InventoryAssetsScreen(),
        ),
        GoRoute(
          path: RouteNames.grievanceManagement,
          builder: (context, state) => const GrievanceManagementScreen(),
        ),

        // 7. Communication
        GoRoute(
          path: RouteNames.notificationManagement,
          builder: (context, state) => const NotificationManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.digitalRepository,
          builder: (context, state) => const DigitalRepositoryScreen(),
        ),

        // 8. Security & Settings
        GoRoute(
          path: RouteNames.rolesPermissions,
          builder: (context, state) => const RolesPermissionsScreen(),
        ),
        GoRoute(
          path: RouteNames.auditLogs,
          builder: (context, state) => const AuditLogsScreen(),
        ),
        GoRoute(
          path: RouteNames.backupRestore,
          builder: (context, state) => const BackupRestoreScreen(),
        ),
        GoRoute(
          path: RouteNames.approvalWorkflow,
          builder: (context, state) => const ApprovalWorkflowScreen(),
        ),
        GoRoute(
          path: RouteNames.systemSettings,
          builder: (context, state) => const SystemSettingsScreen(),
        ),
        GoRoute(
          path: RouteNames.myProfile,
          builder: (context, state) => const MyProfileScreen(),
        ),

        // Super Admin Portal
        GoRoute(
          path: RouteNames.superAdminDashboard,
          builder: (context, state) => const SuperAdminDashboardScreen(),
        ),

        // Redirect root to default dashboard
        GoRoute(
          path: '/',
          redirect: (_, __) => RouteNames.dashboard,
        ),
      ],
    ),
  ],
);
