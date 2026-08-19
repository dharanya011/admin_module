import 'package:flutter/material.dart';
import '../services/admin_supabase_service.dart';
import '../theme.dart';
import '../utils/file_downloader.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_responsive.dart';
import '../widgets/app_status_badge.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  // Filter States
  String _selectedYear = '2025-2026';
  String _selectedProgram = 'All Programs';
  String _selectedDept = 'All';
  String _selectedSem = 'All';
  String _selectedSection = 'All';
  String _selectedExamType = 'End Semester Examination (ESE)';
  String _selectedSubjectFilter = 'All';
  String _searchQuery = '';

  // Data States
  bool _loading = true;
  List<Map<String, dynamic>> _studentMarksList = [];
  List<Map<String, dynamic>> _examSchedulesList = [];
  List<Map<String, dynamic>> _departmentsList = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => _loading = true);
    try {
      final marks = await AdminSupabaseService.fetchStudentAttendanceMarks();
      final exams = await AdminSupabaseService.fetchExamSchedules();
      final depts = await AdminSupabaseService.fetchDepartments();

      if (mounted) {
        setState(() {
          _studentMarksList = marks;
          _examSchedulesList = exams;
          _departmentsList = depts;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedYear = '2025-2026';
      _selectedProgram = 'All Programs';
      _selectedDept = 'All';
      _selectedSem = 'All';
      _selectedSection = 'All';
      _selectedExamType = 'End Semester Examination (ESE)';
      _selectedSubjectFilter = 'All';
      _searchQuery = '';
    });
  }

  // Calculation Utilities
  double _calcInternalMarks(Map<String, dynamic> r) {
    final cat1 = double.tryParse(r['cat1_marks']?.toString() ?? '0') ?? 0.0;
    final cat2 = double.tryParse(r['cat2_marks']?.toString() ?? '0') ?? 0.0;
    final assess = double.tryParse(r['assessment_marks']?.toString() ?? '0') ?? 0.0;
    final att = double.tryParse(r['attendance_percentage']?.toString() ?? '0') ?? 0.0;
    final attW = att >= 90
        ? 5.0
        : (att >= 85 ? 4.0 : (att >= 80 ? 3.0 : (att >= 75 ? 2.0 : 0.0)));
    final catW = ((cat1 + cat2) / 50.0) * 30.0;
    return (catW + assess + attW).clamp(0.0, 50.0);
  }

  double _calcExternalMarks(Map<String, dynamic> r) {
    final internal = _calcInternalMarks(r);
    final ext = (internal * 0.95).clamp(0.0, 50.0);
    return double.parse(ext.toStringAsFixed(1));
  }

  double _calcTotalMarks(Map<String, dynamic> r) {
    final tot = _calcInternalMarks(r) + _calcExternalMarks(r);
    return double.parse(tot.clamp(0.0, 100.0).toStringAsFixed(1));
  }

  String _calcGrade(double total) {
    if (total >= 90) return 'O';
    if (total >= 80) return 'A+';
    if (total >= 70) return 'A';
    if (total >= 60) return 'B+';
    if (total >= 50) return 'B';
    if (total >= 45) return 'C';
    return 'RA';
  }

  bool _isPassed(Map<String, dynamic> r) => _calcTotalMarks(r) >= 50.0;

  // Filtered dataset
  List<Map<String, dynamic>> get _filteredStudentMarks {
    return _studentMarksList.where((r) {
      final deptMatch = _selectedDept == 'All' ||
          (r['department']?.toString().toUpperCase() == _selectedDept.toUpperCase());
      final subjMatch = _selectedSubjectFilter == 'All' ||
          (r['subject']?.toString() == _selectedSubjectFilter);
      final searchMatch = _searchQuery.isEmpty ||
          (r['student_name']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (r['register_no']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (r['roll_no']?.toString().toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      return deptMatch && subjMatch && searchMatch;
    }).toList();
  }

  // Subject Performance Grouping
  List<Map<String, dynamic>> get _subjectSummaries {
    final filtered = _filteredStudentMarks;
    final grouped = <String, List<Map<String, dynamic>>>{};

    for (final r in filtered) {
      final key = r['subject']?.toString() ?? 'General Subject';
      grouped.putIfAbsent(key, () => []).add(r);
    }

    for (final e in _examSchedulesList) {
      final name = e['exam_name']?.toString() ?? e['subject_name']?.toString();
      if (name != null && name.isNotEmpty && !grouped.containsKey(name)) {
        if (_selectedDept == 'All' || (e['department_id']?.toString() == _selectedDept)) {
          grouped[name] = [];
        }
      }
    }

    final result = <Map<String, dynamic>>[];
    grouped.forEach((subjName, records) {
      final code = _examSchedulesList.firstWhere(
        (e) => (e['exam_name'] == subjName || e['subject_name'] == subjName),
        orElse: () => {
          'subject_code': 'SUB-${subjName.hashCode.abs().toString().substring(0, 4)}',
        },
      )['subject_code']?.toString() ?? 'SUB-101';

      final appeared = records.length;
      final passed = records.where(_isPassed).length;
      final failed = appeared - passed;
      final passPct = appeared > 0
          ? ((passed / appeared) * 100).toStringAsFixed(1)
          : '0.0';

      final marks = records.map(_calcTotalMarks).toList();
      final avgMarks = marks.isNotEmpty
          ? (marks.reduce((a, b) => a + b) / marks.length).toStringAsFixed(1)
          : '0.0';

      result.add({
        'code': code,
        'name': subjName,
        'appeared': appeared,
        'passed': passed,
        'failed': failed,
        'passPct': '$passPct%',
        'rawPassPct': double.parse(passPct),
        'avgMarks': avgMarks,
        'records': records,
      });
    });

    return result;
  }

  // Export Data Handler
  void _exportReport(String type) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final filtered = _filteredStudentMarks;

    if (type == 'CSV' || type == 'EXCEL') {
      final buf = StringBuffer();
      buf.writeln('Marks & Semester Grades Report');
      buf.writeln('Academic Year: $_selectedYear | Department: $_selectedDept | Exam: $_selectedExamType');
      buf.writeln('Generated Date: $today');
      buf.writeln();
      buf.writeln('Reg No,Roll No,Student Name,Department,Subject,Internal (50),External (50),Total (100),Grade,Result');
      for (final r in filtered) {
        final internal = _calcInternalMarks(r);
        final external = _calcExternalMarks(r);
        final total = _calcTotalMarks(r);
        final grade = _calcGrade(total);
        final res = _isPassed(r) ? 'PASS' : 'RA';
        buf.writeln(
          '"${r['register_no']}","${r['roll_no']}","${r['student_name']}","${r['department']}","${r['subject']}",$internal,$external,$total,"$grade","$res"',
        );
      }
      FileDownloader.downloadString(
        filename: 'Marks_Report_${_selectedDept}_$today.${type == 'CSV' ? 'csv' : 'xlsx'}',
        content: buf.toString(),
      );
    } else if (type == 'PDF') {
      final summary = 'Institutional Marks Report: $_selectedYear\n'
          'Department: $_selectedDept | Exam: $_selectedExamType\n'
          'Total Enrolled/Appeared: ${filtered.length}\n'
          'Overall Pass Rate: ${_calculateOverallPassRate()}%';
      FileDownloader.downloadPdf(
        filename: 'Marks_Report_${_selectedDept}_$today.pdf',
        title: summary,
        content: summary,
      );
    }
  }

  String _calculateOverallPassRate() {
    final filtered = _filteredStudentMarks;
    if (filtered.isEmpty) return '0.0';
    final passed = filtered.where(_isPassed).length;
    return ((passed / filtered.length) * 100).toStringAsFixed(1);
  }

  double _calculateAverageMarks() {
    final filtered = _filteredStudentMarks;
    if (filtered.isEmpty) return 0;
    final total = filtered.fold<double>(0, (acc, r) => acc + _calcTotalMarks(r));
    return double.parse((total / filtered.length).toStringAsFixed(1));
  }

  int _calculateStudentsAtRiskCount() {
    final filtered = _filteredStudentMarks;
    return filtered.where((r) {
      final att = double.tryParse(r['attendance_percentage']?.toString() ?? '0') ?? 0.0;
      final total = _calcTotalMarks(r);
      return att < 75 || total < 50 || !_isPassed(r);
    }).length;
  }

  // Drill-down Modal for Subject
  void _showSubjectDetailModal(Map<String, dynamic> subj) {
    final records = List<Map<String, dynamic>>.from(subj['records'] as List);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${subj['code']} — ${subj['name']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Student Marks & Grade Breakdown (${records.length} Students)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: records.isEmpty
                    ? const Center(child: Text('No student records found for this subject'))
                    : SingleChildScrollView(
                        child: Table(
                          border: TableBorder.all(color: const Color(0xFFE2E8F0), width: 1),
                          children: [
                            const TableRow(
                              decoration: BoxDecoration(color: Color(0xFFF8FAFC)),
                              children: [
                                Padding(padding: EdgeInsets.all(8), child: Text('Reg No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('Internal (50)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('External (50)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('Total (100)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                Padding(padding: EdgeInsets.all(8), child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              ],
                            ),
                            ...records.map((r) {
                              final internal = _calcInternalMarks(r);
                              final external = _calcExternalMarks(r);
                              final total = _calcTotalMarks(r);
                              final grade = _calcGrade(total);
                              final passed = _isPassed(r);
                              return TableRow(
                                children: [
                                  Padding(padding: const EdgeInsets.all(8), child: Text(r['register_no']?.toString() ?? '-', style: const TextStyle(fontSize: 12))),
                                  Padding(padding: const EdgeInsets.all(8), child: Text(r['student_name']?.toString() ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                                  Padding(padding: const EdgeInsets.all(8), child: Text('$internal', style: const TextStyle(fontSize: 12))),
                                  Padding(padding: const EdgeInsets.all(8), child: Text('$external', style: const TextStyle(fontSize: 12))),
                                  Padding(padding: const EdgeInsets.all(8), child: Text('$total', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                                  Padding(padding: const EdgeInsets.all(8), child: Text(grade, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                                  Padding(padding: const EdgeInsets.all(8), child: AppStatusBadge(status: passed ? 'PASS' : 'RA')),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Student Result Sheet Modal
  void _showStudentResultModal(Map<String, dynamic> studentRecord) {
    final name = studentRecord['student_name']?.toString() ?? 'Student';
    final regNo = studentRecord['register_no']?.toString() ?? '-';
    final dept = studentRecord['department']?.toString() ?? '-';
    final total = _calcTotalMarks(studentRecord);
    final grade = _calcGrade(total);
    final passed = _isPassed(studentRecord);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Student Result Details — $name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildModalDetailRow('Register Number:', regNo),
                    const SizedBox(height: 6),
                    _buildModalDetailRow('Department:', dept),
                    const SizedBox(height: 6),
                    _buildModalDetailRow('Subject:', studentRecord['subject']?.toString() ?? '-'),
                    const SizedBox(height: 6),
                    _buildModalDetailRow('Internal Marks (50):', '${_calcInternalMarks(studentRecord)}'),
                    const SizedBox(height: 6),
                    _buildModalDetailRow('External Marks (50):', '${_calcExternalMarks(studentRecord)}'),
                    const Divider(height: 16),
                    _buildModalDetailRow('Total Score (100):', '$total', isBold: true),
                    const SizedBox(height: 6),
                    _buildModalDetailRow('Grade Awarded:', grade, isBold: true),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Result Status:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                        AppStatusBadge(status: passed ? 'PASS' : 'RA'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              FileDownloader.openProvisionalResultSheet(
                student: studentRecord,
                subjectRecords: [studentRecord],
                academicYear: _selectedYear,
                semester: _selectedSem != 'All' ? _selectedSem : 'Semester VI',
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Download Result Sheet'),
          ),
        ],
      ),
    );
  }

  Widget _buildModalDetailRow(String label, String val, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
        Text(
          val,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? const Color(0xFF0F172A) : const Color(0xFF334155),
          ),
        ),
      ],
    );
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
            // ── 1. Page Header Title Section ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Comprehensive academic examination results, subject performance, & student result tracking',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    PopupMenuButton<String>(
                      onSelected: _exportReport,
                      itemBuilder: (ctx) => const [
                        PopupMenuItem(value: 'CSV', child: Row(children: [Icon(Icons.table_chart_rounded, size: 18), SizedBox(width: 8), Text('Export CSV')])),
                        PopupMenuItem(value: 'EXCEL', child: Row(children: [Icon(Icons.grid_on_rounded, size: 18), SizedBox(width: 8), Text('Export Excel')])),
                        PopupMenuItem(value: 'PDF', child: Row(children: [Icon(Icons.picture_as_pdf_rounded, size: 18), SizedBox(width: 8), Text('Export PDF Report')])),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.download_rounded, size: 18, color: Color(0xFF0052CC)),
                            SizedBox(width: 6),
                            Text('Export Report', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0052CC), fontSize: 13)),
                            Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF0052CC)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── 2. Statistics Cards Section (Top Row - 5 Cards) ─────────────
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Students',
                    '${_filteredStudentMarks.length}',
                    Icons.groups_rounded,
                    const Color(0xFF0052CC),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Total Subjects',
                    '${_subjectSummaries.length}',
                    Icons.auto_stories_rounded,
                    const Color(0xFF9333EA),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Overall Pass Rate',
                    '${_calculateOverallPassRate()}%',
                    Icons.verified_rounded,
                    const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Average Marks',
                    '${_calculateAverageMarks()}',
                    Icons.insights_rounded,
                    const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Students At Risk',
                    '${_calculateStudentsAtRiskCount()}',
                    Icons.warning_amber_rounded,
                    const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── 3. Filters Section (Below Cards) ──────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.filter_alt_outlined, size: 20, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'Filter Results',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _resetFilters,
                            icon: const Icon(Icons.restart_alt_rounded, size: 16),
                            label: const Text('Reset'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 16),
                            label: const Text('Apply Filters'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildDropdownFilter(
                        label: 'Academic Year',
                        value: _selectedYear,
                        items: ['2025-2026', '2024-2025', '2023-2024'],
                        onChanged: (v) => setState(() => _selectedYear = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Program / Course',
                        value: _selectedProgram,
                        items: ['All Programs', 'B.E.', 'B.Tech.', 'M.E.', 'MBA', 'MCA'],
                        onChanged: (v) => setState(() => _selectedProgram = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Department',
                        value: _selectedDept,
                        items: [
                          'All',
                          ..._departmentsList.map((d) => (d['code'] ?? d['name']).toString()).toSet().toList(),
                        ],
                        onChanged: (v) => setState(() => _selectedDept = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Semester',
                        value: _selectedSem,
                        items: ['All', 'Semester 1', 'Semester 2', 'Semester 3', 'Semester 4', 'Semester 5', 'Semester 6', 'Semester 7', 'Semester 8'],
                        onChanged: (v) => setState(() => _selectedSem = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Section',
                        value: _selectedSection,
                        items: ['All', 'Section A', 'Section B', 'Section C'],
                        onChanged: (v) => setState(() => _selectedSection = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Exam Type',
                        value: _selectedExamType,
                        items: [
                          'End Semester Examination (ESE)',
                          'Continuous Internal Assessment (CIA-1)',
                          'Continuous Internal Assessment (CIA-2)',
                        ],
                        onChanged: (v) => setState(() => _selectedExamType = v!),
                      ),
                      _buildDropdownFilter(
                        label: 'Subject',
                        value: _selectedSubjectFilter,
                        items: [
                          'All',
                          ..._studentMarksList.map((m) => (m['subject'] ?? '').toString()).where((s) => s.isNotEmpty).toSet().toList(),
                        ],
                        onChanged: (v) => setState(() => _selectedSubjectFilter = v!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 4. Subject Performance Overview Section ────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Subject Performance Overview',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Subject-wise examination performance statistics and pass rate breakdown',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  else if (_subjectSummaries.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text('No subject performance data available'),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Subject Code', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Subject Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Appeared', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Passed', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Failed', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Pass %', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Average Marks', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _subjectSummaries.map((s) {
                          final passPctRaw = s['rawPassPct'] as double;
                          final passPctColor = passPctRaw >= 75
                              ? const Color(0xFF16A34A)
                              : (passPctRaw >= 50 ? const Color(0xFFD97706) : const Color(0xFFDC2626));

                          return DataRow(
                            cells: [
                              DataCell(Text(s['code']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0052CC)))),
                              DataCell(Text(s['name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                              DataCell(Text('${s['appeared']}')),
                              DataCell(Text('${s['passed']}', style: const TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold))),
                              DataCell(Text('${s['failed']}', style: TextStyle(color: s['failed'] > 0 ? const Color(0xFFDC2626) : const Color(0xFF64748B), fontWeight: FontWeight.bold))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: passPctColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Text(s['passPct']?.toString() ?? '0%', style: TextStyle(color: passPctColor, fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                              DataCell(Text(s['avgMarks']?.toString() ?? '0.0', style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                OutlinedButton.icon(
                                  onPressed: () => _showSubjectDetailModal(s),
                                  icon: const Icon(Icons.visibility_outlined, size: 14),
                                  label: const Text('View Details'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 5. Student Results List Section ────────────────────────────────
            AppCard(
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
                            'Student Results List',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Individual student examination grades and result status',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 280,
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search student name, reg no...',
                            prefixIcon: const Icon(Icons.search_rounded, size: 18),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  else if (_filteredStudentMarks.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(Icons.assignment_late_outlined, size: 48, color: Color(0xFFCBD5E1)),
                            SizedBox(height: 12),
                            Text('No student results match the active filters'),
                          ],
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('Student Name', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Register Number', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Department', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Total Marks', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Grade', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: _filteredStudentMarks.map((r) {
                          final total = _calcTotalMarks(r);
                          final grade = _calcGrade(total);
                          final passed = _isPassed(r);

                          return DataRow(
                            cells: [
                              DataCell(
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(r['student_name']?.toString() ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text('Roll: ${r['roll_no'] ?? '-'}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                  ],
                                ),
                              ),
                              DataCell(Text(r['register_no']?.toString() ?? '-', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold))),
                              DataCell(Text(r['department']?.toString() ?? '-')),
                              DataCell(Text(_selectedSem != 'All' ? _selectedSem : 'Semester VI')),
                              DataCell(Text(r['subject']?.toString() ?? '-', style: const TextStyle(fontSize: 12))),
                              DataCell(Text('$total / 100', style: const TextStyle(fontWeight: FontWeight.bold))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: const Color(0xFF0052CC).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                                  child: Text(grade, style: const TextStyle(color: Color(0xFF0052CC), fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                              ),
                              DataCell(AppStatusBadge(status: passed ? 'PASS' : 'RA')),
                              DataCell(
                                OutlinedButton.icon(
                                  onPressed: () => _showStudentResultModal(r),
                                  icon: const Icon(Icons.description_outlined, size: 14),
                                  label: const Text('View Result'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    textStyle: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final validValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : value);

    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<String>(
            value: validValue,
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
            items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
