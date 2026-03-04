import 'package:vibemental_app/core/config/instrument_module_config.dart';
import 'package:vibemental_app/core/config/screening_thresholds.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

/// Purpose: Hold typed questionnaire content for non-PHQ screening modules.
class ModuleQuestionBank {
  ModuleQuestionBank._();

  static const String languageKo = 'ko';
  static const String languageEn = 'en';
  static const int minimumFallbackQuestionCount = 1;

  static const Map<int, String> _defaultOptionLabelsKo = {
    0: '전혀 없음',
    1: '가끔 있음',
    2: '자주 있음',
    3: '거의 항상 있음',
  };

  static const Map<int, String> _defaultOptionLabelsEn = {
    0: 'Not at all',
    1: 'Sometimes',
    2: 'Often',
    3: 'Almost always',
  };

  static const Map<ScreeningInstrument, ModuleQuestionSet> _questionSets = {
    ScreeningInstrument.hadsD: ModuleQuestionSet(
      instrument: ScreeningInstrument.hadsD,
      expectedQuestionCount: InstrumentModuleConfig.hadsDQuestionCount,
      questionsByLanguage: {
        languageKo: [
          '최근에 차분하게 쉬기 어렵다고 느꼈다.',
          '예전처럼 즐거운 일을 기대하기 어려웠다.',
          '일상 속에서 기운이 쉽게 떨어졌다.',
          '작은 일에도 걱정이 오래 남았다.',
          '평소보다 웃거나 미소 짓는 순간이 줄었다.',
          '하루를 시작할 때 의욕이 낮다고 느꼈다.',
          '최근의 기분 상태가 전반적으로 가라앉아 있었다.',
        ],
        languageEn: [
          'I found it hard to relax and feel calm recently.',
          'I struggled to look forward to enjoyable activities.',
          'My energy dropped easily during daily life.',
          'Small worries stayed with me longer than usual.',
          'I smiled or laughed less than usual.',
          'I felt low motivation at the start of my day.',
          'My overall mood felt down over the recent period.',
        ],
      },
      optionLabelsByLanguage: {
        languageKo: _defaultOptionLabelsKo,
        languageEn: _defaultOptionLabelsEn,
      },
    ),
    ScreeningInstrument.cesD: ModuleQuestionSet(
      instrument: ScreeningInstrument.cesD,
      expectedQuestionCount: InstrumentModuleConfig.cesDQuestionCount,
      questionsByLanguage: {
        languageKo: [
          '지난 일주일 동안 잠들기 어렵거나 수면의 질이 떨어졌다.',
          '평소 하던 일에 집중하기 어려웠다.',
          '사소한 일에도 쉽게 지치거나 피곤했다.',
          '식사 패턴(식욕 저하/과식)이 평소와 달랐다.',
          '사람들과의 대화나 만남이 부담스럽게 느껴졌다.',
          '나 자신을 부정적으로 평가하는 순간이 늘었다.',
          '평소 좋아하던 활동이 덜 즐겁게 느껴졌다.',
          '기분이 가라앉아 하루를 버티기 어렵다고 느꼈다.',
          '이유 없이 불안하거나 초조한 순간이 있었다.',
          '최근 일상을 유지하는 데 추가적인 노력이 필요했다.',
        ],
        languageEn: [
          'Over the past week, I had trouble sleeping or poor sleep quality.',
          'I found it hard to concentrate on usual tasks.',
          'I felt tired or drained even with small activities.',
          'My eating pattern changed from usual (less appetite or overeating).',
          'Conversations or social contact felt more difficult than usual.',
          'I had more self-critical thoughts than usual.',
          'Activities I usually enjoy felt less rewarding.',
          'Low mood made daily routine feel harder to maintain.',
          'I experienced moments of anxiety or restlessness without clear reason.',
          'I needed extra effort to keep up with regular daily life.',
        ],
      },
      optionLabelsByLanguage: {
        languageKo: _defaultOptionLabelsKo,
        languageEn: _defaultOptionLabelsEn,
      },
    ),
    ScreeningInstrument.bdi2: ModuleQuestionSet(
      instrument: ScreeningInstrument.bdi2,
      expectedQuestionCount: InstrumentModuleConfig.bdi2QuestionCount,
      questionsByLanguage: {
        languageKo: [
          '최근에 슬픔이나 공허감이 자주 느껴졌다.',
          '미래에 대한 기대가 줄었다고 느꼈다.',
          '예전보다 실패감이나 좌절감이 커졌다.',
          '평소 하던 일에서 만족감을 얻기 어려웠다.',
          '죄책감이나 자책이 반복되었다.',
          '스스로를 실망스럽게 평가하는 경우가 늘었다.',
          '결정 내리기가 평소보다 어려웠다.',
          '외모나 자기 이미지에 대한 부정적 생각이 증가했다.',
          '평소보다 행동이나 말이 느려졌다고 느꼈다.',
          '안절부절못하거나 긴장된 상태가 지속되었다.',
          '기운이 부족해 시작 자체가 어려운 일이 늘었다.',
          '수면 시간 또는 수면의 질이 불안정했다.',
          '쉽게 피로해져 회복이 더뎠다.',
          '식욕이 감소하거나 반대로 과식하는 날이 있었다.',
          '건강 상태를 과도하게 걱정하는 경향이 있었다.',
          '성취감 없이 하루를 보내는 느낌이 들었다.',
          '일상에서 집중력이 떨어진다고 느꼈다.',
          '타인과의 거리감이 커졌다고 느꼈다.',
          '쉽게 짜증이 나거나 감정 기복이 커졌다.',
          '평소보다 의사소통이 부담스럽게 느껴졌다.',
          '최근 나를 돌보는 행동(식사/휴식/위생)이 줄었다.',
        ],
        languageEn: [
          'I often felt sadness or emotional emptiness recently.',
          'My sense of hope about the future felt lower than usual.',
          'Feelings of failure or discouragement became stronger.',
          'I found less satisfaction in things I usually do.',
          'I experienced repeated guilt or self-blame.',
          'I judged myself more negatively than usual.',
          'Making decisions felt harder than before.',
          'Negative thoughts about my appearance or self-image increased.',
          'My movement or speech felt slower than usual.',
          'I felt restless or tense for longer periods.',
          'Low energy made it harder to begin tasks.',
          'My sleep schedule or quality became less stable.',
          'I tired easily and recovered more slowly.',
          'My appetite changed noticeably (less appetite or overeating).',
          'I worried about my health more than usual.',
          'I felt my days lacked a sense of accomplishment.',
          'My concentration in daily tasks felt weaker.',
          'I felt more distant from other people.',
          'I noticed stronger irritability or mood swings.',
          'Communication felt more burdensome than usual.',
          'Self-care routines (meals, rest, hygiene) decreased recently.',
        ],
      },
      optionLabelsByLanguage: {
        languageKo: _defaultOptionLabelsKo,
        languageEn: _defaultOptionLabelsEn,
      },
    ),
  };

