# Bugfix Requirements Document

## Introduction

The medical report screen feature has two critical issues that prevent cross-platform deployment:

1. **Duplicate File Conflict**: Two separate `MedicalReportScreen` classes exist in different directories (`lib/features/medical_report/` and `lib/features/medical_reports/`), causing ambiguity and potential runtime conflicts.

2. **Platform-Specific Code**: The file at `lib/features/medical_reports/medical_report_screen.dart` uses `dart:html` library (specifically `html.FileUploadInputElement` and `html.FileReader`), which only works on Flutter Web and causes compilation failures on Android/iOS mobile platforms.

These issues prevent the app from being built and deployed as a truly cross-platform solution.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN the codebase contains both `lib/features/medical_report/medical_report_screen.dart` and `lib/features/medical_reports/medical_report_screen.dart` THEN the system has duplicate class definitions causing import ambiguity

1.2 WHEN `lib/features/medical_reports/medical_report_screen.dart` imports `dart:html` THEN the system fails to compile for Android/iOS mobile platforms with "dart:html is not available" errors

1.3 WHEN `lib/features/medical_reports/medical_report_screen.dart` uses `html.FileUploadInputElement` and `html.FileReader` for file picking THEN the system cannot run on mobile platforms where these APIs don't exist

1.4 WHEN `lib/app/router.dart` imports both medical report screen files THEN the system has conflicting route definitions pointing to different implementations

### Expected Behavior (Correct)

2.1 WHEN the medical report feature is implemented THEN the system SHALL have exactly one `MedicalReportScreen` class in a single file location

2.2 WHEN file picking functionality is needed THEN the system SHALL use the `file_picker` package which works on both web and mobile platforms

2.3 WHEN the app is compiled for Flutter Web (Chrome) THEN the system SHALL successfully build and run with full file upload functionality

2.4 WHEN the app is compiled for Android/iOS mobile THEN the system SHALL successfully build and run with full file upload functionality

2.5 WHEN `lib/app/router.dart` imports the medical report screen THEN the system SHALL import from the single correct file location

### Unchanged Behavior (Regression Prevention)

3.1 WHEN users upload PDF medical reports THEN the system SHALL CONTINUE TO analyze them and display risk assessment results

3.2 WHEN users view their medical report history THEN the system SHALL CONTINUE TO display past reports with risk levels and detected conditions

3.3 WHEN users click on a historical report THEN the system SHALL CONTINUE TO display the full report details

3.4 WHEN users click "View PDF" on a report THEN the system SHALL CONTINUE TO open the PDF file using a signed URL

3.5 WHEN the medical report screen is accessed via navigation THEN the system SHALL CONTINUE TO display within the app shell with bottom navigation

3.6 WHEN other screens and features are used THEN the system SHALL CONTINUE TO function without any changes or regressions
