import 'package:isar/isar.dart';

part 'safety_plan_record.g.dart';

/// Purpose: Persist singleton personal safety-plan content.
@collection
class SafetyPlanRecord {
  SafetyPlanRecord({this.id = singletonId});

  static const int singletonId = 1;

  Id id;
  String warningSigns = '';
  String copingStrategies = '';
  String reasonsToStaySafe = '';
  String emergencySteps = '';

  @Index()
  late DateTime updatedAt;
}
