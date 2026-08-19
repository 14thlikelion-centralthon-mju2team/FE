import "package:flutter/material.dart";

/// SYS-01 네트워크 없음
/// 전 화면 공통, 연결 끊김 감지 시 전면 차단.
/// 하단 탭 없이 전체 화면을 덮는 독립 화면.
class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                "인터넷에 연결할 수 없어요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                "Wi-Fi 또는 모바일 데이터 연결을 확인하고\n다시 시도해주세요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("다시 시도"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SYS-02 세션 만료
class SessionExpiredScreen extends StatelessWidget {
  const SessionExpiredScreen({super.key, this.onLogin});

  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                "세션이 만료됐어요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                "보안을 위해 다시 로그인해주세요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (onLogin != null)
                ElevatedButton.icon(
                  onPressed: onLogin,
                  icon: const Icon(Icons.login),
                  label: const Text("로그인"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SYS-03 점검 중
class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.construction, size: 64, color: Colors.grey),
              SizedBox(height: 24),
              Text(
                "서비스 점검 중이에요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text(
                "더 좋은 서비스로 찾아올게요.\n잠시만 기다려주세요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// SYS-04 업데이트 필요
class ForceUpdateScreen extends StatelessWidget {
  const ForceUpdateScreen({super.key, this.onUpdate});

  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.system_update, size: 64, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                "업데이트가 필요해요",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              const Text(
                "최신 버전으로 업데이트해주세요.\n중요한 변경 사항이 포함되어 있어요.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              if (onUpdate != null)
                ElevatedButton.icon(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.download),
                  label: const Text("업데이트"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
