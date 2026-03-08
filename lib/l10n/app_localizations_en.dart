// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mind Check';

  @override
  String get notDiagnosis => 'This app is for screening only.';

  @override
  String get homeTitle => 'Let\'s check in on your mood today.';

  @override
  String get homeSubtitle =>
      'A 2-step depression screening flow for ages 13-49.';

  @override
  String get homeStart => 'Start Mild Screen';

  @override
  String get homeSafetyNote =>
      'If safety risk is detected, emergency guidance appears immediately.';

  @override
  String get homeHowItWorksTitle => 'Quick guide for first-time users';

  @override
  String get homeHowItWorksStep1 => 'Start with mild screening (PHQ-2).';

  @override
  String get homeHowItWorksStep2 =>
      'If needed, continue automatically to moderate screening (PHQ-9).';

  @override
  String get homeHowItWorksStep3 =>
      'Based on results, receive daily-care guidance or nearby care options.';

  @override
  String get homeWellnessToolsTitle => 'Daily Support Tools';

  @override
  String get homeDailyCheckInTitle => 'Daily Check-in';

  @override
  String get homeDailyCheckInSubtitle =>
      'Track mood and energy in under a minute.';

  @override
  String get homeDailyCheckInCta => 'Open Check-in';

  @override
  String get homeSafetyPlanTitle => 'Personal Safety Plan';

  @override
  String get homeSafetyPlanSubtitle =>
      'Write your plan and keep trusted contacts ready.';

  @override
  String get homeSafetyPlanCta => 'Open Safety Plan';

  @override
  String get homeBrowseModules => 'Browse Modules';

  @override
  String get homeThemeLanguage => 'Theme & Language';

  @override
  String get splashLoading => 'Loading personalized safety-first experience...';

  @override
  String get onboardingLabel => 'Onboarding';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingTitle1 => 'Welcome to Mind Check';

  @override
  String get onboardingBody1 =>
      'We use a 2-step screening flow to estimate current depression risk.';

  @override
  String get onboardingTitle2 => 'Clear and supportive results';

  @override
  String get onboardingBody2 =>
      'Results are shown as Normal, Mild, Moderate, and High-risk with next-step guidance.';

  @override
  String get onboardingTitle3 => 'Safety-first escalation';

  @override
  String get onboardingBody3 =>
      'If high-risk signals appear, the app immediately offers emergency actions and nearby care.';

  @override
  String get levelNormal => 'Normal';

  @override
  String get levelMild => 'Mild';

  @override
  String get levelModerate => 'Moderate';

  @override
  String get levelHighRisk => 'High-risk';

  @override
  String get phq2Title => 'PHQ-2 Mild Screen';

  @override
  String get phq2FlowTitle => 'Stage 1 quick screening';

  @override
  String get phq2FlowStepLabel => 'Step 1 of 2';

  @override
  String get phq2FlowEstimate => '~1 min';

  @override
  String get phq2FlowDescription =>
      'Based on your responses, you\'ll either see results now or continue to stage 2.';

  @override
  String get phq2Question1 =>
      'Over the last 2 weeks, how often have you felt down, depressed, or hopeless?';

  @override
  String get phq2Question2 =>
      'Over the last 2 weeks, how often have you had little interest or pleasure in doing things?';

  @override
  String get phq9Title => 'PHQ-9 / PHQ-A Moderate Screen';

  @override
  String get phq9FlowTitle => 'Stage 2 detailed screening';

  @override
  String get phq9FlowStepLabel => 'Step 2 of 2';

  @override
  String get phq9FlowEstimate => '~2-3 min';

  @override
  String get phq9FlowDescription =>
      'This stage is recommended from stage 1 responses. Answer all 9 items for tailored guidance.';

  @override
  String get phq9Intro =>
      'Answer all 9 items. If risk is high, we will show urgent support and nearby clinics.';

  @override
  String get phq9Question1 => 'Little interest or pleasure in doing things';

  @override
  String get phq9Question2 => 'Feeling down, depressed, or hopeless';

  @override
  String get phq9Question3 =>
      'Trouble falling or staying asleep, or sleeping too much';

  @override
  String get phq9Question4 => 'Feeling tired or having little energy';

  @override
  String get phq9Question5 => 'Poor appetite or overeating';

  @override
  String get phq9Question6 =>
      'Feeling bad about yourself or feeling like a failure';

  @override
  String get phq9Question7 => 'Trouble concentrating on things';

  @override
  String get phq9Question8 =>
      'Moving or speaking slowly, or being unusually restless';

  @override
  String get phq9Question9 =>
      'Thoughts that you would be better off dead or of hurting yourself';

  @override
  String get answer0 => 'Not at all';

  @override
  String get answer1 => 'Several days';

  @override
  String get answer2 => 'More than half the days';

  @override
  String get answer3 => 'Nearly every day';

  @override
  String get buttonViewResult => 'View Result';

  @override
  String get buttonContinue => 'Continue';

  @override
  String get buttonFindClinics => 'Find Nearby Clinics';

  @override
  String get buttonCallEmergency => 'Call Emergency';

  @override
  String get buttonCallCrisis => 'Contact Crisis Line';

  @override
  String get buttonBackHome => 'Back to Home';

  @override
  String get buttonCallClinic => 'Call Clinic';

  @override
  String get buttonDirections => 'Directions';

  @override
  String get checkInTitle => 'Daily Check-in';

  @override
  String get checkInSubtitle =>
      'This is a daily wellbeing log for screening support.';

  @override
  String get checkInMoodLabel => 'Mood';

  @override
  String get checkInEnergyLabel => 'Energy';

  @override
  String get checkInNoteLabel => 'Short note (optional)';

  @override
  String get checkInSaveButton => 'Save Today';

  @override
  String get checkInWeeklyTrendTitle => '7-day Trend';

  @override
  String get checkInNoTrendData =>
      'No trend data yet. Save your first check-in.';

  @override
  String checkInWeeklyAverage(Object mood, Object energy) {
    return 'Weekly average - Mood $mood, Energy $energy';
  }

  @override
  String get checkInSavedSuccess => 'Check-in saved.';

  @override
  String get checkInSavedFail => 'Unable to save check-in. Try again.';

  @override
  String get checkInMoodShort => 'Mood';

  @override
  String get checkInEnergyShort => 'Energy';

  @override
  String get safetyPlanTitle => 'Safety Plan';

  @override
  String get safetyPlanIntroTitle => 'Keep support steps ready';

  @override
  String get safetyPlanIntroBody =>
      'Save warning signs, calming steps, and trusted contacts so help is easier to reach.';

  @override
  String get safetyPlanEmergencyTitle => 'If you feel unsafe right now';

  @override
  String get safetyPlanEmergencyBody =>
      'Call emergency services, a crisis line, or your primary contact now. Use the steps below only if it is safe to do so.';

  @override
  String get safetyPlanCallPrimary => 'Call Primary Contact';

  @override
  String get safetyPlanWarningSigns => 'My warning signs';

  @override
  String get safetyPlanCoping => 'What helps me calm down';

  @override
  String get safetyPlanReasons => 'Reasons to stay safe';

  @override
  String get safetyPlanEmergencySteps => 'Emergency steps';

  @override
  String get safetyPlanSaveButton => 'Save Safety Plan';

  @override
  String get safetyPlanContactsTitle => 'Trusted Contacts';

  @override
  String get safetyPlanAddContact => 'Add Contact';

  @override
  String get safetyPlanContactsEmpty => 'No trusted contacts yet.';

  @override
  String get safetyPlanSavedSuccess => 'Safety plan saved.';

  @override
  String get safetyPlanSavedFail => 'Unable to save safety plan.';

  @override
  String get safetyPlanCallFailed => 'Call action failed';

  @override
  String get safetyPlanContactName => 'Name';

  @override
  String get safetyPlanContactRelation => 'Relationship';

  @override
  String get safetyPlanContactPhone => 'Phone';

  @override
  String get safetyPlanSetPrimary => 'Set as primary contact';

  @override
  String get safetyPlanContactSaved => 'Trusted contact saved.';

  @override
  String get safetyPlanContactInvalid =>
      'Please check contact inputs and try again.';

  @override
  String get safetyPlanDialogCancel => 'Cancel';

  @override
  String get safetyPlanDialogSave => 'Save';

  @override
  String get safetyPlanCallContact => 'Call';

  @override
  String get safetyPlanSetPrimaryAction => 'Set Primary';

  @override
  String get safetyPlanRemoveContact => 'Remove';

  @override
  String get resultTitle => 'Screening Result';

  @override
  String get resultUnavailableTitle => 'No screening result available';

  @override
  String get resultUnavailableBody =>
      'This screen needs a completed screening result. Start the screening again to see guidance.';

  @override
  String get resultUnavailableStart => 'Start Screening Again';

  @override
  String get resultScore => 'Score';

  @override
  String get resultNextStep => 'Recommended Next Step';

  @override
  String get guidanceNormal =>
      'Current risk appears low. Maintain healthy routines and retake screening if needed.';

  @override
  String get guidanceMild =>
      'Mild symptoms are present. Focus on sleep, activity, and social support.';

  @override
  String get guidanceModerate =>
      'Moderate symptoms are present. Professional consultation is recommended soon.';

  @override
  String get guidanceHighRisk =>
      'High-risk signals detected. Seek support immediately from trusted people and professionals.';

  @override
  String get selfHarmOverride =>
      'Safety override: self-harm item was positive. Immediate help is recommended.';

  @override
  String get emergencyTitle => 'Immediate Safety Check Needed';

  @override
  String get emergencyBody =>
      'If you may harm yourself, call emergency services or go to the nearest ER now.';

  @override
  String get mapTitle => 'Nearby Mental Health Care';

  @override
  String get mapSubtitle =>
      'High-risk results should connect to real care quickly.';

  @override
  String get mapNoLocation =>
      'Allow location to prioritize nearby clinics. Without permission, a fallback list is shown.';

  @override
  String get mapUseMyLocation => 'Use My Location';

  @override
  String get mapRefreshNearby => 'Refresh Nearby Results';

  @override
  String get mapOpenSettings => 'Open System Settings';

  @override
  String get mapOpenSettingsFailed =>
      'Unable to open system settings. Please open them manually and allow location.';

  @override
  String get mapLocating => 'Checking location and searching nearby clinics...';

  @override
  String get mapRealtimeLoaded => 'Real-time nearby clinics loaded.';

  @override
  String get mapNoResultFallback =>
      'No nearby result from network. Showing fallback clinic list.';

  @override
  String get mapNoFilteredResults =>
      'No clinics match the current filters. Try removing a filter.';

  @override
  String get mapNetworkFallback =>
      'Network issue while searching. Showing fallback clinic list.';

  @override
  String get mapPermissionDenied =>
      'Location permission denied. Showing fallback clinic list.';

  @override
  String get mapPermissionDeniedForever =>
      'Location permission permanently denied. Enable it in system settings.';

  @override
  String get mapUnavailable =>
      'Location service unavailable. Showing fallback clinic list.';

  @override
  String get mapDataDisclaimer =>
      'Specialist and operating-hours information may change. Please confirm by phone before visiting.';

  @override
  String get mapModeMapAndList => 'Map + List';

  @override
  String get mapModeListOnly => 'List only';

  @override
  String get mapFilterSpecialistOnly => 'Specialist only';

  @override
  String get mapFilterOpenNow => 'Open now only';

  @override
  String get mapSortDistance => 'Distance';

  @override
  String get mapSortOpenNow => 'Open now first';

  @override
  String get mapSortSpecialist => 'Specialist first';

  @override
  String get mapControlsTitle => 'How to view clinic options';

  @override
  String get mapSpecialistAvailable => 'Specialist available';

  @override
  String get mapSpecialistUnavailable => 'No specialist listed';

  @override
  String get mapSpecialistUnknown => 'Specialist info unavailable';

  @override
  String get mapHoursToday => 'Today hours';

  @override
  String get mapHoursWeekly => 'Weekly hours';

  @override
  String get mapHoursUnavailable => 'Hours unavailable';

  @override
  String get mapOpenNow => 'Open now';

  @override
  String get mapClosedNow => 'Closed now';

  @override
  String get mapOpenStateUnknown => 'Status unknown';

  @override
  String get mapCopyAddress => 'Copy address';

  @override
  String get mapCopyAddressSuccess => 'Address copied.';

  @override
  String get mapAddressUnavailable => 'Address information is unavailable.';

  @override
  String get settingsTitle => 'Theme & Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageSystem => 'System';

  @override
  String get languageKorean => '한국어';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsFallback => 'Fallback: ko -> en, en -> ko';

  @override
  String get settingsPriority =>
      'Priority: manual override > profile > system > default';

  @override
  String get settingsPersistence =>
      'Persistence: save locally immediately, sync to profile when signed in';

  @override
  String get settingsLegal => 'Legal';

  @override
  String get settingsPrivacyPolicyTitle => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Review what the app processes and how it is stored.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicySummary =>
      'This document explains what information the current app implementation processes on your device and through external services.';

  @override
  String get privacyPolicyLastUpdatedLabel => 'Last updated';

  @override
  String get privacyPolicyLastUpdatedValue => '2026-03-08';

  @override
  String get privacyPolicyDataTitle => '1. Information processed';

  @override
  String get privacyPolicyDataBody =>
      'The app may process settings data (theme, language, onboarding state), check-in data (mood, energy, note, timestamp), safety-plan data (warning signs, coping steps, reasons to stay safe, emergency steps), trusted-contact data (name, relationship, phone number, primary status), location data when you search nearby clinics, and technical logs used for error handling.';

  @override
  String get privacyPolicyPurposeTitle => '2. Why the data is used';

  @override
  String get privacyPolicyPurposeBody =>
      'This information is used to provide the screening flow, show result guidance, save check-ins and safety plans, search nearby clinics, launch phone or directions actions, keep theme and language settings, render ads on non-critical screens, and investigate failures.';

  @override
  String get privacyPolicyStorageTitle => '3. Storage and retention';

  @override
  String get privacyPolicyStorageBody =>
      'On mobile and desktop builds, data is stored in the local Isar database. On web builds, data is stored in browser localStorage. The app does not create a default account backend, so most information stays on your device.';

  @override
  String get privacyPolicySharingTitle =>
      '4. External transfers and third parties';

  @override
  String get privacyPolicySharingBody =>
      'When you run nearby-clinic search, your current location and search radius may be sent to the configured Overpass endpoint. If you tap phone or directions actions, control moves to the operating system or another app and that platform\'s policies apply. Screening answers, check-ins, safety plans, and trusted contacts are not uploaded to a default server.';

  @override
  String get privacyPolicyAdsTitle => '5. Ads and external SDKs';

  @override
  String get privacyPolicyAdsBody =>
      'When ads are enabled, Google Mobile Ads SDK may process ad requests. Based on the current repository, no separate user-behavior analytics SDK was found, but advertising providers may still process technical information under their own policies.';

  @override
  String get privacyPolicySecurityTitle => '6. Security';

  @override
  String get privacyPolicySecurityBody =>
      'The app uses structured logging and masking logic to reduce direct exposure of sensitive values. Even so, local data may still be exposed on shared devices, lost devices, or compromised systems.';

  @override
  String get privacyPolicyControlTitle => '7. Your choices';

  @override
  String get privacyPolicyControlBody =>
      'You can deny location permission and the app will fall back to a default clinic list. You can add, remove, or reprioritize trusted contacts in the app. There is currently no dedicated full-data erase flow, so full deletion may require uninstalling the app or clearing browser storage.';

  @override
  String get privacyPolicyContactTitle => '8. Contact and notice';

  @override
  String get privacyPolicyContactBody =>
      'This repository does not currently embed an operator support contact. Before external release, publish a support contact and the latest policy link in your store listing or support page.';

  @override
  String get modulesTitle => 'Instrument Modules';

  @override
  String get modulesIntroTitle => 'Choose a self-screening module';

  @override
  String get modulesIntroBody =>
      'Start with PHQ-2 for a quick first pass, or open PHQ-9 directly when you need deeper screening.';

  @override
  String get modulesRestrictedTitle => 'Restricted and clinician-only content';

  @override
  String get modulesRestrictedBody =>
      'Some tools require clinician interviews or separate licensing, so they are not available in the self-screening flow.';

  @override
  String get modulePhq2Title => 'PHQ-2';

  @override
  String get modulePhq2Desc =>
      'Stage 1 fast screen used to decide whether deeper screening is needed.';

  @override
  String get modulePhq9Title => 'PHQ-9 / PHQ-A';

  @override
  String get modulePhq9Desc =>
      'Stage 2 deeper screen for adolescents and adults.';

  @override
  String get moduleBdiTitle => 'BDI-II';

  @override
  String get moduleBdiDesc =>
      'Detailed instrument structure for mood and cognition.';

  @override
  String get moduleHadsTitle => 'HADS-D';

  @override
  String get moduleHadsDesc =>
      'Depression-focused module often used in medical settings.';

  @override
  String get moduleCesdTitle => 'CES-D';

  @override
  String get moduleCesdDesc =>
      'Community screening focused on recent week symptoms.';

  @override
  String get moduleStartButton => 'Start Module';

  @override
  String get moduleHadsIntro =>
      'Answer all HADS-D items for a depression-focused screening snapshot.';

  @override
  String get moduleCesdIntro =>
      'Answer all CES-D items based on your recent week.';

  @override
  String get moduleBdiIntro =>
      'Answer all BDI-II items. This module should be used with proper rights and governance.';

  @override
  String get moduleBdiInAppNotice =>
      'Notice: BDI-II copyrighted wording must only be shown under valid license.';

  @override
  String get moduleBackToModules => 'Back to Modules';

  @override
  String moduleQuestionLabel(Object module, Object index) {
    return '$module item $index';
  }

  @override
  String get moduleBdiNote =>
      'Licensed content required: do not expose full copyrighted items without rights.';

  @override
  String get moduleClinicianButton => 'View restriction details';

  @override
  String get clinicianTitle => 'Clinician-administered modules';

  @override
  String get clinicianBody =>
      'HAM-D and MADRS depend on clinician interviews and are not available in the self-screening app.';

  @override
  String get clinicianEmergencyPath =>
      'If someone is at immediate risk, use emergency support and nearby clinic guidance instead.';

  @override
  String get clinicianNearbyClinicsAction => 'Open Nearby Clinics';

  @override
  String get clinicianSafetyPlanAction => 'Open Safety Plan';

  @override
  String get commonMissingAnswer =>
      'Please answer all questions before continuing.';
}
