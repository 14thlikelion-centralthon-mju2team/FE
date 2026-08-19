import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../providers/auth_providers.dart";

/// PRF-07 알림 설정
/// BE: GET/PATCH /me/settings
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  bool _loading = true;
  String _sensitivity = "normal"; // low, normal, high
  bool _lockscreenHide = true;
  bool _wellnessEvent = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<Map<String, dynamic>>("/me/settings");
      if (mounted) {
        setState(() {
          _sensitivity = data["notificationSensitivity"] ?? "normal";
          _lockscreenHide = data["lockscreenHideSensitive"] ?? true;
          _wellnessEvent = data["wellnessEventEnabled"] ?? false;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save(Map<String, dynamic> patch) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.patch("/me/settings", body: patch);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("설정 저장에 실패했어요.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text("알림 설정")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text("알림 설정")),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text("알림 민감도"),
            subtitle: Text(_sensitivityLabel),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: "low", label: Text("낮음")),
                ButtonSegment(value: "normal", label: Text("보통")),
                ButtonSegment(value: "high", label: Text("높음")),
              ],
              selected: {_sensitivity},
              onSelectionChanged: (s) {
                setState(() => _sensitivity = s.first);
                _save({"notificationSensitivity": s.first});
              },
            ),
          ),
          const Divider(height: 32),
          SwitchListTile(
            title: const Text("잠금화면 민감 정보 숨기기"),
            subtitle: const Text("민감 준비 항목을 잠금화면 알림에서 숨겨요"),
            value: _lockscreenHide,
            onChanged: (v) {
              setState(() => _lockscreenHide = v);
              _save({"lockscreenHideSensitive": v});
            },
          ),
          SwitchListTile(
            title: const Text("웰니스 이벤트 알림"),
            subtitle: const Text("야외 일정에서 웰니스 행동을 제안해요"),
            value: _wellnessEvent,
            onChanged: (v) {
              setState(() => _wellnessEvent = v);
              _save({"wellnessEventEnabled": v});
            },
          ),
        ],
      ),
    );
  }

  String get _sensitivityLabel {
    switch (_sensitivity) {
      case "low":
        return "꼭 필요한 알림만 받아요";
      case "high":
        return "여유 있게 미리 알려줘요";
      default:
        return "적절한 시점에 알려줘요";
    }
  }
}
