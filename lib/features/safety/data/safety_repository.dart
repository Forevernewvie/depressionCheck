import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Carry safety-plan and contacts in one read operation.
class SafetySnapshot {
  const SafetySnapshot({required this.plan, required this.contacts});

  final SafetyPlanData plan;
  final List<TrustedContact> contacts;
}

/// Purpose: Define safety-plan persistence contract independent of storage.
abstract class SafetyRepository {
  /// Purpose: Read full snapshot for safety-plan screen rendering.
  SafetySnapshot readSnapshot();

  /// Purpose: Save entire safety-plan sections as one transaction.
  void savePlan(SafetyPlanData plan);

  /// Purpose: Upsert trusted contact.
  void upsertContact(TrustedContact contact);

  /// Purpose: Delete trusted contact by id.
  void deleteContact(int id);
}
