import 'dart:typed_data';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/constants.dart';
import '../auth/providers/auth_provider.dart';
import '../face_analysis/face_result.dart';
import '../motion_test/motion_service.dart';
import '../tap_test/tap_scoring.dart';
import '../voice_check/voice_result.dart';
import 'full_checkup_provider.dart';

class CheckupReportScreen extends ConsumerWidget {
  const CheckupReportScreen({super.key});

  bool _isAbnormal(FullCheckupState state) {
    final face = state.faceResult!;
    final voice = state.voiceResult!;
    final motion = state.motionResult!;
    final tap = state.tapResult!;

    return !face.isNormal ||
        voice.riskTier == 'critical' ||
        voice.riskTier == 'high' ||
        motion.riskLevel == 'Abnormal' ||
        tap.overallRisk == OverallRisk.abnormal;
  }

  Future<void> _sendToNearbyHospital(
      BuildContext context, WidgetRef ref, FullCheckupState state) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);

    // Show loading
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.hospital_loading)),
    );

    try {
      // Get current location
      final position = await _getCurrentLocation(context);
      if (position == null) return;

      // Get all hospitals with distances
      final hospitals = await _getAllHospitalsWithDistance(position);
      if (hospitals.isEmpty || !context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('No hospitals found in database')),
        );
        return;
      }

      // Show hospital selection dialog
      final selectedHospital = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (ctx) => _HospitalSelectionDialog(
          hospitals: hospitals,
          position: position,
        ),
      );

      if (selectedHospital == null || !context.mounted) return;

      final distance = selectedHospital['distance'] as double;

      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.hospital_confirmTitle),
          content: Text(l10n.hospital_confirmMessage(
            selectedHospital['name'],
            distance.toStringAsFixed(1),
          )),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l10n.hospital_cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.statusError,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.hospital_confirm),
            ),
          ],
        ),
      );

      if (confirmed != true || !context.mounted) return;

      // Show sending message
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.hospital_sending)),
      );

      // Send alert
      await _sendHospitalAlert(
        ref,
        selectedHospital,
        position,
        state,
      );

      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.hospital_sent(selectedHospital['name'])),
            backgroundColor: AppTheme.statusSuccess,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.hospital_failed(e.toString())),
            backgroundColor: AppTheme.statusError,
          ),
        );
      }
    }
  }

  Future<Position?> _getCurrentLocation(BuildContext context) async {
    final l10n = context.l10n;
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.hospital_locationError)),
          );
        }
        return null;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.hospital_locationError)),
            );
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.hospital_locationError)),
          );
        }
        return null;
      }

      // Get current position
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.hospital_locationError)),
        );
      }
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> _getAllHospitalsWithDistance(
      Position position) async {
    final supabase = Supabase.instance.client;

    // Get all hospitals
    final response = await supabase.from('hospitals').select();

    if (response.isEmpty) return [];

    // Calculate distances for all hospitals
    final hospitals = (response as List).map((h) {
      final hospital = Map<String, dynamic>.from(h as Map);
      final distance = _calculateDistance(
        position.latitude,
        position.longitude,
        hospital['latitude'] as double,
        hospital['longitude'] as double,
      );
      return {...hospital, 'distance': distance};
    }).toList();

    // Sort by distance (nearest first)
    hospitals.sort(
        (a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

    return hospitals;
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  Future<void> _sendHospitalAlert(
    WidgetRef ref,
    Map<String, dynamic> hospital,
    Position position,
    FullCheckupState state,
  ) async {
    final supabase = Supabase.instance.client;
    final user = ref.read(currentUserProvider);
    final profile = await ref.read(userProfileProvider.future);

    // Get patient info
    final patientName = profile?['full_name'] ?? 'Unknown';
    final age = profile?['age'] ?? 'N/A';
    final gender = profile?['gender'] ?? 'N/A';

    // Determine primary finding and risk level
    final face = state.faceResult!;
    final voice = state.voiceResult!;
    final motion = state.motionResult!;
    final tap = state.tapResult!;

    String primaryFinding = 'Multiple abnormalities detected';
    String riskLevel = 'High';

    if (!face.isNormal) {
      primaryFinding = 'Facial asymmetry detected';
      riskLevel = 'Critical';
    } else if (voice.riskTier == 'critical') {
      primaryFinding = 'Severe speech impairment';
      riskLevel = 'Critical';
    } else if (voice.riskTier == 'high') {
      primaryFinding = 'Speech irregularities';
      riskLevel = 'High';
    } else if (motion.riskLevel == 'Abnormal') {
      primaryFinding = 'Arm drift detected';
      riskLevel = 'High';
    } else if (tap.overallRisk == OverallRisk.abnormal) {
      primaryFinding = 'Coordination deficit';
      riskLevel = 'Medium';
    }

    final timestamp = DateTime.now().toIso8601String();
    final mapsLink =
        'https://maps.google.com/?q=${position.latitude},${position.longitude}';

    // Format WhatsApp message
    final message = '''
🚨 *URGENT PATIENT ALERT*

*Name:* $patientName, $age/$gender
*Location:* $mapsLink
*Condition:* $primaryFinding
*Risk:* $riskLevel
*Time:* $timestamp

Full report is being dispatched. Please prepare.
''';

    // Call Supabase Edge Function to send WhatsApp
    try {
      await supabase.functions.invoke(
        'send-hospital-alert',
        body: {
          'hospital_whatsapp_number': hospital['whatsapp_number'],
          'patient_name': patientName,
          'age': age,
          'gender': gender,
          'gps_coordinates': {
            'latitude': position.latitude,
            'longitude': position.longitude,
          },
          'maps_link': mapsLink,
          'primary_finding': primaryFinding,
          'risk_level': riskLevel,
          'alert_timestamp': timestamp,
          'message': message,
        },
      );

      // Log to Supabase
      await supabase.from('alert_logs').insert({
        'patient_id': user?.id,
        'hospital_id': hospital['id'],
        'sent_at': timestamp,
        'status': 'sent',
        'message_preview': message.substring(0, 100),
      });
    } catch (e) {
      // Log failure
      await supabase.from('alert_logs').insert({
        'patient_id': user?.id,
        'hospital_id': hospital['id'],
        'sent_at': timestamp,
        'status': 'failed',
        'message_preview': 'Error: ${e.toString()}',
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fullCheckupProvider);

    if (!state.allDone) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline,
                size: 48, color: AppTheme.statusError),
            const SizedBox(height: 16),
            Text(context.l10n.checkup_noCheckupFound),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () => context.go('/app'),
                child: Text(context.l10n.checkup_goHome)),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            ref.read(fullCheckupProvider.notifier).reset();
            context.go('/app');
          },
        ),
        title: Text(context.l10n.checkup_reportTitle,
            style:
                GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Send to Nearby Hospital Button
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _sendToNearbyHospital(context, ref, state),
                icon: const Icon(Icons.local_hospital_rounded, size: 24),
                label: Text(context.l10n.hospital_sendToNearby),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.statusError,
                  foregroundColor: Colors.white,
                  textStyle: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),
            _OverallRiskBanner(state: state),
            if (_isAbnormal(state)) ...[
              const SizedBox(height: AppTheme.spaceMD),
              _SosEmergencyCard(),
            ],
            const SizedBox(height: AppTheme.spaceLG),
            _ReportCard(
              icon: Icons.camera_alt_rounded,
              title: context.l10n.checkup_faceAnalysis,
              color: const Color(0xFF0B6B5D),
              child: _FaceResultSummary(result: state.faceResult!),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            _ReportCard(
              icon: Icons.mic_rounded,
              title: context.l10n.checkup_voiceCheck,
              color: const Color(0xFF6366F1),
              child: _VoiceResultSummary(result: state.voiceResult!),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            _ReportCard(
              icon: Icons.accessibility_new_rounded,
              title: context.l10n.checkup_motionTest,
              color: const Color(0xFFF97316),
              child: _MotionResultSummary(result: state.motionResult!),
            ),
            const SizedBox(height: AppTheme.spaceMD),
            _ReportCard(
              icon: Icons.touch_app_rounded,
              title: context.l10n.checkup_tapTest,
              color: const Color(0xFF3B82F6),
              child: _TapResultSummary(result: state.tapResult!),
            ),
            const SizedBox(height: AppTheme.spaceLG),
            _DisclaimerBox(),
            const SizedBox(height: AppTheme.spaceLG),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _downloadPdf(context, state),
                icon: const Icon(Icons.download_rounded),
                label: Text(context.l10n.checkup_downloadPdf),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(fullCheckupProvider.notifier).reset();
                  context.go('/app');
                },
                icon: const Icon(Icons.home_rounded),
                label: Text(context.l10n.checkup_backToHome),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),
          ]),
        ),
      ),
    );
  }

  Future<void> _downloadPdf(
      BuildContext context, FullCheckupState state) async {
    final pdf = await _buildPdf(state);
    await Printing.layoutPdf(onLayout: (_) async => pdf);
  }

  Future<Uint8List> _buildPdf(FullCheckupState state) async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateStr =
        '${now.day}/${now.month}/${now.year}  ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final face = state.faceResult!;
    final voice = state.voiceResult!;
    final motion = state.motionResult!;
    final tap = state.tapResult!;

    final overallRisk = _computeOverallRisk(face, voice, motion, tap);
    final riskColor = _pdfRiskColor(overallRisk);

    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (ctx) => [
        // Header
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('0B6B5D'),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Stroke Mitra',
                        style: pw.TextStyle(
                            fontSize: 22,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white)),
                    pw.Text('Full Check-up Report',
                        style: const pw.TextStyle(
                            fontSize: 13, color: PdfColors.white)),
                  ]),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(dateStr,
                        style: const pw.TextStyle(
                            fontSize: 11, color: PdfColors.white)),
                    pw.Text(AppConstants.appVersion,
                        style: const pw.TextStyle(
                            fontSize: 10, color: PdfColors.white)),
                  ]),
            ],
          ),
        ),
        pw.SizedBox(height: 16),

        // Overall risk
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: riskColor.shade(0.15),
            border: pw.Border.all(color: riskColor, width: 1.5),
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(children: [
            pw.Text('Overall Risk: ',
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text(overallRisk,
                style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: riskColor)),
          ]),
        ),
        pw.SizedBox(height: 20),

        // Face
        _pdfSection('Face Analysis', [
          _pdfRow('Verdict', face.verdict),
          _pdfRow('Status', face.isNormal ? 'Normal' : 'Abnormal'),
          ...face.raw.entries
              .where((e) => ![
                    'verdict',
                    'result',
                    'status',
                    'symmetry_status',
                    'fingerprint_data',
                    'baseline_fingerprint',
                  ].contains(e.key))
              .where((e) => e.value is! Map && e.value is! List)
              .map((e) => _pdfRow(_formatKey(e.key), _formatValue(e.value))),
        ]),
        pw.SizedBox(height: 12),

        // Voice
        _pdfSection('Voice Check', [
          _pdfRow('Severity', voice.severity),
          _pdfRow('Risk Tier', voice.riskTier),
          _pdfRow('Slurring Score',
              '${voice.slurringScore.toStringAsFixed(1)} / 100'),
          _pdfRow('Risk Score', '${voice.riskScore.toStringAsFixed(1)} / 100'),
          _pdfRow(
              'Confidence', '${(voice.confidence * 100).toStringAsFixed(0)}%'),
          _pdfRow('Speaking Rate',
              '${voice.acousticSummary.speakingRate.toStringAsFixed(1)} syl/s'),
          _pdfRow('Pitch Mean',
              '${voice.acousticSummary.pitchMeanHz.toStringAsFixed(1)} Hz'),
          _pdfRow('Pause Ratio',
              '${(voice.acousticSummary.pauseRatio * 100).toStringAsFixed(0)}%'),
        ]),
        pw.SizedBox(height: 12),

        // Motion
        _pdfSection('Motion Test', [
          _pdfRow('Risk Level', motion.riskLevel),
          _pdfRow('Tilt Variance', motion.varianceScore.toStringAsFixed(4)),
          _pdfRow('Drift Magnitude', motion.driftMagnitude.toStringAsFixed(4)),
          _pdfRow('Samples', motion.sampleCount.toString()),
        ]),
        pw.SizedBox(height: 12),

        // Tap
        _pdfSection('Tap Test', [
          _pdfRow('Overall Risk', TapScoring.overallRiskLabel(tap.overallRisk)),
          _pdfRow('Right Hand Taps', tap.rightTaps.toString()),
          _pdfRow('Left Hand Taps', tap.leftTaps.toString()),
          _pdfRow('Right Hand Risk', TapScoring.handRiskLabel(tap.rightRisk)),
          _pdfRow('Left Hand Risk', TapScoring.handRiskLabel(tap.leftRisk)),
          _pdfRow('Asymmetry', '${tap.asymmetryPercent.toStringAsFixed(1)}%'),
          _pdfRow('Asymmetry Label',
              TapScoring.asymmetryLabelString(tap.asymmetryLabel)),
          _pdfRow('Lateralised Deficit', tap.lateralisedDeficit ? 'Yes' : 'No'),
        ]),
        pw.SizedBox(height: 20),

        // Disclaimer
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            '${AppConstants.disclaimerTitle}: ${AppConstants.disclaimerBody}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ),
      ],
    ));

    return doc.save();
  }

  pw.Widget _pdfSection(String title, List<pw.Widget> rows) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child:
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title,
            style: pw.TextStyle(
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('0B6B5D'))),
        pw.Divider(color: PdfColors.grey300, height: 12),
        ...rows,
      ]),
    );
  }

  pw.Widget _pdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw
          .Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
        pw.Text(value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
      ]),
    );
  }

  String _computeOverallRisk(FaceAnalysisResult face, VoiceResult voice,
      MotionResult motion, DualTapResult tap) {
    final risks = <String>[];
    if (!face.isNormal) risks.add('Abnormal');
    if (voice.riskTier == 'critical' || voice.riskTier == 'high') {
      risks.add('Abnormal');
    } else if (voice.riskTier == 'moderate') {
      risks.add('Borderline');
    }
    if (motion.riskLevel == 'Abnormal') {
      risks.add('Abnormal');
    } else if (motion.riskLevel == 'Borderline') {
      risks.add('Borderline');
    }
    if (tap.overallRisk == OverallRisk.abnormal) {
      risks.add('Abnormal');
    } else if (tap.overallRisk == OverallRisk.borderline) {
      risks.add('Borderline');
    }

    if (risks.contains('Abnormal')) return 'Abnormal';
    if (risks.contains('Borderline')) return 'Borderline';
    return 'Normal';
  }

  PdfColor _pdfRiskColor(String risk) {
    switch (risk) {
      case 'Abnormal':
        return PdfColor.fromHex('EF4444');
      case 'Borderline':
        return PdfColor.fromHex('F59E0B');
      default:
        return PdfColor.fromHex('10B981');
    }
  }

  String _formatKey(String key) => key
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  String _formatValue(dynamic v) {
    if (v is double) {
      if (v >= 0 && v <= 1) return '${(v * 100).toStringAsFixed(1)}%';
      return v.toStringAsFixed(2);
    }
    if (v is int) return v.toString();
    if (v is bool) return v ? 'Yes' : 'No';
    return v.toString();
  }
}

