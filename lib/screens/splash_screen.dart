import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.3, end: 1.5).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );
    _shimmerAnim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) _textController.forward();
    });
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepBlack,
      body: Stack(
        children: [
          // Background decorative circles
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.goldPrimary.withOpacity(0.04),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: _buildLogo(),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                // Brand text
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, __) => SlideTransition(
                    position: _textSlide,
                    child: Opacity(
                      opacity: _textOpacity.value,
                      child: _buildBrandText(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom tagline
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _textController,
              builder: (_, __) => Opacity(
                opacity: _textOpacity.value,
                child: Column(
                  children: [
                    const _GoldDotRow(),
                    const SizedBox(height: 14),
                    Text(
                      'HR MANAGEMENT SYSTEM',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        color: AppTheme.goldPrimary.withOpacity(0.7),
                        fontSize: 11,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Background container with glows and radial gradient (no border)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.goldLight.withOpacity(0.15),
                    AppTheme.goldPrimary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.goldPrimary.withOpacity(0.25),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // The clipped and blended image
            SizedBox(
              width: 196,
              height: 196,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Hrms.png',
                  fit: BoxFit.contain,
                  color: AppTheme.deepBlack,
                  colorBlendMode: BlendMode.multiply,
                  opacity: const AlwaysStoppedAnimation(0.9),
                ),
              ),
            ),
            // The border container on top
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrandText() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              AppTheme.goldGradient.createShader(bounds),
          // child: Text(
          //   'NAKSHATRA',
          //   style: GoogleFonts.playfairDisplay(
          //     fontSize: 32,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.white,
          //     letterSpacing: 6,
          //   ),
          // ),
        ),
        const SizedBox(height: 4),
        // Text(
        //   'Gold & Diamonds',
        //   style: GoogleFonts.lato(
        //     color: AppTheme.ivoryDark.withOpacity(0.7),
        //     fontSize: 15,
        //     letterSpacing: 3,
        //     fontWeight: FontWeight.w300,
        //   ),
        // ),
      ],
    );
  }
}

class _GoldDotRow extends StatelessWidget {
  const _GoldDotRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: i == 1 ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}
