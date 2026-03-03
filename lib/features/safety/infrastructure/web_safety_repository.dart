// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

import 'package:vibemental_app/core/config/web_storage_keys.dart';
import 'package:vibemental_app/core/logging/app_logger.dart';
import 'package:vibemental_app/features/safety/data/safety_repository.dart';
import 'package:vibemental_app/features/safety/domain/safety_plan_data.dart';
import 'package:vibemental_app/features/safety/domain/safety_validators.dart';
import 'package:vibemental_app/features/safety/domain/trusted_contact.dart';

/// Purpose: Store safety plan and contacts in browser local storage for web.
class WebSafetyRepository implements SafetyRepository {
  WebSafetyRepository(this._logger);

  final AppLogger _logger;

  @override
  /// Purpose: Read and map plan plus contacts in one consistent snapshot.
  SafetySnapshot readSnapshot() {
    final planPayload = _readMap(WebStorageKeys.safetyPlan);
    final contactsPayload = _readList(WebStorageKeys.safetyContacts);

    final contacts =
        contactsPayload
            .map(_tryParseContact)
            .whereType<TrustedContact>()
            .toList(growable: false)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return SafetySnapshot(
      plan: SafetyPlanData(
        warningSigns: (planPayload[_SafetyField.warningSigns] as String?) ?? '',
        copingStrategies:
            (planPayload[_SafetyField.copingStrategies] as String?) ?? '',
        reasonsToStaySafe:
            (planPayload[_SafetyField.reasonsToStaySafe] as String?) ?? '',
        emergencySteps:
            (planPayload[_SafetyField.emergencySteps] as String?) ?? '',
      ),
      contacts: contacts,
    );
  }

  @override
  /// Purpose: Save normalized safety-plan sections in one atomic write.
  void savePlan(SafetyPlanData plan) {
    final payload = <String, Object>{
      _SafetyField.warningSigns: normalizeSafetySection(plan.warningSigns),
      _SafetyField.copingStrategies: normalizeSafetySection(
        plan.copingStrategies,
      ),
      _SafetyField.reasonsToStaySafe: normalizeSafetySection(
        plan.reasonsToStaySafe,
      ),
      _SafetyField.emergencySteps: normalizeSafetySection(plan.emergencySteps),
    };
    _writeJson(WebStorageKeys.safetyPlan, payload);
  }

  @override
  /// Purpose: Upsert one trusted contact and enforce a single primary contact.
  void upsertContact(TrustedContact contact) {
    final contacts = _readList(
      WebStorageKeys.safetyContacts,
    ).map(_tryParseContact).whereType<TrustedContact>().toList(growable: true);

    final nextContact = _normalizeContact(contact);
    final nextId = nextContact.id > 0 ? nextContact.id : _nextContactId();

    final updated = TrustedContact(
      id: nextId,
      name: nextContact.name,
      relation: nextContact.relation,
      phone: nextContact.phone,
      isPrimary: nextContact.isPrimary,
      sortOrder: nextContact.sortOrder,
    );

    final existingIndex = contacts.indexWhere((item) => item.id == nextId);
    if (existingIndex >= 0) {
      contacts[existingIndex] = updated;
    } else {
      contacts.add(updated);
    }

    if (updated.isPrimary) {
      for (var index = 0; index < contacts.length; index += 1) {
        final item = contacts[index];
        if (item.id == updated.id) {
          continue;
        }
        if (!item.isPrimary) {
          continue;
        }
        contacts[index] = TrustedContact(
          id: item.id,
          name: item.name,
          relation: item.relation,
          phone: item.phone,
          isPrimary: false,
          sortOrder: item.sortOrder,
        );
      }
    }

    final limited = contacts.toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    _writeJson(
      WebStorageKeys.safetyContacts,
      limited.map(_toPayload).toList(growable: false),
    );
  }

  @override
  /// Purpose: Delete one contact by id and persist resulting ordered list.
  void deleteContact(int id) {
    final contacts =
        _readList(WebStorageKeys.safetyContacts)
            .map(_tryParseContact)
            .whereType<TrustedContact>()
            .where((item) => item.id != id)
            .toList(growable: false)
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    _writeJson(
      WebStorageKeys.safetyContacts,
      contacts.map(_toPayload).toList(growable: false),
    );
  }

