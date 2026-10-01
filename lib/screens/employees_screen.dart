import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/employee.dart';
import '../widgets/common.wideget.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final _search = TextEditingController();
  String _filter = 'All';
  List<Employee> _filtered = SampleData.employees;

  final List<String> _departments = [
    'All',
    'Operations',
    'Design',
    'Sales',
    'Human Resources',
    'Finance',
    'Craft',
  ];

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearch);
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onSearch() => _applyFilter();

  void _applyFilter() {
    setState(() {
      _filtered = SampleData.employees.where((e) {
        final matchDept = _filter == 'All' || e.department == _filter;
        final q = _search.text.toLowerCase();
        final matchSearch =
            q.isEmpty ||
            e.name.toLowerCase().contains(q) ||
            e.role.toLowerCase().contains(q) ||
            e.employeeCode.toLowerCase().contains(q);
        return matchDept && matchSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.cardBlack,
            expandedHeight: 0,
            title: ShaderMask(
              shaderCallback: (b) => AppTheme.goldGradient.createShader(b),
              child: Text(
                '✦  Our Team',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search
                TextFormField(
                  controller: _search,
                  style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'Search by name, role or code…',
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppTheme.goldPrimary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Department filter
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _departments.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final d = _departments[i];
                      final active = _filter == d;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _filter = d);
                          _applyFilter();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: active ? AppTheme.goldGradient : null,
                            color: active ? null : AppTheme.cardBlack,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? Colors.transparent
                                  : AppTheme.goldPrimary.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            d,
                            style: GoogleFonts.lato(
                              color: active
                                  ? AppTheme.deepBlack
                                  : AppTheme.textSecondary,
                              fontSize: 12,
                              fontWeight: active
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Count
                Row(
                  children: [
                    Text(
                      '${_filtered.length} employee${_filtered.length != 1 ? 's' : ''}',
                      style: GoogleFonts.lato(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_filtered.where((e) => e.isPresent).length} present today',
                      style: GoogleFonts.lato(
                        color: AppTheme.success,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Employee cards
                ..._filtered.map((e) => _EmployeeCard(employee: e)),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEmployee(context),
        backgroundColor: AppTheme.goldPrimary,
        foregroundColor: AppTheme.deepBlack,
        icon: const Icon(Icons.person_add_outlined),
        label: Text(
          'Add Employee',
          style: GoogleFonts.lato(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showAddEmployee(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBlack,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _AddEmployeeSheet(),
    );
  }
}

// ── Employee Card ─────────────────────────────────────────────────────────────
class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.darkCard,
        child: Row(
          children: [
            AvatarCircle(
              initials: employee.avatarInitials,
              size: 52,
              isPresent: employee.isPresent,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    employee.role,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.goldPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.goldPrimary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          employee.employeeCode,
                          style: GoogleFonts.lato(
                            color: AppTheme.goldPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        employee.department,
                        style: GoogleFonts.lato(
                          color: AppTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                StatusBadge(
                  label: employee.isPresent ? 'In' : 'Out',
                  color: employee.isPresent
                      ? AppTheme.success
                      : AppTheme.danger,
                ),
                const SizedBox(height: 12),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textSecondary,
                  size: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardBlack,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => _EmployeeDetail(employee: employee),
    );
  }
}

// ── Employee Detail Sheet ─────────────────────────────────────────────────────
class _EmployeeDetail extends StatelessWidget {
  final Employee employee;
  const _EmployeeDetail({required this.employee});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppTheme.textSecondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  AvatarCircle(
                    initials: employee.avatarInitials,
                    size: 64,
                    isPresent: employee.isPresent,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          employee.role,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 6),
                        StatusBadge(
                          label: employee.isPresent
                              ? 'Present Today'
                              : 'Absent Today',
                          color: employee.isPresent
                              ? AppTheme.success
                              : AppTheme.danger,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const GoldDivider(width: 60),
              const SizedBox(height: 24),

              // Details grid
              _Detail(
                icon: Icons.badge_outlined,
                label: 'Employee Code',
                value: employee.employeeCode,
              ),
              _Detail(
                icon: Icons.business_outlined,
                label: 'Department',
                value: employee.department,
              ),
              _Detail(
                icon: Icons.email_outlined,
                label: 'Email',
                value: employee.email,
              ),
              _Detail(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: employee.phone,
              ),
              _Detail(
                icon: Icons.calendar_today_outlined,
                label: 'Joined',
                value: employee.joinDate,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: GoldButton(
                      label: 'Message',
                      icon: Icons.message_outlined,
                      onTap: () => Navigator.pop(context),
                      outlined: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GoldButton(
                      label: 'View Profile',
                      icon: Icons.person_outline,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Detail({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.goldPrimary, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.lato(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.lato(
                  color: AppTheme.ivory,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Add Employee Sheet ────────────────────────────────────────────────────────
class _AddEmployeeSheet extends StatelessWidget {
  const _AddEmployeeSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Add New Employee',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 6),
          const GoldDivider(width: 50),
          const SizedBox(height: 20),
          TextFormField(
            style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: AppTheme.goldPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
            decoration: const InputDecoration(
              labelText: 'Role / Designation',
              prefixIcon: Icon(
                Icons.work_outline,
                color: AppTheme.goldPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            style: GoogleFonts.lato(color: AppTheme.ivory, fontSize: 15),
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(
                Icons.email_outlined,
                color: AppTheme.goldPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 24),
          GoldButton(
            label: 'ADD EMPLOYEE',
            icon: Icons.person_add_outlined,
            onTap: () => Navigator.pop(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
