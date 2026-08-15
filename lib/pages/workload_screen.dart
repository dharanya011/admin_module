import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme.dart';
import '../widgets/app_card.dart';
class WorkloadScreen extends ConsumerStatefulWidget {
  const WorkloadScreen({super.key});

  @override
  ConsumerState<WorkloadScreen> createState() => _WorkloadScreenState();
}

class _WorkloadScreenState extends ConsumerState<WorkloadScreen> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;

  final List<Map<String, dynamic>> _fallbackData = [
    {'name': 'Dr. Suresh Kumar', 'dept': 'CSE', 'hoursPerWeek': 16, 'subjectsAssigned': 3, 'labsAssigned': 2, 'loadStatus': 'Optimal'},
    {'name': 'Dr. R. Maheshwari', 'dept': 'ECE', 'hoursPerWeek': 18, 'subjectsAssigned': 4, 'labsAssigned': 1, 'loadStatus': 'Optimal'},
    {'name': 'Dr. V. Priya', 'dept': 'IT', 'hoursPerWeek': 14, 'subjectsAssigned': 3, 'labsAssigned': 1, 'loadStatus': 'Light'},
    {'name': 'Dr. K. Balaji', 'dept': 'IoT', 'hoursPerWeek': 20, 'subjectsAssigned': 4, 'labsAssigned': 3, 'loadStatus': 'Heavy'},
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
            'name': e['faculty_name'] ?? e['name'] ?? '',
            'dept': e['department'] ?? e['dept'] ?? '',
            'hoursPerWeek': e['hours_per_week'] ?? e['hoursPerWeek'] ?? 0,
            'subjectsAssigned': e['subjects_assigned'] ?? e['subjectsAssigned'] ?? 1,
            'labsAssigned': e['labs_assigned'] ?? e['labsAssigned'] ?? 0,
            'loadStatus': e['load_status'] ?? e['loadStatus'] ?? 'Optimal',
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
          title: const Text('Faculty Workload & Allocation', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Faculty Workload & Allocation', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Teaching Hours Allocation Summary', style: AppTypography.h3),
                    AppSpacing.gapLg,
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1.5),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FlexColumnWidth(),
                        4: FlexColumnWidth(),
                      },
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
                          children: [
                            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Faculty Member', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Dept', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Hours / Wk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                            Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Load Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                          ],
                        ),
                        ..._data.map((item) => TableRow(
                            children: [
                              Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(item['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text(item['dept'] as String, style: const TextStyle(fontSize: 12))),
                              Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${item['hoursPerWeek']} hrs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Text('${item['subjectsAssigned']} Courses', style: const TextStyle(fontSize: 12))),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  item['loadStatus'] as String,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: item['loadStatus'] == 'Heavy' ? Colors.red : const Color(0xFF16A34A),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
