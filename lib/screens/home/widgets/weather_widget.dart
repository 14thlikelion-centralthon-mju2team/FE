import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "../../../models/environment_data.dart";
import "../../../providers/environment_provider.dart";
import "../../../theme/ensom_colors.dart";

/// 홈 화면 인라인 날씨/환경 카드.
/// 접힌 상태에서 온도·하늘·PM10 뱃지를 한 줄로 보여주고,
/// 탭하면 확장해 PM25·자외선 정보를 추가로 표시한다.
/// 에러 시 아무것도 렌더링하지 않는다 (graceful degradation).
class WeatherWidget extends ConsumerStatefulWidget {
  const WeatherWidget({super.key});

  @override
  ConsumerState<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends ConsumerState<WeatherWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final envAsync = ref.watch(environmentProvider);

    return envAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (data) => _buildCard(data),
    );
  }

  Widget _buildCard(EnvironmentData data) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Card(
        color: EnsomColors.surface2,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 접힌 상태: 온도 · 하늘 · PM10
              Row(
                children: [
                  if (data.temperature != null) ...[
                    Text(
                      "${data.temperature}°",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: EnsomColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (data.sky != null) ...[
                    Icon(_skyIcon(data.sky!), size: 20, color: EnsomColors.inkMuted),
                    const SizedBox(width: 4),
                    Text(
                      data.sky!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: EnsomColors.inkMuted,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (data.pm10Grade != null)
                    _GradeBadge(label: "미세", grade: data.pm10Grade!),
                  const Spacer(),
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    color: EnsomColors.inkMuted,
                    size: 20,
                  ),
                ],
              ),
              // 확장 상태: PM25 + UV
              if (_expanded) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: EnsomColors.hairline),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (data.pm25Grade != null)
                      _GradeBadge(label: "초미세", grade: data.pm25Grade!),
                    if (data.pm25Grade != null) const SizedBox(width: 12),
                    if (data.uvIndex != null) ...[
                      const Icon(Icons.wb_sunny_outlined,
                          size: 16, color: EnsomColors.inkMuted),
                      const SizedBox(width: 4),
                      Text(
                        "자외선 ${data.uvIndex}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: EnsomColors.inkMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _skyIcon(String sky) {
    switch (sky) {
      case "맑음":
        return Icons.wb_sunny;
      case "구름많음":
        return Icons.cloud;
      case "흐림":
        return Icons.cloud_queue;
      default:
        return Icons.wb_cloudy;
    }
  }
}

class _GradeBadge extends StatelessWidget {
  const _GradeBadge({required this.label, required this.grade});

  final String label;
  final String grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _gradeColor(grade).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$label $grade",
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _gradeColor(grade),
        ),
      ),
    );
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case "좋음":
        return Colors.blue;
      case "보통":
        return Colors.green;
      case "나쁨":
        return Colors.orange;
      case "매우나쁨":
        return Colors.red;
      default:
        return EnsomColors.inkMuted;
    }
  }
}
