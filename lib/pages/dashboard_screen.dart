import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/student_service.dart';
import '../widgets/app_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<List<Map<String, dynamic>>>? _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = StudentService.fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top 5 Metric Cards Row ──
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 1100;
                if (isWide) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildTopMetricCard(
                          title: 'Students',
                          value: '4206',
                          badgePrefix: '1 Active',
                          badgeSuffix: 'Total Enrolled',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTopMetricCard(
                          title: 'Faculty',
                          value: '340',
                          badgePrefix: '1 Active',
                          badgeSuffix: 'Teaching Staff',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTopMetricCard(
                          title: 'Departments',
                          value: '4',
                          badgePrefix: '1 Active',
                          badgeSuffix: 'Academic Units',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTopMetricCard(
                          title: 'Programmes',
                          value: '3',
                          badgePrefix: '1 Active',
                          badgeSuffix: 'Degree Schemes',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTopMetricCard(
                          title: 'Courses',
                          value: '3',
                          badgePrefix: '1 Active',
                          badgeSuffix: 'Curriculum Subjects',
                        ),
                      ),
                    ],
                  );
                } else {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildTopMetricCard(
                        title: 'Students',
                        value: '4206',
                        badgePrefix: '1 Active',
                        badgeSuffix: 'Total Enrolled',
                        width: 200,
                      ),
                      _buildTopMetricCard(
                        title: 'Faculty',
                        value: '340',
                        badgePrefix: '1 Active',
                        badgeSuffix: 'Teaching Staff',
                        width: 200,
                      ),
                      _buildTopMetricCard(
                        title: 'Departments',
                        value: '4',
                        badgePrefix: '1 Active',
                        badgeSuffix: 'Academic Units',
                        width: 200,
                      ),
                      _buildTopMetricCard(
                        title: 'Programmes',
                        value: '3',
                        badgePrefix: '1 Active',
                        badgeSuffix: 'Degree Schemes',
                        width: 200,
                      ),
                      _buildTopMetricCard(
                        title: 'Courses',
                        value: '3',
                        badgePrefix: '1 Active',
                        badgeSuffix: 'Curriculum Subjects',
                        width: 200,
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // ── Middle Section: Student Distribution & Faculty Distribution ──
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildStudentDistributionCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildFacultyDistributionCard()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildStudentDistributionCard(),
                      const SizedBox(height: 16),
                      _buildFacultyDistributionCard(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // ── Bottom Section: Admission Trend & Pending Approvals ──
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildAdmissionTrendCard()),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildPendingApprovalsCard()),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildAdmissionTrendCard(),
                      const SizedBox(height: 16),
                      _buildPendingApprovalsCard(),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── 1. Top Metric Card Widget ──
  Widget _buildTopMetricCard({
    required String title,
    required String value,
    required String badgePrefix,
    required String badgeSuffix,
    double? width,
  }) {
    final cardChild = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
              const Icon(
                Icons.trending_up_rounded,
                color: Color(0xFF0052CC),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                badgePrefix,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0052CC),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                badgeSuffix,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (width != null) {
      return SizedBox(
        width: width,
        child: AppCard(padding: EdgeInsets.zero, child: cardChild),
      );
    }
    return AppCard(padding: EdgeInsets.zero, child: cardChild);
  }

  // ── 2. Student Distribution Card (Donut Chart + Legend) ──
  Widget _buildStudentDistributionCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Student Distribution',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Donut Chart on Left
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(140, 140),
                      painter: _DonutChartPainter(
                        segments: const [
                          _ChartSegment(32.1, Color.fromRGBO(0, 82, 204, 1)), // CSE
                          _ChartSegment(24.3, Color(0xFF059669)), // ECE
                          _ChartSegment(20.0, Color(0xFFD97706)), // IT
                          _ChartSegment(15.2, Color(0xFF7C3AED)), // AIDS
                          _ChartSegment(8.5, Color(0xFF06B6D4)),  // IoT
                        ],
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '4,206',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Legend on Right
              Expanded(
                child: Column(
                  children: const [
                    _DistributionLegendRow(
                      color: Color(0xFF0052CC),
                      label: 'CSE',
                      value: '1,350 (32.1%)',
                    ),
                    SizedBox(height: 8),
                    _DistributionLegendRow(
                      color: Color(0xFF059669),
                      label: 'ECE',
                      value: '1,020 (24.3%)',
                    ),
                    SizedBox(height: 8),
                    _DistributionLegendRow(
                      color: Color(0xFFD97706),
                      label: 'IT',
                      value: '840 (20.0%)',
                    ),
                    SizedBox(height: 8),
                    _DistributionLegendRow(
                      color: Color(0xFF7C3AED),
                      label: 'AIDS',
                      value: '640 (15.2%)',
                    ),
                    SizedBox(height: 8),
                    _DistributionLegendRow(
                      color: Color(0xFF06B6D4),
                      label: 'IoT',
                      value: '356 (8.5%)',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 3. Faculty Distribution Card (Horizontal Bar Chart) ──
  Widget _buildFacultyDistributionCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Faculty Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 20),
          _FacultyBarRow(label: 'CSE', count: 40, maxCount: 40),
          SizedBox(height: 10),
          _FacultyBarRow(label: 'IT', count: 32, maxCount: 40),
          SizedBox(height: 10),
          _FacultyBarRow(label: 'ECE', count: 28, maxCount: 40),
          SizedBox(height: 10),
          _FacultyBarRow(label: 'Mechanical', count: 24, maxCount: 40),
          SizedBox(height: 10),
          _FacultyBarRow(label: 'AIDS', count: 20, maxCount: 40),
          SizedBox(height: 10),
          _FacultyBarRow(label: 'IoT', count: 18, maxCount: 40),
        ],
      ),
    );
  }

  // ── 4. Admission Trend Line Chart Card ──
  Widget _buildAdmissionTrendCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Admission Trend (Students)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Color(0xFF0052CC),
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unable to load admission data',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  );
                }

                final students = snapshot.data ?? [];

                // Group students by admission year
                final yearCounts = <int, int>{};
                for (final s in students) {
                  final dateStr = s['admission_date']?.toString();
                  if (dateStr == null || dateStr.isEmpty) continue;
                  final year = _extractYear(dateStr);
                  if (year != null) {
                    yearCounts[year] = (yearCounts[year] ?? 0) + 1;
                  }
                }

                if (yearCounts.isEmpty) {
                  return const Center(
                    child: Text(
                      'No admission data yet',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  );
                }

                final years = yearCounts.keys.toList()..sort();
                final spots = <FlSpot>[
                  for (var i = 0; i < years.length; i++)
                    FlSpot(i.toDouble(), yearCounts[years[i]]!.toDouble()),
                ];
                final maxCount = yearCounts.values.reduce((a, b) => a > b ? a : b);

                return LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (years.length - 1).toDouble(),
                    minY: 0,
                    maxY: maxCount.toDouble() + 2,
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF0F172A),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final idx = spot.x.toInt();
                            return LineTooltipItem(
                              '${years[idx]}: ${spot.y.toInt()} students',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (v, meta) {
                            final idx = v.toInt();
                            if (idx >= 0 && idx < years.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  '${years[idx]}',
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (v, meta) {
                            if (v == v.toInt()) {
                              return Text(
                                '${v.toInt()}',
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  color: Color(0xFF94A3B8),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) =>
                          const FlLine(color: Color(0xFFF1F5F9), strokeWidth: 1),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        color: const Color(0xFF0052CC),
                        barWidth: 2.5,
                        isCurved: true,
                        dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: const Color(0xFF0052CC).withValues(alpha: 0.08),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int? _extractYear(String dateStr) {
    final match = RegExp(r'(19|20)\d{2}').firstMatch(dateStr);
    if (match != null) {
      return int.tryParse(match.group(0)!);
    }
    return null;
  }

  // ── 5. Pending Approvals Card ──
  Widget _buildPendingApprovalsCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pending Approvals',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded, color: Color(0xFF64748B)),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const _ApprovalItemRow(
            title: 'Faculty Leave',
            count: '5',
            badgeBg: Color(0xFFFEF3C7),
            badgeFg: Color(0xFFD97706),
          ),
          const SizedBox(height: 12),
          const _ApprovalItemRow(
            title: 'Certificates',
            count: '6',
            badgeBg: Color(0xFFF3E8FF),
            badgeFg: Color(0xFF7C3AED),
          ),
          const SizedBox(height: 12),
          const _ApprovalItemRow(
            title: 'Exam Requests',
            count: '3',
            badgeBg: Color(0xFFECFDF5),
            badgeFg: Color(0xFF059669),
          ),
        ],
      ),
    );
  }
}

