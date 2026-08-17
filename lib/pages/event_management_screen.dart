import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_status_badge.dart';

class EventManagementScreen extends StatelessWidget {
  const EventManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {
        'title': 'National Conference on AI & Robotics 2026',
        'category': 'Academic Symposium',
        'date': '2026-09-10',
        'venue': 'KSRCE Main Auditorium',
        'organizer': 'CSE & IT Departments',
        'status': 'Approved',
      },
      {
        'title': 'Annual Cultural Fest - KSR FIESTA 2026',
        'category': 'Cultural',
        'date': '2026-10-18',
        'venue': 'Open Air Theatre',
        'organizer': 'Student Union Council',
        'status': 'Upcoming',
      },
      {
        'title': 'State Level Hackathon - CodeCraft v4',
        'category': 'Technical Competition',
        'date': '2026-11-05',
        'venue': 'Central Computer Centre',
        'organizer': 'IEEE Student Branch',
        'status': 'Registration Open',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campus Event & Seminar Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Conferences, technical fests, venue bookings & guest lecture schedules',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppButton(
                  label: 'Create New Event',
                  icon: Icons.event_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Table(
                border: TableBorder.symmetric(
                  inside: const BorderSide(color: Color(0xFFF1F5F9)),
                ),
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
                    children: [
                      _buildHeader('EVENT TITLE'),
                      _buildHeader('CATEGORY'),
                      _buildHeader('DATE'),
                      _buildHeader('VENUE'),
                      _buildHeader('ORGANIZER'),
                      _buildHeader('STATUS'),
                    ],
                  ),
                  ...events.map(
                    (e) => TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            e['title'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(e['category'] ?? ''),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(e['date'] ?? ''),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(e['venue'] ?? ''),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(e['organizer'] ?? ''),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: AppStatusBadge(
                            status: e['status'] ?? 'Active',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
