import "package:flutter/material.dart";

/// CAL-06 주간 리포트 (P1)
/// 주간 정시도착/촉박/이른도착 수, 준비시간 예측 오차 추이, 웰니스 완료율.
/// BE API 미정 (E-18). 자리만 확보.
class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("주간 리포트")),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              "주간 리포트는 곧 제공될 예정이에요.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
