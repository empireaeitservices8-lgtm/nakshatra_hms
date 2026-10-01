import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common.wideget.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.cardBlack,
            expandedHeight: 0,
            title: ShaderMask(
              shaderCallback: (b) => AppTheme.goldGradient.createShader(b),
              child: Text(
                '✦  Leave Management',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tab,
              labelColor: AppTheme.goldPrimary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.goldPrimary,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.lato(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(text: 'Apply Leave'),
                Tab(text: 'My Leaves'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tab,
          children: const [_ApplyLeaveTab(), _MyLeavesTab()],
        ),
      ),
    );
  }
}

// ── Apply Leave Tab ──────────────────────────────────────────────────────────
class _ApplyLeaveTab extends StatefulWidget {
  const _ApplyLeaveTab();

  @override
  State<_ApplyLeaveTab> createState() => _ApplyLeaveTabState();
}

class _ApplyLeaveTabState extends State<_ApplyLeaveTab> {
  String _selectedType = 'Casual Leave';
  DateTime? _fromDate;
  DateTime? _toDate;
  final _reasonCtrl = TextEditingController();
  bool _submitted = false;

  final List<String> _leaveTypes = [
    'Casual Leave',
    'Sick Leave',
    'Earned Leave',
    'Maternity Leave',
    'Compensatory Leave',
    'Emergency Leave',
  ];

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.goldPrimary,
            onSurface: AppTheme.ivory,
            surface: AppTheme.cardBlack,
          ),
          dialogBackgroundColor: AppTheme.richBlack,
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
          if (_toDate != null && _toDate!.isBefore(picked)) {
            _toDate = picked;
          }
        } else {
          _toDate = picked;
        }
      });
    }
  }

  int get _days {
    if (_fromDate == null || _toDate == null) return 0;
    return _toDate!.difference(_fromDate!).inDays + 1;
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Select Date';
    const months = [
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
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _submit() {
    if (_fromDate == null || _toDate == null || _reasonCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          content: Text(
            'Please fill all fields',
            style: GoogleFonts.lato(color: Colors.white),
          ),
        ),
      );
      return;
    }
    setState(() => _submitted = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _submitted = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Cards
          const _LeaveBalanceRow(),
          const SizedBox(height: 28),

          // Form
          const SectionHeader(title: 'Apply for Leave'),
          const SizedBox(height: 20),

          // Leave type
          _formLabel('LEAVE TYPE'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceBlack,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.goldPrimary.withOpacity(0.25)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                dropdownColor: AppTheme.cardBlack,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.goldPrimary,
                ),
                style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
                items: _leaveTypes
                    .map(
                      (t) => DropdownMenuItem(
                        value: t,
                        child: Text(
                          t,
                          style: GoogleFonts.lato(
                            color: AppTheme.ivory,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Date row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formLabel('FROM DATE'),
                    const SizedBox(height: 10),
                    _DateTile(
                      label: _fmt(_fromDate),
                      onTap: () => _pickDate(true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _formLabel('TO DATE'),
                    const SizedBox(height: 10),
                    _DateTile(
                      label: _fmt(_toDate),
                      onTap: () => _pickDate(false),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          if (_days > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.goldPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.3),
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
                    '$_days day${_days > 1 ? 's' : ''} of leave',
                    style: GoogleFonts.lato(
                      color: AppTheme.goldPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Reason
          _formLabel('REASON FOR LEAVE'),
          const SizedBox(height: 10),
          TextFormField(
            controller: _reasonCtrl,
            maxLines: 4,
            style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Describe the reason for your leave request...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),

          // Attachment option
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceBlack,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.25),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_file,
                    color: AppTheme.goldPrimary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Attach supporting document (optional)',
                    style: GoogleFonts.lato(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Submit button
          _submitted
              ? Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.success.withOpacity(0.4),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppTheme.success,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Leave Request Submitted!',
                          style: GoogleFonts.lato(
                            color: AppTheme.success,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GoldButton(
                  label: 'SUBMIT LEAVE REQUEST',
                  icon: Icons.send_outlined,
                  onTap: _submit,
                  width: double.infinity,
                ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _formLabel(String text) => Text(
    text,
    style: GoogleFonts.lato(
      color: AppTheme.goldPrimary.withOpacity(0.8),
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
  );
}

class _DateTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DateTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceBlack,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.goldPrimary.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: AppTheme.goldPrimary,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.lato(
                  color: label == 'Select Date'
                      ? AppTheme.textSecondary.withOpacity(0.5)
                      : AppTheme.ivory,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Leave Balance Row ─────────────────────────────────────────────────────────
class _LeaveBalanceRow extends StatelessWidget {
  const _LeaveBalanceRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Leave Balance'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _BalanceCard(
                type: 'Casual',
                total: 12,
                used: 4,
                color: AppTheme.info,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BalanceCard(
                type: 'Sick',
                total: 10,
                used: 2,
                color: AppTheme.danger,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BalanceCard(
                type: 'Earned',
                total: 15,
                used: 7,
                color: AppTheme.success,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String type;
  final int total;
  final int used;
  final Color color;
  const _BalanceCard({
    required this.type,
    required this.total,
    required this.used,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = total - used;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
      ),
      child: Column(
        children: [
          Text(
            '$remaining',
            style: GoogleFonts.playfairDisplay(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            type,
            style: GoogleFonts.lato(
              color: AppTheme.ivory,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'of $total days',
            style: GoogleFonts.lato(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: remaining / total,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── My Leaves Tab ─────────────────────────────────────────────────────────────
class _MyLeavesTab extends StatelessWidget {
  const _MyLeavesTab();

  @override
  Widget build(BuildContext context) {
    final leaves = [
      _LeaveEntry(
        'Casual Leave',
        '05 Jan 2025',
        '05 Jan 2025',
        'Personal work',
        'Approved',
      ),
      _LeaveEntry(
        'Sick Leave',
        '20 Dec 2024',
        '21 Dec 2024',
        'Fever and rest',
        'Approved',
      ),
      _LeaveEntry(
        'Casual Leave',
        '10 Jan 2025',
        '11 Jan 2025',
        'Family function',
        'Pending',
      ),
      _LeaveEntry(
        'Earned Leave',
        '25 Feb 2025',
        '28 Feb 2025',
        'Annual vacation',
        'Rejected',
      ),
      _LeaveEntry(
        'Emergency Leave',
        '15 Nov 2024',
        '16 Nov 2024',
        'Family emergency',
        'Approved',
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ...leaves.map((l) => _LeaveCard(entry: l)),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _LeaveEntry {
  final String type;
  final String from;
  final String to;
  final String reason;
  final String status;
  _LeaveEntry(this.type, this.from, this.to, this.reason, this.status);
}

class _LeaveCard extends StatelessWidget {
  final _LeaveEntry entry;
  const _LeaveCard({required this.entry});

  Color _statusColor() {
    switch (entry.status) {
      case 'Approved':
        return AppTheme.success;
      case 'Rejected':
        return AppTheme.danger;
      default:
        return AppTheme.warning;
    }
  }

  IconData _statusIcon() {
    switch (entry.status) {
      case 'Approved':
        return Icons.check_circle_outline;
      case 'Rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.pending_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _statusColor().withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.type, style: Theme.of(context).textTheme.titleMedium),
              StatusBadge(label: entry.status, color: _statusColor()),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                color: AppTheme.goldPrimary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                '${entry.from}  →  ${entry.to}',
                style: GoogleFonts.lato(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.notes_outlined,
                color: AppTheme.textSecondary,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                entry.reason,
                style: GoogleFonts.lato(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_statusIcon(), color: _statusColor(), size: 14),
                const SizedBox(width: 6),
                Text(
                  entry.status == 'Approved'
                      ? 'Leave approved by HR'
                      : entry.status == 'Rejected'
                      ? 'Leave rejected — contact HR'
                      : 'Awaiting HR approval',
                  style: GoogleFonts.lato(
                    color: _statusColor(),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