// ─── UI Widgets ──────────────────────────────────────────────────────────────

class _OverallRiskBanner extends StatelessWidget {
  final FullCheckupState state;
  const _OverallRiskBanner({required this.state});

  String get _risk {
    final face = state.faceResult!;
    final voice = state.voiceResult!;
    final motion = state.motionResult!;
    final tap = state.tapResult!;
    if (!face.isNormal ||
        voice.riskTier == 'critical' ||
        voice.riskTier == 'high' ||
        motion.riskLevel == 'Abnormal' ||
        tap.overallRisk == OverallRisk.abnormal) {
      return 'Abnormal';
    }
    if (voice.riskTier == 'moderate' ||
        motion.riskLevel == 'Borderline' ||
        tap.overallRisk == OverallRisk.borderline) {
      return 'Borderline';
    }
    return 'Normal';
  }

  Color get _color {
    switch (_risk) {
      case 'Abnormal':
        return AppTheme.statusError;
      case 'Borderline':
        return AppTheme.statusWarning;
      default:
        return AppTheme.statusSuccess;
    }
  }

  IconData get _icon {
    switch (_risk) {
      case 'Abnormal':
        return Icons.warning_rounded;
      case 'Borderline':
        return Icons.info_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String _message(BuildContext context) {
    switch (_risk) {
      case 'Abnormal':
        return context.l10n.checkup_riskAbnormalMessage;
      case 'Borderline':
        return context.l10n.checkup_riskBorderlineMessage;
      default:
        return context.l10n.checkup_riskNormalMessage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(_icon, color: _color, size: 32),
          const SizedBox(width: 10),
          Text(context.l10n.checkup_overallRisk(_risk),
              style: GoogleFonts.outfit(
                  fontSize: 24, fontWeight: FontWeight.w900, color: _color)),
        ]),
        const SizedBox(height: 8),
        Text(_message(context),
            style: GoogleFonts.inter(fontSize: 13, color: _color, height: 1.5),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _ReportCard(
      {required this.icon,
      required this.title,
      required this.color,
      required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceMD, vertical: AppTheme.spaceSM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: Row(children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(title,
                style: GoogleFonts.outfit(
                    fontSize: 15, fontWeight: FontWeight.w700, color: color)),
          ]),
        ),
        Padding(padding: const EdgeInsets.all(AppTheme.spaceMD), child: child),
      ]),
    );
  }
}

