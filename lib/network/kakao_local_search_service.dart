import "dart:convert";
import "package:http/http.dart" as http;

/// 카카오 로컬(키워드 검색) REST API 결과 한 건.
/// kakao_map_sdk(지도 렌더링 전용)에는 검색 기능이 없어서 별도로 붙인다.
class KakaoSearchResult {
  const KakaoSearchResult({
    required this.name,
    required this.addressName,
    required this.lat,
    required this.lng,
  });

  final String name;
  final String addressName;
  final double lat;
  final double lng;

  factory KakaoSearchResult.fromJson(Map<String, dynamic> json) {
    return KakaoSearchResult(
      name: json["place_name"] as String,
      addressName:
          (json["road_address_name"] as String?)?.isNotEmpty == true
              ? json["road_address_name"] as String
              : json["address_name"] as String,
      lat: double.parse(json["y"] as String),
      lng: double.parse(json["x"] as String),
    );
  }
}

/// 목적지 키워드 검색. REST API 키가 비어 있으면 항상 빈 리스트를
/// 반환해서 호출부(map_screen.dart)가 지도를 눌러 좌표를 고르는
/// 방식으로 저하 동작하게 한다.
class KakaoLocalSearchService {
  KakaoLocalSearchService({required String restApiKey, http.Client? client})
      : _restApiKey = restApiKey,
        _http = client ?? http.Client();

  static const _endpoint = "https://dapi.kakao.com/v2/local/search/keyword.json";

  final String _restApiKey;
  final http.Client _http;

  bool get isAvailable => _restApiKey.isNotEmpty;

  Future<List<KakaoSearchResult>> search(String query) async {
    if (!isAvailable || query.trim().isEmpty) return const [];

    final uri = Uri.parse(_endpoint).replace(queryParameters: {"query": query});
    final response = await _http.get(
      uri,
      headers: {"Authorization": "KakaoAK $_restApiKey"},
    );

    if (response.statusCode != 200) return const [];

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final documents = body["documents"] as List<dynamic>? ?? const [];
    return documents
        .map((e) => KakaoSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
