import "package:shared_preferences/shared_preferences.dart";

/// 코치마크 표시 이력을 SharedPreferences로 관리한다.
/// 홈 화면 최초 진입 시 1회만 오버레이를 보여준 뒤 다시 표시하지 않는다.
class CoachmarkService {
  CoachmarkService._();
  static final instance = CoachmarkService._();

  static const _keyHomeShown = "coachmark_home_shown";

  /// 코치마크를 보여줘야 하는지 — true면 아직 한 번도 표시한 적 없음.
  Future<bool> shouldShowCoachmark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHomeShown) != true;
  }

  /// 코치마크를 확인 처리(다시 안 보이도록 플래그 세팅).
  Future<void> markCoachmarkShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHomeShown, true);
  }
}