class _FaceResultSummary extends StatelessWidget {
  final FaceAnalysisResult result;
  const _FaceResultSummary({required this.result});

  // Keys to skip — they're either redundant or shown elsewhere
  static const _skip = {
    'verdict',
    'result',
    'status',
    'symmetry_status',
    'fingerprint_data',
    'baseline_fingerprint',
  };

  @override
  Widget build(BuildContext context) {
    final color =
        result.isNormal ? AppTheme.statusSuccess : AppTheme.statusError;

    final rows = result.raw.entries
        .where((e) => !_skip.contains(e.key))
        .where(
            (e) => e.value is! Map && e.value is! List) // skip nested objects
        .take(6)
        .map((e) => _SummaryRow(
              label: _fmtKey(e.key),
              value: _fmtValue(e.value),
            ))
        .toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SummaryRow(label: 'Verdict', value: result.verdict, valueColor: color),
      ...rows,
    ]);
  }

  String _fmtKey(String k) => k
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  String _fmtValue(dynamic v) {
    if (v is double) {
      // Looks like a 0–1 ratio → show as percentage
      if (v >= 0 && v <= 1) return '${(v * 100).toStringAsFixed(1)}%';
      return v.toStringAsFixed(2);
    }
    if (v is int) return v.toString();
    if (v is bool) return v ? 'Yes' : 'No';
    return v.toString();
  }
}