// ── Helper Donut Chart Segment Data ──
class _ChartSegment {
  final double percentage;
  final Color color;
  const _ChartSegment(this.percentage, this.color);
}

// ── Donut Chart Custom Painter ──
class _DonutChartPainter extends CustomPainter {
  final List<_ChartSegment> segments;
  _DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    final strokeWidth = 18.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;

    for (final seg in segments) {
      final sweepAngle = (seg.percentage / 100.0) * (2 * math.pi) - 0.04;
      paint.color = seg.color;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        math.max(0.01, sweepAngle),
        false,
        paint,
      );

      startAngle += (seg.percentage / 100.0) * (2 * math.pi);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ── Legend Row ──
class _DistributionLegendRow extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _DistributionLegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

// ── Faculty Distribution Bar Row ──
class _FacultyBarRow extends StatelessWidget {
  final String label;
  final int count;
  final int maxCount;

  const _FacultyBarRow({
    required this.label,
    required this.count,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final double fraction = count / maxCount;
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: constraints.maxWidth * fraction,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0052CC),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Pending Approval Item Row ──
class _ApprovalItemRow extends StatelessWidget {
  final String title;
  final String count;
  final Color badgeBg;
  final Color badgeFg;

  const _ApprovalItemRow({
    required this.title,
    required this.count,
    required this.badgeBg,
    required this.badgeFg,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.article_outlined,
          size: 18,
          color: Color(0xFF64748B),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: badgeBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: badgeFg,
            ),
          ),
        ),
      ],
    );
  }
}
