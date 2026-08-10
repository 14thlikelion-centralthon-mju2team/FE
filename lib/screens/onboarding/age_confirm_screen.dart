import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../repository/providers.dart';

class AgeConfirmScreen extends ConsumerStatefulWidget {
  const AgeConfirmScreen({super.key});
  @override
  ConsumerState<AgeConfirmScreen> createState() => _AgeConfirmScreenState();
}

class _AgeConfirmScreenState extends ConsumerState<AgeConfirmScreen> {
  bool _loading = false;
  String? _error;

  Future<void> _onSubmit(DateTime pickedDate) async {
    setState(() => _loading = true);
    final repo = ref.read(viumRepositoryProvider);
    final result = await repo.verifyAge(pickedDate);
    // pickedDate는 여기서 로컬 변수로만 존재하고 끝 — Provider나 Hive 어디에도 저장하지 않음
    setState(() => _loading = false);

    if (!mounted) return;
    if (result.eligible) {
      context.go('/onboarding/consent');
    } else {
      setState(() => _error = '만 14세 이상만 가입할 수 있어요');
      // 필요 시 법정대리인 동의 안내 화면으로 분기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('생년월일을 알려주세요')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      initialDate: DateTime(2000),
                    );
                    if (picked != null) await _onSubmit(picked);
                  },
            child: const Text('생년월일 선택'),
          ),
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}