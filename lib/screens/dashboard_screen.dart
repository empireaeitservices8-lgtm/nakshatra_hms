import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../widgets/common.wideget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ac;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final today = days[(now.weekday - 1) % 7];

    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.cardBlack, AppTheme.deepBlack],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 28,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning,',
                              style: GoogleFonts.lato(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ShaderMask(
                              shaderCallback: (b) =>
                                  AppTheme.goldGradient.createShader(b),
                              child: Text(
                                'Arjun Krishnan ✦',
                                style: GoogleFonts.playfairDisplay(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Store Manager  •  NGD-001',
                              style: GoogleFonts.lato(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          const AvatarCircle(
                            initials: 'AK',
                            size: 52,
                            isPresent: true,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppTheme.danger,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.cardBlack,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Today's date strip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.goldPrimary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.goldPrimary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: AppTheme.goldPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_dayName(now.weekday)}, ${now.day} ${_monthName(now.month)} ${now.year}',
                          style: GoogleFonts.lato(
                            color: AppTheme.ivory,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.success.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.success.withOpacity(0.4),
                            ),
                          ),
                          child: Text(
                            'Working Day',
                            style: GoogleFonts.lato(
                              color: AppTheme.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Stats Grid ────────────────────────────────────────
                const SectionHeader(title: 'Today\'s Overview'),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.1,
                  children: [
                    StatCard(
                      label: 'Present Today',
                      value: '18',
                      icon: Icons.how_to_reg_outlined,
                      color: AppTheme.success,
                      isGold: true,
                    ),
                    StatCard(
                      label: 'On Leave',
                      value: '4',
                      icon: Icons.beach_access_outlined,
                      color: AppTheme.warning,
                    ),
                    StatCard(
                      label: 'Total Staff',
                      value: '24',
                      icon: Icons.people_outline,
                      color: AppTheme.info,
                    ),
                    StatCard(
                      label: 'Absent',
                      value: '2',
                      icon: Icons.person_off_outlined,
                      color: AppTheme.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Attendance bar ────────────────────────────────────
                const SectionHeader(title: 'Weekly Attendance'),
                const SizedBox(height: 16),
                _WeeklyBar(today: today),
                const SizedBox(height: 28),

                // ── Quick Actions ─────────────────────────────────────
                const SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.fingerprint,
                        label: 'Mark\nAttendance',
                        color: AppTheme.success,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.event_note_outlined,
                        label: 'Apply\nLeave',
                        color: AppTheme.warning,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickActionCard(
                        icon: Icons.people_outline,
                        label: 'View\nTeam',
                        color: AppTheme.info,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Recent employees ──────────────────────────────────
                SectionHeader(
                  title: 'Team Status',
                  actionLabel: 'View All',
                  onAction: () {},
                ),
                const SizedBox(height: 16),
                ...SampleData.employees
                    .take(4)
                    .map((e) => _EmployeeTile(employee: e)),
                const SizedBox(height: 16),

                // ── Leave requests ────────────────────────────────────
                const SectionHeader(title: 'Pending Approvals'),
                const SizedBox(height: 16),
                _LeaveApprovalCard(
                  name: 'Rahul Nair',
                  type: 'Sick Leave',
                  dates: '02 – 03 Jan 2025',
                  initials: 'RN',
                ),
                const SizedBox(height: 10),
                _LeaveApprovalCard(
                  name: 'Lakshmi Devi',
                  type: 'Casual Leave',
                  dates: '05 Jan 2025',
                  initials: 'LD',
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _dayName(int d) {
    const n = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return n[(d - 1) % 7];
  }

  String _monthName(int m) {
    const n = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return n[m - 1];
  }
}

// ── Weekly Attendance Bar ────────────────────────────────────────────────────
class _WeeklyBar extends StatelessWidget {
  final String today;
  const _WeeklyBar({required this.today});

  @override
  Widget build(BuildContext context) {
    final data = {
      'Mon': 0.95,
      'Tue': 0.88,
      'Wed': 0.92,
      'Thu': 0.78,
      'Fri': 0.85,
      'Sat': 0.60,
      'Sun': 0.0,
    };

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.darkCard,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: data.entries.map((e) {
              final isToday = e.key == today;
              return _BarColumn(day: e.key, ratio: e.value, isToday: isToday);
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Legend(color: AppTheme.goldPrimary, label: 'Present'),
              const SizedBox(width: 20),
              _Legend(color: AppTheme.surfaceBlack, label: 'Absent/Holiday'),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  final String day;
  final double ratio;
  final bool isToday;
  const _BarColumn({
    required this.day,
    required this.ratio,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${(ratio * 24).round()}',
          style: GoogleFonts.lato(
            color: isToday ? AppTheme.goldPrimary : AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 28,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.surfaceBlack,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            width: 28,
            height: 80 * ratio,
            decoration: BoxDecoration(
              gradient: isToday
                  ? AppTheme.goldGradient
                  : LinearGradient(
                      colors: [
                        AppTheme.goldPrimary.withOpacity(0.5),
                        AppTheme.goldPrimary.withOpacity(0.3),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: GoogleFonts.lato(
            color: isToday ? AppTheme.goldPrimary : AppTheme.textSecondary,
            fontSize: 11,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        if (isToday)
          Container(
            margin: const EdgeInsets.only(top: 3),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: AppTheme.goldPrimary,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.lato(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Quick Action Card ────────────────────────────────────────────────────────
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: AppTheme.ivory,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Employee Tile ────────────────────────────────────────────────────────────
class _EmployeeTile extends StatelessWidget {
  final Employee employee;
  const _EmployeeTile({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.goldPrimary.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AvatarCircle(
            initials: employee.avatarInitials,
            size: 42,
            isPresent: employee.isPresent,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  employee.role,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          StatusBadge(
            label: employee.isPresent ? 'Present' : 'Absent',
            color: employee.isPresent ? AppTheme.success : AppTheme.danger,
          ),
        ],
      ),
    );
  }
}

// ── Leave Approval Card ──────────────────────────────────────────────────────
class _LeaveApprovalCard extends StatefulWidget {
  final String name;
  final String type;
  final String dates;
  final String initials;
  const _LeaveApprovalCard({
    required this.name,
    required this.type,
    required this.dates,
    required this.initials,
  });

  @override
  State<_LeaveApprovalCard> createState() => _LeaveApprovalCardState();
}

class _LeaveApprovalCardState extends State<_LeaveApprovalCard> {
  bool _actioned = false;
  bool _approved = false;

  @override
  Widget build(BuildContext context) {
    if (_actioned) {
      return Container(
        margin: const EdgeInsets.only(bottom: 0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _approved
              ? AppTheme.success.withOpacity(0.08)
              : AppTheme.danger.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: (_approved ? AppTheme.success : AppTheme.danger).withOpacity(
              0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _approved ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: _approved ? AppTheme.success : AppTheme.danger,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _approved
                  ? 'Approved ${widget.name}\'s leave'
                  : 'Rejected ${widget.name}\'s leave',
              style: GoogleFonts.lato(
                color: _approved ? AppTheme.success : AppTheme.danger,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.darkCard,
      child: Row(
        children: [
          AvatarCircle(initials: widget.initials, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${widget.type}  •  ${widget.dates}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Row(
            children: [
              _ActionBtn(
                icon: Icons.check,
                color: AppTheme.success,
                onTap: () => setState(() {
                  _actioned = true;
                  _approved = true;
                }),
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.close,
                color: AppTheme.danger,
                onTap: () => setState(() {
                  _actioned = true;
                  _approved = false;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
