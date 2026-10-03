import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

import '../theme/app_theme.dart';
import '../widgets/common.wideget.dart';
import 'main_nav_scrceen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  late AnimationController _ac;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ac = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeIn));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));
    _ac.forward();
  }

  @override
  void dispose() {
    _ac.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainNavScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _checkWifiAndLogin() async {
    setState(() => _loading = true);

    try {
      // 1. Check general network connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasWifi = connectivityResult.contains(ConnectivityResult.wifi);

      if (!hasWifi) {
        setState(() => _loading = false);
        _showWifiWarningDialog(
          title: 'Not Connected to WiFi',
          message:
              'To sign in, please connect to the office WiFi network: "Nakshatra_Office".',
          canBypass: true,
        );
        return;
      }

      // 2. Fetch the SSID
      final info = NetworkInfo();
      String? wifiName;
      try {
        wifiName = await info.getWifiName();
      } catch (_) {}

      final cleanWifiName = wifiName?.replaceAll('"', '') ?? '';
      const officeSSID = 'Nakshatra_Office';

      // 3. Enforce the office WiFi SSID
      if (wifiName == null || cleanWifiName.isEmpty) {
        setState(() => _loading = false);
        _showWifiWarningDialog(
          title: 'SSID Detection Restricted',
          message:
              'Connected to WiFi, but the name is restricted (requires Location permission).\n\nPlease ensure you are connected to the office WiFi: "$officeSSID".',
          canBypass: true,
        );
      } else if (cleanWifiName != officeSSID) {
        setState(() => _loading = false);
        _showWifiWarningDialog(
          title: 'Wrong WiFi Network',
          message:
              'You are currently connected to "$cleanWifiName".\n\nPlease switch to the office WiFi network: "$officeSSID" to sign in.',
          canBypass: true,
        );
      } else {
        _login();
      }
    } catch (e) {
      setState(() => _loading = false);
      _login();
    }
  }

  void _showWifiWarningDialog({
    required String title,
    required String message,
    bool canBypass = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: AppTheme.goldPrimary.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                color: AppTheme.danger,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.playfairDisplay(
                    color: AppTheme.ivory,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.lato(
              color: AppTheme.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            if (canBypass)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _login();
                },
                child: Text(
                  'Bypass (Demo)',
                  style: GoogleFonts.lato(
                    color: AppTheme.goldPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.goldPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Retry',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: Stack(
        children: [
          // Background decorative
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withOpacity(0.04),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),

                      // Top logo
                      Center(child: _buildMiniLogo()),
                      const SizedBox(height: 40),

                      // Welcome text
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 6),
                      const GoldDivider(width: 50),
                      const SizedBox(height: 12),
                      Text(
                        'Sign in to access your HR dashboard',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 44),

                      // Employee ID field
                      _buildLabel('EMPLOYEE ID / EMAIL'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailCtrl,
                        style: GoogleFonts.lato(
                          color: AppTheme.ivory,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'e.g. NGD-001 or email',
                          prefixIcon: Icon(
                            Icons.badge_outlined,
                            color: AppTheme.goldPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      _buildLabel('PASSWORD'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        style: GoogleFonts.lato(
                          color: AppTheme.ivory,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppTheme.goldPrimary,
                            size: 20,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscure = !_obscure),
                            child: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.lato(
                            color: AppTheme.goldPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Login button
                      GestureDetector(
                        onTap: _loading ? null : _checkWifiAndLogin,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: _loading
                              ? BoxDecoration(
                                  color: AppTheme.goldPrimary.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(14),
                                )
                              : AppTheme.goldCard,
                          child: Center(
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: AppTheme.deepBlack,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    'SIGN IN',
                                    style: GoogleFonts.lato(
                                      color: AppTheme.deepBlack,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Demo hint
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.goldPrimary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.goldPrimary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: AppTheme.goldPrimary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Demo: Use any credentials',
                                style: GoogleFonts.lato(
                                  color: AppTheme.goldPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Center(
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         'NAKSHATRA GOLD & DIAMONDS',
                      //         style: GoogleFonts.lato(
                      //           color: AppTheme.textSecondary.withOpacity(0.5),
                      //           fontSize: 10,
                      //           letterSpacing: 2,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         'v1.0.0 © 2024',
                      //         style: GoogleFonts.lato(
                      //           color: AppTheme.textSecondary.withOpacity(0.3),
                      //           fontSize: 10,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.lato(
        color: AppTheme.goldPrimary.withOpacity(0.8),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildMiniLogo() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Blended logo image
            SizedBox(
              width: 196,
              height: 196,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Hrms.png',
                  fit: BoxFit.contain,
                  color: AppTheme.deepBlack,
                  colorBlendMode: BlendMode.multiply,
                ),
              ),
            ),
            // Circular border on top
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
