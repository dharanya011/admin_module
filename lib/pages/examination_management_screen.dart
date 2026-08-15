import 'package:flutter/material.dart';
import '../services/admin_supabase_service.dart';
import '../widgets/app_responsive.dart';

class ExaminationManagementScreen extends StatefulWidget {
  const ExaminationManagementScreen({super.key});
  @override
  State<ExaminationManagementScreen> createState() => _ExaminationManagementScreenState();
}

class _ExaminationManagementScreenState extends State<ExaminationManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _exams = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final data = await AdminSupabaseService.fetchExamSchedules();
    if (mounted) setState(() { _exams = data; _loading = false; });
  }

  void _showAddEditModal([Map<String, dynamic>? ex]) {
    final scCtrl = TextEditingController(text: ex?['subject_code'] ?? '');
    final snCtrl = TextEditingController(text: ex?['subject_name'] ?? '');
    final dateCtrl = TextEditingController(text: ex?['exam_date'] ?? '');
    final hallCtrl = TextEditingController(text: ex?['hall'] ?? '');
    final candCtrl = TextEditingController(text: ex?['candidates']?.toString() ?? '');
    String sem = ex?['semester'] ?? 'Semester 1';
    String sess = ex?['session'] ?? 'FN';
    String stage = ex?['stage'] ?? 'upcoming';

    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, ss) => AlertDialog(
      title: Text(ex == null ? 'Add Exam Schedule' : 'Edit Exam Schedule', style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          Expanded(child: TextField(controller: scCtrl, decoration: const InputDecoration(labelText: 'Subject Code', border: OutlineInputBorder()))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: snCtrl, decoration: const InputDecoration(labelText: 'Subject Name', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: sem, isExpanded: true,
              decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
              items: ['Semester 1','Semester 2','Semester 3','Semester 4','Semester 5','Semester 6','Semester 7','Semester 8'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => ss(() => sem = v!))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Exam Date (YYYY-MM-DD)', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: DropdownButtonFormField<String>(value: sess, isExpanded: true,
              decoration: const InputDecoration(labelText: 'Session', border: OutlineInputBorder()),
              items: ['FN','AN'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => ss(() => sess = v!))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: hallCtrl, decoration: const InputDecoration(labelText: 'Hall', border: OutlineInputBorder()))),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: TextField(controller: candCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Candidates', border: OutlineInputBorder()))),
          const SizedBox(width: 12),
          Expanded(child: DropdownButtonFormField<String>(value: stage, isExpanded: true,
              decoration: const InputDecoration(labelText: 'Stage', border: OutlineInputBorder()),
              items: ['upcoming','in_progress','completed'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (v) => ss(() => stage = v!))),
        ]),
      ]))),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white), onPressed: () async {
          Navigator.pop(ctx);
          final payload = {'subject_code': scCtrl.text.trim(), 'subject_name': snCtrl.text.trim(), 'semester': sem, 'exam_date': dateCtrl.text.trim(), 'session': sess, 'hall': hallCtrl.text.trim(), 'candidates': int.tryParse(candCtrl.text.trim()) ?? 0, 'stage': stage, 'duration_minutes': 180};
          if (ex == null) {
            await AdminSupabaseService.addExamSchedule(payload);
          } else {
            await AdminSupabaseService.updateExamSchedule(ex['id'] as String, payload);
          }
          _loadData();
        }, child: Text(ex == null ? 'Add' : 'Update')),
      ],
    )));
  }

  Future<void> _delete(Map<String, dynamic> e) async {
    final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Delete?'), content: Text('Delete "${e['subject_name']}"?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white), onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete'))]));
    if (ok == true) { await AdminSupabaseService.deleteExamSchedule(e['id'] as String); _loadData(); }
  }

  @override
  Widget build(BuildContext context) {
    final active = _exams.where((e) => e['stage'] != 'completed').toList();
    final done = _exams.where((e) => e['stage'] == 'completed').toList();
    return Scaffold(backgroundColor: const Color(0xFFF8FAFC), body: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (AppResponsive.isMobile(context)) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Examination Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 12), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () => _showAddEditModal(), icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Add Exam'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))))]) else Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Examination Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text('Manage CIA, ESE exam schedules', style: TextStyle(fontSize: 14, color: Colors.grey[600]))]), ElevatedButton.icon(onPressed: () => _showAddEditModal(), icon: const Icon(Icons.add_rounded, size: 18), label: const Text('Add Exam Schedule'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0052CC), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))]),
      const SizedBox(height: 20),
      Row(children: [
        _sc('Total', '${_exams.length}', Icons.event_note_rounded, const Color(0xFF0052CC)), const SizedBox(width: 12),
        _sc('In Progress', '${_exams.where((e) => e['stage'] == 'in_progress').length}', Icons.play_circle_rounded, const Color(0xFF16A34A)), const SizedBox(width: 12),
        _sc('Upcoming', '${_exams.where((e) => e['stage'] == 'upcoming').length}', Icons.schedule_rounded, const Color(0xFF9333EA)), const SizedBox(width: 12),
        _sc('Completed', '${_exams.where((e) => e['stage'] == 'completed').length}', Icons.check_circle_rounded, const Color(0xFFD97706)),
      ]),
      const SizedBox(height: 24),
      Container(decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))), child: TabBar(controller: _tabController, isScrollable: true, labelColor: const Color(0xFF0052CC), unselectedLabelColor: const Color(0xFF64748B), indicatorColor: const Color(0xFF0052CC), indicatorWeight: 3, tabs: const [Tab(text: 'Active / Upcoming'), Tab(text: 'Completed')])),
      const SizedBox(height: 20),
      if (_loading) const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
      else SizedBox(height: 500, child: TabBarView(controller: _tabController, children: [_table(active), _table(done)])),
    ])));
  }

  Widget _sc(String title, String value, IconData icon, Color color) => Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))), child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis), const SizedBox(height: 2), Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))]))])));

  Widget _table(List<Map<String, dynamic>> rows) => Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))), padding: const EdgeInsets.all(16), child: rows.isEmpty ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.event_busy_rounded, size: 48, color: Color(0xFFCBD5E1)), SizedBox(height: 12), Text('No exam schedules found', style: TextStyle(color: Color(0xFF64748B)))])) : SingleChildScrollView(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: DataTable(headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)), columnSpacing: 16, columns: const [DataColumn(label: Text('Subject', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Session', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Hall', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Candidates', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Stage', style: TextStyle(fontWeight: FontWeight.bold))), DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)))], rows: rows.map((e) { final c = e['stage'] == 'completed' ? const Color(0xFF16A34A) : e['stage'] == 'in_progress' ? const Color(0xFFD97706) : const Color(0xFF0052CC); return DataRow(cells: [DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(e['subject_name'] ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)), Text(e['subject_code'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))])), DataCell(Text(e['semester'] ?? '-')), DataCell(Text(e['exam_date'] ?? '-')), DataCell(Text(e['session'] ?? '-')), DataCell(Text(e['hall'] ?? '-')), DataCell(Text('${e['candidates'] ?? 0}')), DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: c.withAlpha(25), borderRadius: BorderRadius.circular(12)), child: Text(e['stage'] ?? '-', style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 12)))), DataCell(Row(children: [IconButton(icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF0284C7)), onPressed: () => _showAddEditModal(e)), IconButton(icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFDC2626)), onPressed: () => _delete(e))]))]); }).toList()))));
}
