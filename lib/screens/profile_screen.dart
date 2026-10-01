import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common.wideget.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.cardBlack, AppTheme.deepBlack],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 32,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            AppTheme.goldGradient.createShader(b),
                        child: Text(
                          '✦  My Profile',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withOpacity(0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: AppTheme.goldPrimary,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Avatar and name
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.goldGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.goldPrimary.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'AK',
                        style: GoogleFonts.playfairDisplay(
                          color: AppTheme.deepBlack,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Arjun Krishnan',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Store Manager',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Tag(label: 'NGD-001'),
                      const SizedBox(width: 10),
                      _Tag(label: 'Operations'),
                      const SizedBox(width: 10),
                      _Tag(label: '5 yrs exp', color: AppTheme.success),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                Row(
                  children: [
                    _MiniStat(label: 'Days Present', value: '280'),
                    const SizedBox(width: 12),
                    _MiniStat(label: 'Leaves Used', value: '9'),
                    const SizedBox(width: 12),
                    _MiniStat(label: 'Projects', value: '14'),
                  ],
                ),
                const SizedBox(height: 28),

                // Personal info
                const SectionHeader(title: 'Personal Information'),
                const SizedBox(height: 16),
                _InfoCard(
                  children: [
                    _InfoRow(Icons.badge_outlined, 'Employee ID', 'NGD-001'),
                    _InfoRow(
                      Icons.email_outlined,
                      'Email',
                      'arjun.k@nakshatra.com',
                    ),
                    _InfoRow(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
                    _InfoRow(
                      Icons.cake_outlined,
                      'Date of Birth',
                      '15 August 1992',
                    ),
                    _InfoRow(
                      Icons.location_on_outlined,
                      'Address',
                      'Thiruvananthapuram, Kerala',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Work info
                const SectionHeader(title: 'Work Details'),
                const SizedBox(height: 16),
                _InfoCard(
                  children: [
                    _InfoRow(
                      Icons.business_center_outlined,
                      'Department',
                      'Operations',
                    ),
                    _InfoRow(
                      Icons.calendar_today_outlined,
                      'Joined',
                      '15 January 2021',
                    ),
                    _InfoRow(
                      Icons.schedule_outlined,
                      'Shift',
                      '9:00 AM – 6:00 PM',
                    ),
                    _InfoRow(
                      Icons.supervisor_account_outlined,
                      'Reports To',
                      'Deepa Pillai (HR)',
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Settings section
                const SectionHeader(title: 'Settings'),
                const SizedBox(height: 16),
                _SettingItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  trailing: Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: AppTheme.goldPrimary,
                  ),
                ),
                _SettingItem(
                  icon: Icons.lock_outline,
                  label: 'Change Password',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.textSecondary,
                    size: 14,
                  ),
                ),
                _SettingItem(
                  icon: Icons.language_outlined,
                  label: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'English',
                        style: GoogleFonts.lato(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.textSecondary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
                _SettingItem(
                  icon: Icons.help_outline,
                  label: 'Help & Support',
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.textSecondary,
                    size: 14,
                  ),
                ),
                const SizedBox(height: 20),

                // Logout
                GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.danger.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          color: AppTheme.danger,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Sign Out',
                          style: GoogleFonts.lato(
                            color: AppTheme.danger,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Nakshatra Gold & Diamonds  •  v1.0.0',
                    style: GoogleFonts.lato(
                      color: AppTheme.textSecondary.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, this.color = AppTheme.goldPrimary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.cardBlack,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.goldPrimary.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.playfairDisplay(
                color: AppTheme.goldPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lato(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.darkCard,
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.goldPrimary, size: 18),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
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
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.goldPrimary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.titleMedium),
          ),
          trailing,
        ],
      ),
    );
  }
}
