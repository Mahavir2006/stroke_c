import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/landing/landing_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/face_analysis/face_analysis_screen.dart';
import '../features/voice_check/voice_check_screen.dart';
import '../features/motion_test/motion_test_screen.dart';
import '../features/tap_test/tap_test_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/signup_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/profile_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/full_checkup/checkup_report_screen.dart';
import '../features/full_checkup/full_checkup_screen.dart';
import '../features/medical_reports/medical_report_screen.dart';
import '../shared/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password';
      final isLandingRoute = state.matchedLocation == '/';

      if (isAuthRoute || isLandingRoute) {
        if (isAuthenticated) return '/app';
        return null;
      }
      if (!isAuthenticated) return '/login';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/checkup/report',
        name: 'checkup-report',
        builder: (context, state) => const CheckupReportScreen(),
      ),
      GoRoute(
        path: '/medical-reports',
        name: 'medical-reports',
        builder: (context, state) => const MedicalReportScreen(),
      ),
      GoRoute(
        path: '/checkup',
        name: 'checkup',
        builder: (context, state) => const FullCheckupScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/app',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/face',
            name: 'face',
            builder: (context, state) => const FaceAnalysisScreen(),
          ),
          GoRoute(
            path: '/voice',
            name: 'voice',
            builder: (context, state) => const VoiceCheckScreen(),
          ),
          GoRoute(
            path: '/motion',
            name: 'motion',
            builder: (context, state) => const MotionTestScreen(),
          ),
          GoRoute(
            path: '/tap',
            name: 'tap',
            builder: (context, state) => const TapTestScreen(),
          ),
          GoRoute(
            path: '/medical-report',
            name: 'medical-report',
            builder: (context, state) => const MedicalReportScreen(),
          ),
        ],
      ),
    ],
  );
});