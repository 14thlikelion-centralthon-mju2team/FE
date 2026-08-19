import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:uuid/uuid.dart";
import "../../network/api_client.dart";
import "../../providers/auth_providers.dart";

/// DTL-01 일정 상세
/// 진입: HM-01 카드 탭, CAL-01 카드 탭, HM-02 알림 행
/// BE API: GET /events/{id}/plans/latest
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  static const _uuid = Uuid();
  Map<String, dynamic>? _event;
  Map<String, dynamic>? _plan;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final apiClient = ref.read(apiClientProvider);
      final event = await apiClient.get<Map<String, dynamic>>(
        "/events/${widget.eventId}",
      );
      Map<String, dynamic>? plan;
      try {
        plan = await apiClient.get<Map<String, dynamic>>(
          "/events/${widget.eventId}/plans/latest",
        );
      } on ApiException catch (e) {
        // 계획이 아직 없을 수 있음 (장소 미지정 등)
        if (e.statusCode != 404) rethrow;
      }
      if (mounted) {
        setState(() {
          _event = event;
          _plan = plan;
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.message;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_event?["displayName"] ?? "일정 상세"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: "edit", child: Text("계획 수정")),
              const PopupMenuItem(
                value: "delete",
                child: Text("일정 삭제", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadDetail, child: const Text("다시 시도")),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(),
          if (_plan != null) ...[
            const SizedBox(height: 24),
            _buildTimePlan(),
            const SizedBox(height: 24),
            _buildBreakdown(),
            const SizedBox(height: 24),
            _buildChecklist(),
            const SizedBox(height: 24),
            _buildRoute(),
          ],
          if (_plan == null) ...[
            const SizedBox(height: 48),
            const Center(
              child: Text(
                "이 일정은 이동 계획이 없어요.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final event = _event!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event["displayName"] ?? "",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            if (event["destinationName"] != null)
              Row(
                children: [
                  const Icon(Icons.place, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(event["destinationName"]),
                ],
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(_formatTime(event["startsAt"])),
                const Text(" ~ "),
                Text(_formatTime(event["endsAt"])),
              ],
            ),
            if (event["status"] != null) ...[
              const SizedBox(height: 8),
              Chip(label: Text(event["status"])),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimePlan() {
    final plan = _plan!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("시간 계획",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _timeRow("준비 시작", plan["prepStartAt"]),
            _timeRow("권장 출발", plan["recommendedDepartAt"]),
            _timeRow("목표 도착", plan["targetArriveAt"]),
            if (plan["feasible"] == false) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text("시간이 충분하지 않을 수 있어요."),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _timeRow(String label, dynamic isoTime) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            _formatTime(isoTime),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdown() {
    final breakdown = _plan!["breakdown"] as Map<String, dynamic>?;
    if (breakdown == null) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("계산 근거",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _breakdownRow("개인 준비", breakdown["estimatedPrepMinutes"]),
            _breakdownRow("추가 준비", breakdown["extraPrepMinutes"]),
            _breakdownRow("루틴", breakdown["personalRoutineMinutes"]),
            _breakdownRow("이동", breakdown["travelMinutes"]),
            _breakdownRow("교통 버퍼", breakdown["trafficBufferMinutes"]),
            _breakdownRow("도착 여유", breakdown["arrivalBufferMinutes"]),
          ],
        ),
      ),
    );
  }

  Widget _breakdownRow(String label, dynamic minutes) {
    final min = minutes as int? ?? 0;
    if (min == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("$min분"),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    final checklist = (_plan!["checklist"] as List<dynamic>?) ?? [];
    if (checklist.isEmpty) return const SizedBox.shrink();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("준비 항목",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...checklist.map((item) {
              final map = item as Map<String, dynamic>;
              // TR-10: 화면 내에서도 민감 항목 마스킹 적용.
              // 잠금화면/푸시 마스킹과 별개로, 화면 공유·스크린샷 시 노출 방지.
              // 사용자가 자기 항목명을 보려면 "자세히" 등 별도 인터랙션 추가 필요(후속).
              final name = map["isSensitive"] == true
                  ? "개인 준비"
                  : (map["itemName"] ?? "");
              final done = map["completionStatus"] == "completed";
              return CheckboxListTile(
                value: done,
                title: Text(name),
                subtitle: map["reason"] != null
                    ? Text(map["reason"], style: const TextStyle(fontSize: 12))
                    : null,
                onChanged: done ? null : (_) => _resolveItem(map["planPrepItemId"]),
                controlAffinity: ListTileControlAffinity.leading,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRoute() {
    final routeId = _plan!["selectedRouteOptionId"];
    if (routeId == null) return const SizedBox.shrink();
    final breakdown = _plan!["breakdown"] as Map<String, dynamic>?;
    final travelMin = breakdown?["travelMinutes"] ?? 0;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.directions),
        title: Text("이동 $travelMin분"),
        trailing: TextButton(
          onPressed: () {
            // TODO: RTE-01 경로 변경 시트
          },
          child: const Text("변경"),
        ),
      ),
    );
  }

  Future<void> _resolveItem(dynamic itemId) async {
    if (itemId == null) return;
    try {
      final apiClient = ref.read(apiClientProvider);
      final planId = _plan!["planId"];
      await apiClient.post(
        "/plans/$planId/prep-items/$itemId/resolve",
        body: {
          "completionStatus": "completed",
          "clientEventId": _uuid.v4(),
        },
      );
      await _loadDetail();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  void _onMenuAction(String action) {
    switch (action) {
      case "edit":
        // TODO: CAL-04 수정 모드로 이동
        break;
      case "delete":
        _showDeleteConfirm();
        break;
    }
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("이 일정을 삭제할까요?"),
        content: const Text("예약된 알림도 함께 취소돼요."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("취소"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteEvent();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("삭제"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteEvent() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.delete("/events/${widget.eventId}");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("삭제했어요.")),
        );
        context.pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  String _formatTime(dynamic isoTime) {
    if (isoTime == null) return "--:--";
    try {
      final dt = DateTime.parse(isoTime.toString()).toLocal();
      final now = DateTime.now();
      final h = dt.hour.toString().padLeft(2, "0");
      final m = dt.minute.toString().padLeft(2, "0");
      // 오늘이면 시간만, 아니면 날짜+시간
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return "$h:$m";
      }
      return "${dt.month}/${dt.day} $h:$m";
    } catch (_) {
      return "--:--";
    }
  }
}