class _VoiceResultSummary extends StatelessWidget {
  final VoiceResult result;
  const _VoiceResultSummary({required this.result});

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (result.severity) {
      case 'severe':
        c = AppTheme.statusError;
        break;
      case 'moderate':
        c = AppTheme.orange500;
        break;
      case 'mild':
        c = AppTheme.statusWarning;
        break;
      default:
        c = AppTheme.statusSuccess;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SummaryRow(label: 'Severity', value: result.severity, valueColor: c),
      _SummaryRow(label: 'Risk Tier', value: result.riskTier),
      _SummaryRow(
          label: 'Slurring Score',
          value: '${result.slurringScore.toStringAsFixed(1)} / 100'),
      _SummaryRow(
          label: 'Confidence',
          value: '${(result.confidence * 100).toStringAsFixed(0)}%'),
    ]);
  }
}

class _MotionResultSummary extends StatelessWidget {
  final MotionResult result;
  const _MotionResultSummary({required this.result});

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (result.riskLevel) {
      case 'Abnormal':
        c = AppTheme.statusError;
        break;
      case 'Borderline':
        c = AppTheme.statusWarning;
        break;
      default:
        c = AppTheme.statusSuccess;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SummaryRow(label: 'Risk Level', value: result.riskLevel, valueColor: c),
      _SummaryRow(
          label: 'Tilt Variance',
          value: result.varianceScore.toStringAsFixed(4)),
      _SummaryRow(
          label: 'Drift Magnitude',
          value: result.driftMagnitude.toStringAsFixed(4)),
      _SummaryRow(label: 'Samples', value: result.sampleCount.toString()),
    ]);
  }
}

