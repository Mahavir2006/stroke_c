import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Stroke Mitra'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Detect Stroke Early. Save Lives.'**
  String get appTagline;

  /// No description provided for @common_startScreening.
  ///
  /// In en, this message translates to:
  /// **'Start Screening'**
  String get common_startScreening;

  /// No description provided for @common_learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get common_learnMore;

  /// No description provided for @common_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get common_tryAgain;

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get common_retry;

  /// No description provided for @common_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// No description provided for @common_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get common_next;

  /// No description provided for @common_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get common_done;

  /// No description provided for @common_saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get common_saveAndContinue;

  /// No description provided for @common_testAgain.
  ///
  /// In en, this message translates to:
  /// **'Test Again'**
  String get common_testAgain;

  /// No description provided for @common_recordAgain.
  ///
  /// In en, this message translates to:
  /// **'Record Again'**
  String get common_recordAgain;

  /// No description provided for @common_startTest.
  ///
  /// In en, this message translates to:
  /// **'Start Test'**
  String get common_startTest;

  /// No description provided for @common_stopEarly.
  ///
  /// In en, this message translates to:
  /// **'Stop Early'**
  String get common_stopEarly;

  /// No description provided for @common_resultsSaved.
  ///
  /// In en, this message translates to:
  /// **'Results saved.'**
  String get common_resultsSaved;

  /// No description provided for @common_right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get common_right;

  /// No description provided for @common_left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get common_left;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_face.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get nav_face;

  /// No description provided for @nav_voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get nav_voice;

  /// No description provided for @nav_motion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get nav_motion;

  /// No description provided for @nav_tap.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get nav_tap;

  /// No description provided for @menu_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menu_profile;

  /// No description provided for @menu_lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get menu_lightMode;

  /// No description provided for @menu_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get menu_darkMode;

  /// No description provided for @menu_medicalReports.
  ///
  /// In en, this message translates to:
  /// **'Medical Reports'**
  String get menu_medicalReports;

  /// No description provided for @dashboard_greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboard_greetingMorning;

  /// No description provided for @dashboard_greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get dashboard_greetingAfternoon;

  /// No description provided for @dashboard_greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get dashboard_greetingEvening;

  /// No description provided for @dashboard_greetingWithName.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}'**
  String dashboard_greetingWithName(String greeting, String name);

  /// No description provided for @dashboard_readyCheck.
  ///
  /// In en, this message translates to:
  /// **'Ready for your daily check?'**
  String get dashboard_readyCheck;

  /// No description provided for @dashboard_lastCheck.
  ///
  /// In en, this message translates to:
  /// **'Last Check'**
  String get dashboard_lastCheck;

  /// No description provided for @dashboard_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get dashboard_status;

  /// No description provided for @dashboard_streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get dashboard_streak;

  /// No description provided for @dashboard_allClear.
  ///
  /// In en, this message translates to:
  /// **'All Clear'**
  String get dashboard_allClear;

  /// No description provided for @dashboard_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboard_today;

  /// No description provided for @dashboard_days.
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String dashboard_days(int count);

  /// No description provided for @dashboard_screeningTests.
  ///
  /// In en, this message translates to:
  /// **'SCREENING TESTS'**
  String get dashboard_screeningTests;

  /// No description provided for @dashboard_startFullCheckup.
  ///
  /// In en, this message translates to:
  /// **'Start Full Check-up'**
  String get dashboard_startFullCheckup;

  /// No description provided for @dashboard_allTestsOneSession.
  ///
  /// In en, this message translates to:
  /// **'All 4 tests in one session'**
  String get dashboard_allTestsOneSession;

  /// No description provided for @dashboard_faceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Face Analysis'**
  String get dashboard_faceAnalysis;

  /// No description provided for @dashboard_detectFacialDrooping.
  ///
  /// In en, this message translates to:
  /// **'Detect facial drooping'**
  String get dashboard_detectFacialDrooping;

  /// No description provided for @dashboard_voiceCheck.
  ///
  /// In en, this message translates to:
  /// **'Voice Check'**
  String get dashboard_voiceCheck;

  /// No description provided for @dashboard_analyzeSpeech.
  ///
  /// In en, this message translates to:
  /// **'Analyze speech clarity'**
  String get dashboard_analyzeSpeech;

  /// No description provided for @dashboard_motionTest.
  ///
  /// In en, this message translates to:
  /// **'Motion Test'**
  String get dashboard_motionTest;

  /// No description provided for @dashboard_assessArmStability.
  ///
  /// In en, this message translates to:
  /// **'Assess arm stability'**
  String get dashboard_assessArmStability;

  /// No description provided for @dashboard_tapTest.
  ///
  /// In en, this message translates to:
  /// **'Tap Test'**
  String get dashboard_tapTest;

  /// No description provided for @dashboard_fingerCoordination.
  ///
  /// In en, this message translates to:
  /// **'Finger coordination'**
  String get dashboard_fingerCoordination;

  /// No description provided for @face_title.
  ///
  /// In en, this message translates to:
  /// **'Face Analysis'**
  String get face_title;

  /// No description provided for @face_stepBaseline.
  ///
  /// In en, this message translates to:
  /// **'STEP 1 — CAPTURE BASELINE PHOTO'**
  String get face_stepBaseline;

  /// No description provided for @face_stepTest.
  ///
  /// In en, this message translates to:
  /// **'STEP 2 — CAPTURE TEST PHOTO'**
  String get face_stepTest;

  /// No description provided for @face_stepResult.
  ///
  /// In en, this message translates to:
  /// **'STEP 3 — RESULT'**
  String get face_stepResult;

  /// No description provided for @face_baselineInstruction.
  ///
  /// In en, this message translates to:
  /// **'Capture your baseline photo with a neutral expression.'**
  String get face_baselineInstruction;

  /// No description provided for @face_testInstruction.
  ///
  /// In en, this message translates to:
  /// **'Now capture a test photo to compare against your baseline.'**
  String get face_testInstruction;

  /// No description provided for @face_startingCamera.
  ///
  /// In en, this message translates to:
  /// **'Starting camera...'**
  String get face_startingCamera;

  /// No description provided for @face_alignFace.
  ///
  /// In en, this message translates to:
  /// **'Align face inside the oval'**
  String get face_alignFace;

  /// No description provided for @face_captureBaseline.
  ///
  /// In en, this message translates to:
  /// **'Capture Baseline'**
  String get face_captureBaseline;

  /// No description provided for @face_captureTestPhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture Test Photo'**
  String get face_captureTestPhoto;

  /// No description provided for @face_faceDetected.
  ///
  /// In en, this message translates to:
  /// **'Face detected'**
  String get face_faceDetected;

  /// No description provided for @face_ovalAligned.
  ///
  /// In en, this message translates to:
  /// **'Oval aligned'**
  String get face_ovalAligned;

  /// No description provided for @face_poseValid.
  ///
  /// In en, this message translates to:
  /// **'Pose valid'**
  String get face_poseValid;

  /// No description provided for @face_lightingOk.
  ///
  /// In en, this message translates to:
  /// **'Lighting OK'**
  String get face_lightingOk;

  /// No description provided for @face_processingBaseline.
  ///
  /// In en, this message translates to:
  /// **'Processing baseline...'**
  String get face_processingBaseline;

  /// No description provided for @face_analyzingSymmetry.
  ///
  /// In en, this message translates to:
  /// **'Analyzing symmetry...'**
  String get face_analyzingSymmetry;

  /// No description provided for @face_serverWarmup.
  ///
  /// In en, this message translates to:
  /// **'This may take up to 2 minutes if the server is warming up.'**
  String get face_serverWarmup;

  /// No description provided for @face_normalResult.
  ///
  /// In en, this message translates to:
  /// **'No significant asymmetry detected. Facial symmetry appears normal.'**
  String get face_normalResult;

  /// No description provided for @face_abnormalResult.
  ///
  /// In en, this message translates to:
  /// **'Potential facial asymmetry detected. Please consult a medical professional promptly.'**
  String get face_abnormalResult;

  /// No description provided for @face_stepBaseline_label.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get face_stepBaseline_label;

  /// No description provided for @face_stepTest_label.
  ///
  /// In en, this message translates to:
  /// **'Test Photo'**
  String get face_stepTest_label;

  /// No description provided for @face_stepResult_label.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get face_stepResult_label;

  /// No description provided for @face_cameraBlocked.
  ///
  /// In en, this message translates to:
  /// **'Camera blocked.\n\nClick the camera/lock icon in your browser address bar → Allow → then tap Retry.'**
  String get face_cameraBlocked;

  /// No description provided for @face_captureFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture: {error}'**
  String face_captureFailed(String error);

  /// No description provided for @voice_title.
  ///
  /// In en, this message translates to:
  /// **'Voice Check'**
  String get voice_title;

  /// No description provided for @voice_readSentence.
  ///
  /// In en, this message translates to:
  /// **'Read the following sentence clearly:'**
  String get voice_readSentence;

  /// No description provided for @voice_startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start Recording'**
  String get voice_startRecording;

  /// No description provided for @voice_stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get voice_stopRecording;

  /// No description provided for @voice_recordingComplete.
  ///
  /// In en, this message translates to:
  /// **'Recording complete ({duration}s)'**
  String voice_recordingComplete(String duration);

  /// No description provided for @voice_playRecording.
  ///
  /// In en, this message translates to:
  /// **'Play Recording'**
  String get voice_playRecording;

  /// No description provided for @voice_analyseSpeech.
  ///
  /// In en, this message translates to:
  /// **'Analyse Speech'**
  String get voice_analyseSpeech;

  /// No description provided for @voice_analysing.
  ///
  /// In en, this message translates to:
  /// **'Analysing your speech...'**
  String get voice_analysing;

  /// No description provided for @voice_analysingWait.
  ///
  /// In en, this message translates to:
  /// **'This may take up to 2 minutes on first use.'**
  String get voice_analysingWait;

  /// No description provided for @voice_slurringScore.
  ///
  /// In en, this message translates to:
  /// **'Slurring Score'**
  String get voice_slurringScore;

  /// No description provided for @voice_riskTier.
  ///
  /// In en, this message translates to:
  /// **'Risk Tier'**
  String get voice_riskTier;

  /// No description provided for @voice_riskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk Score'**
  String get voice_riskScore;

  /// No description provided for @voice_confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get voice_confidence;

  /// No description provided for @voice_acousticSummary.
  ///
  /// In en, this message translates to:
  /// **'Acoustic Summary'**
  String get voice_acousticSummary;

  /// No description provided for @voice_speakingRate.
  ///
  /// In en, this message translates to:
  /// **'Speaking Rate'**
  String get voice_speakingRate;

  /// No description provided for @voice_pitchMean.
  ///
  /// In en, this message translates to:
  /// **'Pitch Mean'**
  String get voice_pitchMean;

  /// No description provided for @voice_pitchVariability.
  ///
  /// In en, this message translates to:
  /// **'Pitch Variability'**
  String get voice_pitchVariability;

  /// No description provided for @voice_pauseRatio.
  ///
  /// In en, this message translates to:
  /// **'Pause Ratio'**
  String get voice_pauseRatio;

  /// No description provided for @voice_voicingRatio.
  ///
  /// In en, this message translates to:
  /// **'Voicing Ratio'**
  String get voice_voicingRatio;

  /// No description provided for @voice_severe.
  ///
  /// In en, this message translates to:
  /// **'Significant speech impairment detected. Seek medical attention immediately.'**
  String get voice_severe;

  /// No description provided for @voice_moderate.
  ///
  /// In en, this message translates to:
  /// **'Notable speech irregularities detected. Medical consultation recommended.'**
  String get voice_moderate;

  /// No description provided for @voice_mild.
  ///
  /// In en, this message translates to:
  /// **'Slight speech irregularities detected. Consider retesting or monitoring.'**
  String get voice_mild;

  /// No description provided for @voice_normal.
  ///
  /// In en, this message translates to:
  /// **'Speech patterns are within normal range. No significant slurring detected.'**
  String get voice_normal;

  /// No description provided for @voice_processedIn.
  ///
  /// In en, this message translates to:
  /// **'Processed in {seconds}s'**
  String voice_processedIn(String seconds);

  /// No description provided for @motion_title.
  ///
  /// In en, this message translates to:
  /// **'Arms Test'**
  String get motion_title;

  /// No description provided for @motion_instruction.
  ///
  /// In en, this message translates to:
  /// **'Hold your phone flat with both arms extended. Keep it as steady as possible for {seconds} seconds.'**
  String motion_instruction(int seconds);

  /// No description provided for @motion_xTilt.
  ///
  /// In en, this message translates to:
  /// **'X Tilt'**
  String get motion_xTilt;

  /// No description provided for @motion_yTilt.
  ///
  /// In en, this message translates to:
  /// **'Y Tilt'**
  String get motion_yTilt;

  /// No description provided for @motion_timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get motion_timeLeft;

  /// No description provided for @motion_secondsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds remaining'**
  String motion_secondsRemaining(int seconds);

  /// No description provided for @motion_tiltVariance.
  ///
  /// In en, this message translates to:
  /// **'Tilt Variance'**
  String get motion_tiltVariance;

  /// No description provided for @motion_driftScore.
  ///
  /// In en, this message translates to:
  /// **'Drift Score'**
  String get motion_driftScore;

  /// No description provided for @motion_samples.
  ///
  /// In en, this message translates to:
  /// **'Samples'**
  String get motion_samples;

  /// No description provided for @motion_abnormal.
  ///
  /// In en, this message translates to:
  /// **'Significant arm drift detected. Seek medical attention immediately.'**
  String get motion_abnormal;

  /// No description provided for @motion_borderline.
  ///
  /// In en, this message translates to:
  /// **'Some instability detected. Retest recommended.'**
  String get motion_borderline;

  /// No description provided for @motion_normal.
  ///
  /// In en, this message translates to:
  /// **'Arm stability is within normal range.'**
  String get motion_normal;

  /// No description provided for @tap_title.
  ///
  /// In en, this message translates to:
  /// **'Tap Test'**
  String get tap_title;

  /// No description provided for @tap_rightHand.
  ///
  /// In en, this message translates to:
  /// **'Right Hand'**
  String get tap_rightHand;

  /// No description provided for @tap_leftHand.
  ///
  /// In en, this message translates to:
  /// **'Left Hand'**
  String get tap_leftHand;

  /// No description provided for @tap_rightHandCaps.
  ///
  /// In en, this message translates to:
  /// **'RIGHT HAND'**
  String get tap_rightHandCaps;

  /// No description provided for @tap_leftHandCaps.
  ///
  /// In en, this message translates to:
  /// **'LEFT HAND'**
  String get tap_leftHandCaps;

  /// No description provided for @tap_rightInstruction.
  ///
  /// In en, this message translates to:
  /// **'Use your RIGHT hand to tap the moving button as many times as you can in 20 seconds.'**
  String get tap_rightInstruction;

  /// No description provided for @tap_leftInstruction.
  ///
  /// In en, this message translates to:
  /// **'Use your LEFT hand to tap the moving button as many times as you can in 20 seconds.'**
  String get tap_leftInstruction;

  /// No description provided for @tap_startRightTest.
  ///
  /// In en, this message translates to:
  /// **'Start Right Hand Test'**
  String get tap_startRightTest;

  /// No description provided for @tap_startLeftTest.
  ///
  /// In en, this message translates to:
  /// **'Start Left Hand Test'**
  String get tap_startLeftTest;

  /// No description provided for @tap_taps.
  ///
  /// In en, this message translates to:
  /// **'Taps: {count}'**
  String tap_taps(int count);

  /// No description provided for @tap_tapsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} taps'**
  String tap_tapsCount(int count);

  /// No description provided for @tap_rightDone.
  ///
  /// In en, this message translates to:
  /// **'Right hand done!'**
  String get tap_rightDone;

  /// No description provided for @tap_switchLeft.
  ///
  /// In en, this message translates to:
  /// **'Now switch to your LEFT hand.'**
  String get tap_switchLeft;

  /// No description provided for @tap_startingLeft.
  ///
  /// In en, this message translates to:
  /// **'Starting left hand test in {seconds} second{suffix}…'**
  String tap_startingLeft(int seconds, String suffix);

  /// No description provided for @tap_asymmetryAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Asymmetry Analysis'**
  String get tap_asymmetryAnalysis;

  /// No description provided for @tap_asymmetryIndex.
  ///
  /// In en, this message translates to:
  /// **'Asymmetry Index'**
  String get tap_asymmetryIndex;

  /// No description provided for @tap_assessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get tap_assessment;

  /// No description provided for @tap_lateralisedDeficit.
  ///
  /// In en, this message translates to:
  /// **'Lateralised Deficit Detected'**
  String get tap_lateralisedDeficit;

  /// No description provided for @emergency_title.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get emergency_title;

  /// No description provided for @emergency_callPrompt.
  ///
  /// In en, this message translates to:
  /// **'Seek immediate medical attention. Tap to call {number}.'**
  String emergency_callPrompt(String number);

  /// No description provided for @emergency_suspectStroke.
  ///
  /// In en, this message translates to:
  /// **'If you suspect a stroke, call emergency services immediately.'**
  String get emergency_suspectStroke;

  /// No description provided for @emergency_numbers.
  ///
  /// In en, this message translates to:
  /// **'Emergency: {emergency} | Ambulance: {ambulance}'**
  String emergency_numbers(String emergency, String ambulance);

  /// No description provided for @disclaimer_title.
  ///
  /// In en, this message translates to:
  /// **'Prototype Screening Tool'**
  String get disclaimer_title;

  /// No description provided for @disclaimer_body.
  ///
  /// In en, this message translates to:
  /// **'This application is for demonstration and research purposes only. It is not a medical device and does not provide a diagnosis. If you suspect a stroke, call emergency services immediately.'**
  String get disclaimer_body;

  /// No description provided for @auth_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get auth_welcomeBack;

  /// No description provided for @auth_signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your screening results'**
  String get auth_signInSubtitle;

  /// No description provided for @auth_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_emailLabel;

  /// No description provided for @auth_passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_passwordLabel;

  /// No description provided for @auth_fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get auth_fullNameLabel;

  /// No description provided for @auth_forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgotPassword;

  /// No description provided for @auth_signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_signIn;

  /// No description provided for @auth_signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_signUp;

  /// No description provided for @auth_createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_createAccount;

  /// No description provided for @auth_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_noAccount;

  /// No description provided for @auth_hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_hasAccount;

  /// No description provided for @auth_joinStrokeMitra.
  ///
  /// In en, this message translates to:
  /// **'Join Stroke Mitra'**
  String get auth_joinStrokeMitra;

  /// No description provided for @auth_signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account to securely store your screening results'**
  String get auth_signUpSubtitle;

  /// No description provided for @auth_validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get auth_validEmail;

  /// No description provided for @auth_validPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get auth_validPassword;

  /// No description provided for @auth_validName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get auth_validName;

  /// No description provided for @auth_resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_resetPassword;

  /// No description provided for @auth_resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to reset your password'**
  String get auth_resetSubtitle;

  /// No description provided for @auth_sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get auth_sendResetLink;

  /// No description provided for @auth_checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check Your Email'**
  String get auth_checkEmail;

  /// No description provided for @auth_resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to\n{email}'**
  String auth_resetLinkSent(String email);

  /// No description provided for @auth_backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get auth_backToLogin;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profile_title;

  /// No description provided for @profile_memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get profile_memberSince;

  /// No description provided for @profile_testsTaken.
  ///
  /// In en, this message translates to:
  /// **'Tests Taken'**
  String get profile_testsTaken;

  /// No description provided for @profile_lastCheck.
  ///
  /// In en, this message translates to:
  /// **'Last Check'**
  String get profile_lastCheck;

  /// No description provided for @profile_baselinePhoto.
  ///
  /// In en, this message translates to:
  /// **'Baseline Photo'**
  String get profile_baselinePhoto;

  /// No description provided for @profile_baselineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used as reference for face symmetry analysis.'**
  String get profile_baselineSubtitle;

  /// No description provided for @profile_noBaseline.
  ///
  /// In en, this message translates to:
  /// **'No baseline photo yet'**
  String get profile_noBaseline;

  /// No description provided for @profile_captureBaseline.
  ///
  /// In en, this message translates to:
  /// **'Capture one from the Face Analysis page.'**
  String get profile_captureBaseline;

  /// No description provided for @profile_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get profile_appearance;

  /// No description provided for @profile_appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme.'**
  String get profile_appearanceSubtitle;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language.'**
  String get profile_languageSubtitle;

  /// No description provided for @profile_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profile_account;

  /// No description provided for @profile_signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get profile_signOut;

  /// No description provided for @profile_privacy.
  ///
  /// In en, this message translates to:
  /// **'Your data is securely stored and private to you.'**
  String get profile_privacy;

  /// No description provided for @profile_notFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profile_notFound;

  /// No description provided for @profile_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String profile_errorLoading(String error);

  /// No description provided for @profile_themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get profile_themeSystem;

  /// No description provided for @profile_themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profile_themeLight;

  /// No description provided for @profile_themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profile_themeDark;

  /// No description provided for @checkup_fullCheckup.
  ///
  /// In en, this message translates to:
  /// **'Full Check-up'**
  String get checkup_fullCheckup;

  /// No description provided for @checkup_exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Full Check-up?'**
  String get checkup_exitTitle;

  /// No description provided for @checkup_exitMessage.
  ///
  /// In en, this message translates to:
  /// **'Your progress will be lost. Are you sure you want to exit?'**
  String get checkup_exitMessage;

  /// No description provided for @checkup_stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get checkup_stay;

  /// No description provided for @checkup_exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get checkup_exit;

  /// No description provided for @checkup_exitTooltip.
  ///
  /// In en, this message translates to:
  /// **'Exit check-up'**
  String get checkup_exitTooltip;

  /// No description provided for @checkup_reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-up Report'**
  String get checkup_reportTitle;

  /// No description provided for @checkup_noCheckupFound.
  ///
  /// In en, this message translates to:
  /// **'No completed check-up found.'**
  String get checkup_noCheckupFound;

  /// No description provided for @checkup_goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get checkup_goHome;

  /// No description provided for @checkup_downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Report'**
  String get checkup_downloadPdf;

  /// No description provided for @checkup_backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get checkup_backToHome;

  /// No description provided for @checkup_faceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Face Analysis'**
  String get checkup_faceAnalysis;

  /// No description provided for @checkup_voiceCheck.
  ///
  /// In en, this message translates to:
  /// **'Voice Check'**
  String get checkup_voiceCheck;

  /// No description provided for @checkup_motionTest.
  ///
  /// In en, this message translates to:
  /// **'Motion Test'**
  String get checkup_motionTest;

  /// No description provided for @checkup_tapTest.
  ///
  /// In en, this message translates to:
  /// **'Tap Test'**
  String get checkup_tapTest;

  /// No description provided for @checkup_overallRisk.
  ///
  /// In en, this message translates to:
  /// **'Overall: {risk}'**
  String checkup_overallRisk(String risk);

  /// No description provided for @checkup_riskAbnormalMessage.
  ///
  /// In en, this message translates to:
  /// **'One or more tests indicate potential stroke signs. Please seek medical attention immediately.'**
  String get checkup_riskAbnormalMessage;

  /// No description provided for @checkup_riskBorderlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Some tests show borderline results. Consider consulting a healthcare provider.'**
  String get checkup_riskBorderlineMessage;

  /// No description provided for @checkup_riskNormalMessage.
  ///
  /// In en, this message translates to:
  /// **'All tests are within normal range. No significant stroke indicators detected.'**
  String get checkup_riskNormalMessage;

  /// No description provided for @checkup_fullCheckupReport.
  ///
  /// In en, this message translates to:
  /// **'Full Check-up Report'**
  String get checkup_fullCheckupReport;

  /// No description provided for @checkup_overallRiskLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall Risk: '**
  String get checkup_overallRiskLabel;

  /// No description provided for @checkup_noRiskFactors.
  ///
  /// In en, this message translates to:
  /// **'No risk factors detected'**
  String get checkup_noRiskFactors;

  /// No description provided for @checkup_detectedConditions.
  ///
  /// In en, this message translates to:
  /// **'Detected Conditions'**
  String get checkup_detectedConditions;

  /// No description provided for @checkup_stepFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get checkup_stepFace;

  /// No description provided for @checkup_stepVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get checkup_stepVoice;

  /// No description provided for @checkup_stepMotion.
  ///
  /// In en, this message translates to:
  /// **'Motion'**
  String get checkup_stepMotion;

  /// No description provided for @checkup_stepTap.
  ///
  /// In en, this message translates to:
  /// **'Tap'**
  String get checkup_stepTap;

  /// No description provided for @medicalReport_title.
  ///
  /// In en, this message translates to:
  /// **'Medical Reports'**
  String get medicalReport_title;

  /// No description provided for @medicalReport_uploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Medical Report'**
  String get medicalReport_uploadTitle;

  /// No description provided for @medicalReport_supportedFormat.
  ///
  /// In en, this message translates to:
  /// **'Supported format: PDF · Max 10MB'**
  String get medicalReport_supportedFormat;

  /// No description provided for @medicalReport_choosePdf.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF File'**
  String get medicalReport_choosePdf;

  /// No description provided for @medicalReport_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get medicalReport_uploading;

  /// No description provided for @medicalReport_fileSizeLimit.
  ///
  /// In en, this message translates to:
  /// **'File exceeds 10MB limit.'**
  String get medicalReport_fileSizeLimit;

  /// No description provided for @medicalReport_couldNotOpenPdf.
  ///
  /// In en, this message translates to:
  /// **'Could not open PDF.'**
  String get medicalReport_couldNotOpenPdf;

  /// No description provided for @medicalReport_failedPdfLink.
  ///
  /// In en, this message translates to:
  /// **'Failed to get PDF link: {error}'**
  String medicalReport_failedPdfLink(String error);

  /// No description provided for @medicalReport_analyzing.
  ///
  /// In en, this message translates to:
  /// **'Analyzing report...'**
  String get medicalReport_analyzing;

  /// No description provided for @medicalReport_extracting.
  ///
  /// In en, this message translates to:
  /// **'Extracting text and detecting risk factors'**
  String get medicalReport_extracting;

  /// No description provided for @medicalReport_pastReports.
  ///
  /// In en, this message translates to:
  /// **'Past Reports'**
  String get medicalReport_pastReports;

  /// No description provided for @medicalReport_noReports.
  ///
  /// In en, this message translates to:
  /// **'No reports yet'**
  String get medicalReport_noReports;

  /// No description provided for @medicalReport_uploadPrompt.
  ///
  /// In en, this message translates to:
  /// **'Upload a PDF medical report to get started.'**
  String get medicalReport_uploadPrompt;

  /// No description provided for @medicalReport_viewPdf.
  ///
  /// In en, this message translates to:
  /// **'View PDF'**
  String get medicalReport_viewPdf;

  /// No description provided for @landing_heroTitle1.
  ///
  /// In en, this message translates to:
  /// **'Detect Stroke Early.'**
  String get landing_heroTitle1;

  /// No description provided for @landing_heroTitle2.
  ///
  /// In en, this message translates to:
  /// **'Save Lives.'**
  String get landing_heroTitle2;

  /// No description provided for @landing_heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stroke Mitra uses your device\'s camera, microphone, and motion sensors to check for early warning signs of stroke — privately, in under 60 seconds.'**
  String get landing_heroSubtitle;

  /// No description provided for @landing_trustPrivate.
  ///
  /// In en, this message translates to:
  /// **'100% Private'**
  String get landing_trustPrivate;

  /// No description provided for @landing_trustFast.
  ///
  /// In en, this message translates to:
  /// **'Under 60s'**
  String get landing_trustFast;

  /// No description provided for @landing_trustNoData.
  ///
  /// In en, this message translates to:
  /// **'No Data Stored'**
  String get landing_trustNoData;

  /// No description provided for @landing_scrollDown.
  ///
  /// In en, this message translates to:
  /// **'Scroll down'**
  String get landing_scrollDown;

  /// No description provided for @landing_aiPowered.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Screening'**
  String get landing_aiPowered;

  /// No description provided for @landing_aboutTag.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get landing_aboutTag;

  /// No description provided for @landing_whatIsTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Stroke Mitra?'**
  String get landing_whatIsTitle;

  /// No description provided for @landing_whatIsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stroke Mitra is an AI-powered screening tool that helps identify early warning signs of stroke using your smartphone\'s built-in sensors — no special equipment needed.'**
  String get landing_whatIsSubtitle;

  /// No description provided for @landing_clinicallyInformed.
  ///
  /// In en, this message translates to:
  /// **'Clinically Informed'**
  String get landing_clinicallyInformed;

  /// No description provided for @landing_clinicallyDesc.
  ///
  /// In en, this message translates to:
  /// **'Built on the FAST (Face, Arms, Speech, Time) framework used by medical professionals worldwide.'**
  String get landing_clinicallyDesc;

  /// No description provided for @landing_deviceNative.
  ///
  /// In en, this message translates to:
  /// **'Device-Native AI'**
  String get landing_deviceNative;

  /// No description provided for @landing_deviceDesc.
  ///
  /// In en, this message translates to:
  /// **'Runs entirely on your device. No cloud uploads, no data retention. Your health data stays yours.'**
  String get landing_deviceDesc;

  /// No description provided for @landing_forEveryone.
  ///
  /// In en, this message translates to:
  /// **'For Everyone'**
  String get landing_forEveryone;

  /// No description provided for @landing_forEveryoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Designed for patients, caregivers, and healthcare workers. No medical training required.'**
  String get landing_forEveryoneDesc;

  /// No description provided for @landing_disclaimerPrefix.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer: '**
  String get landing_disclaimerPrefix;

  /// No description provided for @landing_disclaimerText.
  ///
  /// In en, this message translates to:
  /// **'Stroke Mitra is a screening aid, not a diagnostic tool. Always call emergency services (112) immediately if you suspect a stroke.'**
  String get landing_disclaimerText;

  /// No description provided for @landing_howItWorksTag.
  ///
  /// In en, this message translates to:
  /// **'HOW IT WORKS'**
  String get landing_howItWorksTag;

  /// No description provided for @landing_howItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'Three Simple Steps'**
  String get landing_howItWorksTitle;

  /// No description provided for @landing_howItWorksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stroke Mitra walks you through a quick, guided screening — no medical knowledge needed.'**
  String get landing_howItWorksSubtitle;

  /// No description provided for @landing_step1Title.
  ///
  /// In en, this message translates to:
  /// **'Open & Start'**
  String get landing_step1Title;

  /// No description provided for @landing_step1Desc.
  ///
  /// In en, this message translates to:
  /// **'Launch the app and tap \'Start Screening\'. No registration or login required.'**
  String get landing_step1Desc;

  /// No description provided for @landing_step1Detail1.
  ///
  /// In en, this message translates to:
  /// **'Works on any modern smartphone'**
  String get landing_step1Detail1;

  /// No description provided for @landing_step1Detail2.
  ///
  /// In en, this message translates to:
  /// **'No download needed'**
  String get landing_step1Detail2;

  /// No description provided for @landing_step2Title.
  ///
  /// In en, this message translates to:
  /// **'Complete 3 Quick Tests'**
  String get landing_step2Title;

  /// No description provided for @landing_step2Desc.
  ///
  /// In en, this message translates to:
  /// **'Follow the guided prompts for face, speech, and arm movement analysis.'**
  String get landing_step2Desc;

  /// No description provided for @landing_step2Detail1.
  ///
  /// In en, this message translates to:
  /// **'Face symmetry via camera'**
  String get landing_step2Detail1;

  /// No description provided for @landing_step2Detail2.
  ///
  /// In en, this message translates to:
  /// **'Speech clarity via microphone'**
  String get landing_step2Detail2;

  /// No description provided for @landing_step3Title.
  ///
  /// In en, this message translates to:
  /// **'Get Instant Results'**
  String get landing_step3Title;

  /// No description provided for @landing_step3Desc.
  ///
  /// In en, this message translates to:
  /// **'View your screening summary with clear risk indicators and next steps.'**
  String get landing_step3Desc;

  /// No description provided for @landing_step3Detail1.
  ///
  /// In en, this message translates to:
  /// **'Color-coded risk levels'**
  String get landing_step3Detail1;

  /// No description provided for @landing_step3Detail2.
  ///
  /// In en, this message translates to:
  /// **'Emergency guidance if needed'**
  String get landing_step3Detail2;

  /// No description provided for @landing_featuresTag.
  ///
  /// In en, this message translates to:
  /// **'FEATURES'**
  String get landing_featuresTag;

  /// No description provided for @landing_featuresTitle.
  ///
  /// In en, this message translates to:
  /// **'Built for Speed. Designed for Trust.'**
  String get landing_featuresTitle;

  /// No description provided for @landing_featuresSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Every feature is purpose-built to deliver accurate, fast, and private stroke screening.'**
  String get landing_featuresSubtitle;

  /// No description provided for @landing_feat1Title.
  ///
  /// In en, this message translates to:
  /// **'Camera-Based Facial Analysis'**
  String get landing_feat1Title;

  /// No description provided for @landing_feat1Desc.
  ///
  /// In en, this message translates to:
  /// **'Real-time AI detection of facial asymmetry using your front camera. No special hardware needed.'**
  String get landing_feat1Desc;

  /// No description provided for @landing_feat1Tag.
  ///
  /// In en, this message translates to:
  /// **'Computer Vision'**
  String get landing_feat1Tag;

  /// No description provided for @landing_feat2Title.
  ///
  /// In en, this message translates to:
  /// **'Voice Recording & Speech Detection'**
  String get landing_feat2Title;

  /// No description provided for @landing_feat2Desc.
  ///
  /// In en, this message translates to:
  /// **'Advanced NLP models analyze your speech for slurring, word-finding difficulty, and incoherence.'**
  String get landing_feat2Desc;

  /// No description provided for @landing_feat2Tag.
  ///
  /// In en, this message translates to:
  /// **'NLP + Audio AI'**
  String get landing_feat2Tag;

  /// No description provided for @landing_feat3Title.
  ///
  /// In en, this message translates to:
  /// **'Motion & Coordination Sensing'**
  String get landing_feat3Title;

  /// No description provided for @landing_feat3Desc.
  ///
  /// In en, this message translates to:
  /// **'Gyroscope and accelerometer data assess arm drift and coordination — key neurological indicators.'**
  String get landing_feat3Desc;

  /// No description provided for @landing_feat3Tag.
  ///
  /// In en, this message translates to:
  /// **'Sensor Fusion'**
  String get landing_feat3Tag;

  /// No description provided for @landing_feat4Title.
  ///
  /// In en, this message translates to:
  /// **'Results in Under 60 Seconds'**
  String get landing_feat4Title;

  /// No description provided for @landing_feat4Desc.
  ///
  /// In en, this message translates to:
  /// **'The entire screening process takes less than a minute, giving you fast answers when every second counts.'**
  String get landing_feat4Desc;

  /// No description provided for @landing_feat4Tag.
  ///
  /// In en, this message translates to:
  /// **'Real-Time'**
  String get landing_feat4Tag;

  /// No description provided for @landing_feat5Title.
  ///
  /// In en, this message translates to:
  /// **'Fully Private & Secure'**
  String get landing_feat5Title;

  /// No description provided for @landing_feat5Desc.
  ///
  /// In en, this message translates to:
  /// **'All processing happens on your device. No video, audio, or personal data is ever uploaded or stored.'**
  String get landing_feat5Desc;

  /// No description provided for @landing_feat5Tag.
  ///
  /// In en, this message translates to:
  /// **'On-Device AI'**
  String get landing_feat5Tag;

  /// No description provided for @landing_feat6Title.
  ///
  /// In en, this message translates to:
  /// **'Clinically Guided Framework'**
  String get landing_feat6Title;

  /// No description provided for @landing_feat6Desc.
  ///
  /// In en, this message translates to:
  /// **'Based on the medically validated FAST protocol, trusted by emergency responders globally.'**
  String get landing_feat6Desc;

  /// No description provided for @landing_feat6Tag.
  ///
  /// In en, this message translates to:
  /// **'Evidence-Based'**
  String get landing_feat6Tag;

  /// No description provided for @landing_statsTag.
  ///
  /// In en, this message translates to:
  /// **'THE STAKES'**
  String get landing_statsTag;

  /// No description provided for @landing_statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Every Second Counts'**
  String get landing_statsTitle;

  /// No description provided for @landing_statsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stroke is the second leading cause of death worldwide. Early detection dramatically changes outcomes.'**
  String get landing_statsSubtitle;

  /// No description provided for @landing_stat1Label.
  ///
  /// In en, this message translates to:
  /// **'Strokes occur globally each year'**
  String get landing_stat1Label;

  /// No description provided for @landing_stat2Label.
  ///
  /// In en, this message translates to:
  /// **'Of strokes are preventable with early action'**
  String get landing_stat2Label;

  /// No description provided for @landing_stat3Label.
  ///
  /// In en, this message translates to:
  /// **'Brain cells lost every minute untreated'**
  String get landing_stat3Label;

  /// No description provided for @landing_stat4Label.
  ///
  /// In en, this message translates to:
  /// **'Better outcomes with treatment in first hour'**
  String get landing_stat4Label;

  /// No description provided for @landing_fastRemember.
  ///
  /// In en, this message translates to:
  /// **'Remember '**
  String get landing_fastRemember;

  /// No description provided for @landing_fastTitle.
  ///
  /// In en, this message translates to:
  /// **'F.A.S.T.'**
  String get landing_fastTitle;

  /// No description provided for @landing_fastF.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get landing_fastF;

  /// No description provided for @landing_fastFDesc.
  ///
  /// In en, this message translates to:
  /// **'Is one side drooping?'**
  String get landing_fastFDesc;

  /// No description provided for @landing_fastA.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get landing_fastA;

  /// No description provided for @landing_fastADesc.
  ///
  /// In en, this message translates to:
  /// **'Can they raise both arms?'**
  String get landing_fastADesc;

  /// No description provided for @landing_fastS.
  ///
  /// In en, this message translates to:
  /// **'Speech'**
  String get landing_fastS;

  /// No description provided for @landing_fastSDesc.
  ///
  /// In en, this message translates to:
  /// **'Is speech slurred or strange?'**
  String get landing_fastSDesc;

  /// No description provided for @landing_fastT.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get landing_fastT;

  /// No description provided for @landing_fastTDesc.
  ///
  /// In en, this message translates to:
  /// **'Call 112 immediately!'**
  String get landing_fastTDesc;

  /// No description provided for @landing_ctaTitle1.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Wait. '**
  String get landing_ctaTitle1;

  /// No description provided for @landing_ctaTitle2.
  ///
  /// In en, this message translates to:
  /// **'Act Now.'**
  String get landing_ctaTitle2;

  /// No description provided for @landing_ctaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you or someone near you shows stroke symptoms, every second matters. Start the Stroke Mitra check right now — it could save a life.'**
  String get landing_ctaSubtitle;

  /// No description provided for @landing_ctaStart.
  ///
  /// In en, this message translates to:
  /// **'Start Stroke Check Now'**
  String get landing_ctaStart;

  /// No description provided for @landing_ctaEmergency.
  ///
  /// In en, this message translates to:
  /// **'Call 112 Emergency'**
  String get landing_ctaEmergency;

  /// No description provided for @landing_ctaFree.
  ///
  /// In en, this message translates to:
  /// **'Free to use · No registration · Works on any modern smartphone'**
  String get landing_ctaFree;

  /// No description provided for @landing_footerTagline.
  ///
  /// In en, this message translates to:
  /// **'Early detection. Better outcomes.\nEvery second counts.'**
  String get landing_footerTagline;

  /// No description provided for @landing_footerScreening.
  ///
  /// In en, this message translates to:
  /// **'Screening'**
  String get landing_footerScreening;

  /// No description provided for @landing_footerLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get landing_footerLearn;

  /// No description provided for @landing_footerEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get landing_footerEmergency;

  /// No description provided for @landing_footerWhatIs.
  ///
  /// In en, this message translates to:
  /// **'What is Stroke Mitra'**
  String get landing_footerWhatIs;

  /// No description provided for @landing_footerHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get landing_footerHowItWorks;

  /// No description provided for @landing_footerWhyEarly.
  ///
  /// In en, this message translates to:
  /// **'Why Early Detection'**
  String get landing_footerWhyEarly;

  /// No description provided for @landing_footerCall112.
  ///
  /// In en, this message translates to:
  /// **'Call 112'**
  String get landing_footerCall112;

  /// No description provided for @landing_footerAmbulance108.
  ///
  /// In en, this message translates to:
  /// **'Ambulance 108'**
  String get landing_footerAmbulance108;

  /// No description provided for @landing_footerCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2025 Stroke Mitra. Built with care for public health awareness.'**
  String get landing_footerCopyright;

  /// No description provided for @landing_footerDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This tool is for screening purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment.'**
  String get landing_footerDisclaimer;

  /// No description provided for @landing_nav_checkSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Check Symptoms'**
  String get landing_nav_checkSymptoms;

  /// No description provided for @landing_footer_faceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Face Analysis'**
  String get landing_footer_faceAnalysis;

  /// No description provided for @landing_footer_speechCheck.
  ///
  /// In en, this message translates to:
  /// **'Speech Check'**
  String get landing_footer_speechCheck;

  /// No description provided for @landing_footer_motionTest.
  ///
  /// In en, this message translates to:
  /// **'Motion Test'**
  String get landing_footer_motionTest;

  /// No description provided for @motion_secondsRemainingLabel.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds remaining'**
  String motion_secondsRemainingLabel(int seconds);

  /// No description provided for @face_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get face_retry;

  /// No description provided for @medicalReport_noRiskFactors.
  ///
  /// In en, this message translates to:
  /// **'No risk factors detected'**
  String get medicalReport_noRiskFactors;

  /// No description provided for @medicalReport_detectedConditions.
  ///
  /// In en, this message translates to:
  /// **'Detected Conditions'**
  String get medicalReport_detectedConditions;

  /// No description provided for @checkup_continueToVoice.
  ///
  /// In en, this message translates to:
  /// **'Continue to Voice Check'**
  String get checkup_continueToVoice;

  /// No description provided for @checkup_continueToMotion.
  ///
  /// In en, this message translates to:
  /// **'Continue to Motion Test'**
  String get checkup_continueToMotion;

  /// No description provided for @checkup_continueToTap.
  ///
  /// In en, this message translates to:
  /// **'Continue to Tap Test'**
  String get checkup_continueToTap;

  /// No description provided for @sos_emergencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Emergency SOS'**
  String get sos_emergencyTitle;

  /// No description provided for @sos_emergencySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Abnormal results detected. If you or someone nearby is experiencing stroke symptoms, call emergency services immediately.'**
  String get sos_emergencySubtitle;

  /// No description provided for @sos_callAmbulance.
  ///
  /// In en, this message translates to:
  /// **'Call Ambulance (108)'**
  String get sos_callAmbulance;

  /// No description provided for @sos_callEmergency.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency (112)'**
  String get sos_callEmergency;

  /// No description provided for @sos_couldNotCall.
  ///
  /// In en, this message translates to:
  /// **'Could not place call'**
  String get sos_couldNotCall;

  /// No description provided for @hospital_sendToNearby.
  ///
  /// In en, this message translates to:
  /// **'Send to Nearby Hospital'**
  String get hospital_sendToNearby;

  /// No description provided for @hospital_selectHospital.
  ///
  /// In en, this message translates to:
  /// **'Select Hospital'**
  String get hospital_selectHospital;

  /// No description provided for @hospital_finding.
  ///
  /// In en, this message translates to:
  /// **'Finding nearest hospital...'**
  String get hospital_finding;

  /// No description provided for @hospital_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading hospitals...'**
  String get hospital_loading;

  /// No description provided for @hospital_confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Send Alert to Hospital?'**
  String get hospital_confirmTitle;

  /// No description provided for @hospital_confirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Sending to: {name} ({distance} km away). Confirm?'**
  String hospital_confirmMessage(String name, String distance);

  /// No description provided for @hospital_confirm.
  ///
  /// In en, this message translates to:
  /// **'Send Alert'**
  String get hospital_confirm;

  /// No description provided for @hospital_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get hospital_cancel;

  /// No description provided for @hospital_sending.
  ///
  /// In en, this message translates to:
  /// **'Sending alert...'**
  String get hospital_sending;

  /// No description provided for @hospital_sent.
  ///
  /// In en, this message translates to:
  /// **'Alert sent successfully to {name}'**
  String hospital_sent(String name);

  /// No description provided for @hospital_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send alert: {error}'**
  String hospital_failed(String error);

  /// No description provided for @hospital_noNearby.
  ///
  /// In en, this message translates to:
  /// **'No hospitals found within 50km. Showing 3 nearest hospitals.'**
  String get hospital_noNearby;

  /// No description provided for @hospital_locationError.
  ///
  /// In en, this message translates to:
  /// **'Could not get your location. Please enable location services.'**
  String get hospital_locationError;
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
      <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
