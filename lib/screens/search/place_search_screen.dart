import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/kakao_local_search_service.dart";
import "../../providers/map_providers.dart";
import "../../theme/ensom_colors.dart";

/// SRCH-01 장소 검색 전체화면 — v6 프로토타입 기준 redesign
/// 디자인 기준: Ensom_프로토타입_v6_최종/03_지도/ensom_search.html
class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key});

  @override
  ConsumerState<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<KakaoSearchResult> _results = [];
  bool _searching = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }
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
            _buildSearchHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Row(
        children: [
          // 뒤로가기
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.chevron_left, size: 14, color: EnsomColors.ink),
            ),
          ),
          const SizedBox(width: 10),
          // 검색창
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              decoration: BoxDecoration(
                color: _focusNode.hasFocus ? EnsomColors.canvas : EnsomColors.surface2,
                border: Border.all(
                  color: _focusNode.hasFocus ? EnsomColors.cta : Colors.transparent,
                  width: 1.6,
                ),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 15, color: EnsomColors.inkMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: const InputDecoration.collapsed(
                        hintText: "장소, 지하철역, 도로명으로 검색",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: EnsomColors.inkFaint,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14, color: EnsomColors.ink),
                      textInputAction: TextInputAction.search,
                      onChanged: _search,
                      onSubmitted: _search,
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _controller.clear();
                        setState(() {
                          _results = [];
                          _hasSearched = false;
                        });
                      },
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: EnsomColors.surfaceNeutral,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.close, size: 8, color: EnsomColors.inkMuted),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_searching) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_hasSearched) {
      return _buildDefaultState();
    }
    if (_results.isEmpty) {
      return _buildEmptyState();
    }
    return _buildResultsList();
  }

  Widget _buildDefaultState() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _SectionLabel("최근 검색"),
        ...["강남역", "디자인 리뷰 미팅룸"].map(
          (name) => _SearchRow(
            icon: Icons.access_time,
            name: name,
            onTap: () {
              _controller.text = name;
              _search(name);
            },
          ),
        ),
        _SectionLabel("주요 장소"),
        _SearchRow(icon: Icons.home_outlined, name: "집", onTap: () {}),
        _SearchRow(icon: Icons.business, name: "직장", onTap: () {}),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "검색 결과가 없어요",
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: EnsomColors.ink,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "다른 이름으로 찾아보시겠어요?",
            style: TextStyle(fontSize: 12, color: EnsomColors.inkMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        return _SearchRow(
          icon: Icons.place_outlined,
          name: item.name,
          subtitle: item.addressName,
          onTap: () => Navigator.pop(context, item),
        );
      },
    );
  }
}

// ─── Components ───

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: EnsomColors.inkFaint,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.icon,
    required this.name,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: EnsomColors.surface2,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 14, color: EnsomColors.inkMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: EnsomColors.ink,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: EnsomColors.inkFaint,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
