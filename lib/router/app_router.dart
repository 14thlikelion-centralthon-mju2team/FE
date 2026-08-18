import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "placeholder_screen.dart";
import "../screens/onboarding/auth_screen.dart";
import "../screens/onboarding/consent_screen.dart";
import "../screens/onboarding/email_verification_screen.dart";
import "../screens/onboarding/location_permission_screen.dart";
import "../screens/onboarding/prep_time_entry_screen.dart";
import "../screens/home/home_screen.dart";
import "../screens/notifications/notification_log_screen.dart";
import "../screens/settings/wellness_prefs_screen.dart";
import "../screens/summary/daily_summary_screen.dart";

final appRouterProvider = Provider<GoRouter>((ref) => appRouter);

final appRouter = GoRouter(
  initialLocation: "/onboarding/splash",
  routes: [
    GoRoute(
      path: "/onboarding/splash",
      builder: (c, s) => const PlaceholderScreen(title: "스플래시"),
    ),
    GoRoute(
      path: "/onboarding/intro",
      builder: (c, s) => const PlaceholderScreen(title: "서비스 소개"),
    ),
    GoRoute(
      path: "/onboarding/auth",
      builder: (c, s) => const AuthScreen(),
    ),
    GoRoute(
      path: "/onboarding/consent",
      builder: (c, s) => const ConsentScreen(),
    ),
    GoRoute(
      path: "/onboarding/email-verification",
      builder: (c, s) => EmailVerificationScreen(
        email: s.uri.queryParameters["email"] ?? "",
      ),
    ),
    GoRoute(
      path: "/onboarding/prep-time",
      builder: (c, s) => const PrepTimeEntryScreen(),
    ),
    GoRoute(
      path: "/onboarding/location-intro",
      builder: (c, s) => const LocationPermissionScreen(),
    ),
    GoRoute(
      path: "/onboarding/interest",
      builder: (c, s) => const PlaceholderScreen(title: "관심 영역 선택"),
    ),
    GoRoute(
      path: "/onboarding/complete",
      builder: (c, s) => const PlaceholderScreen(title: "온보딩 완료"),
    ),
    GoRoute(
      path: "/onboarding/password-reset",
      builder: (c, s) => const PlaceholderScreen(title: "비밀번호 재설정"),
    ),
    GoRoute(
      path: "/notifications/today",
      builder: (c, s) => const NotificationLogScreen(),
    ),
    GoRoute(
      path: "/settings/wellness-prefs",
      builder: (c, s) => const WellnessPrefsScreen(),
    ),
    GoRoute(
      path: "/summary/daily",
      builder: (c, s) => const DailySummaryScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainTabShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: "/home", builder: (c, s) => const HomeScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/map",
            builder: (c, s) => const PlaceholderScreen(title: "지도"),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/calendar",
            builder: (c, s) => const PlaceholderScreen(title: "캘린더"),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: "/settings",
            builder: (c, s) => const PlaceholderScreen(title: "설정"),
          ),
        ]),
      ],
    ),
  ],
);

class MainTabShell extends StatelessWidget {
  const MainTabShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: shell.goBranch,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "캘린더",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
        ],
      ),
    );
  }
}
