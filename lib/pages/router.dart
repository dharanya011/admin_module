import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/academic_config_screen.dart';
import '../pages/dashboard_screen.dart';
import '../pages/academic_schedule_screen.dart';
import '../pages/academic_year_screen.dart';
import '../pages/approval_workflow_screen.dart';
import '../pages/attendance_screen.dart';
import '../pages/audit_logs_screen.dart';
import '../pages/backup_restore_screen.dart';
import '../pages/department_list_screen.dart';
import '../pages/digital_repository_screen.dart';
import '../pages/examination_management_screen.dart';
import '../pages/hall_ticket_screen.dart';
import '../pages/marks_screen.dart';
import '../pages/my_profile_screen.dart';
import '../pages/notification_management_screen.dart';
import '../pages/programmes_screen.dart';
import '../pages/programmes_subjects_screen.dart';
import '../pages/regulations_screen.dart';
import '../pages/results_screen.dart';
import '../pages/user_detail_screen.dart';
import '../pages/user_edit_form.dart';
import '../pages/user_list_screen.dart';
import '../widgets/app_scaffold.dart'; // Use the richer AppScaffold
import '../app/router/route_names.dart'; // Import RouteNames

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
        // Pass currentLocation to the AppScaffold for navigation highlighting
        return AppScaffold(child: child, currentLocation: state.uri.path);
      },
      routes: [
        GoRoute(
          path: RouteNames.dashboard,
          builder: (context, state) => const DashboardScreen(),
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
          path: RouteNames.academicSchedule,
          builder: (context, state) => const AcademicScheduleScreen(),
        ),
        GoRoute(
          path: RouteNames.academicConfig,
          builder: (context, state) => const AcademicConfigScreen(),
        ),
        GoRoute(
          path: RouteNames.departments,
          builder: (context, state) => const DepartmentListScreen(),
        ),
        GoRoute(
          path: RouteNames.academicYear,
          builder: (context, state) => const AcademicYearScreen(),
        ),
        GoRoute(
          path: RouteNames.regulations,
          builder: (context, state) => const RegulationsScreen(),
        ),
        GoRoute(
          path: RouteNames.users,
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
          path: RouteNames.hallTicket,
          builder: (context, state) => const HallTicketScreen(),
        ),
        GoRoute(
          path: RouteNames.results,
          builder: (context, state) => const ResultsScreen(),
        ),
        GoRoute(
          path: RouteNames.notificationManagement,
          builder: (context, state) => const NotificationManagementScreen(),
        ),
        GoRoute(
          path: RouteNames.digitalRepository,
          builder: (context, state) => const DigitalRepositoryScreen(),
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
          path: RouteNames.myProfile,
          builder: (context, state) => const MyProfileScreen(),
        ),
        // Redirect root to the default screen
        GoRoute(
          path: '/',
          redirect: (_, __) => RouteNames.dashboard,
        ),
      ],
    ),
  ],
);
