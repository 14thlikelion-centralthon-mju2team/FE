import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "placeholder_screen.dart";
import "../screens/onboarding/auth_screen.dart";
import "../screens/onboarding/consent_screen.dart";
import "../screens/onboarding/email_verification_screen.dart";
import "../screens/onboarding/location_permission_screen.dart";
import "../screens/onboarding/prep_time_entry_screen.dart";
import "../screens/places/place_registration_screen.dart";

/// 5탭(홈/캘린더/리포트/챗봇/마이) -> 4탭(홈/지도/캘린더/설정) 전환.
/// 최종 마일스톤 문서 M0 "4탭 스캐폴딩" 반영.
final appRouter = GoRouter(
  initialLocation: "/onboarding/splash",
  routes: [
    GoRoute(
        path: "/onboarding/splash",
        builder: (c, s) => const PlaceholderScreen(title: "스플래시")),
    GoRoute(
        path: "/onboarding/intro",
        builder: (c, s) => const PlaceholderScreen(title: "서비스 소개")),
    GoRoute(
      path: "/onboarding/auth",
      builder: (c, s) => AuthScreen(
        onGoogleLogin: () async {
          // TODO(fe-auth-onboarding): 실제 Google OAuth 연동
        },
      ),
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
      path: "/onboarding/interest",
      builder: (c, s) => const PlaceholderScreen(title: "관심 영역 선택"),
    ),
    GoRoute(
        path: "/onboarding/survey1",
        builder: (c, s) => const PlaceholderScreen(title: "설문 1/2")),
    GoRoute(
        path: "/onboarding/survey2",
        builder: (c, s) => const PlaceholderScreen(title: "설문 2/2")),
    GoRoute(
        path: "/onboarding/health-data",
        builder: (c, s) => const PlaceholderScreen(title: "건강 데이터 업로드")),
    GoRoute(
        path: "/onboarding/external-data",
        builder: (c, s) => const PlaceholderScreen(title: "외부 데이터 연동")),
    GoRoute(
        path: "/onboarding/notification-permission",
        builder: (c, s) => const PlaceholderScreen(title: "알림 권한")),
    GoRoute(
        path: "/onboarding/location-intro",
        builder: (c, s) => const LocationPermissionScreen()),
    GoRoute(
        path: "/onboarding/location-modal",
        builder: (c, s) => const PlaceholderScreen(title: "권한 모달")),
    GoRoute(
        path: "/onboarding/complete",
        builder: (c, s) => const PlaceholderScreen(title: "온보딩 완료")),
    GoRoute(
      path: "/onboarding/prep-time",
      builder: (c, s) => const PrepTimeEntryScreen(),
    ),
    GoRoute(
        path: "/places/manage",
        builder: (c, s) => const PlaceRegistrationScreen()),

    // 메인 4탭
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainTabShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/home",
              builder: (c, s) => const PlaceholderScreen(title: "홈")),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/map",
              builder: (c, s) => const PlaceholderScreen(title: "지도")),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/calendar",
              builder: (c, s) => const PlaceholderScreen(title: "캘린더")),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: "/settings",
              builder: (c, s) => const PlaceholderScreen(title: "설정")),
        ]),
      ],
    ),
  ],
);

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

// TODO(fe-auth-onboarding): 챗봇 탭 완전 제외 여부를 기획(최수민)에게
// 재확인 필요.