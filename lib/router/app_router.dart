import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:permission_handler/permission_handler.dart";
import "../core/permission_service.dart";
import "../providers/auth_providers.dart";
import "../providers/map_providers.dart";
import "../screens/onboarding/auth_screen.dart";
import "../screens/onboarding/splash_screen.dart";
import "../screens/onboarding/consent_screen.dart";
import "../screens/onboarding/email_verification_screen.dart";
import "../screens/onboarding/location_permission_screen.dart";
import "../screens/onboarding/prep_time_entry_screen.dart";
import "../screens/onboarding/wellness_onboarding_screen.dart";
import "../screens/onboarding/onboarding_complete_screen.dart";
import "../screens/onboarding/permission_priming_screen.dart";
import "../screens/onboarding/signup_complete_screen.dart";
import "../screens/home/home_screen.dart";
import "../screens/notifications/notification_log_screen.dart";
import "../screens/places/place_registration_screen.dart";
import "../screens/route/route_selection_screen.dart";
import "../screens/settings/wellness_prefs_screen.dart";
import "../screens/summary/daily_summary_screen.dart";
import "../screens/map/map_screen.dart";
import "../screens/calendar/calendar_screen.dart";
import "../screens/calendar/event_form_screen.dart";
import "../screens/calendar/calendar_sync_screen.dart";
import "../screens/calendar/weekly_report_screen.dart";
import "../screens/detail/event_detail_screen.dart";
import "../screens/search/place_search_screen.dart";
import "../screens/profile/profile_screen.dart";
import "../screens/profile/account_screen.dart";
import "../screens/profile/notification_settings_screen.dart";
import "../screens/profile/personalization_screen.dart";
import "../screens/profile/permissions_screen.dart";
import "../screens/profile/data_management_screen.dart";
import "../screens/profile/change_password_screen.dart";
import "../screens/profile/change_email_screen.dart";
import "../screens/profile/providers_screen.dart";
import "../screens/profile/sessions_screen.dart";
import "../screens/onboarding/password_reset_screen.dart";
import "../screens/map/bookmarks_screen.dart";

