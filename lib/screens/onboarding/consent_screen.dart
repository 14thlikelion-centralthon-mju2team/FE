import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../core/auth_service.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// PRD §11.2 "필수 약관 동의" / API 명세 §2.8 POST /consents
/// consentRequired가 빈 배열이 될 때까지 홈 진입을 막는다.
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentItem {
  _ConsentItem({
    required this.type,
    required this.label,
    required this.required,
  });

  final String type; // terms | privacy | location | marketing
  final String label;
  final bool required;
  bool agreed = false;
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  final List<_ConsentItem> _items = [
    _ConsentItem(type: "terms", label: "[필수] 이용약관 동의", required: true),
    _ConsentItem(type: "privacy", label: "[필수] 개인정보 처리방침 동의", required: true),
    _ConsentItem(
        type: "location", label: "[필수] 위치정보 이용 동의", required: true),
    _ConsentItem(
        type: "marketing", label: "[선택] 마케팅 정보 수신 동의", required: false),
  ];

  bool get _allRequiredAgreed =>
      _items.where((i) => i.required).every((i) => i.agreed);

  bool get _allAgreed => _items.every((i) => i.agreed);

  void _toggleAll(bool value) {
    setState(() {
      for (final item in _items) {
        item.agreed = value;
      }
    });
  }

  bool _submitting = false;
  String? _error;

  /// 약관 동의 정책 버전. 실제 운영에서는 서버가 내려주는 최신 버전을
  /// bootstrap에서 받아 써야 하지만 MVP에서는 하드코딩.
  static const _policyVersion = "v1";

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final authService = ref.read(authServiceProvider);

      final consents = _items
          .map((item) => ConsentEntry(
                consentType: item.type,
                policyVersion: _policyVersion,
                action: item.agreed ? "agreed" : "revoked",
                isRequired: item.required,
              ))
          .toList();

      await authService.submitConsents(consents);

      if (!mounted) return;

      // 약관 동의 완료 → AuthNotifier 상태 전이
      ref.read(authNotifierProvider.notifier).onConsentCompleted();

      // 온보딩 다음 단계(준비시간 입력)로 이동
      context.go("/onboarding/prep-time");
    } on ApiException catch (e) {
      setState(() {
        switch (e.code) {
          case "NETWORK_ERROR":
            _error = "네트워크에 연결할 수 없어요. 잠시 후 다시 시도해주세요.";
          default:
            _error = "동의 처리에 실패했어요. 다시 시도해주세요.";
        }
      });
    } catch (_) {
      setState(() => _error = "동의 처리에 실패했어요. 다시 시도해주세요.");
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("약관 동의")),
      body: Column(
        children: [
          CheckboxListTile(
            title: const Text("전체 동의",
                style: TextStyle(fontWeight: FontWeight.w600)),
            value: _allAgreed,
            onChanged: (v) => _toggleAll(v ?? false),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return CheckboxListTile(
                  title: Text(item.label),
                  value: item.agreed,
                  onChanged: (v) {
                    setState(() => item.agreed = v ?? false);
                  },
                  secondary: TextButton(
                    onPressed: () {
                      // TODO: 약관 전문 화면으로 이동 (정적 마크다운 뷰어)
                    },
                    child: const Text("보기"),
                  ),
                );
              },
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_allRequiredAgreed && !_submitting) ? _submit : null,
                child: Text(_submitting ? "처리 중..." : "동의하고 계속하기"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
