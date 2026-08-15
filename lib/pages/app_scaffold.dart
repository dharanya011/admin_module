import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/router/route_names.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _getSelectedIndex(currentPath),
            onDestinationSelected: (index) {
              final path = _getNavigationPath(index);
              if (path != null) {
                context.go(path);
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: Text('Programmes'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: Text('Schedule'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Config'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.book_outlined),
                selectedIcon: Icon(Icons.book),
                label: Text('Subjects'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(String path) {
    if (path.startsWith(RouteNames.dashboard)) {
      return 0;
    }
    if (path.startsWith('/programmes-subjects')) {
      return 1;
    }
    if (path.startsWith('/academic-schedule')) {
      return 2;
    }
    if (path.startsWith('/academic-config')) {
      return 3;
    }
    if (path.startsWith('/programmes')) {
      return 4;
    }
    return 0; // Default to the first item
  }

  String? _getNavigationPath(int index) {
    switch (index) {
      case 0:
        return RouteNames.dashboard;
      case 1:
        return '/programmes-subjects';
      case 2:
        return '/academic-schedule';
      case 3:
        return '/academic-config';
      case 4:
        return '/programmes';
      default:
        return null;
    }
  }
}
