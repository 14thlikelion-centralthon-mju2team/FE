import "dart:io";

import "package:ensom/local/place_cache_entry.dart";
import "package:ensom/models/place.dart";
import "package:ensom/repository/ensom_repository.dart";
import "package:ensom/repository/providers.dart";
import "package:ensom/screens/places/place_registration_screen.dart";
import "package:ensom/widgets/ensom/ensom_pill_button.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:hive_ce/hive_ce.dart";

/// registerPlace/deletePlace만 관측하는 최소 fake.
class _FakeRepo implements EnsomRepository {
  int registerCount = 0;

  @override
  Future<Place> registerPlace(Place place) async {
    registerCount++;
    return place;
  }

  @override
  Future<void> deletePlace(String id) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<void> _pumpScreen(WidgetTester tester, _FakeRepo repo) async {
  tester.view.physicalSize = const Size(834, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: "/places",
    routes: [
      GoRoute(
        path: "/places",
        builder: (c, s) => const PlaceRegistrationScreen(),
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

// "등록하기" EnsomPillButton의 onPressed가 null인지(비활성) 확인한다.
bool _registerDisabled(WidgetTester tester) {
  final button = tester.widget<EnsomPillButton>(
    find.ancestor(
      of: find.text("등록하기"),
      matching: find.byType(EnsomPillButton),
    ),
  );
  return button.onPressed == null;
}

void main() {
  late Directory tempDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tempDir = await Directory.systemTemp.createTemp("hive_pr67_test");
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PlaceCacheEntryAdapter());
    }
    await Hive.openBox<PlaceCacheEntry>("place_cache");
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  setUp(() async {
    await Hive.box<PlaceCacheEntry>("place_cache").clear();
  });

  testWidgets("직접 입력 + 이름 미입력이면 등록 버튼이 비활성이다", (tester) async {
    final repo = _FakeRepo();
    await _pumpScreen(tester, repo);

    // "직접 입력" 칩 선택 → 이름 필드 노출, 비워둔 상태.
    await tester.tap(find.text("직접 입력"));
    await tester.pumpAndSettle();

    // 위치가 없으므로 당연히 비활성.
    expect(_registerDisabled(tester), isTrue);

    // 이름을 입력하면(위치는 여전히 없음) 여전히 비활성이어야 한다.
    await tester.enterText(find.byType(TextField).first, "우리집");
    await tester.pumpAndSettle();
    expect(_registerDisabled(tester), isTrue);
  });

  testWidgets("기본 라벨(집)은 이름 입력 없이 위치만 있으면 되지만 커스텀은 이름이 필요하다", (tester) async {
    final repo = _FakeRepo();
    await _pumpScreen(tester, repo);

    // 기본 라벨 "집"은 이름 입력 필드가 없다.
    await tester.tap(find.text("집"));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);

    // "직접 입력"으로 바꾸면 이름 필드가 나타난다.
    await tester.tap(find.text("직접 입력"));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
  });
}
