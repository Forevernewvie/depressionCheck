import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibemental_app/core/logging/logging_providers.dart';
import 'package:vibemental_app/features/instruments/application/module_question_content_service.dart';

/// Purpose: Expose module-question content service through dependency injection.
final moduleQuestionContentServiceProvider =
    Provider<ModuleQuestionContentService>((ref) {
      return ModuleQuestionContentService(ref.watch(appLoggerProvider));
    });
