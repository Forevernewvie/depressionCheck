/// Purpose: Represent editable safety-plan sections in domain layer.
class SafetyPlanData {
  const SafetyPlanData({
    this.warningSigns = '',
    this.copingStrategies = '',
    this.reasonsToStaySafe = '',
    this.emergencySteps = '',
  });

  final String warningSigns;
  final String copingStrategies;
  final String reasonsToStaySafe;
  final String emergencySteps;
}
