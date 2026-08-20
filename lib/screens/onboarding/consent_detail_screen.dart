import "package:flutter/material.dart";
import "../../theme/ensom_colors.dart";

class _Article {
  const _Article(this.heading, this.paragraphs);
  final String heading;
  final List<String> paragraphs;
}

class _Doc {
  const _Doc(this.title, this.effectiveDate, this.articles);
  final String title;
  final String effectiveDate;
  final List<_Article> articles;
}

const _effectiveDate = "시행일 2026년 3월 1일";

const _termsDoc = _Doc("이용약관", _effectiveDate, [
  _Article("제1조 (목적)", [
    "이 약관은 Ensom(이하 \"회사\")이 제공하는 일정 준비 안내 서비스(이하 \"서비스\")의 이용 조건과 절차, 회사와 회원 간의 권리·의무 및 책임 사항을 정하는 것을 목적으로 합니다.",
  ]),
  _Article("제2조 (정의)", [
    "\"서비스\"란 회원이 등록하거나 연동한 일정을 기준으로 준비 시작 시각과 출발 시각을 계산하여 안내하는 일체의 기능을 말합니다.",
    "\"회원\"이란 이 약관에 동의하고 계정을 생성하여 서비스를 이용하는 자를 말합니다.",
    "\"준비 항목\"이란 회원이 일정 전에 수행하거나 챙기기 위해 서비스에 등록한 개별 항목을 말합니다.",
  ]),
  _Article("제3조 (회원가입)", [
    "회원가입은 이용자가 이 약관의 내용에 동의하고, 회사가 정한 절차에 따라 이메일 또는 Google 계정으로 가입을 신청한 뒤 회사가 이를 승낙함으로써 성립합니다.",
    "회사는 실명이 아니거나 타인의 정보를 이용한 신청, 이전에 이용 제한 조치를 받은 이용자의 신청에 대해 승낙을 유보하거나 거절할 수 있습니다.",
  ]),
  _Article("제4조 (서비스의 제공)", [
    "회사는 일정별 준비 시간 계산, 출발 시각 안내, 준비 항목 관리, 외부 캘린더 연동, 알림 발송 기능을 제공합니다.",
    "서비스가 안내하는 시각은 회원이 입력한 정보와 이동·준비 기록을 바탕으로 산출한 추정값이며, 실제 교통 상황이나 개인의 상태에 따라 달라질 수 있습니다.",
    "회사는 서비스의 품질 향상을 위해 기능의 일부를 변경하거나 중단할 수 있으며, 중요한 변경은 사전에 공지합니다.",
  ]),
  _Article("제5조 (회원의 의무)", [
    "회원은 계정 정보를 정확하게 유지하여야 하며, 계정을 타인에게 양도하거나 공유해서는 안 됩니다.",
    "회원은 서비스를 통해 제공되는 안내를 참고 자료로 이용하여야 하며, 안전 운행 및 법령 준수의 책임은 회원 본인에게 있습니다.",
    "회원은 서비스의 정상적인 운영을 방해하는 행위, 다른 회원의 정보를 무단으로 수집하는 행위를 하여서는 안 됩니다.",
  ]),
  _Article("제6조 (계약 해지)", [
    "회원은 언제든지 설정 화면을 통해 이용계약의 해지, 즉 회원 탈퇴를 신청할 수 있으며, 회사는 관련 법령이 정한 경우를 제외하고 지체 없이 이를 처리합니다.",
    "탈퇴가 완료되면 캘린더 연결, 알림 토큰, 주요 장소, 준비 기록은 삭제되며 재가입하더라도 복구되지 않습니다.",
    "회원이 이 약관을 반복적으로 위반하는 경우 회사는 사전 통지 후 이용계약을 해지할 수 있습니다.",
  ]),
]);

const _privacyDoc = _Doc("개인정보 수집·이용 동의", _effectiveDate, [
  _Article("제1조 (수집하는 개인정보의 항목)", [
    "회사는 회원 가입 및 서비스 제공을 위하여 이메일 주소, 비밀번호, 이름을 필수 항목으로 수집합니다.",
    "서비스 이용 과정에서 일정 정보, 주요 장소의 명칭 및 좌표, 회원이 등록한 준비 항목, 서비스 이용 기록과 기기 정보가 수집됩니다.",
    "웰니스 관심 항목과 마케팅 정보 수신 여부는 선택 항목이며, 동의하지 않아도 서비스 이용에 제한이 없습니다.",
  ]),
  _Article("제2조 (이용 목적)", [
    "수집한 개인정보는 회원 식별과 계정 관리, 준비 시작 시각 및 권장 출발 시각의 계산, 알림 발송, 서비스 개선을 위한 통계·분석, 부정 이용의 확인에만 이용합니다.",
  ]),
  _Article("제3조 (민감정보 미수집)", [
    "회사는 개인정보보호법 제23조에 따른 민감정보를 수집하지 않습니다.",
    "회원이 복용약과 같은 항목을 준비 항목으로 등록한 경우에도 회사는 이를 회원이 설정한 준비 행동을 기억하고 확인하는 용도로만 사용하며, 섭취 필요성이나 효능, 건강 상태를 판단하지 않습니다.",
  ]),
  _Article("제4조 (보유 및 이용 기간)", [
    "수집한 개인정보는 동의일로부터 회원 탈퇴 시까지 보관하며, 탈퇴 시 캘린더 연결 정보, 푸시 토큰, 주요 장소, 준비 및 웰니스 데이터를 삭제합니다.",
    "다만 동의 이력은 관계 법령이 정한 법정 보존 기간 동안 보관합니다. 재가입하더라도 이전의 개인화 데이터는 복구되지 않습니다.",
  ]),
  _Article("제5조 (동의 거부 권리)", [
    "회원은 동의를 거부할 권리가 있습니다. 다만 필수 항목에 동의하지 않는 경우 회원 가입 및 서비스 이용이 불가능합니다.",
  ]),
]);