/// GoRouter + Riverpod 연동.
/// AuthState를 구독해서 인증 상태 변화 시 자동 리다이렉트.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ValueNotifier(0);
  ref.listen<AuthState>(authNotifierProvider, (_, _) {
    refreshNotifier.value++;
  });
  ref.listen<AsyncValue<MapDraftEvent?>>(mapDraftEventProvider, (_, _) {
    refreshNotifier.value++;
  });
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    refreshListenable: refreshNotifier,
    initialLocation: "/splash",
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final path = state.uri.path;
      final isAuthPage =
          path.startsWith("/onboarding/auth") ||
          path.startsWith("/onboarding/email") ||
          path.startsWith("/onboarding/password-reset");
      final isConsentPage = path == "/onboarding/consent";

      switch (authState.status) {
        case AuthStatus.unknown:
          // 세션 확인 중 — 스플래시에 머문다
          if (path != "/splash") return "/splash";
          return null;

        case AuthStatus.sessionCheckFailed:
          // 네트워크 오류는 로그아웃으로 간주하지 않고 재시도 가능한
          // 스플래시에 머문다.
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

        case AuthStatus.onboarding:
          final isOnboardingFlow =
              (path.startsWith("/onboarding/") &&
                  !isAuthPage &&
                  !isConsentPage) ||
              (path == "/calendar/sync" &&
                  state.uri.queryParameters["onboarding"] == "true");
          if (isOnboardingFlow) return null;
          // 저장된 온보딩 단계로 복원 — 앱 종료 후 재진입 시 진행 중
          // 단계부터 다시 시작한다.
          final step = authState.onboardingStep;
          switch (step) {
            case "prep_time":
              return "/onboarding/prep-time";
            case "places":
              return "/onboarding/places";
            case "notification":
              // Issue #52: 알림 프라이밍 단계 복원 누락 수정
              return "/onboarding/priming/notification";
            case "location":
              // Issue #52: 위치 프라이밍 단계 복원 누락 수정
              return "/onboarding/priming/location";
            case "calendar":
              return "/onboarding/priming/calendar";
            case "wellness":
              return "/onboarding/wellness";
            case "permissions":
              return "/onboarding/complete";
            default:
              // Issue #54: step이 null(가입완료 버튼 누르기 전 kill)일 때
              // signup-complete(뒤로가기 차단)로 보내면 루프 발생.
              // 온보딩의 실제 첫 단계인 prep-time으로 진행.
              return "/onboarding/prep-time";
          }

        case AuthStatus.authenticated:
          // cold start에서 유효한 지도 draft가 복원되면 사용자가 작성 중이던
          // 일정 폼으로 이어간다. 복원 완료 전 null을 보고 홈으로 보내지 않는다.
          if (path == "/splash") {
            final draftState = ref.read(mapDraftEventProvider);
            if (draftState.isLoading) return null;
            if (draftState.hasValue && draftState.value != null) {
              return "/events/create-from-map";
            }
            return "/home";
          }
          // 인증 완료 — 나머지 인증/온보딩 화면에서는 홈으로
          if (path == "/onboarding/auth" ||
              isConsentPage ||
              path.startsWith("/onboarding/email-verification")) {
            return "/home";
          }
          return null;
      }
    },
    routes: [
      // ─── 스플래시 (세션 확인 중) ─────────────────────────────────
      GoRoute(path: "/splash", builder: (c, s) => const SplashScreen()),

      // ─── 온보딩 ──────────────────────────────────────────────────
      GoRoute(path: "/onboarding/auth", builder: (c, s) => const AuthScreen()),
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
        path: "/onboarding/signup-complete",
        builder: (c, s) => const SignupCompleteScreen(),
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
        path: "/onboarding/complete",
        builder: (c, s) => const OnboardingCompleteScreen(),
      ),
      GoRoute(
        path: "/onboarding/password-reset",
        builder: (c, s) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: "/onboarding/priming/notification",
        builder: (c, s) => PermissionPrimingScreen(
          type: PermissionPrimingType.notification,
          onAllow: () async {
            final status = await PermissionService.instance
                .requestNotification();
            if (!c.mounted) return;
            if (!status.isGranted && !status.isLimited) {
              await PermissionService.instance.showRationale(
                c,
                PermissionRationaleType.notification,
              );
            }
            await ref.read(secureStorageProvider).setOnboardingStep("location");
            if (c.mounted) c.go("/onboarding/priming/location");
          },
          onSkip: () async {
            await ref.read(secureStorageProvider).setOnboardingStep("location");
            if (c.mounted) c.go("/onboarding/priming/location");
          },
        ),
      ),
      GoRoute(
        path: "/onboarding/priming/location",
        builder: (c, s) => PermissionPrimingScreen(
          type: PermissionPrimingType.location,
          onAllow: () async {
            final status = await PermissionService.instance.requestLocation();
            if (!c.mounted) return;
            if (!status.isGranted) {
              await PermissionService.instance.showRationale(
                c,
                PermissionRationaleType.location,
              );
            }
            await ref.read(secureStorageProvider).setOnboardingStep("calendar");
            if (c.mounted) c.go("/onboarding/priming/calendar");
          },
          onSkip: () async {
            await ref.read(secureStorageProvider).setOnboardingStep("calendar");
            if (c.mounted) c.go("/onboarding/priming/calendar");
          },
        ),
      ),
      GoRoute(
        path: "/onboarding/priming/calendar",
        builder: (c, s) => PermissionPrimingScreen(
          type: PermissionPrimingType.calendar,
          onAllow: () async {
            await ref.read(secureStorageProvider).setOnboardingStep("calendar");
            if (c.mounted) c.push("/calendar/sync?onboarding=true");
          },
          onSkip: () async {
            await ref.read(secureStorageProvider).setOnboardingStep("wellness");
            if (c.mounted) c.go("/onboarding/wellness");
          },
        ),
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
        builder: (c, s) => const EventFormScreen(fromMap: true),
      ),
      GoRoute(
        path: "/search/place",
        builder: (c, s) => const PlaceSearchScreen(),
      ),
      GoRoute(
        path: "/calendar/new",
        builder: (c, s) => const EventFormScreen(),
      ),
      GoRoute(
        path: "/calendar/sync",
        builder: (c, s) => CalendarSyncScreen(
          isOnboarding: s.uri.queryParameters["onboarding"] == "true",
        ),
      ),
      GoRoute(
        path: "/calendar/weekly-report",
        builder: (c, s) => const WeeklyReportScreen(),
      ),

      // ─── DTL-01 일정 상세 ─────────────────────────────────────
      GoRoute(
        path: "/events/:eventId",
        builder: (c, s) =>
            EventDetailScreen(eventId: s.pathParameters["eventId"]!),
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
        builder: (c, s) => const PrepTimeEntryScreen(isOnboarding: false),
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
      GoRoute(
        path: "/profile/change-password",
        builder: (c, s) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: "/profile/change-email",
        builder: (c, s) => const ChangeEmailScreen(),
      ),
      GoRoute(
        path: "/profile/providers",
        builder: (c, s) => const ProvidersScreen(),
      ),
      GoRoute(
        path: "/profile/sessions",
        builder: (c, s) => const SessionsScreen(),
      ),
      GoRoute(
        path: "/map/bookmarks",
        builder: (c, s) => const BookmarksScreen(),
      ),

      // ─── 메인 4탭 (화면설계서 확정: 캘린더·홈·지도·프로필) ────
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainTabShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/calendar",
                builder: (c, s) => const CalendarScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: "/home", builder: (c, s) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/map",
                builder: (c, s) => MapScreen(
                  initialDestName: s.uri.queryParameters["destName"],
                  initialDestLat: double.tryParse(
                    s.uri.queryParameters["destLat"] ?? "",
                  ),
                  initialDestLng: double.tryParse(
                    s.uri.queryParameters["destLng"] ?? "",
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/profile",
                builder: (c, s) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

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
