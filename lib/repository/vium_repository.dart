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

abstract class ViumRepository {
  // 온보딩
  Future<AgeVerificationResult> verifyAge(DateTime birthDate);

  // 오늘의 루틴
  Future<RoutineRun> fetchTodayRoutine();
  Future<DailyCheckin> submitDailyCheckin(DailyCheckin checkin);

  // 실행·기록
  Future<TaskLog> submitTaskLog(TaskLog log);

  // 상태·리포트
  Future<List<DailyState>> fetchDailyStates(DateTime from, DateTime to);

  // 난이도 조정
  Future<void> submitAdjustment(Adjustment adjustment);

  // 챗봇
  Future<ChatResponse> sendChatMessage(String message);

  // 장소·지오펜스
  Future<List<Place>> fetchPlaces();
  Future<Place> registerPlace(Place place);
  Future<void> deletePlace(String placeId);
  Future<void> notifyPlaceEnter(String placeId);

  // 건강 데이터·외부 일정
  Future<List<HealthCheckup>> fetchHealthCheckups();
  Future<List<UserEvent>> fetchUserEvents(DateTime from, DateTime to);
}