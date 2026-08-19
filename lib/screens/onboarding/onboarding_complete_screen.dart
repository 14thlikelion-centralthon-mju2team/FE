import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-42 온보딩 완료. 이전 단계로 돌아갈 수 없으며 시작하기로 상태를 확정한다.
class OnboardingCompleteScreen extends ConsumerWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: EnsomColors.limeInk,
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
                  style: TextStyle(color: EnsomColors.inkMuted, fontSize: 15),
                ),
                const SizedBox(height: 8),
                const Text(
                  "설정은 언제든 프로필에서 변경할 수 있어요.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .onOnboardingCompleted();
                      context.go("/home");
                    },
                    child: const Text("시작하기"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
