import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/common.wideget.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  bool _isSignedIn = false;
  String? _signInTime;
  String? _signOutTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulse;

  final List<_AttRecord> _history = [
    _AttRecord('Mon, 30 Dec', '09:02 AM', '06:15 PM', 'Present', 9.2),
    _AttRecord('Tue, 31 Dec', '08:58 AM', '06:08 PM', 'Present', 9.2),
    _AttRecord('Wed, 01 Jan', null, null, 'Holiday', 0),
    _AttRecord('Thu, 02 Jan', '09:10 AM', '05:55 PM', 'Present', 8.7),
    _AttRecord('Fri, 03 Jan', '09:00 AM', null, 'Present', 0),
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _timeNow() {
    final n = DateTime.now();
    final h = n.hour > 12
        ? n.hour - 12
        : n.hour == 0
        ? 12
        : n.hour;
    final m = n.minute.toString().padLeft(2, '0');
    final ampm = n.hour >= 12 ? 'PM' : 'AM';
    return '${h.toString().padLeft(2, '0')}:$m $ampm';
  }

  void _signIn() {
    setState(() {
      _isSignedIn = true;
      _signInTime = _timeNow();
      _signOutTime = null;
      _elapsed = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  void _signOut() {
    _timer?.cancel();
    setState(() {
      _isSignedIn = false;
      _signOutTime = _timeNow();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              'Signed out at $_signOutTime. Have a great day!',
              style: GoogleFonts.lato(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 0,
            pinned: true,
            backgroundColor: AppTheme.cardBlack,
            title: Row(
              children: [
                ShaderMask(
                  shaderCallback: (b) => AppTheme.goldGradient.createShader(b),
                  child: Text(
                    '✦  Attendance',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Live clock ───────────────────────────────────────
                _LiveClock(),
                const SizedBox(height: 28),

                // ── Sign In/Out Button ────────────────────────────────
                Center(
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (_, child) => Transform.scale(
                      scale: _isSignedIn ? _pulse.value : 1.0,
                      child: child,
                    ),
                    child: GestureDetector(
                      onTap: _isSignedIn ? _signOut : _signIn,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: _isSignedIn
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF4CAF86),
                                    Color(0xFF2E7D5A),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : AppTheme.goldGradient,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  (_isSignedIn
                                          ? AppTheme.success
                                          : AppTheme.goldPrimary)
                                      .withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isSignedIn
                                  ? Icons.logout_outlined
                                  : Icons.fingerprint,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _isSignedIn ? 'SIGN OUT' : 'SIGN IN',
                              style: GoogleFonts.lato(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                            ),
                            if (_isSignedIn) ...[
                              const SizedBox(height: 6),
                              Text(
                                _fmt(_elapsed),
                                style: GoogleFonts.lato(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _isSignedIn
                        ? 'Tap to sign out when leaving'
                        : 'Tap to mark your attendance',
                    style: GoogleFonts.lato(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Today's info ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.darkCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Record",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      const GoldDivider(width: 36),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _TimeBox(
                              label: 'Sign In',
                              time: _signInTime ?? '--:-- --',
                              icon: Icons.login_outlined,
                              color: AppTheme.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TimeBox(
                              label: 'Sign Out',
                              time: _signOutTime ?? '--:-- --',
                              icon: Icons.logout_outlined,
                              color: AppTheme.danger,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TimeBox(
                              label: 'Duration',
                              time: _isSignedIn
                                  ? _fmt(_elapsed)
                                  : (_signOutTime != null
                                        ? _fmt(_elapsed)
                                        : '-- : --'),
                              icon: Icons.timer_outlined,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── Monthly summary ───────────────────────────────────
                const SectionHeader(title: 'Monthly Summary'),
                const SizedBox(height: 16),
                _MonthlySummary(),
                const SizedBox(height: 28),

                // ── History ───────────────────────────────────────────
                const SectionHeader(title: 'Recent History'),
                const SizedBox(height: 16),
                ..._history.map((r) => _HistoryRow(record: r)),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Live Clock ───────────────────────────────────────────────────────────────
class _LiveClock extends StatefulWidget {
  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late Timer _t;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _t = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = DateTime.now()),
    );
  }

  @override
  void dispose() {
    _t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _now.hour > 12
        ? _now.hour - 12
        : _now.hour == 0
        ? 12
        : _now.hour;
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');
    final ampm = _now.hour >= 12 ? 'PM' : 'AM';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
      decoration: BoxDecoration(
        gradient: AppTheme.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.goldPrimary.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Time',
                style: GoogleFonts.lato(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShaderMask(
                    shaderCallback: (b) =>
                        AppTheme.goldGradient.createShader(b),
                    child: Text(
                      '${h.toString().padLeft(2, '0')}:$m:$s',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      ampm,
                      style: GoogleFonts.lato(
                        color: AppTheme.goldPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppTheme.goldPrimary.withOpacity(0.25),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.goldPrimary,
                  size: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  'Office',
                  style: GoogleFonts.lato(
                    color: AppTheme.ivory,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Verified',
                  style: GoogleFonts.lato(
                    color: AppTheme.success,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Time Box ─────────────────────────────────────────────────────────────────
class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;
  const _TimeBox({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            time,
            style: GoogleFonts.lato(
              color: AppTheme.ivory,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lato(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Monthly Summary ──────────────────────────────────────────────────────────
class _MonthlySummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.darkCard,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryChip(
                label: 'Present',
                value: '18',
                color: AppTheme.success,
              ),
              _SummaryChip(label: 'Absent', value: '2', color: AppTheme.danger),
              _SummaryChip(label: 'Leave', value: '3', color: AppTheme.warning),
              _SummaryChip(label: 'Holidays', value: '2', color: AppTheme.info),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Flexible(
                  flex: 18,
                  child: Container(height: 8, color: AppTheme.success),
                ),
                Flexible(
                  flex: 2,
                  child: Container(height: 8, color: AppTheme.danger),
                ),
                Flexible(
                  flex: 3,
                  child: Container(height: 8, color: AppTheme.warning),
                ),
                Flexible(
                  flex: 2,
                  child: Container(height: 8, color: AppTheme.info),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'January 2025',
                style: GoogleFonts.lato(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                '25 / 25 working days',
                style: GoogleFonts.lato(
                  color: AppTheme.goldPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.lato(color: AppTheme.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Attendance Record ─────────────────────────────────────────────────────────
class _AttRecord {
  final String date;
  final String? signIn;
  final String? signOut;
  final String status;
  final double hours;
  _AttRecord(this.date, this.signIn, this.signOut, this.status, this.hours);
}

class _HistoryRow extends StatelessWidget {
  final _AttRecord record;
  const _HistoryRow({required this.record});

  Color _color() {
    switch (record.status) {
      case 'Present':
        return AppTheme.success;
      case 'Holiday':
        return AppTheme.info;
      case 'Absent':
        return AppTheme.danger;
      default:
        return AppTheme.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.goldPrimary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: _color(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.date,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  record.signIn != null
                      ? '${record.signIn}  →  ${record.signOut ?? 'In Progress'}'
                      : record.status,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StatusBadge(label: record.status, color: _color()),
              if (record.hours > 0) ...[
                const SizedBox(height: 6),
                Text(
                  '${record.hours}h',
                  style: GoogleFonts.lato(
                    color: AppTheme.goldPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
