import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_toggle_row.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// PRF-07 알림 설정
/// BE: GET/PATCH /me/settings
///
/// ensom_profile.html "4. 알림" 화면 반영. 목업엔 "시간 알림"/"교통
/// 지연 알림" 토글도 있지만, 실제 /me/settings 응답엔 그 두 값이 없어
/// (wellnessEventEnabled·lockscreenHideSensitive만 존재) 만들지 않았다
/// — 저장할 곳 없는 토글을 보여주는 대신 실제로 있는 두 설정만 둔다.
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
  bool _saving = false;

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
    if (_saving) return; // 연타 방어
    setState(() => _saving = true);
    // BE는 부분 patch가 아니라 전체 필드를 요구한다 (SettingsRequest).
    // 현재 state 기준으로 전체를 구성해서 보낸다.
    final fullBody = {
      "initialPrepMinutes": null, // 온보딩에서 설정 — 여기서는 건드리지 않지만 필수
      "arrivalBufferMinutes": 10,
      "notificationSensitivity": _sensitivity,
      "personalizationEnabled": true,
      "autoManageEnabled": true,
      "wellnessEventEnabled": _wellnessEvent,
      "lockscreenHideSensitive": _lockscreenHide,
      ...patch, // 변경분 덮어쓰기
    };
    try {
      final api = ref.read(apiClientProvider);
      await api.patch("/me/settings", body: fullBody);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("설정 저장에 실패했어요.")),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "알림"),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
                children: [
                  const Text(
                    "알림 민감도",
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EnsomColors.inkFaint, letterSpacing: .4),
                  ),
                  const SizedBox(height: 8),
                  _SegmentedControl(
                    options: const [("low", "적게"), ("normal", "보통"), ("high", "자주")],
                    value: _sensitivity,
                    onChanged: (v) {
                      setState(() => _sensitivity = v);
                      _save({"notificationSensitivity": v});
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(_sensitivityLabel, style: const TextStyle(fontSize: 11.5, color: EnsomColors.inkMuted)),
                  const Divider(height: 30, color: EnsomColors.hairline),
                  const Text(
                    "잠금화면 표시",
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: EnsomColors.inkFaint, letterSpacing: .4),
                  ),
                  EnsomToggleRow(
                    title: "잠금화면에서 민감한 정보 숨기기",
                    subtitle: "복용약 등 민감 항목은 잠금화면에서 일반화되어 표시돼요",
                    value: _lockscreenHide,
                    onChanged: (v) {
                      setState(() => _lockscreenHide = v);
                      _save({"lockscreenHideSensitive": v});
                    },
                  ),
                  EnsomToggleRow(
                    title: "웰니스 이벤트 알림",
                    subtitle: "야외 일정에서 웰니스 행동을 제안해요",
                    value: _wellnessEvent,
                    onChanged: (v) {
                      setState(() => _wellnessEvent = v);
                      _save({"wellnessEventEnabled": v});
                    },
                  ),
                ],
              ),
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

/// 목업 `.seg`/`.sitem` — surface2 알약 트랙 안에서 선택된 항목만 cta로 채운다.
class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({required this.options, required this.value, required this.onChanged});

  final List<(String, String)> options;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(13)),
      child: Row(
        children: [
          for (final (key, label) in options)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(key),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: value == key ? EnsomColors.cta : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: value == key ? Colors.white : EnsomColors.inkMuted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
