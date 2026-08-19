import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

/// ONB-09 온보딩 완료
/// 온보딩 전 단계 종료 후 표시. [시작하기] → 홈으로 이동.
class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.check_circle_outline,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                "준비 완료!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "이제 Ensom이 일정에 맞춰\n준비 시작 시각을 알려드릴게요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 8),
              const Text(
                "설정은 언제든 프로필에서 변경할 수 있어요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.go("/home"),
                  child: const Text("시작하기"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
