import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mind Check'**
  String get appTitle;

  /// No description provided for @notDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'This app is for screening only.'**
  String get notDiagnosis;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s check in on your mood today.'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A 2-step depression screening flow for ages 13-49.'**
  String get homeSubtitle;

  /// No description provided for @homeStart.
  ///
  /// In en, this message translates to:
  /// **'Start Mild Screen'**
  String get homeStart;

  /// No description provided for @homeSafetyNote.
  ///
  /// In en, this message translates to:
  /// **'If safety risk is detected, emergency guidance appears immediately.'**
  String get homeSafetyNote;

  /// No description provided for @homeHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick guide for first-time users'**
  String get homeHowItWorksTitle;

  /// No description provided for @homeHowItWorksStep1.
  ///
  /// In en, this message translates to:
  /// **'Start with mild screening (PHQ-2).'**
  String get homeHowItWorksStep1;

  /// No description provided for @homeHowItWorksStep2.
  ///
  /// In en, this message translates to:
  /// **'If needed, continue automatically to moderate screening (PHQ-9).'**
  String get homeHowItWorksStep2;

  /// No description provided for @homeHowItWorksStep3.
  ///
  /// In en, this message translates to:
  /// **'Based on results, receive daily-care guidance or nearby care options.'**
  String get homeHowItWorksStep3;

  /// No description provided for @homeWellnessToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Support Tools'**
  String get homeWellnessToolsTitle;

  /// No description provided for @homeDailyCheckInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get homeDailyCheckInTitle;

  /// No description provided for @homeDailyCheckInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track mood and energy in under a minute.'**
  String get homeDailyCheckInSubtitle;

  /// No description provided for @homeDailyCheckInCta.
  ///
  /// In en, this message translates to:
  /// **'Open Check-in'**
  String get homeDailyCheckInCta;

  /// No description provided for @homeSafetyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Safety Plan'**
  String get homeSafetyPlanTitle;

  /// No description provided for @homeSafetyPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write your plan and keep trusted contacts ready.'**
  String get homeSafetyPlanSubtitle;

  /// No description provided for @homeSafetyPlanCta.
  ///
  /// In en, this message translates to:
  /// **'Open Safety Plan'**
  String get homeSafetyPlanCta;

  /// No description provided for @homeBrowseModules.
  ///
  /// In en, this message translates to:
  /// **'Browse Modules'**
  String get homeBrowseModules;

  /// No description provided for @homeThemeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Theme & Language'**
  String get homeThemeLanguage;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading personalized safety-first experience...'**
  String get splashLoading;

  /// No description provided for @onboardingLabel.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get onboardingLabel;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mind Check'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'We use a 2-step screening flow to estimate current depression risk.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Clear and supportive results'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Results are shown as Normal, Mild, Moderate, and High-risk with next-step guidance.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Safety-first escalation'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'If high-risk signals appear, the app immediately offers emergency actions and nearby care.'**
  String get onboardingBody3;

  /// No description provided for @levelNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get levelNormal;

  /// No description provided for @levelMild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get levelMild;

  /// No description provided for @levelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get levelModerate;

  /// No description provided for @levelHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High-risk'**
  String get levelHighRisk;

  /// No description provided for @phq2Title.
  ///
  /// In en, this message translates to:
  /// **'PHQ-2 Mild Screen'**
  String get phq2Title;

  /// No description provided for @phq2FlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage 1 quick screening'**
  String get phq2FlowTitle;

  /// No description provided for @phq2FlowStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2'**
  String get phq2FlowStepLabel;

  /// No description provided for @phq2FlowEstimate.
  ///
  /// In en, this message translates to:
  /// **'~1 min'**
  String get phq2FlowEstimate;

  /// No description provided for @phq2FlowDescription.
  ///
  /// In en, this message translates to:
  /// **'Based on your responses, you\'ll either see results now or continue to stage 2.'**
  String get phq2FlowDescription;

  /// No description provided for @phq2Question1.
  ///
  /// In en, this message translates to:
  /// **'Over the last 2 weeks, how often have you felt down, depressed, or hopeless?'**
  String get phq2Question1;

  /// No description provided for @phq2Question2.
  ///
  /// In en, this message translates to:
  /// **'Over the last 2 weeks, how often have you had little interest or pleasure in doing things?'**
  String get phq2Question2;

  /// No description provided for @phq9Title.
  ///
  /// In en, this message translates to:
  /// **'PHQ-9 / PHQ-A Moderate Screen'**
  String get phq9Title;

  /// No description provided for @phq9FlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Stage 2 detailed screening'**
  String get phq9FlowTitle;

  /// No description provided for @phq9FlowStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step 2 of 2'**
  String get phq9FlowStepLabel;

  /// No description provided for @phq9FlowEstimate.
  ///
  /// In en, this message translates to:
  /// **'~2-3 min'**
  String get phq9FlowEstimate;

  /// No description provided for @phq9FlowDescription.
  ///
  /// In en, this message translates to:
  /// **'This stage is recommended from stage 1 responses. Answer all 9 items for tailored guidance.'**
  String get phq9FlowDescription;

  /// No description provided for @phq9Intro.
  ///
  /// In en, this message translates to:
  /// **'Answer all 9 items. If risk is high, we will show urgent support and nearby clinics.'**
  String get phq9Intro;

  /// No description provided for @phq9Question1.
  ///
  /// In en, this message translates to:
  /// **'Little interest or pleasure in doing things'**
  String get phq9Question1;

  /// No description provided for @phq9Question2.
  ///
  /// In en, this message translates to:
  /// **'Feeling down, depressed, or hopeless'**
  String get phq9Question2;

  /// No description provided for @phq9Question3.
  ///
  /// In en, this message translates to:
  /// **'Trouble falling or staying asleep, or sleeping too much'**
  String get phq9Question3;

  /// No description provided for @phq9Question4.
  ///
  /// In en, this message translates to:
  /// **'Feeling tired or having little energy'**
  String get phq9Question4;

  /// No description provided for @phq9Question5.
  ///
  /// In en, this message translates to:
  /// **'Poor appetite or overeating'**
  String get phq9Question5;

  /// No description provided for @phq9Question6.
  ///
  /// In en, this message translates to:
  /// **'Feeling bad about yourself or feeling like a failure'**
  String get phq9Question6;

  /// No description provided for @phq9Question7.
  ///
  /// In en, this message translates to:
  /// **'Trouble concentrating on things'**
  String get phq9Question7;

  /// No description provided for @phq9Question8.
  ///
  /// In en, this message translates to:
  /// **'Moving or speaking slowly, or being unusually restless'**
  String get phq9Question8;

  /// No description provided for @phq9Question9.
  ///
  /// In en, this message translates to:
  /// **'Thoughts that you would be better off dead or of hurting yourself'**
  String get phq9Question9;

  /// No description provided for @answer0.
  ///
  /// In en, this message translates to:
  /// **'Not at all'**
  String get answer0;

  /// No description provided for @answer1.
  ///
  /// In en, this message translates to:
  /// **'Several days'**
  String get answer1;

  /// No description provided for @answer2.
  ///
  /// In en, this message translates to:
  /// **'More than half the days'**
  String get answer2;

  /// No description provided for @answer3.
  ///
  /// In en, this message translates to:
  /// **'Nearly every day'**
  String get answer3;

  /// No description provided for @buttonViewResult.
  ///
  /// In en, this message translates to:
  /// **'View Result'**
  String get buttonViewResult;

  /// No description provided for @buttonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get buttonContinue;

  /// No description provided for @buttonFindClinics.
  ///
  /// In en, this message translates to:
  /// **'Find Nearby Clinics'**
  String get buttonFindClinics;

  /// No description provided for @buttonCallEmergency.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency'**
  String get buttonCallEmergency;

  /// No description provided for @buttonCallCrisis.
  ///
  /// In en, this message translates to:
  /// **'Contact Crisis Line'**
  String get buttonCallCrisis;

  /// No description provided for @buttonBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get buttonBackHome;

  /// No description provided for @buttonCallClinic.
  ///
  /// In en, this message translates to:
  /// **'Call Clinic'**
  String get buttonCallClinic;

  /// No description provided for @buttonDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get buttonDirections;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Check-in'**
  String get checkInTitle;

  /// No description provided for @checkInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This is a daily wellbeing log for screening support.'**
  String get checkInSubtitle;

  /// No description provided for @checkInMoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get checkInMoodLabel;

  /// No description provided for @checkInEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get checkInEnergyLabel;

  /// No description provided for @checkInNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Short note (optional)'**
  String get checkInNoteLabel;

  /// No description provided for @checkInSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Today'**
  String get checkInSaveButton;

  /// No description provided for @checkInWeeklyTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'7-day Trend'**
  String get checkInWeeklyTrendTitle;

  /// No description provided for @checkInNoTrendData.
  ///
  /// In en, this message translates to:
  /// **'No trend data yet. Save your first check-in.'**
  String get checkInNoTrendData;

  /// No description provided for @checkInWeeklyAverage.
  ///
  /// In en, this message translates to:
  /// **'Weekly average - Mood {mood}, Energy {energy}'**
  String checkInWeeklyAverage(Object mood, Object energy);

  /// No description provided for @checkInSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in saved.'**
  String get checkInSavedSuccess;

  /// No description provided for @checkInSavedFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to save check-in. Try again.'**
  String get checkInSavedFail;

  /// No description provided for @checkInMoodShort.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get checkInMoodShort;

  /// No description provided for @checkInEnergyShort.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get checkInEnergyShort;

  /// No description provided for @safetyPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Plan'**
  String get safetyPlanTitle;

  /// No description provided for @safetyPlanIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep support steps ready'**
  String get safetyPlanIntroTitle;

  /// No description provided for @safetyPlanIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Save warning signs, calming steps, and trusted contacts so help is easier to reach.'**
  String get safetyPlanIntroBody;

  /// No description provided for @safetyPlanEmergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'If you feel unsafe right now'**
  String get safetyPlanEmergencyTitle;

  /// No description provided for @safetyPlanCallPrimary.
  ///
  /// In en, this message translates to:
  /// **'Call Primary Contact'**
  String get safetyPlanCallPrimary;

  /// No description provided for @safetyPlanWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'My warning signs'**
  String get safetyPlanWarningSigns;

  /// No description provided for @safetyPlanCoping.
  ///
  /// In en, this message translates to:
  /// **'What helps me calm down'**
  String get safetyPlanCoping;

  /// No description provided for @safetyPlanReasons.
  ///
  /// In en, this message translates to:
  /// **'Reasons to stay safe'**
  String get safetyPlanReasons;

  /// No description provided for @safetyPlanEmergencySteps.
  ///
  /// In en, this message translates to:
  /// **'Emergency steps'**
  String get safetyPlanEmergencySteps;

  /// No description provided for @safetyPlanSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Safety Plan'**
  String get safetyPlanSaveButton;

  /// No description provided for @safetyPlanContactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trusted Contacts'**
  String get safetyPlanContactsTitle;

  /// No description provided for @safetyPlanAddContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get safetyPlanAddContact;

  /// No description provided for @safetyPlanContactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No trusted contacts yet.'**
  String get safetyPlanContactsEmpty;

  /// No description provided for @safetyPlanSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Safety plan saved.'**
  String get safetyPlanSavedSuccess;

  /// No description provided for @safetyPlanSavedFail.
  ///
  /// In en, this message translates to:
  /// **'Unable to save safety plan.'**
  String get safetyPlanSavedFail;

  /// No description provided for @safetyPlanCallFailed.
  ///
  /// In en, this message translates to:
  /// **'Call action failed'**
  String get safetyPlanCallFailed;

  /// No description provided for @safetyPlanContactName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get safetyPlanContactName;

  /// No description provided for @safetyPlanContactRelation.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get safetyPlanContactRelation;

  /// No description provided for @safetyPlanContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get safetyPlanContactPhone;

  /// No description provided for @safetyPlanSetPrimary.
  ///
  /// In en, this message translates to:
  /// **'Set as primary contact'**
  String get safetyPlanSetPrimary;

  /// No description provided for @safetyPlanContactSaved.
  ///
  /// In en, this message translates to:
  /// **'Trusted contact saved.'**
  String get safetyPlanContactSaved;

  /// No description provided for @safetyPlanContactInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please check contact inputs and try again.'**
  String get safetyPlanContactInvalid;

  /// No description provided for @safetyPlanDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get safetyPlanDialogCancel;

  /// No description provided for @safetyPlanDialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get safetyPlanDialogSave;

  /// No description provided for @safetyPlanCallContact.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get safetyPlanCallContact;

  /// No description provided for @safetyPlanSetPrimaryAction.
  ///
  /// In en, this message translates to:
  /// **'Set Primary'**
  String get safetyPlanSetPrimaryAction;

  /// No description provided for @safetyPlanRemoveContact.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get safetyPlanRemoveContact;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Screening Result'**
  String get resultTitle;

  /// No description provided for @resultScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get resultScore;

  /// No description provided for @resultNextStep.
  ///
  /// In en, this message translates to:
  /// **'Recommended Next Step'**
  String get resultNextStep;

  /// No description provided for @guidanceNormal.
  ///
  /// In en, this message translates to:
  /// **'Current risk appears low. Maintain healthy routines and retake screening if needed.'**
  String get guidanceNormal;

  /// No description provided for @guidanceMild.
  ///
  /// In en, this message translates to:
  /// **'Mild symptoms are present. Focus on sleep, activity, and social support.'**
  String get guidanceMild;

  /// No description provided for @guidanceModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate symptoms are present. Professional consultation is recommended soon.'**
  String get guidanceModerate;

  /// No description provided for @guidanceHighRisk.
  ///
  /// In en, this message translates to:
  /// **'High-risk signals detected. Seek support immediately from trusted people and professionals.'**
  String get guidanceHighRisk;

  /// No description provided for @selfHarmOverride.
  ///
  /// In en, this message translates to:
  /// **'Safety override: self-harm item was positive. Immediate help is recommended.'**
  String get selfHarmOverride;

  /// No description provided for @emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Immediate Safety Check Needed'**
  String get emergencyTitle;

  /// No description provided for @emergencyBody.
  ///
  /// In en, this message translates to:
  /// **'If you may harm yourself, call emergency services or go to the nearest ER now.'**
  String get emergencyBody;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'Nearby Mental Health Care'**
  String get mapTitle;

  /// No description provided for @mapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'High-risk results should connect to real care quickly.'**
  String get mapSubtitle;

  /// No description provided for @mapNoLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow location to prioritize nearby clinics. Without permission, a fallback list is shown.'**
  String get mapNoLocation;

  /// No description provided for @mapUseMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use My Location'**
  String get mapUseMyLocation;

  /// No description provided for @mapLocating.
  ///
  /// In en, this message translates to:
  /// **'Checking location and searching nearby clinics...'**
  String get mapLocating;

  /// No description provided for @mapRealtimeLoaded.
  ///
  /// In en, this message translates to:
  /// **'Real-time nearby clinics loaded.'**
  String get mapRealtimeLoaded;

  /// No description provided for @mapNoResultFallback.
  ///
  /// In en, this message translates to:
  /// **'No nearby result from network. Showing fallback clinic list.'**
  String get mapNoResultFallback;

  /// No description provided for @mapNetworkFallback.
  ///
  /// In en, this message translates to:
  /// **'Network issue while searching. Showing fallback clinic list.'**
  String get mapNetworkFallback;

  /// No description provided for @mapPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Showing fallback clinic list.'**
  String get mapPermissionDenied;

  /// No description provided for @mapPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Enable it in system settings.'**
  String get mapPermissionDeniedForever;

  /// No description provided for @mapUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location service unavailable. Showing fallback clinic list.'**
  String get mapUnavailable;

  /// No description provided for @mapDataDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Specialist and operating-hours information may change. Please confirm by phone before visiting.'**
  String get mapDataDisclaimer;

  /// No description provided for @mapModeMapAndList.
  ///
  /// In en, this message translates to:
  /// **'Map + List'**
  String get mapModeMapAndList;

  /// No description provided for @mapModeListOnly.
  ///
  /// In en, this message translates to:
  /// **'List only'**
  String get mapModeListOnly;

  /// No description provided for @mapFilterSpecialistOnly.
  ///
  /// In en, this message translates to:
  /// **'Specialist only'**
  String get mapFilterSpecialistOnly;

  /// No description provided for @mapFilterOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now only'**
  String get mapFilterOpenNow;

  /// No description provided for @mapSortDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get mapSortDistance;

  /// No description provided for @mapSortOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now first'**
  String get mapSortOpenNow;

  /// No description provided for @mapSortSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Specialist first'**
  String get mapSortSpecialist;

  /// No description provided for @mapControlsTitle.
  ///
  /// In en, this message translates to:
  /// **'How to view clinic options'**
  String get mapControlsTitle;

  /// No description provided for @mapSpecialistAvailable.
  ///
  /// In en, this message translates to:
  /// **'Specialist available'**
  String get mapSpecialistAvailable;

  /// No description provided for @mapSpecialistUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No specialist listed'**
  String get mapSpecialistUnavailable;

  /// No description provided for @mapSpecialistUnknown.
  ///
  /// In en, this message translates to:
  /// **'Specialist info unavailable'**
  String get mapSpecialistUnknown;

  /// No description provided for @mapHoursToday.
  ///
  /// In en, this message translates to:
  /// **'Today hours'**
  String get mapHoursToday;

  /// No description provided for @mapHoursWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly hours'**
  String get mapHoursWeekly;

  /// No description provided for @mapHoursUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Hours unavailable'**
  String get mapHoursUnavailable;

  /// No description provided for @mapOpenNow.
  ///
  /// In en, this message translates to:
  /// **'Open now'**
  String get mapOpenNow;

  /// No description provided for @mapClosedNow.
  ///
  /// In en, this message translates to:
  /// **'Closed now'**
  String get mapClosedNow;

  /// No description provided for @mapOpenStateUnknown.
  ///
  /// In en, this message translates to:
  /// **'Status unknown'**
  String get mapOpenStateUnknown;

  /// No description provided for @mapCopyAddress.
  ///
  /// In en, this message translates to:
  /// **'Copy address'**
  String get mapCopyAddress;

  /// No description provided for @mapCopyAddressSuccess.
  ///
  /// In en, this message translates to:
  /// **'Address copied.'**
  String get mapCopyAddressSuccess;

  /// No description provided for @mapAddressUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Address information is unavailable.'**
  String get mapAddressUnavailable;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme & Language'**
  String get settingsTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageKorean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsFallback.
  ///
  /// In en, this message translates to:
  /// **'Fallback: ko -> en, en -> ko'**
  String get settingsFallback;

  /// No description provided for @settingsPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority: manual override > profile > system > default'**
  String get settingsPriority;

  /// No description provided for @settingsPersistence.
  ///
  /// In en, this message translates to:
  /// **'Persistence: save locally immediately, sync to profile when signed in'**
  String get settingsPersistence;

  /// No description provided for @modulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Instrument Modules'**
  String get modulesTitle;

  /// No description provided for @modulesIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a self-screening module'**
  String get modulesIntroTitle;

  /// No description provided for @modulesIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Start with PHQ-2 for a quick first pass, or open PHQ-9 directly when you need deeper screening.'**
  String get modulesIntroBody;

  /// No description provided for @modulesRestrictedTitle.
  ///
  /// In en, this message translates to:
  /// **'Restricted and clinician-only content'**
  String get modulesRestrictedTitle;

  /// No description provided for @modulePhq2Title.
  ///
  /// In en, this message translates to:
  /// **'PHQ-2'**
  String get modulePhq2Title;

  /// No description provided for @modulePhq2Desc.
  ///
  /// In en, this message translates to:
  /// **'Stage 1 fast screen used to decide whether deeper screening is needed.'**
  String get modulePhq2Desc;

  /// No description provided for @modulePhq9Title.
  ///
  /// In en, this message translates to:
  /// **'PHQ-9 / PHQ-A'**
  String get modulePhq9Title;

  /// No description provided for @modulePhq9Desc.
  ///
  /// In en, this message translates to:
  /// **'Stage 2 deeper screen for adolescents and adults.'**
  String get modulePhq9Desc;

  /// No description provided for @moduleBdiTitle.
  ///
  /// In en, this message translates to:
  /// **'BDI-II'**
  String get moduleBdiTitle;

  /// No description provided for @moduleBdiDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed instrument structure for mood and cognition.'**
  String get moduleBdiDesc;

  /// No description provided for @moduleHadsTitle.
  ///
  /// In en, this message translates to:
  /// **'HADS-D'**
  String get moduleHadsTitle;

  /// No description provided for @moduleHadsDesc.
  ///
  /// In en, this message translates to:
  /// **'Depression-focused module often used in medical settings.'**
  String get moduleHadsDesc;

  /// No description provided for @moduleCesdTitle.
  ///
  /// In en, this message translates to:
  /// **'CES-D'**
  String get moduleCesdTitle;

  /// No description provided for @moduleCesdDesc.
  ///
  /// In en, this message translates to:
  /// **'Community screening focused on recent week symptoms.'**
  String get moduleCesdDesc;

  /// No description provided for @moduleStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Module'**
  String get moduleStartButton;

  /// No description provided for @moduleHadsIntro.
  ///
  /// In en, this message translates to:
  /// **'Answer all HADS-D items for a depression-focused screening snapshot.'**
  String get moduleHadsIntro;

  /// No description provided for @moduleCesdIntro.
  ///
  /// In en, this message translates to:
  /// **'Answer all CES-D items based on your recent week.'**
  String get moduleCesdIntro;

  /// No description provided for @moduleBdiIntro.
  ///
  /// In en, this message translates to:
  /// **'Answer all BDI-II items. This module should be used with proper rights and governance.'**
  String get moduleBdiIntro;

  /// No description provided for @moduleBdiInAppNotice.
  ///
  /// In en, this message translates to:
  /// **'Notice: BDI-II copyrighted wording must only be shown under valid license.'**
  String get moduleBdiInAppNotice;

  /// No description provided for @moduleBackToModules.
  ///
  /// In en, this message translates to:
  /// **'Back to Modules'**
  String get moduleBackToModules;

  /// No description provided for @moduleQuestionLabel.
  ///
  /// In en, this message translates to:
  /// **'{module} item {index}'**
  String moduleQuestionLabel(Object module, Object index);

  /// No description provided for @moduleBdiNote.
  ///
  /// In en, this message translates to:
  /// **'Licensed content required: do not expose full copyrighted items without rights.'**
  String get moduleBdiNote;

  /// No description provided for @moduleClinicianButton.
  ///
  /// In en, this message translates to:
  /// **'Open Clinician-only HAM-D / MADRS'**
  String get moduleClinicianButton;

  /// No description provided for @clinicianTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinician-only Module'**
  String get clinicianTitle;

  /// No description provided for @clinicianBody.
  ///
  /// In en, this message translates to:
  /// **'HAM-D and MADRS are clinician-administered. This flow should stay hidden from self-screen users in production.'**
  String get clinicianBody;

  /// No description provided for @clinicianEmergencyPath.
  ///
  /// In en, this message translates to:
  /// **'Severe result path: emergency support + hospital map + follow-up scheduling.'**
  String get clinicianEmergencyPath;

  /// No description provided for @commonMissingAnswer.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions before continuing.'**
  String get commonMissingAnswer;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
