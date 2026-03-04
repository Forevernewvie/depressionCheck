import 'dart:ui';

import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/instruments/domain/module_question_bank.dart';
import 'package:vibemental_app/features/screening/domain/screening_result.dart';

/// Purpose: Resolve validated module questionnaire content with locale fallback.
class ModuleQuestionContentService {
  ModuleQuestionContentService(this._logger);

  final AppLogger _logger;

  /// Purpose: Return sanitized questions and options for a module/locale pair.
  ModuleQuestionContent resolve({
    required ScreeningInstrument instrument,
    required Locale locale,
  }) {
    final questionSet = ModuleQuestionBank.byInstrument(instrument);
    if (questionSet == null) {
      _logger.warn(
        'Question set was missing for module instrument.',
        context: {'instrument': instrument.name},
      );

      return ModuleQuestionContent(
        questions: ModuleQuestionBank.fallbackQuestions(
          languageCode: locale.languageCode,
          expectedCount: ModuleQuestionBank.minimumFallbackQuestionCount,
        ),
        optionLabels: ModuleQuestionBank.defaultOptionLabels(
          locale.languageCode,
        ),
      );
    }

    final normalizedLanguage = _normalizeLanguage(locale);
    final questions = _resolveQuestions(questionSet, normalizedLanguage);
    final optionLabels = _resolveOptionLabels(questionSet, normalizedLanguage);

    return ModuleQuestionContent(
      questions: questions,
      optionLabels: optionLabels,
    );
  }

  /// Purpose: Select and sanitize question list with explicit fallback behavior.
  List<String> _resolveQuestions(
    ModuleQuestionSet questionSet,
    String languageCode,
  ) {
    final rawQuestions =
        questionSet.questionsByLanguage[languageCode] ??
        questionSet.questionsByLanguage[ModuleQuestionBank.languageEn];

    if (rawQuestions == null || rawQuestions.isEmpty) {
      _logger.warn(
        'Questions were empty for module; fallback questions applied.',
        context: {
          'instrument': questionSet.instrument.name,
          'language': languageCode,
        },
      );
      return ModuleQuestionBank.fallbackQuestions(
        languageCode: languageCode,
        expectedCount: questionSet.expectedQuestionCount,
      );
    }

    final sanitized = rawQuestions
        .map((question) => question.trim())
        .where((question) => question.isNotEmpty)
        .toList(growable: false);

    if (sanitized.length == questionSet.expectedQuestionCount) {
      return sanitized;
    }

    _logger.warn(
      'Question count mismatch detected; normalized to expected count.',
      context: {
        'instrument': questionSet.instrument.name,
        'language': languageCode,
        'actual_count': sanitized.length,
        'expected_count': questionSet.expectedQuestionCount,
      },
    );

    final fallback = ModuleQuestionBank.fallbackQuestions(
      languageCode: languageCode,
      expectedCount: questionSet.expectedQuestionCount,
    );

    final normalized = <String>[];
    for (int index = 0; index < questionSet.expectedQuestionCount; index++) {
      if (index < sanitized.length) {
        normalized.add(sanitized[index]);
      } else {
        normalized.add(fallback[index]);
      }
    }

    return normalized;
  }

  /// Purpose: Return complete Likert labels and replace missing entries safely.
  Map<int, String> _resolveOptionLabels(
    ModuleQuestionSet questionSet,
    String languageCode,
  ) {
    final raw =
        questionSet.optionLabelsByLanguage[languageCode] ??
        questionSet.optionLabelsByLanguage[ModuleQuestionBank.languageEn];

    if (ModuleQuestionBank.isValidOptionMap(raw)) {
      return raw!;
    }

    _logger.warn(
      'Option labels were incomplete; default labels applied.',
      context: {
        'instrument': questionSet.instrument.name,
        'language': languageCode,
      },
    );

    return ModuleQuestionBank.defaultOptionLabels(languageCode);
  }

  /// Purpose: Normalize locale to supported language codes.
  String _normalizeLanguage(Locale locale) {
    final normalized = locale.languageCode.toLowerCase();
    if (normalized.startsWith(ModuleQuestionBank.languageKo)) {
      return ModuleQuestionBank.languageKo;
    }
    return ModuleQuestionBank.languageEn;
  }
}

/// Purpose: Transport ready-to-render question and option content.
class ModuleQuestionContent {
  const ModuleQuestionContent({
    required this.questions,
    required this.optionLabels,
  });

  final List<String> questions;
  final Map<int, String> optionLabels;
}
