import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_sign_in/google_sign_in.dart";
import "../../core/app_config.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

/// S-27 로그인 수단 관리
class ProvidersScreen extends ConsumerStatefulWidget {
  const ProvidersScreen({super.key});

  @override
  ConsumerState<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends ConsumerState<ProvidersScreen> {
  List<Map<String, dynamic>>? _providers;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<List<dynamic>>("/me/providers");
      if (mounted) {
        setState(() {
          _providers = data.map((e) => e as Map<String, dynamic>).toList();
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.isNetworkError ? "네트워크에 연결할 수 없어요. 다시 시도해주세요." : e.message;
        });
      }
    }
  }

  Future<void> _disconnect(String providerId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("로그인 수단을 해제할까요?"),
        content: const Text("이 수단으로 더 이상 로그인할 수 없게 돼요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: EnsomColors.caution),
            child: const Text("해제"),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final api = ref.read(apiClientProvider);
      await api.delete<Map<String, dynamic>>("/me/providers/$providerId");
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _connectGoogle() async {
    try {
      final googleSignIn = GoogleSignIn(
        serverClientId: kGoogleServerClientId.isEmpty
            ? null
            : kGoogleServerClientId,
        scopes: ["email"],
      );
      final account = await googleSignIn.signIn();
      if (account == null) return;
      final auth = await account.authentication;
      final idToken = auth.idToken;
      if (idToken == null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Google 인증에 실패했어요.")));
        }
        return;
      }

      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>(
        "/me/providers",
        body: {"provider": "google", "providerToken": idToken},
      );
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google 로그인에 실패했어요. 다시 시도해주세요.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인 수단")),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text("다시 시도")),
            ],
          ),
        ),
      );
    }

    final providers = _providers ?? [];
    final isOnlyOne = providers.length <= 1;

    return ListView(
      children: [
        const SizedBox(height: 8),
        ...providers.map((p) {
          final id = p["identityId"]?.toString() ?? "";
          final type = p["provider"]?.toString() ?? "";
          final email = p["email"]?.toString() ?? "";
          return ListTile(
            leading: Icon(_iconForProvider(type)),
            title: Text(_labelForProvider(type)),
            subtitle: email.isNotEmpty ? Text(email) : null,
            trailing: isOnlyOne
                ? const Tooltip(
                    message: "마지막 로그인 수단은 해제할 수 없어요",
                    child: Icon(
                      Icons.lock_outline,
                      color: EnsomColors.inkMuted,
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.link_off),
                    onPressed: () => _disconnect(id),
                  ),
          );
        }),
        if (isOnlyOne) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "마지막 로그인 수단은 해제할 수 없어요. 다른 수단을 먼저 연결해주세요.",
              style: TextStyle(color: EnsomColors.inkMuted, fontSize: 13),
            ),
          ),
        ],
        const Divider(),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Google 계정 연결"),
          onTap: _connectGoogle,
        ),
      ],
    );
  }

  IconData _iconForProvider(String type) {
    switch (type.toUpperCase()) {
      case "GOOGLE":
        return Icons.g_mobiledata;
      case "EMAIL":
        return Icons.email_outlined;
      default:
        return Icons.account_circle_outlined;
    }
  }

  String _labelForProvider(String type) {
    switch (type.toUpperCase()) {
      case "GOOGLE":
        return "Google";
      case "EMAIL":
        return "이메일";
      default:
        return type;
    }
  }
}
