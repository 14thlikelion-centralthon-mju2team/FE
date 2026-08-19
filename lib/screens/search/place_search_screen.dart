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
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "장소를 검색하세요",
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: _search,
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _results = [];
                  _hasSearched = false;
                });
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasSearched) {
      return const Center(
        child: Text(
          "검색어를 입력하세요",
          style: TextStyle(color: EnsomColors.inkMuted),
        ),
      );
    }
    if (_results.isEmpty) {
      return const Center(
        child: Text(
          "검색 결과가 없어요",
          style: TextStyle(color: EnsomColors.inkMuted),
        ),
      );
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _results[index];
        return ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(item.name),
          subtitle: Text(
            item.addressName,
            style: const TextStyle(fontSize: 12),
          ),
          onTap: () => Navigator.pop(context, item),
        );
      },
    );
  }
}
