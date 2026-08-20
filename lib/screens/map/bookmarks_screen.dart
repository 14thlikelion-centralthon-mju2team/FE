import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";
import "../../widgets/ensom/ensom_chip.dart";
import "../../widgets/ensom/ensom_pill_button.dart";
import "../../widgets/ensom/ensom_text_field.dart";
import "../../widgets/ensom/ensom_top_bar.dart";

/// S-30/S-31 북마크 관리
class BookmarksScreen extends ConsumerStatefulWidget {
  const BookmarksScreen({super.key});

  @override
  ConsumerState<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends ConsumerState<BookmarksScreen> {
  List<Map<String, dynamic>>? _bookmarks;
  bool _loading = true;
  String? _error;
  String _selectedFolder = "전체";
  List<String> _folders = ["전체"];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(apiClientProvider);
      final data = await api.get<List<dynamic>>("/me/bookmarks");
      if (mounted) {
        final bookmarks = data.map((e) => e as Map<String, dynamic>).toList();
        final folderSet = <String>{"전체"};
        for (final b in bookmarks) {
          final folder = b["folder"]?.toString();
          if (folder != null && folder.isNotEmpty) {
            folderSet.add(folder);
          }
        }
        setState(() {
          _bookmarks = bookmarks;
          _folders = folderSet.toList();
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.isNetworkError ? "네트워크에 연결할 수 없어요. 다시 시도해주세요." : e.message;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filteredBookmarks {
    if (_bookmarks == null) return [];
    if (_selectedFolder == "전체") return _bookmarks!;
    return _bookmarks!
        .where((b) => b["folder"]?.toString() == _selectedFolder)
        .toList();
  }

  Future<void> _deleteBookmark(String bookmarkId) async {
    try {
      final api = ref.read(apiClientProvider);
      await api.delete<Map<String, dynamic>>("/me/bookmarks/$bookmarkId");
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _showAddDialog() async {
    final placeNameCtrl = TextEditingController();
    final latCtrl = TextEditingController();
    final lngCtrl = TextEditingController();
    final folderCtrl = TextEditingController();

    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: EnsomColors.canvas,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 22,
          right: 22,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 22,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "북마크 추가",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: -.2, color: EnsomColors.ink),
              ),
              const SizedBox(height: 16),
              EnsomTextField(label: "장소 이름", controller: placeNameCtrl),
              const SizedBox(height: 12),
              EnsomTextField(
                label: "위도 (lat)",
                controller: latCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              EnsomTextField(
                label: "경도 (lng)",
                controller: lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              EnsomTextField(label: "폴더 (선택)", controller: folderCtrl),
              const SizedBox(height: 18),
              EnsomPillButton(label: "추가", onPressed: () => Navigator.pop(ctx, true)),
              const SizedBox(height: 4),
              EnsomPillButton(label: "취소", variant: EnsomPillVariant.text, onPressed: () => Navigator.pop(ctx, false)),
            ],
          ),
        ),
      ),
    );

    if (result != true) return;

    final placeName = placeNameCtrl.text.trim();
    final lat = double.tryParse(latCtrl.text.trim());
    final lng = double.tryParse(lngCtrl.text.trim());

    if (placeName.isEmpty || lat == null || lng == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("장소 이름, 위도, 경도를 올바르게 입력해주세요.")),
        );
      }
      return;
    }

    try {
      final api = ref.read(apiClientProvider);
      await api.post<Map<String, dynamic>>(
        "/me/bookmarks",
        body: {
          "placeName": placeName,
          "lat": lat,
          "lng": lng,
          "folder": folderCtrl.text.trim().isEmpty
              ? null
              : folderCtrl.text.trim(),
        },
      );
      await _load();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EnsomColors.canvas,
      appBar: const EnsomTopBar(title: "북마크"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: EnsomColors.cta,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(top: false, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: EnsomColors.inkMuted)),
              const SizedBox(height: 16),
              EnsomPillButton(label: "다시 시도", expand: false, onPressed: _load),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredBookmarks;

    return Column(
      children: [
        // 폴더 필터
        if (_folders.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            child: Row(
              children: _folders.map((folder) {
                return Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: EnsomChip(
                    label: folder,
                    selected: folder == _selectedFolder,
                    onTap: () => setState(() => _selectedFolder = folder),
                  ),
                );
              }).toList(),
            ),
          ),
        // 리스트
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("북마크가 없어요.", style: TextStyle(color: EnsomColors.inkFaint)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 90),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final bookmark = filtered[index];
                    final id = bookmark["bookmarkId"]?.toString() ?? "";
                    final name = bookmark["placeName"]?.toString() ?? "이름 없음";
                    final folder = bookmark["folder"]?.toString() ?? "";
                    final lat = (bookmark["lat"] as num?)?.toDouble();
                    final lng = (bookmark["lng"] as num?)?.toDouble();

                    return Dismissible(
                      key: Key(id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        decoration: BoxDecoration(color: EnsomColors.caution, borderRadius: BorderRadius.circular(16)),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete_outline, color: Colors.white, size: 18),
                      ),
                      onDismissed: (_) => _deleteBookmark(id),
                      child: InkWell(
                        onTap: (lat != null && lng != null)
                            ? () => context.push(
                                  "/map?destLat=$lat&destLng=$lng"
                                  "&destName=${Uri.encodeComponent(name)}",
                                )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: EnsomColors.surface1,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: EnsomColors.hairline),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: const BoxDecoration(color: EnsomColors.surface2, shape: BoxShape.circle),
                                child: const Icon(Icons.bookmark_outline, size: 15, color: EnsomColors.inkMuted),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: EnsomColors.ink),
                                    ),
                                    if (folder.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(folder, style: const TextStyle(fontSize: 11, color: EnsomColors.inkFaint)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
