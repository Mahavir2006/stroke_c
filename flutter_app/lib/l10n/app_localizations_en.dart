// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Stroke Mitra';

  @override
  String get appTagline => 'Detect Stroke Early. Save Lives.';

  @override
  String get common_startScreening => 'Start Screening';

  @override
  String get common_learnMore => 'Learn More';

  @override
  String get common_tryAgain => 'Try Again';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_retry => 'Retry';

  @override
  String get common_back => 'Back';

  @override
  String get common_next => 'Next';

  @override
  String get common_done => 'Done';

  @override
  String get common_saveAndContinue => 'Save & Continue';

  @override
  String get common_testAgain => 'Test Again';

  @override
  String get common_recordAgain => 'Record Again';

  @override
  String get common_startTest => 'Start Test';

  @override
  String get common_stopEarly => 'Stop Early';

  @override
  String get common_resultsSaved => 'Results saved.';

  @override
  String get common_right => 'Right';

  @override
  String get common_left => 'Left';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_face => 'Face';

  @override
  String get nav_voice => 'Voice';

  @override
  String get nav_motion => 'Motion';

  @override
  String get nav_tap => 'Tap';

  @override
  String get menu_profile => 'Profile';

  @override
  String get menu_lightMode => 'Light Mode';

  @override
  String get menu_darkMode => 'Dark Mode';

  @override
  String get menu_medicalReports => 'Medical Reports';

  @override
  String get dashboard_greetingMorning => 'Good morning';

  @override
  String get dashboard_greetingAfternoon => 'Good afternoon';

  @override
  String get dashboard_greetingEvening => 'Good evening';

  @override
  String dashboard_greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get dashboard_readyCheck => 'Ready for your daily check?';

  @override
  String get dashboard_lastCheck => 'Last Check';

  @override
  String get dashboard_status => 'Status';

  @override
  String get dashboard_streak => 'Streak';

  @override
  String get dashboard_allClear => 'All Clear';

  @override
  String get dashboard_today => 'Today';

  @override
  String dashboard_days(int count) {
    return '$count days';
  }

  @override
  String get dashboard_screeningTests => 'SCREENING TESTS';

  @override
  String get dashboard_startFullCheckup => 'Start Full Check-up';

  @override
  String get dashboard_allTestsOneSession => 'All 4 tests in one session';

  @override
  String get dashboard_faceAnalysis => 'Face Analysis';

  @override
  String get dashboard_detectFacialDrooping => 'Detect facial drooping';

  @override
  String get dashboard_voiceCheck => 'Voice Check';

  @override
  String get dashboard_analyzeSpeech => 'Analyze speech clarity';

  @override
  String get dashboard_motionTest => 'Motion Test';

  @override
  String get dashboard_assessArmStability => 'Assess arm stability';

  @override
  String get dashboard_tapTest => 'Tap Test';

  @override
  String get dashboard_fingerCoordination => 'Finger coordination';

  @override
  String get face_title => 'Face Analysis';

  @override
  String get face_stepBaseline => 'STEP 1 — CAPTURE BASELINE PHOTO';

  @override
  String get face_stepTest => 'STEP 2 — CAPTURE TEST PHOTO';

  @override
  String get face_stepResult => 'STEP 3 — RESULT';

  @override
  String get face_baselineInstruction =>
      'Capture your baseline photo with a neutral expression.';

  @override
  String get face_testInstruction =>
      'Now capture a test photo to compare against your baseline.';

  @override
  String get face_startingCamera => 'Starting camera...';

  @override
  String get face_alignFace => 'Align face inside the oval';

  @override
  String get face_captureBaseline => 'Capture Baseline';

  @override
  String get face_captureTestPhoto => 'Capture Test Photo';

  @override
  String get face_faceDetected => 'Face detected';

  @override
  String get face_ovalAligned => 'Oval aligned';

  @override
  String get face_poseValid => 'Pose valid';

  @override
  String get face_lightingOk => 'Lighting OK';

  @override
  String get face_processingBaseline => 'Processing baseline...';

  @override
  String get face_analyzingSymmetry => 'Analyzing symmetry...';

  @override
  String get face_serverWarmup =>
      'This may take up to 2 minutes if the server is warming up.';

  @override
  String get face_normalResult =>
      'No significant asymmetry detected. Facial symmetry appears normal.';

  @override
  String get face_abnormalResult =>
      'Potential facial asymmetry detected. Please consult a medical professional promptly.';

  @override
  String get face_stepBaseline_label => 'Baseline';

  @override
  String get face_stepTest_label => 'Test Photo';

  @override
  String get face_stepResult_label => 'Result';

  @override
  String get face_cameraBlocked =>
      'Camera blocked.\n\nClick the camera/lock icon in your browser address bar → Allow → then tap Retry.';

  @override
  String face_captureFailed(String error) {
    return 'Failed to capture: $error';
  }

  @override
  String get voice_title => 'Voice Check';

  @override
  String get voice_readSentence => 'Read the following sentence clearly:';

  @override
  String get voice_startRecording => 'Start Recording';

  @override
  String get voice_stopRecording => 'Stop Recording';

  @override
  String voice_recordingComplete(String duration) {
    return 'Recording complete (${duration}s)';
  }

  @override
  String get voice_playRecording => 'Play Recording';

  @override
  String get voice_analyseSpeech => 'Analyse Speech';

  @override
  String get voice_analysing => 'Analysing your speech...';

  @override
  String get voice_analysingWait =>
      'This may take up to 2 minutes on first use.';

  @override
  String get voice_slurringScore => 'Slurring Score';

  @override
  String get voice_riskTier => 'Risk Tier';

  @override
  String get voice_riskScore => 'Risk Score';

  @override
  String get voice_confidence => 'Confidence';

  @override
  String get voice_acousticSummary => 'Acoustic Summary';

  @override
  String get voice_speakingRate => 'Speaking Rate';

  @override
  String get voice_pitchMean => 'Pitch Mean';

  @override
  String get voice_pitchVariability => 'Pitch Variability';

  @override
  String get voice_pauseRatio => 'Pause Ratio';

  @override
  String get voice_voicingRatio => 'Voicing Ratio';

  @override
  String get voice_severe =>
      'Significant speech impairment detected. Seek medical attention immediately.';

  @override
  String get voice_moderate =>
      'Notable speech irregularities detected. Medical consultation recommended.';

  @override
  String get voice_mild =>
      'Slight speech irregularities detected. Consider retesting or monitoring.';

  @override
  String get voice_normal =>
      'Speech patterns are within normal range. No significant slurring detected.';

  @override
  String voice_processedIn(String seconds) {
    return 'Processed in ${seconds}s';
  }

  @override
  String get motion_title => 'Arms Test';

  @override
  String motion_instruction(int seconds) {
    return 'Hold your phone flat with both arms extended. Keep it as steady as possible for $seconds seconds.';
  }

  @override
  String get motion_xTilt => 'X Tilt';

  @override
  String get motion_yTilt => 'Y Tilt';

  @override
  String get motion_timeLeft => 'Time Left';

  @override
  String motion_secondsRemaining(int seconds) {
    return '$seconds seconds remaining';
  }

  @override
  String get motion_tiltVariance => 'Tilt Variance';

  @override
  String get motion_driftScore => 'Drift Score';

  @override
  String get motion_samples => 'Samples';

  @override
  String get motion_abnormal =>
      'Significant arm drift detected. Seek medical attention immediately.';

  @override
  String get motion_borderline =>
      'Some instability detected. Retest recommended.';

  @override
  String get motion_normal => 'Arm stability is within normal range.';

  @override
  String get tap_title => 'Tap Test';

  @override
  String get tap_rightHand => 'Right Hand';

  @override
  String get tap_leftHand => 'Left Hand';

  @override
  String get tap_rightHandCaps => 'RIGHT HAND';

  @override
  String get tap_leftHandCaps => 'LEFT HAND';

  @override
  String get tap_rightInstruction =>
      'Use your RIGHT hand to tap the moving button as many times as you can in 20 seconds.';

  @override
  String get tap_leftInstruction =>
      'Use your LEFT hand to tap the moving button as many times as you can in 20 seconds.';

  @override
  String get tap_startRightTest => 'Start Right Hand Test';

  @override
  String get tap_startLeftTest => 'Start Left Hand Test';

  @override
  String tap_taps(int count) {
    return 'Taps: $count';
  }

  @override
  String tap_tapsCount(int count) {
    return '$count taps';
  }

  @override
  String get tap_rightDone => 'Right hand done!';

  @override
  String get tap_switchLeft => 'Now switch to your LEFT hand.';

  @override
  String tap_startingLeft(int seconds, String suffix) {
    return 'Starting left hand test in $seconds second$suffix…';
  }

  @override
  String get tap_asymmetryAnalysis => 'Asymmetry Analysis';

  @override
  String get tap_asymmetryIndex => 'Asymmetry Index';

  @override
  String get tap_assessment => 'Assessment';

  @override
  String get tap_lateralisedDeficit => 'Lateralised Deficit Detected';

  @override
  String get emergency_title => 'EMERGENCY';

  @override
  String emergency_callPrompt(String number) {
    return 'Seek immediate medical attention. Tap to call $number.';
  }

  @override
  String get emergency_suspectStroke =>
      'If you suspect a stroke, call emergency services immediately.';

  @override
  String emergency_numbers(String emergency, String ambulance) {
    return 'Emergency: $emergency | Ambulance: $ambulance';
  }

  @override
  String get disclaimer_title => 'Prototype Screening Tool';

  @override
  String get disclaimer_body =>
      'This application is for demonstration and research purposes only. It is not a medical device and does not provide a diagnosis. If you suspect a stroke, call emergency services immediately.';

  @override
  String get auth_welcomeBack => 'Welcome Back';

  @override
  String get auth_signInSubtitle => 'Sign in to access your screening results';

  @override
  String get auth_emailLabel => 'Email Address';

  @override
  String get auth_passwordLabel => 'Password';

  @override
  String get auth_fullNameLabel => 'Full Name';

  @override
  String get auth_forgotPassword => 'Forgot Password?';

  @override
  String get auth_signIn => 'Sign In';

  @override
  String get auth_signUp => 'Sign Up';

  @override
  String get auth_createAccount => 'Create Account';

  @override
  String get auth_noAccount => 'Don\'t have an account?';

  @override
  String get auth_hasAccount => 'Already have an account?';

  @override
  String get auth_joinStrokeMitra => 'Join Stroke Mitra';

  @override
  String get auth_signUpSubtitle =>
      'Create an account to securely store your screening results';

  @override
  String get auth_validEmail => 'Please enter a valid email';

  @override
  String get auth_validPassword => 'Password must be at least 6 characters';

  @override
  String get auth_validName => 'Please enter your full name';

  @override
  String get auth_resetPassword => 'Reset Password';

  @override
  String get auth_resetSubtitle =>
      'Enter your email and we\'ll send you a link to reset your password';

  @override
  String get auth_sendResetLink => 'Send Reset Link';

  @override
  String get auth_checkEmail => 'Check Your Email';

  @override
  String auth_resetLinkSent(String email) {
    return 'We sent a password reset link to\n$email';
  }

  @override
  String get auth_backToLogin => 'Back to Login';

  @override
  String get profile_title => 'My Profile';

  @override
  String get profile_memberSince => 'Member Since';

  @override
  String get profile_testsTaken => 'Tests Taken';

  @override
  String get profile_lastCheck => 'Last Check';

  @override
  String get profile_baselinePhoto => 'Baseline Photo';

  @override
  String get profile_baselineSubtitle =>
      'Used as reference for face symmetry analysis.';

  @override
  String get profile_noBaseline => 'No baseline photo yet';

  @override
  String get profile_captureBaseline =>
      'Capture one from the Face Analysis page.';

  @override
  String get profile_appearance => 'Appearance';

  @override
  String get profile_appearanceSubtitle => 'Choose your preferred theme.';

  @override
  String get profile_language => 'Language';

  @override
  String get profile_languageSubtitle => 'Choose your preferred language.';

  @override
  String get profile_account => 'Account';

  @override
  String get profile_signOut => 'Sign Out';

  @override
  String get profile_privacy =>
      'Your data is securely stored and private to you.';

  @override
  String get profile_notFound => 'Profile not found';

  @override
  String profile_errorLoading(String error) {
    return 'Error loading profile: $error';
  }

  @override
  String get profile_themeSystem => 'System';

  @override
  String get profile_themeLight => 'Light';

  @override
  String get profile_themeDark => 'Dark';

  @override
  String get checkup_fullCheckup => 'Full Check-up';

  @override
  String get checkup_exitTitle => 'Exit Full Check-up?';

  @override
  String get checkup_exitMessage =>
      'Your progress will be lost. Are you sure you want to exit?';

  @override
  String get checkup_stay => 'Stay';

  @override
  String get checkup_exit => 'Exit';

  @override
  String get checkup_exitTooltip => 'Exit check-up';

  @override
  String get checkup_reportTitle => 'Check-up Report';

  @override
  String get checkup_noCheckupFound => 'No completed check-up found.';

  @override
  String get checkup_goHome => 'Go Home';

  @override
  String get checkup_downloadPdf => 'Download PDF Report';

  @override
  String get checkup_backToHome => 'Back to Home';

  @override
  String get checkup_faceAnalysis => 'Face Analysis';

  @override
  String get checkup_voiceCheck => 'Voice Check';

  @override
  String get checkup_motionTest => 'Motion Test';

  @override
  String get checkup_tapTest => 'Tap Test';

  @override
  String checkup_overallRisk(String risk) {
    return 'Overall: $risk';
  }

  @override
  String get checkup_riskAbnormalMessage =>
      'One or more tests indicate potential stroke signs. Please seek medical attention immediately.';

  @override
  String get checkup_riskBorderlineMessage =>
      'Some tests show borderline results. Consider consulting a healthcare provider.';

  @override
  String get checkup_riskNormalMessage =>
      'All tests are within normal range. No significant stroke indicators detected.';

  @override
  String get checkup_fullCheckupReport => 'Full Check-up Report';

  @override
  String get checkup_overallRiskLabel => 'Overall Risk: ';

  @override
  String get checkup_noRiskFactors => 'No risk factors detected';

  @override
  String get checkup_detectedConditions => 'Detected Conditions';

  @override
  String get checkup_stepFace => 'Face';

  @override
  String get checkup_stepVoice => 'Voice';

  @override
  String get checkup_stepMotion => 'Motion';

  @override
  String get checkup_stepTap => 'Tap';

  @override
  String get medicalReport_title => 'Medical Reports';

  @override
  String get medicalReport_uploadTitle => 'Upload Medical Report';

  @override
  String get medicalReport_supportedFormat =>
      'Supported format: PDF · Max 10MB';

  @override
  String get medicalReport_choosePdf => 'Choose PDF File';

  @override
  String get medicalReport_uploading => 'Uploading...';

  @override
  String get medicalReport_fileSizeLimit => 'File exceeds 10MB limit.';

  @override
  String get medicalReport_couldNotOpenPdf => 'Could not open PDF.';

  @override
  String medicalReport_failedPdfLink(String error) {
    return 'Failed to get PDF link: $error';
  }

  @override
  String get medicalReport_analyzing => 'Analyzing report...';

  @override
  String get medicalReport_extracting =>
      'Extracting text and detecting risk factors';

  @override
  String get medicalReport_pastReports => 'Past Reports';

  @override
  String get medicalReport_noReports => 'No reports yet';

  @override
  String get medicalReport_uploadPrompt =>
      'Upload a PDF medical report to get started.';

  @override
  String get medicalReport_viewPdf => 'View PDF';

  @override
  String get landing_heroTitle1 => 'Detect Stroke Early.';

  @override
  String get landing_heroTitle2 => 'Save Lives.';

  @override
  String get landing_heroSubtitle =>
      'Stroke Mitra uses your device\'s camera, microphone, and motion sensors to check for early warning signs of stroke — privately, in under 60 seconds.';

  @override
  String get landing_trustPrivate => '100% Private';

  @override
  String get landing_trustFast => 'Under 60s';

  @override
  String get landing_trustNoData => 'No Data Stored';

  @override
  String get landing_scrollDown => 'Scroll down';

  @override
  String get landing_aiPowered => 'AI-Powered Screening';

  @override
  String get landing_aboutTag => 'About';

  @override
  String get landing_whatIsTitle => 'What is Stroke Mitra?';

  @override
  String get landing_whatIsSubtitle =>
      'Stroke Mitra is an AI-powered screening tool that helps identify early warning signs of stroke using your smartphone\'s built-in sensors — no special equipment needed.';

  @override
  String get landing_clinicallyInformed => 'Clinically Informed';

  @override
  String get landing_clinicallyDesc =>
      'Built on the FAST (Face, Arms, Speech, Time) framework used by medical professionals worldwide.';

  @override
  String get landing_deviceNative => 'Device-Native AI';

  @override
  String get landing_deviceDesc =>
      'Runs entirely on your device. No cloud uploads, no data retention. Your health data stays yours.';

  @override
  String get landing_forEveryone => 'For Everyone';

  @override
  String get landing_forEveryoneDesc =>
      'Designed for patients, caregivers, and healthcare workers. No medical training required.';

  @override
  String get landing_disclaimerPrefix => 'Medical Disclaimer: ';

  @override
  String get landing_disclaimerText =>
      'Stroke Mitra is a screening aid, not a diagnostic tool. Always call emergency services (112) immediately if you suspect a stroke.';

  @override
  String get landing_howItWorksTag => 'HOW IT WORKS';

  @override
  String get landing_howItWorksTitle => 'Three Simple Steps';

  @override
  String get landing_howItWorksSubtitle =>
      'Stroke Mitra walks you through a quick, guided screening — no medical knowledge needed.';

  @override
  String get landing_step1Title => 'Open & Start';

  @override
  String get landing_step1Desc =>
      'Launch the app and tap \'Start Screening\'. No registration or login required.';

  @override
  String get landing_step1Detail1 => 'Works on any modern smartphone';

  @override
  String get landing_step1Detail2 => 'No download needed';

  @override
  String get landing_step2Title => 'Complete 3 Quick Tests';

  @override
  String get landing_step2Desc =>
      'Follow the guided prompts for face, speech, and arm movement analysis.';

  @override
  String get landing_step2Detail1 => 'Face symmetry via camera';

  @override
  String get landing_step2Detail2 => 'Speech clarity via microphone';

  @override
  String get landing_step3Title => 'Get Instant Results';

  @override
  String get landing_step3Desc =>
      'View your screening summary with clear risk indicators and next steps.';

  @override
  String get landing_step3Detail1 => 'Color-coded risk levels';

  @override
  String get landing_step3Detail2 => 'Emergency guidance if needed';

  @override
  String get landing_featuresTag => 'FEATURES';

  @override
  String get landing_featuresTitle => 'Built for Speed. Designed for Trust.';

  @override
  String get landing_featuresSubtitle =>
      'Every feature is purpose-built to deliver accurate, fast, and private stroke screening.';

  @override
  String get landing_feat1Title => 'Camera-Based Facial Analysis';

  @override
  String get landing_feat1Desc =>
      'Real-time AI detection of facial asymmetry using your front camera. No special hardware needed.';

  @override
  String get landing_feat1Tag => 'Computer Vision';

  @override
  String get landing_feat2Title => 'Voice Recording & Speech Detection';

  @override
  String get landing_feat2Desc =>
      'Advanced NLP models analyze your speech for slurring, word-finding difficulty, and incoherence.';

  @override
  String get landing_feat2Tag => 'NLP + Audio AI';

  @override
  String get landing_feat3Title => 'Motion & Coordination Sensing';

  @override
  String get landing_feat3Desc =>
      'Gyroscope and accelerometer data assess arm drift and coordination — key neurological indicators.';

  @override
  String get landing_feat3Tag => 'Sensor Fusion';

  @override
  String get landing_feat4Title => 'Results in Under 60 Seconds';

  @override
  String get landing_feat4Desc =>
      'The entire screening process takes less than a minute, giving you fast answers when every second counts.';

  @override
  String get landing_feat4Tag => 'Real-Time';

  @override
  String get landing_feat5Title => 'Fully Private & Secure';

  @override
  String get landing_feat5Desc =>
      'All processing happens on your device. No video, audio, or personal data is ever uploaded or stored.';

  @override
  String get landing_feat5Tag => 'On-Device AI';

  @override
  String get landing_feat6Title => 'Clinically Guided Framework';

  @override
  String get landing_feat6Desc =>
      'Based on the medically validated FAST protocol, trusted by emergency responders globally.';

  @override
  String get landing_feat6Tag => 'Evidence-Based';

  @override
  String get landing_statsTag => 'THE STAKES';

  @override
  String get landing_statsTitle => 'Why Every Second Counts';

  @override
  String get landing_statsSubtitle =>
      'Stroke is the second leading cause of death worldwide. Early detection dramatically changes outcomes.';

  @override
  String get landing_stat1Label => 'Strokes occur globally each year';

  @override
  String get landing_stat2Label =>
      'Of strokes are preventable with early action';

  @override
  String get landing_stat3Label => 'Brain cells lost every minute untreated';

  @override
  String get landing_stat4Label =>
      'Better outcomes with treatment in first hour';

  @override
  String get landing_fastRemember => 'Remember ';

  @override
  String get landing_fastTitle => 'F.A.S.T.';

  @override
  String get landing_fastF => 'Face';

  @override
  String get landing_fastFDesc => 'Is one side drooping?';

  @override
  String get landing_fastA => 'Arms';

  @override
  String get landing_fastADesc => 'Can they raise both arms?';

  @override
  String get landing_fastS => 'Speech';

  @override
  String get landing_fastSDesc => 'Is speech slurred or strange?';

  @override
  String get landing_fastT => 'Time';

  @override
  String get landing_fastTDesc => 'Call 112 immediately!';

  @override
  String get landing_ctaTitle1 => 'Don\'t Wait. ';

  @override
  String get landing_ctaTitle2 => 'Act Now.';

  @override
  String get landing_ctaSubtitle =>
      'If you or someone near you shows stroke symptoms, every second matters. Start the Stroke Mitra check right now — it could save a life.';

  @override
  String get landing_ctaStart => 'Start Stroke Check Now';

  @override
  String get landing_ctaEmergency => 'Call 112 Emergency';

  @override
  String get landing_ctaFree =>
      'Free to use · No registration · Works on any modern smartphone';

  @override
  String get landing_footerTagline =>
      'Early detection. Better outcomes.\nEvery second counts.';

  @override
  String get landing_footerScreening => 'Screening';

  @override
  String get landing_footerLearn => 'Learn';

  @override
  String get landing_footerEmergency => 'Emergency';

  @override
  String get landing_footerWhatIs => 'What is Stroke Mitra';

  @override
  String get landing_footerHowItWorks => 'How It Works';

  @override
  String get landing_footerWhyEarly => 'Why Early Detection';

  @override
  String get landing_footerCall112 => 'Call 112';

  @override
  String get landing_footerAmbulance108 => 'Ambulance 108';

  @override
  String get landing_footerCopyright =>
      '© 2025 Stroke Mitra. Built with care for public health awareness.';

  @override
  String get landing_footerDisclaimer =>
      'This tool is for screening purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment.';

  @override
  String get landing_nav_checkSymptoms => 'Check Symptoms';

  @override
  String get landing_footer_faceAnalysis => 'Face Analysis';

  @override
  String get landing_footer_speechCheck => 'Speech Check';

  @override
  String get landing_footer_motionTest => 'Motion Test';

  @override
  String motion_secondsRemainingLabel(int seconds) {
    return '$seconds seconds remaining';
  }

  @override
  String get face_retry => 'Retry';

  @override
  String get medicalReport_noRiskFactors => 'No risk factors detected';

  @override
  String get medicalReport_detectedConditions => 'Detected Conditions';

  @override
  String get checkup_continueToVoice => 'Continue to Voice Check';

  @override
  String get checkup_continueToMotion => 'Continue to Motion Test';

  @override
  String get checkup_continueToTap => 'Continue to Tap Test';

  @override
  String get sos_emergencyTitle => 'Emergency SOS';

  @override
  String get sos_emergencySubtitle =>
      'Abnormal results detected. If you or someone nearby is experiencing stroke symptoms, call emergency services immediately.';

  @override
  String get sos_callAmbulance => 'Call Ambulance (108)';

  @override
  String get sos_callEmergency => 'Call Emergency (112)';

  @override
  String get sos_couldNotCall => 'Could not place call';

  @override
  String get hospital_sendToNearby => 'Send to Nearby Hospital';

  @override
  String get hospital_selectHospital => 'Select Hospital';

  @override
  String get hospital_finding => 'Finding nearest hospital...';

  @override
  String get hospital_loading => 'Loading hospitals...';

  @override
  String get hospital_confirmTitle => 'Send Alert to Hospital?';

  @override
  String hospital_confirmMessage(String name, String distance) {
    return 'Sending to: $name ($distance km away). Confirm?';
  }

  @override
  String get hospital_confirm => 'Send Alert';

  @override
  String get hospital_cancel => 'Cancel';

  @override
  String get hospital_sending => 'Sending alert...';

  @override
  String hospital_sent(String name) {
    return 'Alert sent successfully to $name';
  }

  @override
  String hospital_failed(String error) {
    return 'Failed to send alert: $error';
  }

  @override
  String get hospital_noNearby =>
      'No hospitals found within 50km. Showing 3 nearest hospitals.';

  @override
  String get hospital_locationError =>
      'Could not get your location. Please enable location services.';
}