  /// Purpose: Normalize contact values and guard invalid phone/name payloads.
  TrustedContact _normalizeContact(TrustedContact contact) {
    final sanitizedPhone = normalizeContactPhone(contact.phone);
    if (!isValidContactName(contact.name) ||
        !isValidContactRelation(contact.relation) ||
        !isValidContactPhone(sanitizedPhone)) {
      _logger.warn(
        'Rejected invalid trusted contact payload for web persistence.',
        context: {'contactId': contact.id},
      );
      return TrustedContact(
        id: contact.id,
        name: contact.name.trim(),
        relation: contact.relation.trim(),
        phone: sanitizedPhone,
        isPrimary: contact.isPrimary,
        sortOrder: contact.sortOrder,
      );
    }

    return TrustedContact(
      id: contact.id,
      name: contact.name.trim(),
      relation: contact.relation.trim(),
      phone: sanitizedPhone,
      isPrimary: contact.isPrimary,
      sortOrder: contact.sortOrder,
    );
  }

  /// Purpose: Parse one serialized contact payload into domain model safely.
  TrustedContact? _tryParseContact(Object? raw) {
    if (raw is! Map<String, dynamic>) {
      return null;
    }

    final id = raw[_SafetyField.id] as int?;
    final name = raw[_SafetyField.name] as String?;
    final relation = raw[_SafetyField.relation] as String?;
    final phone = raw[_SafetyField.phone] as String?;
    final isPrimary = raw[_SafetyField.isPrimary] as bool?;
    final sortOrder = raw[_SafetyField.sortOrder] as int?;
    if (id == null ||
        name == null ||
        relation == null ||
        phone == null ||
        isPrimary == null ||
        sortOrder == null) {
      return null;
    }

    return TrustedContact(
      id: id,
      name: name,
      relation: relation,
      phone: phone,
      isPrimary: isPrimary,
      sortOrder: sortOrder,
    );
  }

  /// Purpose: Serialize domain contact to storage-friendly JSON payload.
  Map<String, Object> _toPayload(TrustedContact contact) {
    return <String, Object>{
      _SafetyField.id: contact.id,
      _SafetyField.name: contact.name,
      _SafetyField.relation: contact.relation,
      _SafetyField.phone: contact.phone,
      _SafetyField.isPrimary: contact.isPrimary,
      _SafetyField.sortOrder: contact.sortOrder,
    };
  }

  /// Purpose: Read one JSON object safely from local storage.
  Map<String, dynamic> _readMap(String key) {
    final raw = html.window.localStorage[key];
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to parse web safety map payload.',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return <String, dynamic>{};
  }

  /// Purpose: Read one JSON list safely from local storage.
  List<Object?> _readList(String key) {
    final raw = html.window.localStorage[key];
    if (raw == null || raw.isEmpty) {
      return <Object?>[];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List<dynamic>) {
        return decoded;
      }
    } catch (error, stackTrace) {
      _logger.error(
        'Failed to parse web safety list payload.',
        error: error,
        stackTrace: stackTrace,
      );
    }
    return <Object?>[];
  }

  /// Purpose: Persist JSON payload to local storage safely.
  void _writeJson(String key, Object payload) {
    html.window.localStorage[key] = jsonEncode(payload);
  }

  /// Purpose: Allocate deterministic next id for new web trusted contacts.
  int _nextContactId() {
    final raw = html.window.localStorage[WebStorageKeys.safetyNextContactId];
    final current = int.tryParse(raw ?? '') ?? 1;
    final next = current + 1;
    html.window.localStorage[WebStorageKeys.safetyNextContactId] = '$next';
    return current;
  }
}

/// Purpose: Centralize serialized field names for safety web payloads.
abstract final class _SafetyField {
  static const String id = 'id';
  static const String name = 'name';
  static const String relation = 'relation';
  static const String phone = 'phone';
  static const String isPrimary = 'is_primary';
  static const String sortOrder = 'sort_order';
  static const String warningSigns = 'warning_signs';
  static const String copingStrategies = 'coping_strategies';
  static const String reasonsToStaySafe = 'reasons_to_stay_safe';
  static const String emergencySteps = 'emergency_steps';
}
