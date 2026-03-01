// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '마음체크';

  @override
  String get notDiagnosis => '이 앱은 선별 전용 도구입니다.';

  @override
  String get homeTitle => '오늘의 마음 상태를 확인해볼까요?';

  @override
  String get homeSubtitle => '13-49세를 위한 2단계 우울 선별 흐름입니다.';

  @override
  String get homeStart => '경도 검사 시작';

  @override
  String get homeSafetyNote => '안전 위험이 감지되면 즉시 응급 안내를 표시합니다.';

  @override
  String get homeWellnessToolsTitle => '일상 지원 도구';

  @override
  String get homeDailyCheckInTitle => '데일리 체크인';

  @override
  String get homeDailyCheckInSubtitle => '1분 이내로 기분과 에너지를 기록해보세요.';

  @override
  String get homeDailyCheckInCta => '체크인 열기';

  @override
  String get homeSafetyPlanTitle => '개인 안전 플랜';

  @override
  String get homeSafetyPlanSubtitle => '나만의 안전 계획과 신뢰 연락처를 미리 준비하세요.';

  @override
  String get homeSafetyPlanCta => '안전 플랜 열기';

  @override
  String get homeBrowseModules => '설문 모듈 보기';

  @override
  String get homeThemeLanguage => '테마/언어 설정';

  @override
  String get splashLoading => '개인화된 안전 중심 경험을 불러오는 중입니다...';

  @override
  String get onboardingLabel => '온보딩';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingGetStarted => '시작하기';

  @override
  String get onboardingTitle1 => '마음체크에 오신 것을 환영합니다';

  @override
  String get onboardingBody1 => '현재 우울 위험을 추정하기 위해 2단계 선별 흐름을 사용합니다.';

  @override
  String get onboardingTitle2 => '이해하기 쉬운 결과 안내';

  @override
  String get onboardingBody2 => '결과는 정상, 경도, 중등도, 고위험으로 표기되며 다음 행동을 함께 제안합니다.';

  @override
  String get onboardingTitle3 => '안전 우선 연계';

  @override
  String get onboardingBody3 => '고위험 신호가 감지되면 즉시 응급 도움과 주변 진료기관 안내를 제공합니다.';

  @override
  String get levelNormal => '정상';

  @override
  String get levelMild => '경도';

  @override
  String get levelModerate => '중등도';

  @override
  String get levelHighRisk => '고위험';

  @override
  String get phq2Title => 'PHQ-2 경도 선별';

  @override
  String get phq2Question1 =>
      '지난 2주 동안, 기분이 가라앉거나 우울하거나 희망이 없다고 느낀 빈도는 어느 정도였나요?';

  @override
  String get phq2Question2 => '지난 2주 동안, 일에 대한 흥미나 즐거움이 줄었다고 느낀 빈도는 어느 정도였나요?';

  @override
  String get phq9Title => 'PHQ-9 / PHQ-A 중등도 선별';

  @override
  String get phq9Intro => '9개 문항에 모두 응답해주세요. 위험도가 높으면 즉시 도움과 주변 병원을 안내합니다.';

  @override
  String get phq9Question1 => '일이나 활동에 대한 흥미 또는 즐거움이 줄었다';

  @override
  String get phq9Question2 => '우울하거나 침체되거나 희망이 없다고 느꼈다';

  @override
  String get phq9Question3 => '잠들기 어렵거나 자주 깨거나 너무 많이 잤다';

  @override
  String get phq9Question4 => '피곤하고 기운이 없었다';

  @override
  String get phq9Question5 => '식욕이 줄거나 과식했다';

  @override
  String get phq9Question6 => '자신이 쓸모없거나 실패자처럼 느껴졌다';

  @override
  String get phq9Question7 => '일에 집중하기 어려웠다';

  @override
  String get phq9Question8 => '평소보다 매우 느려지거나 안절부절못했다';

  @override
  String get phq9Question9 => '차라리 죽는 것이 낫겠다고 생각했거나 자신을 해칠 생각이 들었다';

  @override
  String get answer0 => '전혀 없었다';

  @override
  String get answer1 => '며칠 있었다';

  @override
  String get answer2 => '1주일 이상 있었다';

  @override
  String get answer3 => '거의 매일 있었다';

  @override
  String get buttonViewResult => '결과 확인';

  @override
  String get buttonContinue => '계속';

  @override
  String get buttonFindClinics => '주변 병원 찾기';

  @override
  String get buttonCallEmergency => '응급전화';

  @override
  String get buttonCallCrisis => '위기상담 연결';

  @override
  String get buttonBackHome => '홈으로';

  @override
  String get buttonCallClinic => '병원 전화';

  @override
  String get buttonDirections => '길찾기';

  @override
  String get checkInTitle => '데일리 체크인';

  @override
  String get checkInSubtitle => '이 기능은 선별 지원을 위한 일상 상태 기록용입니다.';

  @override
  String get checkInMoodLabel => '기분';

  @override
  String get checkInEnergyLabel => '에너지';

  @override
  String get checkInNoteLabel => '짧은 메모 (선택)';

  @override
  String get checkInSaveButton => '오늘 기록 저장';

  @override
  String get checkInWeeklyTrendTitle => '최근 7일 추세';

  @override
  String get checkInNoTrendData => '아직 추세 데이터가 없습니다. 첫 기록을 저장해보세요.';

  @override
  String checkInWeeklyAverage(Object mood, Object energy) {
    return '주간 평균 - 기분 $mood, 에너지 $energy';
  }

  @override
  String get checkInSavedSuccess => '체크인이 저장되었습니다.';

  @override
  String get checkInSavedFail => '체크인 저장에 실패했습니다. 다시 시도해주세요.';

  @override
  String get checkInMoodShort => '기분';

  @override
  String get checkInEnergyShort => '에너지';

  @override
  String get safetyPlanTitle => '안전 플랜';

  @override
  String get safetyPlanEmergencyTitle => '지금 당장 안전이 걱정된다면';

  @override
  String get safetyPlanCallPrimary => '주요 연락처에 전화';

  @override
  String get safetyPlanWarningSigns => '내 위험 신호';

  @override
  String get safetyPlanCoping => '나를 진정시키는 방법';

  @override
  String get safetyPlanReasons => '안전을 지켜야 하는 이유';

  @override
  String get safetyPlanEmergencySteps => '응급 상황 행동 단계';

  @override
  String get safetyPlanSaveButton => '안전 플랜 저장';

  @override
  String get safetyPlanContactsTitle => '신뢰 연락처';

  @override
  String get safetyPlanAddContact => '연락처 추가';

  @override
  String get safetyPlanContactsEmpty => '등록된 신뢰 연락처가 없습니다.';

  @override
  String get safetyPlanSavedSuccess => '안전 플랜이 저장되었습니다.';

  @override
  String get safetyPlanSavedFail => '안전 플랜 저장에 실패했습니다.';

  @override
  String get safetyPlanCallFailed => '전화 실행에 실패했습니다';

  @override
  String get safetyPlanContactName => '이름';

  @override
  String get safetyPlanContactRelation => '관계';

  @override
  String get safetyPlanContactPhone => '전화번호';

  @override
  String get safetyPlanSetPrimary => '주요 연락처로 지정';

  @override
  String get safetyPlanContactSaved => '신뢰 연락처가 저장되었습니다.';

  @override
  String get safetyPlanContactInvalid => '입력값을 확인한 뒤 다시 시도해주세요.';

  @override
  String get safetyPlanDialogCancel => '취소';

  @override
  String get safetyPlanDialogSave => '저장';

  @override
  String get safetyPlanCallContact => '전화';

  @override
  String get safetyPlanSetPrimaryAction => '주요로 지정';

  @override
  String get safetyPlanRemoveContact => '삭제';

  @override
  String get resultTitle => '선별 결과';

  @override
  String get resultScore => '점수';

  @override
  String get resultNextStep => '권장 다음 단계';

  @override
  String get guidanceNormal => '현재 위험은 낮아 보입니다. 생활 리듬을 유지하고 필요 시 다시 검사하세요.';

  @override
  String get guidanceMild => '경미한 증상이 있습니다. 수면·활동·대화 등 기본 관리를 권장합니다.';

  @override
  String get guidanceModerate =>
      '중등도 증상이 있어 전문가 상담을 권장합니다. 가까운 시일 내 일정을 잡아보세요.';

  @override
  String get guidanceHighRisk =>
      '고위험 신호가 감지되었습니다. 신뢰할 수 있는 사람과 함께 즉시 전문 도움을 받으세요.';

  @override
  String get selfHarmOverride => '안전 우선 규칙: 자해 관련 문항에 응답이 있어 즉시 도움 권고가 표시됩니다.';

  @override
  String get emergencyTitle => '즉시 안전 확인이 필요합니다';

  @override
  String get emergencyBody => '스스로를 해칠 가능성이 있다면 즉시 응급번호로 연락하거나 가까운 응급실로 이동하세요.';

  @override
  String get mapTitle => '주변 정신건강 진료기관';

  @override
  String get mapSubtitle => '고위험 결과에서는 빠른 실제 진료 연계가 중요합니다.';

  @override
  String get mapNoLocation =>
      'MVP 안내: 실시간 지도 연동은 추후 추가 가능하며, 현재는 주변 기관 카드를 우선 제공합니다.';

  @override
  String get mapUseMyLocation => '내 위치로 검색';

  @override
  String get mapLocating => '위치 확인 및 주변 병원을 검색하고 있습니다...';

  @override
  String get mapRealtimeLoaded => '실시간 주변 병원 정보를 불러왔습니다.';

  @override
  String get mapNoResultFallback => '실시간 결과가 없어 기본 병원 목록을 보여드립니다.';

  @override
  String get mapNetworkFallback => '네트워크 문제로 기본 병원 목록을 보여드립니다.';

  @override
  String get mapPermissionDenied => '위치 권한이 없어 기본 병원 목록을 보여드립니다.';

  @override
  String get mapPermissionDeniedForever =>
      '위치 권한이 영구 거부되었습니다. 시스템 설정에서 허용해주세요.';

  @override
  String get mapUnavailable => '위치 서비스를 사용할 수 없어 기본 병원 목록을 보여드립니다.';

  @override
  String get settingsTitle => '테마/언어 설정';

  @override
  String get settingsTheme => '테마';

  @override
  String get settingsLanguage => '언어';

  @override
  String get themeSystem => '시스템';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get languageSystem => '시스템';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsFallback => '대체 규칙: ko -> en, en -> ko';

  @override
  String get settingsPriority => '우선순위: 수동 설정 > 프로필 > 시스템 > 기본값';

  @override
  String get settingsPersistence => '저장 규칙: 로컬 즉시 저장, 로그인 시 프로필 동기화';

  @override
  String get modulesTitle => '설문 모듈';

  @override
  String get modulePhq2Title => 'PHQ-2';

  @override
  String get modulePhq2Desc => '2차 선별 필요 여부를 판단하는 1단계 빠른 검사입니다.';

  @override
  String get modulePhq9Title => 'PHQ-9 / PHQ-A';

  @override
  String get modulePhq9Desc => '청소년/성인을 위한 2단계 심화 선별입니다.';

  @override
  String get moduleBdiTitle => 'BDI-II';

  @override
  String get moduleBdiDesc => '인지·정서 증상을 더 자세히 다루는 모듈 구조입니다.';

  @override
  String get moduleHadsTitle => 'HADS-D';

  @override
  String get moduleHadsDesc => '의료환경에서 자주 쓰이는 우울 중심 모듈입니다.';

  @override
  String get moduleCesdTitle => 'CES-D';

  @override
  String get moduleCesdDesc => '최근 1주 증상을 중심으로 한 지역사회 선별 모듈입니다.';

  @override
  String get moduleBdiNote => '라이선스 필요: 권한 없이 저작권 문항 원문 전체를 노출하면 안 됩니다.';

  @override
  String get moduleClinicianButton => '임상의 전용 HAM-D / MADRS 열기';

  @override
  String get clinicianTitle => '임상의 전용 모듈';

  @override
  String get clinicianBody =>
      'HAM-D와 MADRS는 임상의 면담 기반입니다. 실제 서비스에서는 자가 선별 사용자에게 숨겨야 합니다.';

  @override
  String get clinicianEmergencyPath => '중증 결과 경로: 응급 지원 + 병원 지도 + 추적 예약 연결.';

  @override
  String get commonMissingAnswer => '모든 문항에 응답한 뒤 계속해주세요.';
}