class _TapResultSummary extends StatelessWidget {
  final DualTapResult result;
  const _TapResultSummary({required this.result});

  @override
  Widget build(BuildContext context) {
    Color c;
    switch (result.overallRisk) {
      case OverallRisk.abnormal:
        c = AppTheme.statusError;
        break;
      case OverallRisk.borderline:
        c = AppTheme.statusWarning;
        break;
      default:
        c = AppTheme.statusSuccess;
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _SummaryRow(
          label: 'Overall Risk',
          value: TapScoring.overallRiskLabel(result.overallRisk),
          valueColor: c),
      _SummaryRow(
          label: 'Right Hand',
          value:
              '${result.rightTaps} taps (${TapScoring.handRiskLabel(result.rightRisk)})'),
      _SummaryRow(
          label: 'Left Hand',
          value:
              '${result.leftTaps} taps (${TapScoring.handRiskLabel(result.leftRisk)})'),
      _SummaryRow(
          label: 'Asymmetry',
          value: '${result.asymmetryPercent.toStringAsFixed(1)}%'),
    ]);
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _SummaryRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor ?? theme.colorScheme.onSurface)),
      ]),
    );
  }
}

class _DisclaimerBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: theme.colorScheme.outline.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Text(
        '${context.l10n.disclaimer_title}: ${context.l10n.disclaimer_body}',
        style: GoogleFonts.inter(
            fontSize: 11,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// ─── SOS Emergency Card ──────────────────────────────────────────────────────
class _SosEmergencyCard extends StatelessWidget {
  Future<void> _makeCall(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.sos_couldNotCall)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      decoration: BoxDecoration(
        color: AppTheme.statusError.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLG),
        border: Border.all(
          color: AppTheme.statusError,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title row
          Row(
            children: [
              const Icon(
                Icons.emergency_rounded,
                color: AppTheme.statusError,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.sos_emergencyTitle,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.statusError,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Warning message
          Text(
            l10n.sos_emergencySubtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.statusError,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          // Call Ambulance button (primary)
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _makeCall(context, '108'),
              icon: const Icon(Icons.local_hospital_rounded, size: 24),
              label: Text(l10n.sos_callAmbulance),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.statusError,
                foregroundColor: Colors.white,
                textStyle: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          // Call Emergency button (secondary)
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => _makeCall(context, '112'),
              icon: const Icon(Icons.phone_rounded, size: 20),
              label: Text(l10n.sos_callEmergency),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.statusError,
                side: const BorderSide(color: AppTheme.statusError, width: 1.5),
                textStyle: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Hospital Selection Dialog ───────────────────────────────────────────────
class _HospitalSelectionDialog extends StatelessWidget {
  final List<Map<String, dynamic>> hospitals;
  final Position position;

  const _HospitalSelectionDialog({
    required this.hospitals,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        l10n.hospital_selectHospital,
        style: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: hospitals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final hospital = hospitals[index];
            final distance = hospital['distance'] as double;
            final isNearest = index == 0;

            return InkWell(
              onTap: () => Navigator.pop(context, hospital),
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: BoxDecoration(
                  color: isNearest
                      ? AppTheme.statusError.withValues(alpha: 0.08)
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  border: Border.all(
                    color: isNearest
                        ? AppTheme.statusError
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: isNearest ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isNearest
                            ? AppTheme.statusError
                            : theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_hospital_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  hospital['name'],
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              if (isNearest)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.statusError,
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.radiusSM),
                                  ),
                                  child: Text(
                                    'NEAREST',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${distance.toStringAsFixed(1)} km away',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                          if (hospital['address'] != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              hospital['address'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.hospital_cancel),
        ),
      ],
    );
  }
}
