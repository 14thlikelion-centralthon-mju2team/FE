import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

/// CAL-03 캘린더 연동 관리
/// 화면설계서: 계정별 캘린더 동기화 on/off, 연결 해제, 재인증 필요 상태
/// BE: POST /calendar/google/connect (authCode), DELETE /calendar/google
///
/// 현재 상태: UI 스캐폴딩만 구현.
/// 실제 연동은 Google Sign-In의 serverAuthCode를 BE에 전달해야 함.
class CalendarSyncScreen extends ConsumerStatefulWidget {
  const CalendarSyncScreen({super.key});

  @override
  ConsumerState<CalendarSyncScreen> createState() => _CalendarSyncScreenState();
}

class _CalendarSyncScreenState extends ConsumerState<CalendarSyncScreen> {
  bool _connected = false;
  bool _needsReauth = false;
  bool _loading = false;

  Future<void> _connect() async {
    // TODO: Google Sign-In으로 calendar.readonly 스코프 동의 → serverAuthCode 획득
    // → POST /calendar/google/connect { authCode }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1)); // stub
    if (mounted) {
      setState(() {
        _connected = true;
        _needsReauth = false;
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("캘린더를 연동했어요.")),
      );
    }
  }

  Future<void> _disconnect() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("캘린더 연결을 해제할까요?"),
        content: const Text("연동된 일정이 더 이상 자동으로 가져와지지 않아요."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("취소")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("연결 해제"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    // TODO: DELETE /calendar/google
    setState(() {
      _connected = false;
      _needsReauth = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("캘린더 연결을 해제했어요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("캘린더 연동")),
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
                            const Text("Google 캘린더",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                            Text(
                              _needsReauth
                                  ? "다시 연결이 필요해요"
                                  : _connected
                                      ? "연동됨"
                                      : "연동 안 됨",
                              style: TextStyle(
                                color: _needsReauth ? Colors.orange : Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_needsReauth)
                        const Icon(Icons.warning_amber, color: Colors.orange)
                      else if (_connected)
                        const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (!_connected || _needsReauth)
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _loading ? null : _connect,
                        child: Text(_loading
                            ? "연결 중..."
                            : _needsReauth
                                ? "다시 연결하기"
                                : "Google 캘린더 연동하기"),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _disconnect,
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text("연결 해제"),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "캘린더를 연동하면 다음 일정과 장소를 자동으로 인식해요.\n별도로 일정을 입력하지 않아도 준비 계획을 세워드려요.",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
