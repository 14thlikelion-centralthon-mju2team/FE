import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/kakao_local_search_service.dart";
import "../../providers/map_providers.dart";
import "../../theme/ensom_colors.dart";

/// SRCH-01 장소 검색 전체화면
/// 호출: MAP-01, CAL-04, ONB-05, PRF-06
/// 결과 선택 시 KakaoSearchResult를 pop으로 반환.
///
/// 사용법:
/// ```dart
/// final result = await Navigator.push<KakaoSearchResult>(
///   context,
///   MaterialPageRoute(builder: (_) => const PlaceSearchScreen()),
/// );
/// ```
class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  ConsumerState<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  final _controller = TextEditingController();
  List<KakaoSearchResult> _results = [];
  bool _searching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() => _searching = true);
    final service = ref.read(kakaoLocalSearchServiceProvider);
    final results = await service.search(query);
    if (mounted) {
      setState(() {
        _results = results;
        _searching = false;
        _hasSearched = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Material(
                    color: EnsomColors.surface2,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(Icons.arrow_back, size: 15, color: EnsomColors.ink),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: EnsomColors.surface2, borderRadius: BorderRadius.circular(999)),
                      child: Row(
                        children: [
                          const Icon(Icons.search, size: 15, color: EnsomColors.inkFaint),
                          const SizedBox(width: 9),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              onSubmitted: _search,
                              style: const TextStyle(fontSize: 13.5, color: EnsomColors.ink),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "장소를 검색하세요",
                                isCollapsed: true,
                                hintStyle: TextStyle(color: EnsomColors.inkFaint),
                              ),
                            ),
                          ),
                          if (_controller.text.isNotEmpty)
                            InkWell(
                              onTap: () {
                                _controller.clear();
                                setState(() {
                                  _results = [];
                                  _hasSearched = false;
                                });
                              },
                              child: const Icon(Icons.close, size: 15, color: EnsomColors.inkFaint),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasSearched) {
      return const Center(
        child: Text("검색어를 입력하세요", style: TextStyle(fontSize: 12.5, color: EnsomColors.inkFaint)),
      );
    }
    if (_results.isEmpty) {
      return const Center(
        child: Text("검색 결과가 없어요", style: TextStyle(fontSize: 12.5, color: EnsomColors.inkFaint)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: EnsomColors.hairline),
      itemBuilder: (context, index) {
        final item = _results[index];
        return InkWell(
          onTap: () => Navigator.pop(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
                  child: const Icon(Icons.place_outlined, size: 15, color: EnsomColors.inkMuted),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.addressName,
                        style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
