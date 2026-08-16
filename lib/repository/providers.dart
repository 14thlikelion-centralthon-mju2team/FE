import "package:flutter_riverpod/flutter_riverpod.dart";
import "ensom_repository.dart";
import "mock_ensom_repository.dart";

final ensomRepositoryProvider = Provider<EnsomRepository>((ref) {
  // 나중에 실제 API 붙일 때 이 한 줄만 바꾸면 됨
  return MockEnsomRepository();
});
