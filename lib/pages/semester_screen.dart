import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
class SemesterScreen extends ConsumerStatefulWidget {
  const SemesterScreen({super.key});

  @override
  ConsumerState<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends ConsumerState<SemesterScreen> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;

  final List<Map<String, dynamic>> _fallbackData = [
    {'sem': 'Semester I', 'academicYear': '2026-27', 'status': 'Upcoming', 'startDate': '18 Aug 2026', 'endDate': '20 Dec 2026'},
    {'sem': 'Semester III', 'academicYear': '2026-27', 'status': 'Active', 'startDate': '02 Aug 2026', 'endDate': '15 Dec 2026'},
    {'sem': 'Semester V', 'academicYear': '2026-27', 'status': 'Active', 'startDate': '02 Aug 2026', 'endDate': '15 Dec 2026'},
    {'sem': 'Semester VII', 'academicYear': '2026-27', 'status': 'Active', 'startDate': '02 Aug 2026', 'endDate': '15 Dec 2026'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final result = <Map<String, dynamic>>[];
      if (result.isNotEmpty) {
        setState(() {
          _data = result.map((e) => {
            'sem': e['name'] ?? e['sem'] ?? '',
            'academicYear': e['academic_year'] ?? e['code'] ?? e['academicYear'] ?? '',
            'status': e['status'] ?? 'Active',
            'startDate': e['start_date'] ?? e['startDate'] ?? '',
            'endDate': e['end_date'] ?? e['endDate'] ?? '',
          }).toList();
          _loading = false;
        });
      } else {
        setState(() { _data = List.from(_fallbackData); _loading = false; });
      }
    } catch (_) {
      setState(() { _data = List.from(_fallbackData); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Semester Examinations & Schedules', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Semester Examinations & Schedules', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Academic Semesters Configuration', style: AppTypography.h2),
              AppSpacing.gapLg,

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _data.length,
                itemBuilder: (context, idx) {
                  final item = _data[idx];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 500;
                          return Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 10,
                            children: [
                              SizedBox(
                                width: isWide ? (constraints.maxWidth - 180) : constraints.maxWidth,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(10)),
                                      child: const Icon(Icons.event_note_rounded, color: Color(0xFF0052CC), size: 24),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['sem'] as String, style: AppTypography.h3),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Academic Year: ${item['academicYear']} • Dates: ${item['startDate']} - ${item['endDate']}',
                                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              OutlinedButton(onPressed: () {}, child: const Text('Configure Exam Schedule')),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
