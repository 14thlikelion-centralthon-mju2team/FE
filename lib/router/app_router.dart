import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'placeholder_screen.dart';
import '../screens/onboarding/auth_screen.dart';
import '../screens/onboarding/age_confirm_screen.dart';
import '../screens/onboarding/location_permission_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding/splash',
  routes: [
    // 온보딩 16화면 (탭바 없음)
    GoRoute(path: '/onboarding/splash', builder: (c, s) => const PlaceholderScreen(title: '스플래시')),
    GoRoute(path: '/onboarding/intro', builder: (c, s) => const PlaceholderScreen(title: '서비스 소개')),
    GoRoute(path: '/onboarding/auth', builder: (c, s) => const AuthScreen()),
    GoRoute(path: '/onboarding/age', builder: (c, s) => const AgeConfirmScreen()),
    GoRoute(path: '/onboarding/consent', builder: (c, s) => const PlaceholderScreen(title: '데이터 수집 동의')),
    GoRoute(path: '/onboarding/interest', builder: (c, s) => const PlaceholderScreen(title: '관심 영역 선택')),
    GoRoute(path: '/onboarding/survey1', builder: (c, s) => const PlaceholderScreen(title: '설문 1/2')),
    GoRoute(path: '/onboarding/survey2', builder: (c, s) => const PlaceholderScreen(title: '설문 2/2')),
    GoRoute(path: '/onboarding/health-data', builder: (c, s) => const PlaceholderScreen(title: '건강 데이터 업로드')),
    GoRoute(path: '/onboarding/external-data', builder: (c, s) => const PlaceholderScreen(title: '외부 데이터 연동')),
    GoRoute(path: '/onboarding/notification-permission', builder: (c, s) => const PlaceholderScreen(title: '알림 권한')),
    GoRoute(path: '/onboarding/location-intro', builder: (c, s) => const LocationPermissionScreen()),
    GoRoute(path: '/onboarding/location-modal', builder: (c, s) => const PlaceholderScreen(title: '권한 모달')),
    GoRoute(path: '/onboarding/complete', builder: (c, s) => const PlaceholderScreen(title: '온보딩 완료')),
    GoRoute(path: '/onboarding/routine-setup', builder: (c, s) => const PlaceholderScreen(title: '목표·기본 루틴 설정')),

    // 메인 5탭
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MainTabShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (c, s) => const PlaceholderScreen(title: '홈')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/calendar', builder: (c, s) => const PlaceholderScreen(title: '캘린더')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/report', builder: (c, s) => const PlaceholderScreen(title: '리포트')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/chat', builder: (c, s) => const PlaceholderScreen(title: '챗봇')),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/my', builder: (c, s) => const PlaceholderScreen(title: '마이')),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '캘린더'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: '리포트'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: '챗봇'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이'),
        ],
      ),
    );
  }
}