const _locationDoc = _Doc("위치기반 서비스 이용약관", _effectiveDate, [
  _Article("제1조 (목적)", [
    "이 약관은 회사가 제공하는 위치기반서비스의 이용과 관련하여 회사와 개인위치정보주체 간의 권리·의무 및 책임 사항을 규정하는 것을 목적으로 합니다.",
  ]),
  _Article("제2조 (위치정보의 이용 목적)", [
    "회사는 일정과 관련된 출발지 이탈과 목적지 도착의 확인, 출발지 기준 예상 이동 시간의 계산을 위한 목적으로만 개인위치정보를 이용합니다.",
    "회사는 회원의 하루 전체 이동 경로를 수집하거나 저장하지 않습니다.",
  ]),
  _Article("제3조 (보유 및 파기)", [
    "수집된 좌표는 암호화하여 보관하며, 이용 목적이 달성된 후에는 지체 없이 파기합니다. 주요 장소의 좌표는 회원이 직접 삭제하거나 탈퇴할 때까지 보관합니다.",
  ]),
  _Article("제4조 (이용자의 권리)", [
    "회원은 언제든지 앱 내 설정 또는 단말기의 운영체제 설정에서 위치정보 제공을 중단할 수 있습니다.",
    "제공을 중단하더라도 출발·도착을 직접 입력하는 방식으로 서비스를 계속 이용할 수 있습니다.",
    "회원은 위치정보의 이용·제공 사실 확인자료의 열람을 요구할 수 있습니다.",
  ]),
  _Article("제5조 (동의 거부 권리)", [
    "회원은 위치정보 수집에 대한 동의를 거부할 수 있으며, 거부하더라도 출발·도착 자동 확인을 제외한 서비스의 핵심 기능은 정상적으로 이용할 수 있습니다.",
  ]),
]);

/// S-21 약관 본문 뷰어. ensom_auth.html 목업 "화면4/5" 반영 —
/// 이용약관·개인정보·위치기반 세 문서를 세그먼트 탭으로 오갈 수 있다.
/// consentType이 marketing 등 세 문서에 없는 값이면 탭 없이 안내만
/// 보여준다(마케팅 수신 동의는 별도 법정 고지문이 아니라 서비스 내부
/// 정책이라 이 세 문서 세트에 속하지 않는다).
class ConsentDetailScreen extends StatefulWidget {
  const ConsentDetailScreen({super.key, required this.consentType, required this.title});

  final String consentType;
  final String title;

  @override
  State<ConsentDetailScreen> createState() => _ConsentDetailScreenState();
}

class _ConsentDetailScreenState extends State<ConsentDetailScreen> {
  static const _docs = [_termsDoc, _privacyDoc, _locationDoc];

  late int _active = switch (widget.consentType) {
    "terms" => 0,
    "privacy" => 1,
    "location" => 2,
    _ => -1,
  };

  @override
  Widget build(BuildContext context) {
    final showTabs = _active >= 0;
    final doc = showTabs ? _docs[_active] : null;

    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: AppBar(
        backgroundColor: EnsomColors.canvas,
        surfaceTintColor: EnsomColors.canvas,
        elevation: 0,
        title: Text(
          doc?.title ?? widget.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: EnsomColors.ink),
        ),
      ),
      body: Column(
        children: [
          if (showTabs)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: _DocSegment(
                active: _active,
                onChanged: (i) => setState(() => _active = i),
              ),
            ),
          Expanded(
            child: doc != null
                ? ListView(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                    children: [
                      Text(
                        doc.effectiveDate,
                        style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                      ),
                      const SizedBox(height: 16),
                      for (final article in doc.articles) ...[
                        Text(
                          article.heading,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -.2,
                            color: EnsomColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (final p in article.paragraphs)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              p,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: EnsomColors.inkMuted,
                                height: 1.75,
                                letterSpacing: -.2,
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _placeholderBody,
                      style: const TextStyle(color: EnsomColors.ink, fontSize: 14, height: 1.6),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  String get _placeholderBody {
    switch (widget.consentType) {
      case "marketing":
        return "마케팅 정보 수신 동의 내용이 여기에 표시됩니다.\n\n"
            "동의하지 않아도 서비스 이용에는 제한이 없습니다. 언제든지 설정에서 바꿀 수 있어요.";
      default:
        return "약관 전문을 불러오지 못했어요.";
    }
  }
}

class _DocSegment extends StatelessWidget {
  const _DocSegment({required this.active, required this.onChanged});

  final int active;
  final ValueChanged<int> onChanged;

  static const _labels = ["이용약관", "개인정보", "위치기반"];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(13)),
      child: Row(
        children: List.generate(_labels.length, (i) {
          final on = i == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: on ? EnsomColors.cta : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  _labels[i],
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: on ? Colors.white : EnsomColors.inkMuted,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
