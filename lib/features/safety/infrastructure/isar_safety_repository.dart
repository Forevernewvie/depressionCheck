import 'package:isar/isar.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/safety/data/safety_plan_record.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/data/trusted_contact_record.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Isar-backed implementation of safety-plan repository contracts.
class IsarSafetyRepository implements SafetyRepository {
  IsarSafetyRepository(this._isar, this._logger);

  final Isar _isar;
  final AppLogger _logger;

  @override
  SafetySnapshot readSnapshot() {
    final planRecord = _ensurePlanRecord();
    final contactRecords = _isar.trustedContactRecords
        .where()
        .sortBySortOrder()
        .findAllSync();

    return SafetySnapshot(
      plan: SafetyPlanData(
        warningSigns: planRecord.warningSigns,
        copingStrategies: planRecord.copingStrategies,
        reasonsToStaySafe: planRecord.reasonsToStaySafe,
        emergencySteps: planRecord.emergencySteps,
      ),
      contacts: contactRecords.map(_toContact).toList(growable: false),
    );
  }

  @override
  void savePlan(SafetyPlanData plan) {
    final existing = _ensurePlanRecord();
    existing.warningSigns = plan.warningSigns;
    existing.copingStrategies = plan.copingStrategies;
    existing.reasonsToStaySafe = plan.reasonsToStaySafe;
    existing.emergencySteps = plan.emergencySteps;
    existing.updatedAt = DateTime.now();

    _isar.writeTxnSync(() {
      _isar.safetyPlanRecords.putSync(existing);
    });
  }

  @override
  void upsertContact(TrustedContact contact) {
    _isar.writeTxnSync(() {
      if (contact.isPrimary) {
        final all = _isar.trustedContactRecords.where().findAllSync();
        for (final item in all) {
          if (item.id != contact.id && item.isPrimary) {
            item.isPrimary = false;
            _isar.trustedContactRecords.putSync(item);
          }
        }
      }

      final record = contact.id > 0
          ? (_isar.trustedContactRecords.getSync(contact.id) ??
                TrustedContactRecord())
          : TrustedContactRecord();

      record.name = contact.name;
      record.relation = contact.relation;
      record.phone = contact.phone;
      record.isPrimary = contact.isPrimary;
      record.sortOrder = contact.sortOrder;
      record.updatedAt = DateTime.now();

      _isar.trustedContactRecords.putSync(record);
    });
  }

  @override
  void deleteContact(int id) {
    _isar.writeTxnSync(() {
      _isar.trustedContactRecords.deleteSync(id);
    });
  }

  /// Purpose: Ensure singleton safety-plan document exists.
  SafetyPlanRecord _ensurePlanRecord() {
    final existing = _isar.safetyPlanRecords.getSync(
      SafetyPlanRecord.singletonId,
    );
    if (existing != null) {
      return existing;
    }

    final created = SafetyPlanRecord()..updatedAt = DateTime.now();
    _isar.writeTxnSync(() {
      _isar.safetyPlanRecords.putSync(created);
    });
    _logger.info('Created default safety-plan record.');
    return created;
  }

  /// Purpose: Map trusted contact record to domain model.
  TrustedContact _toContact(TrustedContactRecord record) {
    return TrustedContact(
      id: record.id,
      name: record.name,
      relation: record.relation,
      phone: record.phone,
      isPrimary: record.isPrimary,
      sortOrder: record.sortOrder,
    );
  }
}
