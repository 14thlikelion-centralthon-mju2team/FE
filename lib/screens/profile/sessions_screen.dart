import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-29 로그인 기록 (세션 관리)
class SessionsScreen extends ConsumerStatefulWidget {
  const SessionsScreen({super.key});

  @override
  ConsumerState<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends ConsumerState<SessionsScreen> {
  List<Map<String, dynamic>>? _sessions;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<List<dynamic>>("/me/sessions");
      if (mounted) {
        setState(() {
          _sessions = data.map((e) => e as Map<String, dynamic>).toList();
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.isNetworkError ? "네트워크에 연결할 수 없어요. 다시 시도해주세요." : e.message;
        });
      }
    }
  }

  Future<void> _deleteSession(String sessionId) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.delete<Map<String, dynamic>>("/me/sessions/$sessionId");
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _deleteAllSessions() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("다른 기기에서 로그아웃할까요?"),
        // Issue #52: 명세상 현재 기기는 제외 — 다른 기기 세션만 종료
        content: const Text("현재 기기를 제외한 모든 세션이 종료돼요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
            child: const Text("다른 기기 로그아웃"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final api = ref.read(apiClientProvider);
      // DELETE /me/sessions는 현재 기기를 제외한 세션만 종료한다.
      // 따라서 로컬 소거·로그아웃 없이 세션 목록만 새로고침한다.
      await api.delete<Map<String, dynamic>>("/me/sessions");
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("다른 기기에서 로그아웃했어요.")));
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인 기록"),
        actions: [
          TextButton(
            onPressed: _deleteAllSessions,
            child: const Text(
              "전체 로그아웃",
              style: TextStyle(color: EnsomColors.caution),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text("다시 시도")),
            ],
          ),
        ),
      );
    }

    final sessions = _sessions ?? [];
    if (sessions.isEmpty) {
      return const Center(child: Text("세션 정보가 없어요."));
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final id = session["refreshTokenId"]?.toString() ?? "";
        final isCurrent = session["isCurrent"] == true;
        final deviceName = session["platform"]?.toString() ?? "알 수 없는 기기";
        final lastActive = session["issuedAt"]?.toString() ?? "";

        return Dismissible(
          key: Key(id),
          direction: isCurrent
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: Container(
            color: EnsomColors.caution,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: const Icon(Icons.logout, color: EnsomColors.canvas),
          ),
          confirmDismiss: (_) async {
            if (isCurrent) return false;
            return true;
          },
          onDismissed: (_) => _deleteSession(id),
          child: ListTile(
            leading: Icon(
              isCurrent ? Icons.phone_android : Icons.devices_other,
            ),
            title: Row(
              children: [
                Flexible(child: Text(deviceName)),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: EnsomColors.lime,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "현재 기기",
                      style: TextStyle(
                        fontSize: 11,
                        color: EnsomColors.limeInk,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: lastActive.isNotEmpty ? Text(lastActive) : null,
          ),
        );
      },
    );
  }
}
