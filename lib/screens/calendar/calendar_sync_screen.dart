import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/app_config.dart";
import "../../core/google_auth_helper.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../providers/bootstrap_provider.dart";
import "../../theme/ensom_colors.dart";

/// S-41 캘린더 연동 관리.
/// Google OAuth에서 받은 serverAuthCode를 BE 계약에 맞춰 전달한다.
class CalendarSyncScreen extends ConsumerStatefulWidget {
  const CalendarSyncScreen({super.key, this.isOnboarding = false});

  final bool isOnboarding;

  @override
  ConsumerState<CalendarSyncScreen> createState() => _CalendarSyncScreenState();
}

class _CalendarSyncScreenState extends ConsumerState<CalendarSyncScreen> {
  bool _connected = false;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus();
  }

  Future<void> _loadConnectionStatus() async {
    try {
      final bootstrap = await ref.read(bootstrapProvider.future);
      final calendarPermissions = bootstrap.permissions.where(
        (permission) => permission.permissionType == "calendar",
      );
      if (!mounted) return;
      setState(() {
        _connected = calendarPermissions.any(
          (permission) => permission.status == "granted",
        );
      });
    } catch (_) {
      // 전용 connection 조회 API가 없으므로 상태 조회 실패가 화면 전체를
      // 막지는 않는다. 사용자가 연결을 시도하면 BE 응답으로 재확인한다.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connect() async {
    if (kGoogleServerClientId.isEmpty) {
      setState(() => _error = "Google 서버 클라이언트 설정이 없어 지금은 연동할 수 없어요.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authCode = await GoogleAuthHelper.instance.signInForCalendar();
      if (authCode == null) return;

      await ref
          .read(apiClientProvider)
          .post<Map<String, dynamic>>(
            "/calendar/google/connect",
            body: {"authCode": authCode},
          );

      if (!mounted) return;
      setState(() => _connected = true);
      ref.invalidate(bootstrapProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("캘린더를 연동했어요.")));

      if (widget.isOnboarding) {
        ref.read(secureStorageProvider).setOnboardingStep("wellness");
        context.go("/onboarding/wellness");
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.isNetworkError
            ? "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요."
            : "캘린더를 연동하지 못했어요. 다시 시도해주세요.";
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Google 인증 정보를 가져오지 못했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _disconnect() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("캘린더 연결을 해제할까요?"),
        content: const Text("연동된 일정이 더 이상 자동으로 가져와지지 않아요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text("연결 해제"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(apiClientProvider)
          .delete<Map<String, dynamic>>("/calendar/google");
      if (!mounted) return;
      setState(() => _connected = false);
      ref.invalidate(bootstrapProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("캘린더 연결을 해제했어요.")));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.isNetworkError
            ? "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요."
            : "연결을 해제하지 못했어요. 다시 시도해주세요.";
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _continueWithoutCalendar() {
    ref.read(secureStorageProvider).setOnboardingStep("wellness");
    context.go("/onboarding/wellness");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("캘린더 연동"),
        automaticallyImplyLeading: !widget.isOnboarding,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Google 캘린더",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _connected ? "연동됨" : "연동 안 됨",
                              style: const TextStyle(
                                color: EnsomColors.inkMuted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_connected)
                        const Icon(
                          Icons.check_circle,
                          color: EnsomColors.limeInk,
                        ),
                    ],
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: EnsomColors.caution),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _connected
                        ? OutlinedButton(
                            onPressed: _loading ? null : _disconnect,
                            child: const Text("연결 해제"),
                          )
                        : FilledButton(
                            onPressed: _loading ? null : _connect,
                            child: Text(
                              _loading ? "연결 중..." : "Google 캘린더 연동하기",
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "캘린더를 연동하면 다음 일정과 장소를 자동으로 인식해요.\n별도로 일정을 입력하지 않아도 준비 계획을 세워드려요.",
            style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
          ),
          if (widget.isOnboarding) ...[
            const SizedBox(height: 24),
            TextButton(
              onPressed: _loading ? null : _continueWithoutCalendar,
              child: const Text("나중에 할게요"),
            ),
          ],
        ],
      ),
    );
  }
}
