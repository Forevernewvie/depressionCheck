import 'package:flutter/material.dart';
import 'package:vibemental_app/core/time/clock.dart';
import 'package:vibemental_app/features/map/application/models/nearby_clinic_load_result.dart';
import 'package:vibemental_app/features/map/domain/clinic.dart';
import 'package:vibemental_app/l10n/app_localizations.dart';

/// Purpose: Represent user-visible clinic sort options in a testable form.
enum ClinicSortOption { distance, openNow, specialist }

/// Purpose: Describe the primary action shown in the map load card.
enum MapPrimaryActionKind { useLocation, refresh, openSettings }

/// Purpose: Encapsulate map filtering, sorting, and call-to-action policy away
/// from the widget state class.
class MapPresentationPolicy {
  MapPresentationPolicy(this._clock);

  final Clock _clock;

  /// Purpose: Return the current time through the injected clock abstraction.
  DateTime now() {
    return _clock.now();
  }

  /// Purpose: Apply active filters and sorting rules without mutating source
  /// clinic data.
  List<Clinic> visibleClinics({
    required List<Clinic> clinics,
    required bool specialistOnly,
    required bool openNowOnly,
    required ClinicSortOption sortOption,
  }) {
    final now = _clock.now();
    final filtered = clinics
        .where((clinic) {
          if (specialistOnly &&
              clinic.specialistAvailability !=
                  ClinicSpecialistAvailability.available) {
            return false;
          }

          if (openNowOnly &&
              clinic.resolveOpenState(now) != ClinicOpenState.open) {
            return false;
          }

          return true;
        })
        .toList(growable: false);

    final sorted = List<Clinic>.from(filtered);
    sorted.sort((a, b) {
      return switch (sortOption) {
        ClinicSortOption.distance => a.distanceMeters.compareTo(b.distanceMeters),
        ClinicSortOption.openNow =>
          _openNowSortRank(a, now)
              .compareTo(_openNowSortRank(b, now))
              .thenWith(() => a.distanceMeters.compareTo(b.distanceMeters)),
        ClinicSortOption.specialist =>
          _specialistSortRank(a)
              .compareTo(_specialistSortRank(b))
              .thenWith(() => a.distanceMeters.compareTo(b.distanceMeters)),
      };
    });

    return sorted;
  }

  /// Purpose: Convert current load status into a truthful primary action kind.
  MapPrimaryActionKind primaryActionKind(NearbyClinicStatus? status) {
    return switch (status) {
      NearbyClinicStatus.permissionDeniedForever =>
        MapPrimaryActionKind.openSettings,
      NearbyClinicStatus.realtimeLoaded ||
      NearbyClinicStatus.noResultFallback ||
      NearbyClinicStatus.networkFallback ||
      NearbyClinicStatus.permissionDenied ||
      NearbyClinicStatus.unavailable => MapPrimaryActionKind.refresh,
      null => MapPrimaryActionKind.useLocation,
    };
  }

  /// Purpose: Resolve the load-card body text from normalized view state
  /// without storing localized strings inside controller state.
  String loadCardBodyText({
    required AppLocalizations l10n,
    required bool isLoading,
    required NearbyClinicStatus? status,
  }) {
    if (isLoading) {
      return l10n.mapLocating;
    }

    return switch (status) {
      NearbyClinicStatus.realtimeLoaded => l10n.mapRealtimeLoaded,
      NearbyClinicStatus.noResultFallback => l10n.mapNoResultFallback,
      NearbyClinicStatus.networkFallback => l10n.mapNetworkFallback,
      NearbyClinicStatus.permissionDenied => l10n.mapPermissionDenied,
      NearbyClinicStatus.permissionDeniedForever =>
        l10n.mapPermissionDeniedForever,
      NearbyClinicStatus.unavailable => l10n.mapUnavailable,
      null => l10n.mapNoLocation,
    };
  }

  /// Purpose: Resolve the localized primary button label for the load card.
  String primaryActionLabel(
    AppLocalizations l10n,
    MapPrimaryActionKind actionKind,
  ) {
    return switch (actionKind) {
      MapPrimaryActionKind.useLocation => l10n.mapUseMyLocation,
      MapPrimaryActionKind.refresh => l10n.mapRefreshNearby,
      MapPrimaryActionKind.openSettings => l10n.mapOpenSettings,
    };
  }

  /// Purpose: Resolve the icon that matches the current primary action.
  IconData primaryActionIcon(MapPrimaryActionKind actionKind) {
    return switch (actionKind) {
      MapPrimaryActionKind.useLocation => Icons.my_location,
      MapPrimaryActionKind.refresh => Icons.refresh_rounded,
      MapPrimaryActionKind.openSettings => Icons.settings_outlined,
    };
  }

  /// Purpose: Separate filter-empty messaging from fallback/no-result copy.
  String emptyStateMessage({
    required AppLocalizations l10n,
    required bool hasAnyClinics,
    required bool hasActiveFilters,
  }) {
    if (hasAnyClinics && hasActiveFilters) {
      return l10n.mapNoFilteredResults;
    }
    return l10n.mapNoResultFallback;
  }

  /// Purpose: Rank clinics so open locations appear before closed ones.
  int _openNowSortRank(Clinic clinic, DateTime now) {
    return switch (clinic.resolveOpenState(now)) {
      ClinicOpenState.open => 0,
      ClinicOpenState.unknown => 1,
      ClinicOpenState.closed => 2,
    };
  }

  /// Purpose: Rank clinics so verified specialist availability appears first.
  int _specialistSortRank(Clinic clinic) {
    return switch (clinic.specialistAvailability) {
      ClinicSpecialistAvailability.available => 0,
      ClinicSpecialistAvailability.unknown => 1,
      ClinicSpecialistAvailability.unavailable => 2,
    };
  }
}

extension on int {
  /// Purpose: Provide deterministic comparator chaining for map sort rules.
  int thenWith(int Function() next) {
    if (this != 0) {
      return this;
    }
    return next();
  }
}
