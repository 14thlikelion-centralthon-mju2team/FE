import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// PRD §11.2 "1.소셜 로그인/이메일 가입 2.필수 약관 동의" 순서 반영.
/// API 명세 §consent: consentType(terms/privacy/location/marketing),
/// policyVersion, action(agreed/revoked), isRequired.
class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
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

class _ConsentScreenState extends State<ConsentScreen> {
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

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      // TODO(fe-auth-onboarding): POST /consents 연동
      // 필수 항목만이 아니라 선택 항목도 각각의 agreed 상태를 그대로 전송.
      // for (final item in _items) {
      //   await apiClient.post('/consents', body: {
      //     'consentType': item.type,
      //     'policyVersion': '2026-08-17', // TODO: 실제 정책 버전 확정 필요
      //     'action': item.agreed ? 'agreed' : 'revoked',
      //     'isRequired': item.required,
      //   });
      // }
      if (!mounted) return;
      context.go("/onboarding/interest");
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
                      // TODO: 약관 전문 화면으로 이동 (기획/디자인 확정 대기)
                    },
                    child: const Text("보기"),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (_allRequiredAgreed && !_submitting) ? _submit : null,
              child: Text(_submitting ? "처리 중..." : "동의하고 계속하기"),
            ),
          ),
        ],
      ),
    );
  }
}