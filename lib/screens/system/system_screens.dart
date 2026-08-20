import "package:flutter/material.dart";
import "../../theme/ensom_colors.dart";

/// SYS-01~04 전면 오류·차단 화면 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/02_홈·일정/ensom_fullscreen_errors.html
/// 공통 원칙: 사과 문구 금지, 경고 아이콘·빨강 없음, 하단 탭바 없음, 여백 위주 담백.

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key, this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return _FullscreenError(
      icon: Icons.wifi,
      title: "연결을 확인해 주세요",
      description: "인터넷에 연결되면 자동으로 다시 시도할게요",
      buttonLabel: "다시 시도",
      buttonStyle: _ButtonStyle.secondary,
      onAction: onRetry,
    );
  }
}

class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key, this.onLogin});
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return _FullscreenError(
      icon: Icons.person_outline,
      title: "다시 로그인해 주세요",
      description: "보안을 위해 로그인이 만료되었어요",
      buttonLabel: "로그인",
      buttonStyle: _ButtonStyle.primary,
      onAction: onLogin,
    );
  }
}

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FullscreenError(
      icon: Icons.build_outlined,
      title: "잠시 점검 중이에요",
      description: "잠시 후 다시 이용하실 수 있어요",
    );
  }
}

class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, this.onUpdate});
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return _FullscreenError(
      icon: Icons.phone_iphone,
      title: "새 버전이 필요해요",
      description: "계속 사용하려면 업데이트해 주세요",
      buttonLabel: "업데이트",
      buttonStyle: _ButtonStyle.primary,
      onAction: onUpdate,
    );
  }
}

// ─── Shared Fullscreen Error ───

enum _ButtonStyle { primary, secondary }

class _FullscreenError extends StatelessWidget {
  const _FullscreenError({
    required this.icon,
    required this.title,
    required this.description,
    this.buttonLabel,
    this.buttonStyle,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final String? buttonLabel;
  final _ButtonStyle? buttonStyle;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 원형 아이콘 래퍼
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: EnsomColors.surface2,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 24, color: EnsomColors.inkMuted),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: EnsomColors.ink,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 9),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: EnsomColors.inkMuted,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              if (buttonLabel != null && onAction != null) ...[
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: onAction,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 22,
                    ),
                    decoration: BoxDecoration(
                      color: buttonStyle == _ButtonStyle.primary
                          ? EnsomColors.cta
                          : EnsomColors.surface2,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      buttonLabel!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: buttonStyle == _ButtonStyle.primary
                            ? Colors.white
                            : EnsomColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
