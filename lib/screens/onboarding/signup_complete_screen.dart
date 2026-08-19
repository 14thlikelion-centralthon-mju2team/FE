import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "../../theme/ensom_colors.dart";

/// S-18 가입 완료.
/// BE 이메일 링크 방식 기준: 이메일 인증 후 사용자가 앱에서 로그인하면
/// BE가 isNew=true를 반환한다. 로그인 분기에서 이 화면으로 보내고,
/// [시작하기]를 누르면 S-03 준비 시간 온보딩으로 진행한다.
/// 뒤로가기는 차단된다 — 가입 이전으로 돌아갈 수 없다.
class SignupCompleteScreen extends StatelessWidget {
  const SignupCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Icons.celebration_outlined,
                  size: 72,
                  color: EnsomColors.limeInk,
                ),
                const SizedBox(height: 24),
                const Text(
                  "가입을 환영해요!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  "일정에 맞춰 서두르지 않는 하루를\n함께 만들어볼까요?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: EnsomColors.inkMuted, fontSize: 15),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => context.go("/onboarding/prep-time"),
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
