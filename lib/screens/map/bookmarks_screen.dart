import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";
import "../../theme/ensom_colors.dart";

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

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("북마크 추가"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: placeNameCtrl,
                decoration: const InputDecoration(labelText: "장소 이름"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: latCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "위도 (lat)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lngCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: "경도 (lng)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: folderCtrl,
                decoration: const InputDecoration(
                  labelText: "폴더 (선택)",
                  hintText: "미분류",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("추가"),
          ),
        ],
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
      appBar: AppBar(title: const Text("북마크")),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
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
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text("다시 시도")),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredBookmarks;

    return Column(
      children: [
        // 폴더 필터 세그먼트
        if (_folders.length > 1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _folders.map((folder) {
                final selected = folder == _selectedFolder;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(folder),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedFolder = folder),
                    selectedColor: EnsomColors.lime,
                    labelStyle: TextStyle(
                      color: selected ? EnsomColors.limeInk : EnsomColors.ink,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        // 리스트
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("북마크가 없어요."))
              : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final bookmark = filtered[index];
                    final id = bookmark["bookmarkId"]?.toString() ?? "";
                    final name = bookmark["placeName"]?.toString() ?? "이름 없음";
                    final folder = bookmark["folder"]?.toString() ?? "";

                    return Dismissible(
                      key: Key(id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: EnsomColors.caution,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: const Icon(
                          Icons.delete,
                          color: EnsomColors.canvas,
                        ),
                      ),
                      onDismissed: (_) => _deleteBookmark(id),
                      child: ListTile(
                        leading: const Icon(Icons.bookmark_outline),
                        title: Text(name),
                        subtitle: folder.isNotEmpty ? Text(folder) : null,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
