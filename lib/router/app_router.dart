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
import "../screens/places/place_registration_screen.dart";
import "../screens/home/home_screen.dart";
import "../screens/route/route_selection_screen.dart";

/// go_router + Riverpod 연동.
/// AuthState를 구독해서 인증 상태 변화 시 자동 리다이렉트.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: "/splash",
    redirect: (context, state) {
      final path = state.uri.path;
      final isOnboarding = path.startsWith("/onboarding") || path == "/splash";
      final isAuth = path.startsWith("/onboarding/auth") ||
          path.startsWith("/onboarding/email");

      switch (authState.status) {
        case AuthStatus.unknown:
          // 세션 확인 중 — 스플래시에 머문다
          if (path != "/splash") return "/splash";
          return null;

        case AuthStatus.unauthenticated:
          // 로그인 필요 — 인증 화면으로
          if (isAuth || path == "/onboarding/auth") return null;
          return "/onboarding/auth";

        case AuthStatus.emailVerificationRequired:
          // 이메일 미인증 — 인증 화면으로
          if (path.startsWith("/onboarding/email-verification")) return null;
          if (path == "/onboarding/auth") return null; // "다른 방법으로 로그인" 허용
          final email = authState.email ?? "";
          return "/onboarding/email-verification?email=${Uri.encodeComponent(email)}";

        case AuthStatus.consentRequired:
          // 약관 미동의 — 약관 화면으로
          if (path == "/onboarding/consent") return null;
          return "/onboarding/consent";

        case AuthStatus.authenticated:
          // 인증 완료 — 온보딩 페이지에 있으면 홈으로
          // 단, prep-time/location 등 초기 설정 화면은 허용
          if (path == "/splash") return "/home";
          if (path == "/onboarding/auth" ||
              path == "/onboarding/consent" ||
              path.startsWith("/onboarding/email-verification")) {
            return "/home";
          }
          return null;
      }
    },
    routes: [
      // ─── 스플래시 (세션 확인 중) ───────────────────────────────
      GoRoute(
        path: "/splash",
        builder: (c, s) => const _SplashScreen(),
      ),

      // ─── 온보딩 ────────────────────────────────────────────────
      GoRoute(
        path: "/onboarding/auth",
        builder: (c, s) => const AuthScreen(),
      ),
      GoRoute(
        path: "/onboarding/email-verification",
        builder: (c, s) {
          final email = s.uri.queryParameters["email"] ?? "";
          return EmailVerificationScreen(email: email);
        },
      ),
      GoRoute(
        path: "/onboarding/consent",
        builder: (c, s) => const ConsentScreen(),
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

      // ─── 기능 화면 (인증 필요) ─────────────────────────────────
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
        path: "/notifications/today",
        builder: (c, s) => const PlaceholderScreen(title: "알림 로그"),
      ),
      GoRoute(
        path: "/settings/wellness-prefs",
        builder: (c, s) => const PlaceholderScreen(title: "웰니스 설정"),
      ),
      GoRoute(
        path: "/summary/daily",
        builder: (c, s) => const PlaceholderScreen(title: "일일 마무리"),
      ),

      // ─── 메인 4탭 ─────────────────────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainTabShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: "/home",
              builder: (c, s) => const HomeScreen(),
            ),
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
});

// ─── 스플래시 (세션 확인 중 표시) ────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Ensom",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
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

// ─── 메인 탭 셸 ─────────────────────────────────────────────────
class MainTabShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const MainTabShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: (i) => shell.goBranch(i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "지도"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), label: "캘린더"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
        ],
      ),
    );
  }
}
