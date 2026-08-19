import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "placeholder_screen.dart";
import "../providers/auth_providers.dart";
import "../screens/onboarding/auth_screen.dart";
import "../screens/onboarding/consent_screen.dart";
import "../screens/onboarding/email_verification_screen.dart";
import "../screens/onboarding/location_permission_screen.dart";
import "../screens/onboarding/prep_time_entry_screen.dart";
import "../screens/onboarding/wellness_onboarding_screen.dart";
import "../screens/home/home_screen.dart";
import "../screens/notifications/notification_log_screen.dart";
import "../screens/places/place_registration_screen.dart";
import "../screens/route/route_selection_screen.dart";
import "../screens/settings/wellness_prefs_screen.dart";
import "../screens/summary/daily_summary_screen.dart";
import "../screens/map/map_screen.dart";
import "../screens/events/event_create_from_map_screen.dart";
import "../screens/calendar/calendar_screen.dart";
import "../screens/calendar/event_form_screen.dart";
import "../screens/detail/event_detail_screen.dart";
import "../screens/search/place_search_screen.dart";
import "../screens/profile/profile_screen.dart";
import "../screens/profile/account_screen.dart";
import "../screens/profile/notification_settings_screen.dart";
import "../screens/profile/personalization_screen.dart";
import "../screens/profile/permissions_screen.dart";
import "../screens/profile/data_management_screen.dart";

/// GoRouter + Riverpod 연동.
/// AuthState를 구독해서 인증 상태 변화 시 자동 리다이렉트.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: "/splash",
    redirect: (context, state) {
      final path = state.uri.path;
      final isAuthPage = path.startsWith("/onboarding/auth") ||
          path.startsWith("/onboarding/email");
      final isConsentPage = path == "/onboarding/consent";

      switch (authState.status) {
        case AuthStatus.unknown:
          // 세션 확인 중 — 스플래시에 머문다
          if (path != "/splash") return "/splash";
          return null;

        case AuthStatus.unauthenticated:
          // 인증 필요 — 인증 화면으로
          if (isAuthPage) return null;
          return "/onboarding/auth";

        case AuthStatus.emailVerificationRequired:
          // 이메일 미인증 — 인증 대기 화면으로
          if (path.startsWith("/onboarding/email-verification")) return null;
          if (path == "/onboarding/auth") return null;
          final email = authState.email ?? "";
          return "/onboarding/email-verification?email=${Uri.encodeComponent(email)}";

        case AuthStatus.consentRequired:
          // 약관 미동의 — 동의 화면으로
          if (isConsentPage) return null;
          return "/onboarding/consent";

        case AuthStatus.authenticated:
          // 인증 완료 — 온보딩/스플래시에 있으면 홈으로
          if (path == "/splash" ||
              path == "/onboarding/auth" ||
              isConsentPage ||
              path.startsWith("/onboarding/email-verification")) {
            return "/home";
          }
          return null;
      }
    },
    routes: [
      // ─── 스플래시 (세션 확인 중) ─────────────────────────────────
      GoRoute(
        path: "/splash",
        builder: (c, s) => const _SplashScreen(),
      ),

      // ─── 온보딩 ──────────────────────────────────────────────────
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
        path: "/onboarding/places",
        builder: (c, s) => const PlaceRegistrationScreen(isOnboarding: true),
      ),
      GoRoute(
        path: "/onboarding/wellness",
        builder: (c, s) => const WellnessOnboardingScreen(),
      ),
      GoRoute(
        path: "/onboarding/password-reset",
        builder: (c, s) => const PlaceholderScreen(title: "비밀번호 재설정"),
      ),

      // ─── 기능 화면 (인증 필요) ───────────────────────────────────
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
      GoRoute(
        path: "/places/manage",
        builder: (c, s) => const PlaceRegistrationScreen(),
      ),
      GoRoute(
        path: "/plans/:planId/routes",
        builder: (c, s) => RouteSelectionScreen(
          planId: s.pathParameters["planId"]!,
          eventId: s.uri.queryParameters["eventId"]!,
        ),
      ),
      GoRoute(
        path: "/events/create-from-map",
        builder: (c, s) => const EventCreateFromMapScreen(),
      ),
      GoRoute(
        path: "/search/place",
        builder: (c, s) => const PlaceSearchScreen(),
      ),
      GoRoute(
        path: "/calendar/new",
        builder: (c, s) => const EventFormScreen(),
      ),

      // ─── DTL-01 일정 상세 ─────────────────────────────────────
      GoRoute(
        path: "/events/:eventId",
        builder: (c, s) => EventDetailScreen(
          eventId: s.pathParameters["eventId"]!,
        ),
      ),

      // ─── PRF 프로필 하위 ──────────────────────────────────────
      GoRoute(
        path: "/profile/account",
        builder: (c, s) => const AccountScreen(),
      ),
      GoRoute(
        path: "/profile/withdraw",
        builder: (c, s) => const WithdrawScreen(),
      ),
      GoRoute(
        path: "/profile/prep",
        builder: (c, s) => const PrepTimeEntryScreen(),
      ),
      GoRoute(
        path: "/profile/notifications",
        builder: (c, s) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: "/profile/permissions",
        builder: (c, s) => const PermissionsScreen(),
      ),
      GoRoute(
        path: "/profile/personalization",
        builder: (c, s) => const PersonalizationScreen(),
      ),
      GoRoute(
        path: "/profile/data",
        builder: (c, s) => const DataManagementScreen(),
      ),

      // ─── 메인 4탭 (화면설계서 확정: 캘린더·홈·지도·프로필) ────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainTabShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/calendar",
              builder: (c, s) => const CalendarScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: "/home", builder: (c, s) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: "/map", builder: (c, s) => const MapScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/profile",
              builder: (c, s) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});

// ─── 스플래시 (세션 확인 중 표시) ──────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ensom",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("늦지 않게, 서두르지 않게.",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 32),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

// ─── 메인 탭 셸 ───────────────────────────────────────────────────
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
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "캘린더",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "프로필",
          ),
        ],
      ),
    );
  }
}
