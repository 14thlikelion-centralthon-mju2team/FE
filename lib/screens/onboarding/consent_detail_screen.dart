import "package:flutter/material.dart";
import "../../theme/ensom_colors.dart";

/// S-21 약관 본문 뷰어.
/// S-02 약관 동의 및 S-16 회원가입에서 '보기' 탭으로 진입한다.
/// 실제 약관 문서 URL/마크다운이 확정되면 내용을 교체한다.
class ConsentDetailScreen extends StatelessWidget {
  const ConsentDetailScreen({
    super.key,
    required this.consentType,
    required this.title,
  });

  final String consentType;
  final String title;

  String get _placeholderBody {
    switch (consentType) {
      case "terms":
        return "이용약관은 Product/Legal 검토 및 승인 대기 중입니다.\n\n"
            "승인된 전문과 시행일이 확정되면 이 화면에서 제공합니다.";
      case "privacy":
        return "개인정보 처리방침은 Product/Legal 검토 및 승인 대기 중입니다.\n\n"
            "승인된 수집 항목·이용 목적·보유기간·시행일이 확정되면 이 화면에서 제공합니다.";
      case "location":
        return "위치기반 서비스 이용약관은 Product/Legal 검토 및 승인 대기 중입니다.\n\n"
            "승인된 위치정보 처리·보유기간·시행일이 확정되면 이 화면에서 제공합니다.";
      case "marketing":
        return "마케팅 정보 수신 동의 내용이 여기에 표시됩니다.";
      default:
        return "약관 전문을 불러오지 못했어요.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Text(
          _placeholderBody,
          style: const TextStyle(
            color: EnsomColors.ink,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ),
    );
  }
}
