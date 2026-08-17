import 'package:flutter/material.dart';
import '../services/campus_services_backend.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_status_badge.dart';

class PlacementManagementScreen extends StatefulWidget {
  const PlacementManagementScreen({super.key});

  @override
  State<PlacementManagementScreen> createState() =>
      _PlacementManagementScreenState();
}

class _PlacementManagementScreenState
    extends State<PlacementManagementScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _drives = [];

  @override
  void initState() {
    super.initState();
    _loadDrives();
  }

  Future<void> _loadDrives() async {
    final data = await CampusServicesBackend.instance.getPlacementDrives();
    if (mounted) {
      setState(() {
        _drives = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      'Training & Placement Cell',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Campus recruitment drives, student offer tracking & corporate outreach',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppButton(
                  label: 'New Drive Announcement',
                  icon: Icons.work_rounded,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Students Placed',
                    '842',
                    Icons.verified_user_rounded,
                    const Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Highest Package Offered',
                    '₹ 24.5 LPA',
                    Icons.payments_rounded,
                    const Color(0xFF0052CC),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Visiting Companies 2026',
                    '86 Companies',
                    Icons.business_center_rounded,
                    const Color(0xFFD97706),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upcoming Recruitment Drives',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Color(0xFFF1F5F9)),
                      ),
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                          ),
                          children: [
                            _buildTableHeader('COMPANY NAME'),
                            _buildTableHeader('ROLE'),
                            _buildTableHeader('PACKAGE CTC'),
                            _buildTableHeader('ELIGIBILITY'),
                            _buildTableHeader('DRIVE DATE'),
                            _buildTableHeader('STATUS'),
                          ],
                        ),
                        ..._drives.map(
                          (d) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  d['company_name'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(d['role'] ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  d['package'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(d['eligible_depts'] ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(d['drive_date'] ?? ''),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: AppStatusBadge(
                                  status: d['status'] ?? 'Scheduled',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
