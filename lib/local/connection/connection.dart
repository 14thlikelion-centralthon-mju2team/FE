import "package:drift/drift.dart";

// 플랫폼별 실제 구현을 조건부 import로 선택한다.
// - dart:io 가 있으면(모바일/데스크톱) native.dart (NativeDatabase, FFI)
// - 없으면(web) web.dart (WasmDatabase)
import "native.dart" if (dart.library.js_interop) "web.dart" as impl;

/// 오프라인 큐 DB의 실행자(QueryExecutor)를 플랫폼에 맞게 연다.
QueryExecutor openConnection() => impl.openConnection();
