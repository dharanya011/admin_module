import 'package:flutter/material.dart';
import '../services/campus_services_backend.dart';
import '../theme.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_status_badge.dart';

class LibraryManagementScreen extends StatefulWidget {
  const LibraryManagementScreen({super.key});

  @override
  State<LibraryManagementScreen> createState() =>
      _LibraryManagementScreenState();
}

class _LibraryManagementScreenState extends State<LibraryManagementScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _resources = [];

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    final data = await CampusServicesBackend.instance.getLibraryResources();
    if (mounted) {
      setState(() {
        _resources = data;
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
            // Page Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Library & Digital Resource Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Central Digital Library repository, book issues, & e-learning archives',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                AppButton(
                  label: 'Add New Book / E-Book',
                  icon: Icons.add_rounded,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Add Resource Form Opened'),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stat Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Books Registered',
                    '48,250',
                    Icons.menu_book_rounded,
                    const Color(0xFF0052CC),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Active E-Journals',
                    '3,420',
                    Icons.auto_stories_rounded,
                    const Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Books Currently Issued',
                    '1,840',
                    Icons.assignment_turned_in_rounded,
                    const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Overdue Returns',
                    '42',
                    Icons.warning_amber_rounded,
                    const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Main Resources Table Card
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Digital Library Catalog',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: _loadResources,
                        icon: const Icon(Icons.refresh_rounded),
                        tooltip: 'Refresh Catalog',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Color(0xFFF1F5F9)),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(3),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1.2),
                        3: FlexColumnWidth(2),
                        4: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                          ),
                          children: [
                            _buildTableHeader('FILE / BOOK TITLE'),
                            _buildTableHeader('FORMAT'),
                            _buildTableHeader('FILE SIZE'),
                            _buildTableHeader('ADDED BY'),
                            _buildTableHeader('ACTION'),
                          ],
                        ),
                        ..._resources.map(
                          (item) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.picture_as_pdf_rounded,
                                      color: Color(0xFFDC2626),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item['file_name'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: AppStatusBadge(
                                  status: item['file_type'] ?? 'PDF',
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  item['file_size'] ?? 'N/A',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  item['uploaded_by'] ?? 'System',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  onPressed: () {},
                                  tooltip: 'Download File',
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
