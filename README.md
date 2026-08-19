# FE

## 실행

카카오 지도/검색 키는 커밋에 남기지 않고 빌드 시점에 주입한다.

```
flutter run --dart-define=KAKAO_NATIVE_APP_KEY=xxx --dart-define=KAKAO_REST_API_KEY=yyy
```

- `KAKAO_NATIVE_APP_KEY`: 카카오 개발자 콘솔의 네이티브 앱 키 (지도 SDK)
- `KAKAO_REST_API_KEY`: 같은 콘솔의 REST API 키 (목적지 키워드 검색)

둘 다 비어 있어도 빌드는 되며, 해당 기능만 저하 동작한다.
