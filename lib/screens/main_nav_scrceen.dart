import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'attendance_screen.dart';
import 'leave_screen.dart';
import 'employees_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _current = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    AttendanceScreen(),
    LeaveScreen(),
    EmployeesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.cardBlack,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.deepBlack,
        body: IndexedStack(
          index: _current,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBlack,
            border: Border(
              top: BorderSide(
                color: AppTheme.goldPrimary.withOpacity(0.15),
                width: 1,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Home',
                    isActive: _current == 0,
                    onTap: () => setState(() => _current = 0),
                  ),
                  _NavItem(
                    icon: Icons.fingerprint,
                    activeIcon: Icons.fingerprint,
                    label: 'Attendance',
                    isActive: _current == 1,
                    onTap: () => setState(() => _current = 1),
                  ),
                  _NavItem(
                    icon: Icons.event_note_outlined,
                    activeIcon: Icons.event_note,
                    label: 'Leave',
                    isActive: _current == 2,
                    onTap: () => setState(() => _current = 2),
                  ),
                  _NavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    label: 'Team',
                    isActive: _current == 3,
                    onTap: () => setState(() => _current = 3),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    isActive: _current == 4,
                    onTap: () => setState(() => _current = 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppTheme.goldPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.goldPrimary.withOpacity(0.25),
                    width: 1),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive
                    ? AppTheme.goldPrimary
                    : const Color(0xFF555555),
                size: 22,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppTheme.goldPrimary
                    : const Color(0xFF555555),
                fontSize: 10,
                fontWeight:
                    isActive ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
