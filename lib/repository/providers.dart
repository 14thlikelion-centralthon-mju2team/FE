import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vium_repository.dart';
import 'mock_vium_repository.dart';

final viumRepositoryProvider = Provider<ViumRepository>((ref) {
  return MockViumRepository(); // 나중에 실제 API 붙일 때 이 한 줄만 바꾸면 됨
});