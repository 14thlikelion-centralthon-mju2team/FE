import "package:ensom/models/prep_item.dart";
import "package:ensom/repository/ensom_repository.dart";
import "package:ensom/repository/providers.dart";
import "package:ensom/screens/onboarding/prep_time_entry_screen.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";

/// createPrepItem/updateSettings만 관측하는 최소 fake. 나머지 추상 메서드는
/// 테스트에서 호출되지 않으므로 noSuchMethod로 처리한다.
class _FakeRepo implements EnsomRepository {
  final List<PrepItem> created = [];
  Map<String, dynamic>? lastSettings;

  @override
  Future<void> updateSettings(Map<String, dynamic> patch) async {
    lastSettings = patch;
  }

  @override
  Future<PrepItem> createPrepItem(PrepItem item) async {
    created.add(item);
    return item;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<void> _pumpScreen(WidgetTester tester, _FakeRepo repo) async {
  // 유한 큰 뷰포트로 전체 폼을 스크롤 없이 렌더한다(무한 높이 제약 회피).
  tester.view.physicalSize = const Size(834, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // 화면이 context.go를 사용하므로 GoRouter 하네스가 필요하다.
  final router = GoRouter(
    initialLocation: "/prep",
    routes: [
      GoRoute(path: "/prep", builder: (c, s) => const PrepTimeEntryScreen()),
      // 저장 성공 후 이동 대상. 검증 대상 repository 호출은 이동 전에
      // 이미 끝나므로 이 화면 내용은 중요하지 않다.
      GoRoute(
        path: "/onboarding/places",
        builder: (c, s) => const Scaffold(body: Text("places")),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [ensomRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets("접었다 편 커스텀 항목 텍스트는 제출되지 않는다", (tester) async {
    final repo = _FakeRepo();
    await _pumpScreen(tester, repo);

    // 준비 시간 선택(제출 가능 상태로).
    await _tap(tester, find.text("30분"));

    // 빠른 추가 필드 열기.
    await _tap(tester, find.text("+ 직접 추가").first);

    // 텍스트 입력 후, 확정("추가")하지 않고 칩을 다시 눌러 접는다.
    await tester.enterText(find.byType(TextField).first, "지갑");
    await _tap(tester, find.text("+ 직접 추가").first);

    // 저장.
    await _tap(tester, find.text("다음으로"));

    // 접힌 "지갑"은 확정되지 않았으므로 생성되면 안 된다.
    expect(repo.created.any((i) => i.label == "지갑"), isFalse);
  });

  testWidgets("추가 버튼은 여러 커스텀 항목을 모두 확정한다", (tester) async {
    final repo = _FakeRepo();
    await _pumpScreen(tester, repo);

    await _tap(tester, find.text("30분"));
    await _tap(tester, find.text("+ 직접 추가").first);

    // 첫 항목 추가.
    await tester.enterText(find.byType(TextField).first, "지갑");
    await _tap(tester, find.text("추가"));
    // 둘째 항목 추가.
    await tester.enterText(find.byType(TextField).first, "이어폰");
    await _tap(tester, find.text("추가"));

    await _tap(tester, find.text("다음으로"));

    final labels = repo.created.map((i) => i.label).toList();
    expect(labels, containsAll(<String>["지갑", "이어폰"]));
  });

  testWidgets("분 라벨을 눌러도 루틴 체크가 해제되지 않는다", (tester) async {
    final repo = _FakeRepo();
    await _pumpScreen(tester, repo);

    await _tap(tester, find.text("30분"));

    // 루틴 체크(라벨 탭으로 선택).
    await _tap(tester, find.text("렌즈 착용"));

    // 스테퍼 분 라벨을 탭 — 조상 InkWell로 전달돼 해제되면 안 된다.
    await _tap(tester, find.text("5분"));

    await _tap(tester, find.text("다음으로"));

    // 렌즈 착용 루틴이 여전히 확정돼 제출됐는지 확인.
    expect(
      repo.created.any((i) => i.label == "렌즈 착용" && i.kind == PrepKind.routine),
      isTrue,
    );
  });
}