  /// Purpose: Return typed question set for a given module instrument.
  static ModuleQuestionSet? byInstrument(ScreeningInstrument instrument) {
    return _questionSets[instrument];
  }

  /// Purpose: Generate non-empty localized fallback questions for defensive UI rendering.
  static List<String> fallbackQuestions({
    required String languageCode,
    required int expectedCount,
  }) {
    final normalized = _normalizeLanguage(languageCode);
    if (normalized == languageKo) {
      return List<String>.generate(
        expectedCount,
        (index) => '모듈 선별 문항 ${index + 1}',
        growable: false,
      );
    }

    return List<String>.generate(
      expectedCount,
      (index) => 'Module screening item ${index + 1}',
      growable: false,
    );
  }

  /// Purpose: Return default localized option labels for Likert selections.
  static Map<int, String> defaultOptionLabels(String languageCode) {
    final normalized = _normalizeLanguage(languageCode);
    return normalized == languageKo
        ? _defaultOptionLabelsKo
        : _defaultOptionLabelsEn;
  }

  /// Purpose: Validate that an option map contains all Likert labels.
  static bool isValidOptionMap(Map<int, String>? options) {
    if (options == null) {
      return false;
    }

    for (
      int value = ScreeningThresholds.likertMin;
      value <= ScreeningThresholds.likertMax;
      value++
    ) {
      final label = options[value];
      if (label == null || label.trim().isEmpty) {
        return false;
      }
    }

    return true;
  }

  /// Purpose: Normalize language selection to supported locale keys.
  static String _normalizeLanguage(String languageCode) {
    return languageCode.toLowerCase().startsWith(languageKo)
        ? languageKo
        : languageEn;
  }
}

/// Purpose: Represent localized module questionnaire content with expected bounds.
class ModuleQuestionSet {
  const ModuleQuestionSet({
    required this.instrument,
    required this.expectedQuestionCount,
    required this.questionsByLanguage,
    required this.optionLabelsByLanguage,
  });

  final ScreeningInstrument instrument;
  final int expectedQuestionCount;
  final Map<String, List<String>> questionsByLanguage;
  final Map<String, Map<int, String>> optionLabelsByLanguage;
}
