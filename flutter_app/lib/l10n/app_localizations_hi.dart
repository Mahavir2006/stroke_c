// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'Stroke Mitra';

  @override
  String get appTagline => 'स्ट्रोक को जल्दी पहचानें। जिंदगी बचाएं।';

  @override
  String get common_startScreening => 'जांच शुरू करें';

  @override
  String get common_learnMore => 'और जानें';

  @override
  String get common_tryAgain => 'फिर से कोशिश करें';

  @override
  String get common_save => 'सेव करें';

  @override
  String get common_cancel => 'रद्द करें';

  @override
  String get common_retry => 'फिर से करें';

  @override
  String get common_back => 'वापस';

  @override
  String get common_next => 'आगे';

  @override
  String get common_done => 'हो गया';

  @override
  String get common_saveAndContinue => 'सेव करें और आगे बढ़ें';

  @override
  String get common_testAgain => 'फिर से टेस्ट करें';

  @override
  String get common_recordAgain => 'फिर से Record करें';

  @override
  String get common_startTest => 'टेस्ट शुरू करें';

  @override
  String get common_stopEarly => 'जल्दी रोकें';

  @override
  String get common_resultsSaved => 'रिज़ल्ट सेव हो गए।';

  @override
  String get common_right => 'दायां';

  @override
  String get common_left => 'बायां';

  @override
  String get nav_home => 'होम';

  @override
  String get nav_face => 'चेहरा';

  @override
  String get nav_voice => 'आवाज़';

  @override
  String get nav_motion => 'मोशन';

  @override
  String get nav_tap => 'टैप';

  @override
  String get menu_profile => 'प्रोफ़ाइल';

  @override
  String get menu_lightMode => 'लाइट मोड';

  @override
  String get menu_darkMode => 'डार्क मोड';

  @override
  String get menu_medicalReports => 'मेडिकल रिपोर्ट्स';

  @override
  String get dashboard_greetingMorning => 'सुप्रभात';

  @override
  String get dashboard_greetingAfternoon => 'नमस्कार';

  @override
  String get dashboard_greetingEvening => 'शुभ संध्या';

  @override
  String dashboard_greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get dashboard_readyCheck => 'आज की जांच के लिए तैयार हैं?';

  @override
  String get dashboard_lastCheck => 'पिछली जांच';

  @override
  String get dashboard_status => 'स्थिति';

  @override
  String get dashboard_streak => 'लगातार';

  @override
  String get dashboard_allClear => 'सब ठीक है';

  @override
  String get dashboard_today => 'आज';

  @override
  String dashboard_days(int count) {
    return '$count दिन';
  }

  @override
  String get dashboard_screeningTests => 'स्क्रीनिंग टेस्ट';

  @override
  String get dashboard_startFullCheckup => 'पूरी जांच शुरू करें';

  @override
  String get dashboard_allTestsOneSession => 'एक बार में सभी 4 टेस्ट';

  @override
  String get dashboard_faceAnalysis => 'चेहरे की जांच';

  @override
  String get dashboard_detectFacialDrooping => 'चेहरे की ढीलापन जांचें';

  @override
  String get dashboard_voiceCheck => 'आवाज़ की जांच';

  @override
  String get dashboard_analyzeSpeech => 'बोलने की स्पष्टता जांचें';

  @override
  String get dashboard_motionTest => 'मोशन टेस्ट';

  @override
  String get dashboard_assessArmStability => 'बाजू की स्थिरता जांचें';

  @override
  String get dashboard_tapTest => 'टैप टेस्ट';

  @override
  String get dashboard_fingerCoordination => 'उंगलियों का कोऑर्डिनेशन';

  @override
  String get face_title => 'चेहरे की जांच';

  @override
  String get face_stepBaseline => 'स्टेप 1 — बेसलाइन फोटो लें';

  @override
  String get face_stepTest => 'स्टेप 2 — टेस्ट फोटो लें';

  @override
  String get face_stepResult => 'स्टेप 3 — रिज़ल्ट';

  @override
  String get face_baselineInstruction =>
      'सामान्य चेहरे के भाव के साथ अपनी बेसलाइन फोटो लें।';

  @override
  String get face_testInstruction =>
      'अब बेसलाइन से तुलना के लिए एक टेस्ट फोटो लें।';

  @override
  String get face_startingCamera => 'Camera शुरू हो रहा है...';

  @override
  String get face_alignFace => 'चेहरे को ओवल के अंदर लाएं';

  @override
  String get face_captureBaseline => 'बेसलाइन कैप्चर करें';

  @override
  String get face_captureTestPhoto => 'टेस्ट फोटो कैप्चर करें';

  @override
  String get face_faceDetected => 'चेहरा मिल गया';

  @override
  String get face_ovalAligned => 'ओवल में सही है';

  @override
  String get face_poseValid => 'पोज़ सही है';

  @override
  String get face_lightingOk => 'लाइटिंग ठीक है';

  @override
  String get face_processingBaseline => 'बेसलाइन प्रोसेस हो रही है...';

  @override
  String get face_analyzingSymmetry => 'सिमेट्री जांची जा रही है...';

  @override
  String get face_serverWarmup =>
      'सर्वर शुरू हो रहा हो तो इसमें 2 मिनट तक लग सकते हैं।';

  @override
  String get face_normalResult =>
      'कोई खास असमानता नहीं मिली। चेहरे की सिमेट्री सामान्य दिख रही है।';

  @override
  String get face_abnormalResult =>
      'चेहरे में संभावित असमानता मिली है। कृपया जल्द किसी डॉक्टर से मिलें।';

  @override
  String get face_stepBaseline_label => 'बेसलाइन';

  @override
  String get face_stepTest_label => 'टेस्ट फोटो';

  @override
  String get face_stepResult_label => 'रिज़ल्ट';

  @override
  String get face_cameraBlocked =>
      'Camera ब्लॉक है।\n\nअपने ब्राउज़र के एड्रेस बार में Camera/Lock आइकन पर क्लिक करें → Allow करें → फिर Retry दबाएं।';

  @override
  String face_captureFailed(String error) {
    return 'कैप्चर नहीं हो पाया: $error';
  }

  @override
  String get voice_title => 'आवाज़ की जांच';

  @override
  String get voice_readSentence => 'नीचे दिया गया वाक्य साफ़ आवाज़ में पढ़ें:';

  @override
  String get voice_startRecording => 'Recording शुरू करें';

  @override
  String get voice_stopRecording => 'Recording बंद करें';

  @override
  String voice_recordingComplete(String duration) {
    return 'Recording पूरी हुई (${duration}s)';
  }

  @override
  String get voice_playRecording => 'Recording सुनें';

  @override
  String get voice_analyseSpeech => 'आवाज़ जांचें';

  @override
  String get voice_analysing => 'आपकी आवाज़ जांची जा रही है...';

  @override
  String get voice_analysingWait => 'पहली बार इसमें 2 मिनट तक लग सकते हैं।';

  @override
  String get voice_slurringScore => 'लड़खड़ाहट स्कोर';

  @override
  String get voice_riskTier => 'रिस्क लेवल';

  @override
  String get voice_riskScore => 'रिस्क स्कोर';

  @override
  String get voice_confidence => 'कॉन्फ़िडेंस';

  @override
  String get voice_acousticSummary => 'ध्वनि विश्लेषण';

  @override
  String get voice_speakingRate => 'बोलने की गति';

  @override
  String get voice_pitchMean => 'औसत पिच';

  @override
  String get voice_pitchVariability => 'पिच में बदलाव';

  @override
  String get voice_pauseRatio => 'रुकावट अनुपात';

  @override
  String get voice_voicingRatio => 'वॉइसिंग अनुपात';

  @override
  String get voice_severe =>
      'बोलने में गंभीर दिक्कत मिली है। तुरंत डॉक्टर को दिखाएं।';

  @override
  String get voice_moderate =>
      'बोलने में कुछ अनियमितताएं मिली हैं। डॉक्टर से सलाह लें।';

  @override
  String get voice_mild =>
      'बोलने में हल्की अनियमितता मिली है। दोबारा टेस्ट करें या ध्यान रखें।';

  @override
  String get voice_normal =>
      'आवाज़ बिल्कुल सामान्य है। कोई लड़खड़ाहट नहीं मिली।';

  @override
  String voice_processedIn(String seconds) {
    return '${seconds}s में प्रोसेस हुआ';
  }

  @override
  String get motion_title => 'बाजू का टेस्ट';

  @override
  String motion_instruction(int seconds) {
    return 'अपने फोन को दोनों हाथों से सीधा पकड़ें। इसे $seconds सेकंड तक जितना हो सके स्थिर रखें।';
  }

  @override
  String get motion_xTilt => 'X झुकाव';

  @override
  String get motion_yTilt => 'Y झुकाव';

  @override
  String get motion_timeLeft => 'बाकी समय';

  @override
  String motion_secondsRemaining(int seconds) {
    return '$seconds सेकंड बाकी';
  }

  @override
  String get motion_tiltVariance => 'झुकाव भिन्नता';

  @override
  String get motion_driftScore => 'ड्रिफ्ट स्कोर';

  @override
  String get motion_samples => 'सैंपल';

  @override
  String get motion_abnormal =>
      'बाजू में काफी ड्रिफ्ट मिली है। तुरंत डॉक्टर को दिखाएं।';

  @override
  String get motion_borderline => 'थोड़ी अस्थिरता मिली है। दोबारा टेस्ट करें।';

  @override
  String get motion_normal => 'बाजू की स्थिरता सामान्य है।';

  @override
  String get tap_title => 'टैप टेस्ट';

  @override
  String get tap_rightHand => 'दायां हाथ';

  @override
  String get tap_leftHand => 'बायां हाथ';

  @override
  String get tap_rightHandCaps => 'दायां हाथ';

  @override
  String get tap_leftHandCaps => 'बायां हाथ';

  @override
  String get tap_rightInstruction =>
      'अपने दाएं हाथ से 20 सेकंड में जितनी बार हो सके मूव होते बटन को टैप करें।';

  @override
  String get tap_leftInstruction =>
      'अपने बाएं हाथ से 20 सेकंड में जितनी बार हो सके मूव होते बटन को टैप करें।';

  @override
  String get tap_startRightTest => 'दाएं हाथ का टेस्ट शुरू करें';

  @override
  String get tap_startLeftTest => 'बाएं हाथ का टेस्ट शुरू करें';

  @override
  String tap_taps(int count) {
    return 'टैप: $count';
  }

  @override
  String tap_tapsCount(int count) {
    return '$count टैप';
  }

  @override
  String get tap_rightDone => 'दायां हाथ हो गया!';

  @override
  String get tap_switchLeft => 'अब बाएं हाथ से करें।';

  @override
  String tap_startingLeft(int seconds, String suffix) {
    return 'बाएं हाथ का टेस्ट $seconds सेकंड$suffix में शुरू होगा…';
  }

  @override
  String get tap_asymmetryAnalysis => 'असमानता विश्लेषण';

  @override
  String get tap_asymmetryIndex => 'असमानता इंडेक्स';

  @override
  String get tap_assessment => 'आकलन';

  @override
  String get tap_lateralisedDeficit => 'एक तरफ की कमज़ोरी मिली है';

  @override
  String get emergency_title => 'इमरजेंसी';

  @override
  String emergency_callPrompt(String number) {
    return 'तुरंत मेडिकल मदद लें। $number पर कॉल करने के लिए टैप करें।';
  }

  @override
  String get emergency_suspectStroke =>
      'अगर आपको स्ट्रोक का शक है तो तुरंत इमरजेंसी सेवाओं को कॉल करें।';

  @override
  String emergency_numbers(String emergency, String ambulance) {
    return 'इमरजेंसी: $emergency | एम्बुलेंस: $ambulance';
  }

  @override
  String get disclaimer_title => 'प्रोटोटाइप स्क्रीनिंग टूल';

  @override
  String get disclaimer_body =>
      'यह ऐप सिर्फ डेमो और रिसर्च के लिए है। यह कोई मेडिकल डिवाइस नहीं है और न ही यह कोई डायग्नोसिस देता है। अगर आपको स्ट्रोक का शक हो तो तुरंत इमरजेंसी सेवाओं को कॉल करें।';

  @override
  String get auth_welcomeBack => 'वापस आने पर स्वागत है';

  @override
  String get auth_signInSubtitle =>
      'अपने स्क्रीनिंग रिज़ल्ट देखने के लिए Sign In करें';

  @override
  String get auth_emailLabel => 'ईमेल एड्रेस';

  @override
  String get auth_passwordLabel => 'पासवर्ड';

  @override
  String get auth_fullNameLabel => 'पूरा नाम';

  @override
  String get auth_forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get auth_signIn => 'Sign In';

  @override
  String get auth_signUp => 'Sign Up';

  @override
  String get auth_createAccount => 'अकाउंट बनाएं';

  @override
  String get auth_noAccount => 'अकाउंट नहीं है?';

  @override
  String get auth_hasAccount => 'पहले से अकाउंट है?';

  @override
  String get auth_joinStrokeMitra => 'Stroke Mitra से जुड़ें';

  @override
  String get auth_signUpSubtitle =>
      'अपने स्क्रीनिंग रिज़ल्ट सुरक्षित रखने के लिए अकाउंट बनाएं';

  @override
  String get auth_validEmail => 'कृपया सही ईमेल डालें';

  @override
  String get auth_validPassword => 'पासवर्ड कम से कम 6 अक्षर का होना चाहिए';

  @override
  String get auth_validName => 'कृपया अपना पूरा नाम डालें';

  @override
  String get auth_resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get auth_resetSubtitle =>
      'अपना ईमेल डालें, हम आपको पासवर्ड रीसेट का लिंक भेजेंगे';

  @override
  String get auth_sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get auth_checkEmail => 'अपना ईमेल चेक करें';

  @override
  String auth_resetLinkSent(String email) {
    return 'हमने पासवर्ड रीसेट का लिंक भेज दिया है\n$email';
  }

  @override
  String get auth_backToLogin => 'Login पर वापस जाएं';

  @override
  String get profile_title => 'मेरी प्रोफ़ाइल';

  @override
  String get profile_memberSince => 'मेंबर बने';

  @override
  String get profile_testsTaken => 'टेस्ट किए गए';

  @override
  String get profile_lastCheck => 'पिछली जांच';

  @override
  String get profile_baselinePhoto => 'बेसलाइन फोटो';

  @override
  String get profile_baselineSubtitle =>
      'चेहरे की सिमेट्री जांच के लिए रेफ़रेंस फोटो।';

  @override
  String get profile_noBaseline => 'अभी बेसलाइन फोटो नहीं है';

  @override
  String get profile_captureBaseline =>
      'चेहरे की जांच पेज से बेसलाइन कैप्चर करें।';

  @override
  String get profile_appearance => 'दिखावट';

  @override
  String get profile_appearanceSubtitle => 'अपनी पसंद की थीम चुनें।';

  @override
  String get profile_language => 'भाषा';

  @override
  String get profile_languageSubtitle => 'अपनी पसंद की भाषा चुनें।';

  @override
  String get profile_account => 'अकाउंट';

  @override
  String get profile_signOut => 'Sign Out';

  @override
  String get profile_privacy => 'आपका डेटा सुरक्षित है और सिर्फ आपके लिए है।';

  @override
  String get profile_notFound => 'प्रोफ़ाइल नहीं मिली';

  @override
  String profile_errorLoading(String error) {
    return 'प्रोफ़ाइल लोड करने में दिक्कत: $error';
  }

  @override
  String get profile_themeSystem => 'सिस्टम';

  @override
  String get profile_themeLight => 'लाइट';

  @override
  String get profile_themeDark => 'डार्क';

  @override
  String get checkup_fullCheckup => 'पूरी जांच';

  @override
  String get checkup_exitTitle => 'पूरी जांच से बाहर निकलें?';

  @override
  String get checkup_exitMessage =>
      'आपकी प्रोग्रेस खो जाएगी। क्या आप सच में बाहर निकलना चाहते हैं?';

  @override
  String get checkup_stay => 'रुकें';

  @override
  String get checkup_exit => 'बाहर निकलें';

  @override
  String get checkup_exitTooltip => 'जांच से बाहर निकलें';

  @override
  String get checkup_reportTitle => 'जांच रिपोर्ट';

  @override
  String get checkup_noCheckupFound => 'कोई पूर्ण जांच नहीं मिली।';

  @override
  String get checkup_goHome => 'होम जाएं';

  @override
  String get checkup_downloadPdf => 'PDF रिपोर्ट डाउनलोड करें';

  @override
  String get checkup_backToHome => 'होम पर वापस जाएं';

  @override
  String get checkup_faceAnalysis => 'चेहरा विश्लेषण';

  @override
  String get checkup_voiceCheck => 'आवाज़ जांच';

  @override
  String get checkup_motionTest => 'मोशन टेस्ट';

  @override
  String get checkup_tapTest => 'टैप टेस्ट';

  @override
  String checkup_overallRisk(String risk) {
    return 'कुल: $risk';
  }

  @override
  String get checkup_riskAbnormalMessage =>
      'एक या अधिक परीक्षण संभावित स्ट्रोक संकेत दिखाते हैं। कृपया तुरंत चिकित्सा सहायता लें।';

  @override
  String get checkup_riskBorderlineMessage =>
      'कुछ परीक्षण सीमा रेखा परिणाम दिखाते हैं। स्वास्थ्य सेवा प्रदाता से परामर्श करें।';

  @override
  String get checkup_riskNormalMessage =>
      'सभी परीक्षण सामान्य सीमा में हैं। कोई महत्वपूर्ण स्ट्रोक संकेतक नहीं मिले।';

  @override
  String get checkup_fullCheckupReport => 'पूर्ण जांच रिपोर्ट';

  @override
  String get checkup_overallRiskLabel => 'कुल जोखिम: ';

  @override
  String get checkup_noRiskFactors => 'कोई जोखिम कारक नहीं मिले';

  @override
  String get checkup_detectedConditions => 'पाई गई स्थितियां';

  @override
  String get checkup_stepFace => 'चेहरा';

  @override
  String get checkup_stepVoice => 'आवाज़';

  @override
  String get checkup_stepMotion => 'मोशन';

  @override
  String get checkup_stepTap => 'टैप';

  @override
  String get medicalReport_title => 'मेडिकल रिपोर्ट';

  @override
  String get medicalReport_uploadTitle => 'मेडिकल रिपोर्ट अपलोड करें';

  @override
  String get medicalReport_supportedFormat =>
      'समर्थित प्रारूप: PDF · अधिकतम 10MB';

  @override
  String get medicalReport_choosePdf => 'PDF फाइल चुनें';

  @override
  String get medicalReport_uploading => 'अपलोड हो रहा है...';

  @override
  String get medicalReport_fileSizeLimit => 'फाइल 10MB सीमा से अधिक है।';

  @override
  String get medicalReport_couldNotOpenPdf => 'PDF नहीं खोल सके।';

  @override
  String medicalReport_failedPdfLink(String error) {
    return 'PDF लिंक प्राप्त करने में विफल: $error';
  }

  @override
  String get medicalReport_analyzing => 'रिपोर्ट का विश्लेषण हो रहा है...';

  @override
  String get medicalReport_extracting =>
      'टेक्स्ट निकालना और जोखिम कारकों का पता लगाना';

  @override
  String get medicalReport_pastReports => 'पिछली रिपोर्ट';

  @override
  String get medicalReport_noReports => 'अभी तक कोई रिपोर्ट नहीं';

  @override
  String get medicalReport_uploadPrompt =>
      'शुरू करने के लिए PDF मेडिकल रिपोर्ट अपलोड करें।';

  @override
  String get medicalReport_viewPdf => 'PDF देखें';

  @override
  String get landing_heroTitle1 => 'स्ट्रोक को जल्दी पहचानें।';

  @override
  String get landing_heroTitle2 => 'जिंदगी बचाएं।';

  @override
  String get landing_heroSubtitle =>
      'Stroke Mitra आपके फोन के Camera, माइक्रोफोन और मोशन सेंसर से स्ट्रोक के शुरुआती लक्षणों की जांच करता है — पूरी तरह प्राइवेट, 60 सेकंड से कम में।';

  @override
  String get landing_trustPrivate => '100% प्राइवेट';

  @override
  String get landing_trustFast => '60 सेकंड से कम';

  @override
  String get landing_trustNoData => 'कोई डेटा स्टोर नहीं';

  @override
  String get landing_scrollDown => 'नीचे स्क्रॉल करें';

  @override
  String get landing_aiPowered => 'AI-पावर्ड स्क्रीनिंग';

  @override
  String get landing_aboutTag => 'परिचय';

  @override
  String get landing_whatIsTitle => 'Stroke Mitra क्या है?';

  @override
  String get landing_whatIsSubtitle =>
      'Stroke Mitra एक AI-पावर्ड स्क्रीनिंग टूल है जो आपके स्मार्टफोन के बिल्ट-इन सेंसर से स्ट्रोक के शुरुआती लक्षणों की पहचान करता है — किसी खास उपकरण की ज़रूरत नहीं।';

  @override
  String get landing_clinicallyInformed => 'क्लिनिकली इन्फॉर्म्ड';

  @override
  String get landing_clinicallyDesc =>
      'दुनियाभर में डॉक्टरों द्वारा इस्तेमाल होने वाले FAST (Face, Arms, Speech, Time) फ्रेमवर्क पर बना है।';

  @override
  String get landing_deviceNative => 'डिवाइस-नेटिव AI';

  @override
  String get landing_deviceDesc =>
      'पूरी तरह आपके फोन पर चलता है। कोई क्लाउड अपलोड नहीं, कोई डेटा स्टोर नहीं। आपका हेल्थ डेटा आपके पास रहता है।';

  @override
  String get landing_forEveryone => 'सबके लिए';

  @override
  String get landing_forEveryoneDesc =>
      'मरीज़ों, केयरगिवर्स और हेल्थकेयर वर्कर्स के लिए बनाया गया। किसी मेडिकल ट्रेनिंग की ज़रूरत नहीं।';

  @override
  String get landing_disclaimerPrefix => 'मेडिकल डिस्क्लेमर: ';

  @override
  String get landing_disclaimerText =>
      'Stroke Mitra एक स्क्रीनिंग टूल है, डायग्नोस्टिक टूल नहीं। अगर आपको स्ट्रोक का शक हो तो तुरंत इमरजेंसी सेवाओं (112) को कॉल करें।';

  @override
  String get landing_howItWorksTag => 'कैसे काम करता है';

  @override
  String get landing_howItWorksTitle => 'तीन आसान स्टेप्स';

  @override
  String get landing_howItWorksSubtitle =>
      'Stroke Mitra आपको एक क्विक, गाइडेड स्क्रीनिंग के ज़रिए ले जाता है — किसी मेडिकल जानकारी की ज़रूरत नहीं।';

  @override
  String get landing_step1Title => 'खोलें और शुरू करें';

  @override
  String get landing_step1Desc =>
      'ऐप खोलें और \'जांच शुरू करें\' पर टैप करें। कोई रजिस्ट्रेशन या Login ज़रूरी नहीं।';

  @override
  String get landing_step1Detail1 => 'किसी भी मॉडर्न स्मार्टफोन पर काम करता है';

  @override
  String get landing_step1Detail2 => 'कोई डाउनलोड ज़रूरी नहीं';

  @override
  String get landing_step2Title => '3 क्विक टेस्ट पूरे करें';

  @override
  String get landing_step2Desc =>
      'चेहरे, आवाज़ और बाजू की मूवमेंट जांच के लिए गाइडेड प्रॉम्प्ट्स फॉलो करें।';

  @override
  String get landing_step2Detail1 => 'Camera से चेहरे की सिमेट्री';

  @override
  String get landing_step2Detail2 => 'माइक्रोफोन से आवाज़ की स्पष्टता';

  @override
  String get landing_step3Title => 'तुरंत रिज़ल्ट पाएं';

  @override
  String get landing_step3Desc =>
      'अपनी स्क्रीनिंग समरी देखें जिसमें साफ़ रिस्क इंडिकेटर्स और अगले कदम होंगे।';

  @override
  String get landing_step3Detail1 => 'रंग से पहचानें रिस्क लेवल';

  @override
  String get landing_step3Detail2 => 'ज़रूरत पड़ने पर इमरजेंसी गाइडेंस';

  @override
  String get landing_featuresTag => 'फ़ीचर्स';

  @override
  String get landing_featuresTitle =>
      'तेज़ी के लिए बना। भरोसे के लिए डिज़ाइन किया।';

  @override
  String get landing_featuresSubtitle =>
      'हर फ़ीचर सटीक, तेज़ और प्राइवेट स्ट्रोक स्क्रीनिंग के लिए बनाया गया है।';

  @override
  String get landing_feat1Title => 'Camera से चेहरे का विश्लेषण';

  @override
  String get landing_feat1Desc =>
      'फ्रंट Camera से AI चेहरे की असमानता रियल-टाइम में पहचानता है। किसी खास हार्डवेयर की ज़रूरत नहीं।';

  @override
  String get landing_feat1Tag => 'Computer Vision';

  @override
  String get landing_feat2Title => 'आवाज़ रिकॉर्डिंग और स्पीच जांच';

  @override
  String get landing_feat2Desc =>
      'एडवांस्ड NLP मॉडल आपकी आवाज़ में लड़खड़ाहट, शब्द खोजने की दिक्कत और असंगति जांचते हैं।';

  @override
  String get landing_feat2Tag => 'NLP + Audio AI';

  @override
  String get landing_feat3Title => 'मोशन और कोऑर्डिनेशन सेंसिंग';

  @override
  String get landing_feat3Desc =>
      'गायरोस्कोप और एक्सेलेरोमीटर डेटा से बाजू की ड्रिफ्ट और कोऑर्डिनेशन जांचा जाता है — ये अहम न्यूरोलॉजिकल इंडिकेटर हैं।';

  @override
  String get landing_feat3Tag => 'Sensor Fusion';

  @override
  String get landing_feat4Title => '60 सेकंड से कम में रिज़ल्ट';

  @override
  String get landing_feat4Desc =>
      'पूरी स्क्रीनिंग प्रक्रिया एक मिनट से कम में होती है — जब हर सेकंड मायने रखता है।';

  @override
  String get landing_feat4Tag => 'Real-Time';

  @override
  String get landing_feat5Title => 'पूरी तरह प्राइवेट और सुरक्षित';

  @override
  String get landing_feat5Desc =>
      'सारी प्रोसेसिंग आपके डिवाइस पर होती है। कोई वीडियो, ऑडियो या पर्सनल डेटा कभी अपलोड या स्टोर नहीं होता।';

  @override
  String get landing_feat5Tag => 'On-Device AI';

  @override
  String get landing_feat6Title => 'क्लिनिकली गाइडेड फ्रेमवर्क';

  @override
  String get landing_feat6Desc =>
      'मेडिकली वैलिडेटेड FAST प्रोटोकॉल पर आधारित, जिस पर दुनियाभर के इमरजेंसी रेस्पॉन्डर्स भरोसा करते हैं।';

  @override
  String get landing_feat6Tag => 'Evidence-Based';

  @override
  String get landing_statsTag => 'क्यों ज़रूरी है';

  @override
  String get landing_statsTitle => 'हर सेकंड क्यों मायने रखता है';

  @override
  String get landing_statsSubtitle =>
      'स्ट्रोक दुनिया में मौत का दूसरा सबसे बड़ा कारण है। जल्दी पहचान नतीजों को काफी बदल सकती है।';

  @override
  String get landing_stat1Label => 'हर साल दुनियाभर में स्ट्रोक होते हैं';

  @override
  String get landing_stat2Label =>
      'स्ट्रोक जल्दी कदम उठाने से रोके जा सकते हैं';

  @override
  String get landing_stat3Label =>
      'ब्रेन सेल्स हर मिनट नष्ट होती हैं बिना इलाज के';

  @override
  String get landing_stat4Label => 'पहले घंटे में इलाज से बेहतर नतीजे';

  @override
  String get landing_fastRemember => 'याद रखें ';

  @override
  String get landing_fastTitle => 'F.A.S.T.';

  @override
  String get landing_fastF => 'Face (चेहरा)';

  @override
  String get landing_fastFDesc => 'क्या एक तरफ ढीलापन है?';

  @override
  String get landing_fastA => 'Arms (बाजू)';

  @override
  String get landing_fastADesc => 'क्या दोनों बाजू उठा सकते हैं?';

  @override
  String get landing_fastS => 'Speech (बोली)';

  @override
  String get landing_fastSDesc => 'क्या बोली लड़खड़ा रही है?';

  @override
  String get landing_fastT => 'Time (समय)';

  @override
  String get landing_fastTDesc => 'तुरंत 112 पर कॉल करें!';

  @override
  String get landing_ctaTitle1 => 'रुकें नहीं। ';

  @override
  String get landing_ctaTitle2 => 'अभी कदम उठाएं।';

  @override
  String get landing_ctaSubtitle =>
      'अगर आपको या आपके पास किसी को स्ट्रोक के लक्षण दिखें, तो हर सेकंड मायने रखता है। अभी Stroke Mitra चेक करें — इससे एक जान बच सकती है।';

  @override
  String get landing_ctaStart => 'अभी स्ट्रोक चेक शुरू करें';

  @override
  String get landing_ctaEmergency => '112 इमरजेंसी कॉल करें';

  @override
  String get landing_ctaFree =>
      'फ्री · बिना रजिस्ट्रेशन · किसी भी मॉडर्न स्मार्टफोन पर';

  @override
  String get landing_footerTagline =>
      'जल्दी पहचान। बेहतर नतीजे।\nहर सेकंड मायने रखता है।';

  @override
  String get landing_footerScreening => 'स्क्रीनिंग';

  @override
  String get landing_footerLearn => 'जानें';

  @override
  String get landing_footerEmergency => 'इमरजेंसी';

  @override
  String get landing_footerWhatIs => 'Stroke Mitra क्या है';

  @override
  String get landing_footerHowItWorks => 'कैसे काम करता है';

  @override
  String get landing_footerWhyEarly => 'जल्दी पहचान क्यों ज़रूरी';

  @override
  String get landing_footerCall112 => '112 पर कॉल करें';

  @override
  String get landing_footerAmbulance108 => 'एम्बुलेंस 108';

  @override
  String get landing_footerCopyright =>
      '© 2025 Stroke Mitra. जन स्वास्थ्य जागरूकता के लिए बनाया गया।';

  @override
  String get landing_footerDisclaimer =>
      'यह टूल सिर्फ स्क्रीनिंग के लिए है। यह प्रोफेशनल मेडिकल सलाह, डायग्नोसिस या इलाज का विकल्प नहीं है।';

  @override
  String get landing_nav_checkSymptoms => 'लक्षण जांचें';

  @override
  String get landing_footer_faceAnalysis => 'चेहरे की जांच';

  @override
  String get landing_footer_speechCheck => 'आवाज़ जांच';

  @override
  String get landing_footer_motionTest => 'मोशन टेस्ट';

  @override
  String motion_secondsRemainingLabel(int seconds) {
    return '$seconds सेकंड बाकी';
  }

  @override
  String get face_retry => 'फिर से करें';

  @override
  String get medicalReport_noRiskFactors => 'कोई जोखिम कारक नहीं मिले';

  @override
  String get medicalReport_detectedConditions => 'पाई गई स्थितियां';

  @override
  String get checkup_continueToVoice => 'आवाज़ जांच पर जाएं';

  @override
  String get checkup_continueToMotion => 'मोशन टेस्ट पर जाएं';

  @override
  String get checkup_continueToTap => 'टैप टेस्ट पर जाएं';

  @override
  String get sos_emergencyTitle => 'इमरजेंसी SOS';

  @override
  String get sos_emergencySubtitle =>
      'असामान्य परिणाम मिले हैं। अगर आप या आपके पास कोई स्ट्रोक के लक्षण महसूस कर रहा है, तो तुरंत इमरजेंसी सेवाओं को कॉल करें।';

  @override
  String get sos_callAmbulance => 'एम्बुलेंस बुलाएं (108)';

  @override
  String get sos_callEmergency => 'इमरजेंसी कॉल करें (112)';

  @override
  String get sos_couldNotCall => 'कॉल नहीं कर सके';

  @override
  String get hospital_sendToNearby => 'नजदीकी अस्पताल को भेजें';

  @override
  String get hospital_selectHospital => 'अस्पताल चुनें';

  @override
  String get hospital_finding => 'नजदीकी अस्पताल ढूंढ रहे हैं...';

  @override
  String get hospital_loading => 'अस्पताल लोड हो रहे हैं...';

  @override
  String get hospital_confirmTitle => 'अस्पताल को अलर्ट भेजें?';

  @override
  String hospital_confirmMessage(String name, String distance) {
    return 'भेज रहे हैं: $name ($distance किमी दूर)। कन्फर्म करें?';
  }

  @override
  String get hospital_confirm => 'अलर्ट भेजें';

  @override
  String get hospital_cancel => 'रद्द करें';

  @override
  String get hospital_sending => 'अलर्ट भेज रहे हैं...';

  @override
  String hospital_sent(String name) {
    return '$name को अलर्ट सफलतापूर्वक भेजा गया';
  }

  @override
  String hospital_failed(String error) {
    return 'अलर्ट भेजने में विफल: $error';
  }

  @override
  String get hospital_noNearby =>
      '50 किमी के भीतर कोई अस्पताल नहीं मिला। 3 नजदीकी अस्पताल दिखा रहे हैं।';

  @override
  String get hospital_locationError =>
      'आपकी लोकेशन नहीं मिल सकी। कृपया लोकेशन सर्विसेज चालू करें।';
}
