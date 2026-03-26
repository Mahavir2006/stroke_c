// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'Stroke Mitra';

  @override
  String get appTagline => 'स्ट्रोक लवकर ओळखा. जीव वाचवा.';

  @override
  String get common_startScreening => 'तपासणी सुरू करा';

  @override
  String get common_learnMore => 'अधिक जाणून घ्या';

  @override
  String get common_tryAgain => 'पुन्हा प्रयत्न करा';

  @override
  String get common_save => 'सेव्ह करा';

  @override
  String get common_cancel => 'रद्द करा';

  @override
  String get common_retry => 'पुन्हा प्रयत्न करा';

  @override
  String get common_back => 'मागे';

  @override
  String get common_next => 'पुढे';

  @override
  String get common_done => 'झालं';

  @override
  String get common_saveAndContinue => 'सेव्ह करा आणि पुढे जा';

  @override
  String get common_testAgain => 'पुन्हा तपासा';

  @override
  String get common_recordAgain => 'पुन्हा रेकॉर्ड करा';

  @override
  String get common_startTest => 'टेस्ट सुरू करा';

  @override
  String get common_stopEarly => 'लवकर थांबा';

  @override
  String get common_resultsSaved => 'निकाल सेव्ह झाले.';

  @override
  String get common_right => 'उजवा';

  @override
  String get common_left => 'डावा';

  @override
  String get nav_home => 'होम';

  @override
  String get nav_face => 'चेहरा';

  @override
  String get nav_voice => 'आवाज';

  @override
  String get nav_motion => 'हालचाल';

  @override
  String get nav_tap => 'टॅप';

  @override
  String get menu_profile => 'प्रोफाइल';

  @override
  String get menu_lightMode => 'लाइट मोड';

  @override
  String get menu_darkMode => 'डार्क मोड';

  @override
  String get menu_medicalReports => 'मेडिकल रिपोर्ट्स';

  @override
  String get dashboard_greetingMorning => 'सुप्रभात';

  @override
  String get dashboard_greetingAfternoon => 'शुभ दुपार';

  @override
  String get dashboard_greetingEvening => 'शुभ संध्याकाळ';

  @override
  String dashboard_greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get dashboard_readyCheck => 'आजच्या तपासणीसाठी तयार आहात?';

  @override
  String get dashboard_lastCheck => 'शेवटची तपासणी';

  @override
  String get dashboard_status => 'स्थिती';

  @override
  String get dashboard_streak => 'स्ट्रीक';

  @override
  String get dashboard_allClear => 'सर्व ठीक आहे';

  @override
  String get dashboard_today => 'आज';

  @override
  String dashboard_days(int count) {
    return '$count दिवस';
  }

  @override
  String get dashboard_screeningTests => 'तपासणी टेस्ट्स';

  @override
  String get dashboard_startFullCheckup => 'पूर्ण तपासणी सुरू करा';

  @override
  String get dashboard_allTestsOneSession => 'एकाच वेळी सर्व ४ टेस्ट्स';

  @override
  String get dashboard_faceAnalysis => 'चेहऱ्याची तपासणी';

  @override
  String get dashboard_detectFacialDrooping => 'चेहऱ्याचं लटकणं ओळखा';

  @override
  String get dashboard_voiceCheck => 'आवाज तपासणी';

  @override
  String get dashboard_analyzeSpeech => 'बोलण्याची स्पष्टता तपासा';

  @override
  String get dashboard_motionTest => 'हालचाल तपासणी';

  @override
  String get dashboard_assessArmStability => 'हाताची स्थिरता तपासा';

  @override
  String get dashboard_tapTest => 'टॅप टेस्ट';

  @override
  String get dashboard_fingerCoordination => 'बोटांचा समन्वय';

  @override
  String get face_title => 'चेहऱ्याची तपासणी';

  @override
  String get face_stepBaseline => 'स्टेप १ — बेसलाइन फोटो घ्या';

  @override
  String get face_stepTest => 'स्टेप २ — टेस्ट फोटो घ्या';

  @override
  String get face_stepResult => 'स्टेप ३ — निकाल';

  @override
  String get face_baselineInstruction =>
      'सामान्य चेहऱ्याने तुमचा बेसलाइन फोटो घ्या.';

  @override
  String get face_testInstruction =>
      'आता बेसलाइनशी तुलना करण्यासाठी टेस्ट फोटो घ्या.';

  @override
  String get face_startingCamera => 'कॅमेरा सुरू होतोय...';

  @override
  String get face_alignFace => 'चेहरा ओव्हलमध्ये ठेवा';

  @override
  String get face_captureBaseline => 'बेसलाइन कॅप्चर करा';

  @override
  String get face_captureTestPhoto => 'टेस्ट फोटो कॅप्चर करा';

  @override
  String get face_faceDetected => 'चेहरा ओळखला';

  @override
  String get face_ovalAligned => 'ओव्हल जुळलं';

  @override
  String get face_poseValid => 'पोझ योग्य';

  @override
  String get face_lightingOk => 'प्रकाश ठीक आहे';

  @override
  String get face_processingBaseline => 'बेसलाइन प्रोसेस होतेय...';

  @override
  String get face_analyzingSymmetry => 'सममिती तपासतोय...';

  @override
  String get face_serverWarmup =>
      'सर्व्हर सुरू होत असेल तर यासाठी २ मिनिटं लागू शकतात.';

  @override
  String get face_normalResult =>
      'कोणतीही लक्षणीय असममिती आढळली नाही. चेहऱ्याची सममिती सामान्य दिसतेय.';

  @override
  String get face_abnormalResult =>
      'चेहऱ्यात संभाव्य असममिती आढळली. कृपया लवकर डॉक्टरांचा सल्ला घ्या.';

  @override
  String get face_stepBaseline_label => 'बेसलाइन';

  @override
  String get face_stepTest_label => 'टेस्ट फोटो';

  @override
  String get face_stepResult_label => 'निकाल';

  @override
  String get face_cameraBlocked =>
      'कॅमेरा ब्लॉक आहे.\n\nब्राउझरच्या address bar मध्ये कॅमेरा/lock आयकॉन वर क्लिक करा → Allow करा → मग Retry वर टॅप करा.';

  @override
  String face_captureFailed(String error) {
    return 'कॅप्चर अयशस्वी: $error';
  }

  @override
  String get voice_title => 'आवाज तपासणी';

  @override
  String get voice_readSentence => 'खालचं वाक्य स्पष्टपणे वाचा:';

  @override
  String get voice_startRecording => 'रेकॉर्डिंग सुरू करा';

  @override
  String get voice_stopRecording => 'रेकॉर्डिंग थांबवा';

  @override
  String voice_recordingComplete(String duration) {
    return 'रेकॉर्डिंग पूर्ण (${duration}s)';
  }

  @override
  String get voice_playRecording => 'रेकॉर्डिंग ऐका';

  @override
  String get voice_analyseSpeech => 'बोलणं तपासा';

  @override
  String get voice_analysing => 'तुमचं बोलणं तपासतोय...';

  @override
  String get voice_analysingWait =>
      'पहिल्यांदा वापरताना यासाठी २ मिनिटं लागू शकतात.';

  @override
  String get voice_slurringScore => 'अस्पष्टता स्कोअर';

  @override
  String get voice_riskTier => 'रिस्क लेव्हल';

  @override
  String get voice_riskScore => 'रिस्क स्कोअर';

  @override
  String get voice_confidence => 'विश्वसनीयता';

  @override
  String get voice_acousticSummary => 'ध्वनी सारांश';

  @override
  String get voice_speakingRate => 'बोलण्याचा वेग';

  @override
  String get voice_pitchMean => 'पिच सरासरी';

  @override
  String get voice_pitchVariability => 'पिच बदल';

  @override
  String get voice_pauseRatio => 'विराम प्रमाण';

  @override
  String get voice_voicingRatio => 'आवाज प्रमाण';

  @override
  String get voice_severe =>
      'बोलण्यात गंभीर अडथळा आढळला. तातडीने वैद्यकीय मदत घ्या.';

  @override
  String get voice_moderate =>
      'बोलण्यात लक्षणीय अनियमितता आढळली. डॉक्टरांचा सल्ला घ्या.';

  @override
  String get voice_mild =>
      'बोलण्यात थोडी अनियमितता आढळली. पुन्हा तपासा किंवा लक्ष ठेवा.';

  @override
  String get voice_normal =>
      'बोलणं सामान्य आहे. कोणतीही लक्षणीय अस्पष्टता आढळली नाही.';

  @override
  String voice_processedIn(String seconds) {
    return '${seconds}s मध्ये प्रोसेस झालं';
  }

  @override
  String get motion_title => 'हातांची तपासणी';

  @override
  String motion_instruction(int seconds) {
    return 'फोन दोन्ही हातांनी सरळ धरा. $seconds सेकंद शक्य तितका स्थिर ठेवा.';
  }

  @override
  String get motion_xTilt => 'X कलणं';

  @override
  String get motion_yTilt => 'Y कलणं';

  @override
  String get motion_timeLeft => 'वेळ बाकी';

  @override
  String motion_secondsRemaining(int seconds) {
    return '$seconds सेकंद बाकी';
  }

  @override
  String get motion_tiltVariance => 'कलणं फरक';

  @override
  String get motion_driftScore => 'ड्रिफ्ट स्कोअर';

  @override
  String get motion_samples => 'सॅम्पल्स';

  @override
  String get motion_abnormal =>
      'हातांमध्ये लक्षणीय ड्रिफ्ट आढळलं. तातडीने वैद्यकीय मदत घ्या.';

  @override
  String get motion_borderline => 'काही अस्थिरता आढळली. पुन्हा तपासणं चांगलं.';

  @override
  String get motion_normal => 'हातांची स्थिरता सामान्य आहे.';

  @override
  String get tap_title => 'टॅप टेस्ट';

  @override
  String get tap_rightHand => 'उजवा हात';

  @override
  String get tap_leftHand => 'डावा हात';

  @override
  String get tap_rightHandCaps => 'उजवा हात';

  @override
  String get tap_leftHandCaps => 'डावा हात';

  @override
  String get tap_rightInstruction =>
      'तुमच्या उजव्या हाताने २० सेकंदात शक्य तितक्या वेळा हलणाऱ्या बटणावर टॅप करा.';

  @override
  String get tap_leftInstruction =>
      'तुमच्या डाव्या हाताने २० सेकंदात शक्य तितक्या वेळा हलणाऱ्या बटणावर टॅप करा.';

  @override
  String get tap_startRightTest => 'उजव्या हाताची टेस्ट सुरू करा';

  @override
  String get tap_startLeftTest => 'डाव्या हाताची टेस्ट सुरू करा';

  @override
  String tap_taps(int count) {
    return 'टॅप्स: $count';
  }

  @override
  String tap_tapsCount(int count) {
    return '$count टॅप्स';
  }

  @override
  String get tap_rightDone => 'उजव्या हाताचं झालं!';

  @override
  String get tap_switchLeft => 'आता डाव्या हाताने करा.';

  @override
  String tap_startingLeft(int seconds, String suffix) {
    return 'डाव्या हाताची टेस्ट $seconds सेकंदात सुरू होतेय$suffix…';
  }

  @override
  String get tap_asymmetryAnalysis => 'असममिती विश्लेषण';

  @override
  String get tap_asymmetryIndex => 'असममिती निर्देशांक';

  @override
  String get tap_assessment => 'मूल्यांकन';

  @override
  String get tap_lateralisedDeficit => 'एकतर्फी कमतरता आढळली';

  @override
  String get emergency_title => 'आणीबाणी';

  @override
  String emergency_callPrompt(String number) {
    return 'तातडीने वैद्यकीय मदत घ्या. कॉल करण्यासाठी $number वर टॅप करा.';
  }

  @override
  String get emergency_suspectStroke =>
      'तुम्हाला स्ट्रोकचा संशय असल्यास, लगेच इमर्जन्सी सर्व्हिसेस ला कॉल करा.';

  @override
  String emergency_numbers(String emergency, String ambulance) {
    return 'इमर्जन्सी: $emergency | अँब्युलन्स: $ambulance';
  }

  @override
  String get disclaimer_title => 'प्रोटोटाइप स्क्रीनिंग टूल';

  @override
  String get disclaimer_body =>
      'हे अॅप फक्त डेमो आणि रिसर्चसाठी आहे. हे मेडिकल डिव्हाइस नाही आणि हे निदान देत नाही. तुम्हाला स्ट्रोकचा संशय असल्यास, लगेच इमर्जन्सी सर्व्हिसेस ला कॉल करा.';

  @override
  String get auth_welcomeBack => 'पुन्हा स्वागत आहे';

  @override
  String get auth_signInSubtitle => 'तुमचे तपासणी निकाल बघण्यासाठी साइन इन करा';

  @override
  String get auth_emailLabel => 'ईमेल अॅड्रेस';

  @override
  String get auth_passwordLabel => 'पासवर्ड';

  @override
  String get auth_fullNameLabel => 'पूर्ण नाव';

  @override
  String get auth_forgotPassword => 'पासवर्ड विसरलात?';

  @override
  String get auth_signIn => 'साइन इन';

  @override
  String get auth_signUp => 'साइन अप';

  @override
  String get auth_createAccount => 'अकाउंट बनवा';

  @override
  String get auth_noAccount => 'अकाउंट नाही?';

  @override
  String get auth_hasAccount => 'आधीच अकाउंट आहे?';

  @override
  String get auth_joinStrokeMitra => 'Stroke Mitra मध्ये सामील व्हा';

  @override
  String get auth_signUpSubtitle =>
      'तुमचे तपासणी निकाल सुरक्षित ठेवण्यासाठी अकाउंट बनवा';

  @override
  String get auth_validEmail => 'कृपया योग्य ईमेल टाका';

  @override
  String get auth_validPassword => 'पासवर्ड किमान ६ अक्षरांचा असावा';

  @override
  String get auth_validName => 'कृपया तुमचं पूर्ण नाव टाका';

  @override
  String get auth_resetPassword => 'पासवर्ड रिसेट करा';

  @override
  String get auth_resetSubtitle =>
      'तुमचा ईमेल टाका, आम्ही तुम्हाला पासवर्ड रिसेट लिंक पाठवू';

  @override
  String get auth_sendResetLink => 'रिसेट लिंक पाठवा';

  @override
  String get auth_checkEmail => 'तुमचा ईमेल तपासा';

  @override
  String auth_resetLinkSent(String email) {
    return 'आम्ही पासवर्ड रिसेट लिंक पाठवली आहे\n$email';
  }

  @override
  String get auth_backToLogin => 'लॉगिन वर परत जा';

  @override
  String get profile_title => 'माझं प्रोफाइल';

  @override
  String get profile_memberSince => 'सदस्य कधीपासून';

  @override
  String get profile_testsTaken => 'केलेल्या तपासण्या';

  @override
  String get profile_lastCheck => 'शेवटची तपासणी';

  @override
  String get profile_baselinePhoto => 'बेसलाइन फोटो';

  @override
  String get profile_baselineSubtitle =>
      'चेहऱ्याच्या सममिती तपासणीसाठी रेफरन्स म्हणून वापरला जातो.';

  @override
  String get profile_noBaseline => 'अजून बेसलाइन फोटो नाही';

  @override
  String get profile_captureBaseline =>
      'चेहऱ्याच्या तपासणी पेजवरून एक कॅप्चर करा.';

  @override
  String get profile_appearance => 'दिसणं';

  @override
  String get profile_appearanceSubtitle => 'तुमची आवडती थीम निवडा.';

  @override
  String get profile_language => 'भाषा';

  @override
  String get profile_languageSubtitle => 'तुमची आवडती भाषा निवडा.';

  @override
  String get profile_account => 'अकाउंट';

  @override
  String get profile_signOut => 'साइन आउट';

  @override
  String get profile_privacy =>
      'तुमचा डेटा सुरक्षित आहे आणि फक्त तुम्हालाच दिसतो.';

  @override
  String get profile_notFound => 'प्रोफाइल सापडलं नाही';

  @override
  String profile_errorLoading(String error) {
    return 'प्रोफाइल लोड करताना एरर: $error';
  }

  @override
  String get profile_themeSystem => 'सिस्टम';

  @override
  String get profile_themeLight => 'लाइट';

  @override
  String get profile_themeDark => 'डार्क';

  @override
  String get checkup_fullCheckup => 'पूर्ण तपासणी';

  @override
  String get checkup_exitTitle => 'पूर्ण तपासणी बंद करायची?';

  @override
  String get checkup_exitMessage => 'तुमची प्रगती गमावली जाईल. खात्री आहे?';

  @override
  String get checkup_stay => 'थांबा';

  @override
  String get checkup_exit => 'बाहेर जा';

  @override
  String get checkup_exitTooltip => 'तपासणी बंद करा';

  @override
  String get checkup_reportTitle => 'तपासणी अहवाल';

  @override
  String get checkup_noCheckupFound => 'पूर्ण तपासणी सापडली नाही.';

  @override
  String get checkup_goHome => 'होम वर जा';

  @override
  String get checkup_downloadPdf => 'PDF अहवाल डाउनलोड करा';

  @override
  String get checkup_backToHome => 'होम वर परत जा';

  @override
  String get checkup_faceAnalysis => 'चेहरा विश्लेषण';

  @override
  String get checkup_voiceCheck => 'आवाज तपासणी';

  @override
  String get checkup_motionTest => 'मोशन चाचणी';

  @override
  String get checkup_tapTest => 'टॅप चाचणी';

  @override
  String checkup_overallRisk(String risk) {
    return 'एकूण: $risk';
  }

  @override
  String get checkup_riskAbnormalMessage =>
      'एक किंवा अधिक चाचण्यांमध्ये संभाव्य स्ट्रोक चिन्हे आढळली. कृपया तातडीने वैद्यकीय मदत घ्या.';

  @override
  String get checkup_riskBorderlineMessage =>
      'काही चाचण्या सीमारेषेवरील निकाल दर्शवतात. आरोग्य सेवा प्रदात्याचा सल्ला घ्या.';

  @override
  String get checkup_riskNormalMessage =>
      'सर्व चाचण्या सामान्य श्रेणीत आहेत. कोणतेही महत्त्वपूर्ण स्ट्रोक संकेत आढळले नाहीत.';

  @override
  String get checkup_fullCheckupReport => 'संपूर्ण तपासणी अहवाल';

  @override
  String get checkup_overallRiskLabel => 'एकूण धोका: ';

  @override
  String get checkup_noRiskFactors => 'कोणतेही धोक्याचे घटक आढळले नाहीत';

  @override
  String get checkup_detectedConditions => 'आढळलेल्या स्थिती';

  @override
  String get checkup_stepFace => 'चेहरा';

  @override
  String get checkup_stepVoice => 'आवाज';

  @override
  String get checkup_stepMotion => 'मोशन';

  @override
  String get checkup_stepTap => 'टॅप';

  @override
  String get medicalReport_title => 'वैद्यकीय अहवाल';

  @override
  String get medicalReport_uploadTitle => 'वैद्यकीय अहवाल अपलोड करा';

  @override
  String get medicalReport_supportedFormat => 'समर्थित स्वरूप: PDF · कमाल 10MB';

  @override
  String get medicalReport_choosePdf => 'PDF फाइल निवडा';

  @override
  String get medicalReport_uploading => 'अपलोड होत आहे...';

  @override
  String get medicalReport_fileSizeLimit => 'फाइल 10MB मर्यादेपेक्षा मोठी आहे.';

  @override
  String get medicalReport_couldNotOpenPdf => 'PDF उघडता आले नाही.';

  @override
  String medicalReport_failedPdfLink(String error) {
    return 'PDF लिंक मिळवता आली नाही: $error';
  }

  @override
  String get medicalReport_analyzing => 'अहवालाचे विश्लेषण होत आहे...';

  @override
  String get medicalReport_extracting => 'मजकूर काढणे आणि धोक्याचे घटक शोधणे';

  @override
  String get medicalReport_pastReports => 'मागील अहवाल';

  @override
  String get medicalReport_noReports => 'अजून कोणतेही अहवाल नाहीत';

  @override
  String get medicalReport_uploadPrompt =>
      'सुरू करण्यासाठी PDF वैद्यकीय अहवाल अपलोड करा.';

  @override
  String get medicalReport_viewPdf => 'PDF पहा';

  @override
  String get landing_heroTitle1 => 'स्ट्रोक लवकर ओळखा.';

  @override
  String get landing_heroTitle2 => 'जीव वाचवा.';

  @override
  String get landing_heroSubtitle =>
      'Stroke Mitra तुमच्या फोनचा कॅमेरा, माइक्रोफोन आणि मोशन सेन्सर वापरून स्ट्रोकची लवकर लक्षणं तपासतो — प्रायव्हेटली, ६० सेकंदात.';

  @override
  String get landing_trustPrivate => '१००% प्रायव्हेट';

  @override
  String get landing_trustFast => '६० सेकंदात';

  @override
  String get landing_trustNoData => 'डेटा स्टोअर होत नाही';

  @override
  String get landing_scrollDown => 'खाली स्क्रोल करा';

  @override
  String get landing_aiPowered => 'AI-Powered स्क्रीनिंग';

  @override
  String get landing_aboutTag => 'माहिती';

  @override
  String get landing_whatIsTitle => 'Stroke Mitra म्हणजे काय?';

  @override
  String get landing_whatIsSubtitle =>
      'Stroke Mitra हे AI-powered स्क्रीनिंग टूल आहे जे तुमच्या स्मार्टफोनच्या बिल्ट-इन सेन्सर वापरून स्ट्रोकची लवकर लक्षणं ओळखायला मदत करतं — कोणत्याही विशेष उपकरणाची गरज नाही.';

  @override
  String get landing_clinicallyInformed => 'वैद्यकीयदृष्ट्या माहितीपूर्ण';

  @override
  String get landing_clinicallyDesc =>
      'जगभरातील डॉक्टर वापरतात त्या FAST (Face, Arms, Speech, Time) फ्रेमवर्कवर आधारित.';

  @override
  String get landing_deviceNative => 'Device-Native AI';

  @override
  String get landing_deviceDesc =>
      'पूर्णपणे तुमच्या डिव्हाइसवर चालतं. कोणताही डेटा क्लाउडवर जात नाही. तुमचा हेल्थ डेटा तुमच्याकडेच राहतो.';

  @override
  String get landing_forEveryone => 'सगळ्यांसाठी';

  @override
  String get landing_forEveryoneDesc =>
      'रुग्ण, काळजीवाहक आणि आरोग्य कर्मचाऱ्यांसाठी बनवलेलं. कोणत्याही मेडिकल ट्रेनिंगची गरज नाही.';

  @override
  String get landing_disclaimerPrefix => 'वैद्यकीय सूचना: ';

  @override
  String get landing_disclaimerText =>
      'Stroke Mitra हे फक्त स्क्रीनिंग साधन आहे, निदान साधन नाही. तुम्हाला स्ट्रोकचा संशय असल्यास लगेच इमर्जन्सी सर्व्हिसेस (112) ला कॉल करा.';

  @override
  String get landing_howItWorksTag => 'कसं काम करतं';

  @override
  String get landing_howItWorksTitle => 'तीन सोप्या स्टेप्स';

  @override
  String get landing_howItWorksSubtitle =>
      'Stroke Mitra तुम्हाला एका झटपट, गाइडेड स्क्रीनिंगमधून घेऊन जातं — कोणत्याही मेडिकल ज्ञानाची गरज नाही.';

  @override
  String get landing_step1Title => 'ओपन करा आणि सुरू करा';

  @override
  String get landing_step1Desc =>
      'अॅप उघडा आणि \'तपासणी सुरू करा\' वर टॅप करा. कोणतंही रजिस्ट्रेशन किंवा लॉगिन लागत नाही.';

  @override
  String get landing_step1Detail1 => 'कोणत्याही आधुनिक स्मार्टफोनवर चालतं';

  @override
  String get landing_step1Detail2 => 'डाउनलोडची गरज नाही';

  @override
  String get landing_step2Title => '३ झटपट टेस्ट्स पूर्ण करा';

  @override
  String get landing_step2Desc =>
      'चेहरा, बोलणं आणि हाताच्या हालचालींच्या तपासणीसाठी गाइडेड सूचना फॉलो करा.';

  @override
  String get landing_step2Detail1 => 'कॅमेऱ्याने चेहऱ्याची सममिती';

  @override
  String get landing_step2Detail2 => 'माइक्रोफोनने बोलण्याची स्पष्टता';

  @override
  String get landing_step3Title => 'तात्काळ निकाल मिळवा';

  @override
  String get landing_step3Desc =>
      'स्पष्ट रिस्क इंडिकेटर्स आणि पुढील स्टेप्ससह तुमचा स्क्रीनिंग सारांश बघा.';

  @override
  String get landing_step3Detail1 => 'रंग-कोडेड रिस्क लेव्हल्स';

  @override
  String get landing_step3Detail2 => 'गरज असल्यास इमर्जन्सी मार्गदर्शन';

  @override
  String get landing_featuresTag => 'फीचर्स';

  @override
  String get landing_featuresTitle =>
      'वेगासाठी बनवलेलं. विश्वासासाठी डिझाइन केलेलं.';

  @override
  String get landing_featuresSubtitle =>
      'प्रत्येक फीचर अचूक, वेगवान आणि प्रायव्हेट स्ट्रोक स्क्रीनिंग देण्यासाठी बनवलेलं आहे.';

  @override
  String get landing_feat1Title => 'कॅमेरा-बेस्ड चेहरा तपासणी';

  @override
  String get landing_feat1Desc =>
      'तुमच्या फ्रंट कॅमेऱ्याने चेहऱ्याच्या असममितीचा रिअल-टाइम AI डिटेक्शन. कोणत्याही विशेष हार्डवेअरची गरज नाही.';

  @override
  String get landing_feat1Tag => 'Computer Vision';

  @override
  String get landing_feat2Title => 'व्हॉइस रेकॉर्डिंग आणि स्पीच डिटेक्शन';

  @override
  String get landing_feat2Desc =>
      'अॅडव्हान्स NLP मॉडेल्स तुमच्या बोलण्यात अस्पष्टता, शब्द शोधण्यात अडचण आणि असंबद्धता तपासतात.';

  @override
  String get landing_feat2Tag => 'NLP + Audio AI';

  @override
  String get landing_feat3Title => 'हालचाल आणि समन्वय सेन्सिंग';

  @override
  String get landing_feat3Desc =>
      'जायरोस्कोप आणि अॅक्सेलेरोमीटर डेटा हाताचं ड्रिफ्ट आणि समन्वय तपासतो — हे महत्त्वाचे न्यूरोलॉजिकल इंडिकेटर्स आहेत.';

  @override
  String get landing_feat3Tag => 'Sensor Fusion';

  @override
  String get landing_feat4Title => '६० सेकंदात निकाल';

  @override
  String get landing_feat4Desc =>
      'पूर्ण स्क्रीनिंग प्रक्रिया एक मिनिटापेक्षा कमी वेळात होते, जेव्हा प्रत्येक सेकंद महत्त्वाचा आहे तेव्हा तुम्हाला वेगवान उत्तरं देते.';

  @override
  String get landing_feat4Tag => 'Real-Time';

  @override
  String get landing_feat5Title => 'पूर्णपणे प्रायव्हेट आणि सुरक्षित';

  @override
  String get landing_feat5Desc =>
      'सर्व प्रोसेसिंग तुमच्या डिव्हाइसवर होतं. कोणताही व्हिडिओ, ऑडिओ किंवा वैयक्तिक डेटा कधीही अपलोड किंवा स्टोअर होत नाही.';

  @override
  String get landing_feat5Tag => 'On-Device AI';

  @override
  String get landing_feat6Title => 'वैद्यकीय मार्गदर्शित फ्रेमवर्क';

  @override
  String get landing_feat6Desc =>
      'जगभरातील इमर्जन्सी रिस्पॉन्डर्सनी विश्वास ठेवलेल्या वैद्यकीयदृष्ट्या प्रमाणित FAST प्रोटोकॉलवर आधारित.';

  @override
  String get landing_feat6Tag => 'Evidence-Based';

  @override
  String get landing_statsTag => 'धोका';

  @override
  String get landing_statsTitle => 'प्रत्येक सेकंद का महत्त्वाचा आहे';

  @override
  String get landing_statsSubtitle =>
      'स्ट्रोक हे जगभरात मृत्यूचं दुसरं प्रमुख कारण आहे. लवकर ओळखणं निकाल पूर्णपणे बदलतं.';

  @override
  String get landing_stat1Label => 'दरवर्षी जगभरात स्ट्रोक होतात';

  @override
  String get landing_stat2Label => 'स्ट्रोक लवकर कृतीने टाळता येतात';

  @override
  String get landing_stat3Label =>
      'उपचाराशिवाय दर मिनिटाला मेंदूच्या पेशी नष्ट होतात';

  @override
  String get landing_stat4Label => 'पहिल्या तासात उपचार मिळाल्यास चांगले निकाल';

  @override
  String get landing_fastRemember => 'लक्षात ठेवा ';

  @override
  String get landing_fastTitle => 'F.A.S.T.';

  @override
  String get landing_fastF => 'Face (चेहरा)';

  @override
  String get landing_fastFDesc => 'एक बाजू लटकतेय का?';

  @override
  String get landing_fastA => 'Arms (हात)';

  @override
  String get landing_fastADesc => 'दोन्ही हात वर करता येतात का?';

  @override
  String get landing_fastS => 'Speech (बोलणं)';

  @override
  String get landing_fastSDesc => 'बोलणं अस्पष्ट किंवा विचित्र आहे का?';

  @override
  String get landing_fastT => 'Time (वेळ)';

  @override
  String get landing_fastTDesc => 'लगेच 112 वर कॉल करा!';

  @override
  String get landing_ctaTitle1 => 'थांबू नका. ';

  @override
  String get landing_ctaTitle2 => 'आत्ताच कृती करा.';

  @override
  String get landing_ctaSubtitle =>
      'तुम्हाला किंवा तुमच्या जवळच्या कोणाला स्ट्रोकची लक्षणं दिसत असतील तर, प्रत्येक सेकंद महत्त्वाचा आहे. आत्ताच Stroke Mitra तपासणी सुरू करा — एक जीव वाचू शकतो.';

  @override
  String get landing_ctaStart => 'आत्ताच स्ट्रोक तपासणी सुरू करा';

  @override
  String get landing_ctaEmergency => '112 इमर्जन्सी कॉल करा';

  @override
  String get landing_ctaFree =>
      'मोफत · रजिस्ट्रेशन नाही · कोणत्याही आधुनिक स्मार्टफोनवर चालतं';

  @override
  String get landing_footerTagline =>
      'लवकर ओळखा. चांगले निकाल.\nप्रत्येक सेकंद महत्त्वाचा.';

  @override
  String get landing_footerScreening => 'तपासणी';

  @override
  String get landing_footerLearn => 'जाणून घ्या';

  @override
  String get landing_footerEmergency => 'आणीबाणी';

  @override
  String get landing_footerWhatIs => 'Stroke Mitra म्हणजे काय';

  @override
  String get landing_footerHowItWorks => 'कसं काम करतं';

  @override
  String get landing_footerWhyEarly => 'लवकर ओळखणं का महत्त्वाचं';

  @override
  String get landing_footerCall112 => '112 वर कॉल करा';

  @override
  String get landing_footerAmbulance108 => 'अँब्युलन्स 108';

  @override
  String get landing_footerCopyright =>
      '© 2025 Stroke Mitra. सार्वजनिक आरोग्य जागरूकतेसाठी काळजीपूर्वक बनवलेलं.';

  @override
  String get landing_footerDisclaimer =>
      'हे टूल फक्त स्क्रीनिंगसाठी आहे. हे व्यावसायिक वैद्यकीय सल्ला, निदान किंवा उपचारांचा पर्याय नाही.';

  @override
  String get landing_nav_checkSymptoms => 'लक्षणं तपासा';

  @override
  String get landing_footer_faceAnalysis => 'चेहरा तपासणी';

  @override
  String get landing_footer_speechCheck => 'बोलणं तपासणी';

  @override
  String get landing_footer_motionTest => 'हालचाल तपासणी';

  @override
  String motion_secondsRemainingLabel(int seconds) {
    return '$seconds सेकंद बाकी';
  }

  @override
  String get face_retry => 'पुन्हा प्रयत्न करा';

  @override
  String get medicalReport_noRiskFactors => 'कोणतेही धोक्याचे घटक आढळले नाहीत';

  @override
  String get medicalReport_detectedConditions => 'आढळलेल्या स्थिती';

  @override
  String get checkup_continueToVoice => 'आवाज तपासणीकडे जा';

  @override
  String get checkup_continueToMotion => 'हालचाल तपासणीकडे जा';

  @override
  String get checkup_continueToTap => 'टॅप टेस्टकडे जा';

  @override
  String get sos_emergencyTitle => 'आणीबाणी SOS';

  @override
  String get sos_emergencySubtitle =>
      'असामान्य निकाल आढळले आहेत. तुम्हाला किंवा तुमच्या जवळच्या कोणाला स्ट्रोकची लक्षणे जाणवत असल्यास, लगेच आणीबाणी सेवांना कॉल करा.';

  @override
  String get sos_callAmbulance => 'रुग्णवाहिका बोलवा (108)';

  @override
  String get sos_callEmergency => 'आणीबाणी कॉल करा (112)';

  @override
  String get sos_couldNotCall => 'कॉल करता आला नाही';

  @override
  String get hospital_sendToNearby => 'जवळच्या रुग्णालयाला पाठवा';

  @override
  String get hospital_selectHospital => 'रुग्णालय निवडा';

  @override
  String get hospital_finding => 'जवळचं रुग्णालय शोधत आहे...';

  @override
  String get hospital_loading => 'रुग्णालय लोड होत आहेत...';

  @override
  String get hospital_confirmTitle => 'रुग्णालयाला अलर्ट पाठवायचा?';

  @override
  String hospital_confirmMessage(String name, String distance) {
    return 'पाठवत आहे: $name ($distance किमी दूर). कन्फर्म करा?';
  }

  @override
  String get hospital_confirm => 'अलर्ट पाठवा';

  @override
  String get hospital_cancel => 'रद्द करा';

  @override
  String get hospital_sending => 'अलर्ट पाठवत आहे...';

  @override
  String hospital_sent(String name) {
    return '$name ला अलर्ट यशस्वीरित्या पाठवला';
  }

  @override
  String hospital_failed(String error) {
    return 'अलर्ट पाठवता आला नाही: $error';
  }

  @override
  String get hospital_noNearby =>
      '50 किमी मध्ये कोणतेही रुग्णालय सापडले नाही. 3 जवळचे रुग्णालय दाखवत आहे.';

  @override
  String get hospital_locationError =>
      'तुमचं लोकेशन मिळाले नाही. कृपया लोकेशन सर्व्हिसेस चालू करा.';
}
