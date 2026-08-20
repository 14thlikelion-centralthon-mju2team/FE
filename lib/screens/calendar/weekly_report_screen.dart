import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../theme/ensom_colors.dart";

/// CAL-06 주간 리포트 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/06_공통·P1/ensom_p1_reports.html
/// BE API 미정. 디자인 셸만 확보.
class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 16),
                  // 요약 카드
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: EnsomColors.surface2,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("이번 주 요약",
                            style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: EnsomColors.inkFaint,
                                letterSpacing: 0.4)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _StatBox(label: "관리 일정", value: "—"),
                            const SizedBox(width: 14),
                            _StatBox(label: "정시 도착", value: "—"),
                            const SizedBox(width: 14),
                            _StatBox(label: "평균 여유", value: "—"),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  // 준비 시간 추이 placeholder
                  _ReportSection(
                    title: "준비 시간 추이",
                    description: "예측과 실제 준비 시간 차이를 보여드려요",
                  ),

                  const SizedBox(height: 12),
                  // 웰니스 완료율 placeholder
                  _ReportSection(
                    title: "웰니스 완료율",
                    description: "제안한 행동 중 완료한 비율이에요",
                  ),

                  const SizedBox(height: 12),
                  // 환경 노출 placeholder
                  _ReportSection(
                    title: "환경 노출",
                    description: "이번 주 야외 노출 시간과 환경 상태 요약이에요",
                  ),

                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      "데이터가 쌓이면 여기에 차트가 표시돼요",
                      style: TextStyle(
                        fontSize: 12,
                        color: EnsomColors.inkFaint,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.chevron_left, size: 14, color: EnsomColors.ink),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "주간 리포트",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: EnsomColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: EnsomColors.ink)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: EnsomColors.inkFaint)),
        ],
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  const _ReportSection({required this.title, required this.description});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EnsomColors.surface1,
        border: Border.all(color: EnsomColors.hairline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: EnsomColors.ink)),
          const SizedBox(height: 4),
          Text(description,
              style: const TextStyle(
                  fontSize: 12,
                  color: EnsomColors.inkMuted,
                  height: 1.55)),
          const SizedBox(height: 12),
          // 차트 placeholder (shimmer)
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: EnsomColors.surface2,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}
