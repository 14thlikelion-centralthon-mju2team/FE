import '../models/age_verification.dart';
import '../models/routine_run.dart';
import '../models/daily_checkin.dart';
import '../models/task_log.dart';
import '../models/adjustment.dart';
import '../models/daily_state.dart';
import '../models/place.dart';
import '../models/health_checkup.dart';
import '../models/user_event.dart';
import '../models/chat_response.dart';
import 'vium_repository.dart';

class MockViumRepository implements ViumRepository {
  @override
  Future<AgeVerificationResult> verifyAge(DateTime birthDate) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final age = DateTime.now().difference(birthDate).inDays ~/ 365;
    return AgeVerificationResult(
      eligible: age >= 14,
      ageConfirmedAt: age >= 14 ? DateTime.now() : null,
    );
  }

  @override
  Future<RoutineRun> fetchTodayRoutine() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return RoutineRun(
      id: 'mock-run-1',
      routineId: 'mock-routine-1',
      runDate: DateTime.now(),
      status: 'scheduled',
    );
  }

  @override
  Future<DailyCheckin> submitDailyCheckin(DailyCheckin checkin) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return checkin.copyWith(conditionInferred: 'normal', conditionAccepted: true);
  }

  @override
  Future<TaskLog> submitTaskLog(TaskLog log) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return log.copyWith(completedAt: DateTime.now());
  }

  @override
  Future<List<DailyState>> fetchDailyStates(DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      DailyState(
        runDate: DateTime.now(),
        doneCount: 2,
        expectedCount: 3,
        completionRate: 0.67,
        signal: 'green',
      ),
    ];
  }

  @override
  Future<void> submitAdjustment(Adjustment adjustment) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<ChatResponse> sendChatMessage(String message) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const ChatResponse(
      intent: 'modify',
      targetTaskId: 'task-1',
      proposedActionId: 'a1-modified',
      reason: '물 3잔은 지금보다 두 단계 높아요. 우선 2잔으로 올려볼까요?',
    );
  }

  @override
  Future<List<Place>> fetchPlaces() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Place(id: 'p1', label: '집', lat: 37.5665, lng: 126.9780, radiusM: 300),
    ];
  }

  @override
  Future<Place> registerPlace(Place place) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return place;
  }

  @override
  Future<void> deletePlace(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> notifyPlaceEnter(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<List<HealthCheckup>> fetchHealthCheckups() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      HealthCheckup(measuredOn: DateTime.now(), data: {'체지방률': '22%', '골격근량': '28kg'}),
    ];
  }

  @override
  Future<List<UserEvent>> fetchUserEvents(DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [];
  }
}