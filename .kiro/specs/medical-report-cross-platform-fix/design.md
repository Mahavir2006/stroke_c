# Medical Report Cross-Platform Fix Design

## Overview

This bugfix addresses two critical issues preventing cross-platform deployment of the medical report feature:

1. **Duplicate File Conflict**: Two separate `MedicalReportScreen` implementations exist in different directories, causing import ambiguity and potential runtime conflicts.
2. **Platform-Specific Code**: The `lib/features/medical_reports/medical_report_screen.dart` file uses `dart:html` library, which only works on Flutter Web and causes compilation failures on Android/iOS.

The fix involves consolidating to a single implementation using the cross-platform `file_picker` package that already exists in `lib/features/medical_report/medical_report_screen.dart`, removing the web-only duplicate, and updating router imports.

## Glossary

- **Bug_Condition (C)**: The condition that triggers the bug - when duplicate MedicalReportScreen files exist or when dart:html is used for file picking
- **Property (P)**: The desired behavior - single cross-platform implementation using file_picker package
- **Preservation**: All medical report functionality (upload, analysis, history, PDF viewing) must continue working exactly as before
- **file_picker**: Cross-platform Flutter package for file selection that works on Web, Android, and iOS
- **dart:html**: Web-only Dart library that provides access to browser APIs, incompatible with mobile platforms
- **MedicalReportScreen**: The screen component that handles medical report upload, analysis, and history display

## Bug Details

### Bug Condition

The bug manifests when the codebase contains duplicate `MedicalReportScreen` implementations or when platform-specific code (dart:html) is used for file picking. This causes compilation failures on mobile platforms and import ambiguity.

**Formal Specification:**
```
FUNCTION isBugCondition(codebase)
  INPUT: codebase containing Flutter app files
  OUTPUT: boolean
  
  RETURN (EXISTS file "lib/features/medical_report/medical_report_screen.dart" 
         AND EXISTS file "lib/features/medical_reports/medical_report_screen.dart")
         OR (file "lib/features/medical_reports/medical_report_screen.dart" 
             IMPORTS "dart:html")
         OR (router.dart IMPORTS both medical report screen files)
END FUNCTION
```

### Examples

- **Duplicate Files**: Both `lib/features/medical_report/medical_report_screen.dart` and `lib/features/medical_reports/medical_report_screen.dart` exist, causing import ambiguity when router tries to import MedicalReportScreen
- **Platform-Specific Import**: `lib/features/medical_reports/medical_report_screen.dart` imports `dart:html`, causing "Error: Not found: 'dart:html'" when compiling for Android/iOS
- **Web-Only APIs**: Code uses `html.FileUploadInputElement()` and `html.FileReader()`, which don't exist on mobile platforms
- **Router Conflict**: `lib/app/router.dart` imports both files, creating conflicting route definitions

## Expected Behavior

### Preservation Requirements

**Unchanged Behaviors:**
- PDF file upload functionality must continue to work on all platforms
- Medical report analysis with AI must continue to produce risk assessments
- Report history display must continue to show past reports with risk levels
- PDF viewing via signed URLs must continue to work
- UI/UX of the medical report screen must remain visually identical
- Navigation to medical report screen from dashboard must continue to work

**Scope:**
All inputs and user interactions with the medical report feature should be completely unaffected by this fix. This includes:
- Clicking "Upload PDF" button
- Selecting PDF files from device/browser
- Viewing analysis results
- Browsing report history
- Opening PDF files
- All other app features and screens

## Hypothesized Root Cause

Based on the bug description and code analysis, the root causes are:

1. **Development Duplication**: Two separate implementations were created during development - one using cross-platform `file_picker` package (`lib/features/medical_report/`) and another using web-only `dart:html` (`lib/features/medical_reports/`). The web-only version was likely created first or as an experiment.

2. **Import Ambiguity**: The router file imports both implementations, creating conflicting class definitions and route handlers.

3. **Platform-Specific API Usage**: The `dart:html` library is only available in Flutter Web compilation target. When compiling for Android/iOS, the Dart compiler cannot find this library, causing build failures.

4. **Incomplete Migration**: The cross-platform implementation using `file_picker` already exists and is complete, but the old web-only implementation was never removed.

## Correctness Properties

Property 1: Bug Condition - Single Cross-Platform Implementation

_For any_ platform target (Flutter Web, Android, iOS) where the app is compiled, the fixed codebase SHALL contain exactly one MedicalReportScreen implementation using the cross-platform file_picker package, and the compilation SHALL succeed without "dart:html not found" errors.

**Validates: Requirements 2.1, 2.2, 2.3, 2.4, 2.5**

Property 2: Preservation - Medical Report Functionality

_For any_ user interaction with the medical report feature (uploading PDFs, viewing analysis, browsing history, opening PDFs), the fixed code SHALL produce exactly the same behavior as the original working implementation, preserving all functionality for file upload, analysis, and history display.

**Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5, 3.6**

## Fix Implementation

### Changes Required

The fix involves removing the duplicate web-only implementation and ensuring the router uses the correct cross-platform version.

**File 1**: `lib/features/medical_reports/medical_report_screen.dart`

**Action**: DELETE this entire file

**Rationale**: This file uses `dart:html` which is web-only. The cross-platform implementation already exists in `lib/features/medical_report/medical_report_screen.dart` using the `file_picker` package.

---

**File 2**: `lib/app/router.dart`

**Action**: Remove duplicate import

**Specific Changes**:
1. **Remove Import**: Delete the line `import '../features/medical_reports/medical_report_screen.dart';` (line 18)
2. **Keep Import**: Retain the line `import '../features/medical_report/medical_report_screen.dart';` (line 12)
3. **Verify Routes**: Ensure both route definitions (line 60 `/medical-reports` and line 95 `/medical-report`) point to the same MedicalReportScreen class from the correct import

**Current State**:
```dart
import '../features/medical_report/medical_report_screen.dart';  // Line 12 - KEEP
import '../features/medical_reports/medical_report_screen.dart'; // Line 18 - REMOVE
```

**Fixed State**:
```dart
import '../features/medical_report/medical_report_screen.dart';  // Line 12 - KEEP
// Line 18 removed
```

---

**File 3**: `flutter_app/pubspec.yaml`

**Action**: VERIFY (no changes needed)

**Verification**: Confirm that `file_picker: ^8.1.2` is already present in dependencies (it is, at line 52). This package provides cross-platform file picking for Web, Android, and iOS.

## Testing Strategy

### Validation Approach

The testing strategy follows a two-phase approach: first, verify the bug exists on unfixed code by attempting to compile for mobile platforms, then verify the fix works correctly across all platforms and preserves existing functionality.

### Exploratory Bug Condition Checking

**Goal**: Surface counterexamples that demonstrate the bug BEFORE implementing the fix. Confirm the root cause analysis.

**Test Plan**: Attempt to compile the app for Android/iOS with the unfixed code. Observe compilation failures related to `dart:html` not being found. Verify that duplicate imports exist in router.

**Test Cases**:
1. **Android Compilation Test**: Run `flutter build apk` on unfixed code (will fail with "dart:html not found")
2. **iOS Compilation Test**: Run `flutter build ios` on unfixed code (will fail with "dart:html not found")
3. **Import Analysis Test**: Check router.dart for duplicate imports (will find both medical_report and medical_reports imports)
4. **File Existence Test**: Verify both medical_report_screen.dart files exist in different directories (will find duplicates)

**Expected Counterexamples**:
- Compilation fails for Android/iOS with error: "Error: Not found: 'dart:html'"
- Router contains conflicting imports from two different directories
- Two separate MedicalReportScreen class definitions exist

### Fix Checking

**Goal**: Verify that for all platform targets where the bug condition held, the fixed codebase compiles successfully and runs correctly.

**Pseudocode:**
```
FOR ALL platform IN ['web', 'android', 'ios'] DO
  result := compile_app(platform, fixed_codebase)
  ASSERT result.success = true
  ASSERT result.errors DOES NOT CONTAIN "dart:html"
  ASSERT count_files("**/medical_report_screen.dart") = 1
END FOR
```

**Test Cases**:
1. **Web Compilation**: `flutter build web` succeeds
2. **Android Compilation**: `flutter build apk` succeeds
3. **iOS Compilation**: `flutter build ios` succeeds (on macOS)
4. **Single File Verification**: Only one medical_report_screen.dart exists
5. **Router Import Verification**: Router imports from single correct location

### Preservation Checking

**Goal**: Verify that for all user interactions with the medical report feature, the fixed implementation produces the same behavior as the original working implementation.

**Pseudocode:**
```
FOR ALL interaction IN [upload_pdf, view_analysis, browse_history, open_pdf] DO
  ASSERT behavior_after_fix(interaction) = behavior_before_fix(interaction)
END FOR
```

**Testing Approach**: Manual testing is recommended for preservation checking because:
- The fix only removes duplicate code and updates imports, not logic
- The working implementation (lib/features/medical_report/) is being preserved as-is
- UI/UX behavior can be visually verified across platforms
- File picker behavior can be tested with actual file selection

**Test Plan**: Test the medical report feature on both Web and mobile platforms after the fix, comparing behavior to the known working implementation.

**Test Cases**:
1. **File Upload Preservation**: Verify PDF file selection works on Web (browser file picker) and mobile (native file picker)
2. **Analysis Preservation**: Verify uploaded PDFs are analyzed and results display correctly
3. **History Preservation**: Verify past reports display in history section
4. **PDF Viewing Preservation**: Verify "View PDF" button opens PDFs via signed URLs
5. **UI Preservation**: Verify screen layout, styling, and animations remain identical
6. **Navigation Preservation**: Verify navigation to/from medical report screen works correctly

### Unit Tests

- Test that file_picker package is correctly imported and used
- Test that no dart:html imports exist in the codebase
- Test that router has single import for MedicalReportScreen
- Test that compilation succeeds for all target platforms

### Property-Based Tests

Not applicable for this bugfix - the fix is structural (removing duplicate files and imports) rather than algorithmic. Manual testing and compilation verification are sufficient.

### Integration Tests

- Test full medical report flow on Flutter Web (Chrome)
- Test full medical report flow on Android emulator/device
- Test full medical report flow on iOS simulator/device (if available)
- Test file upload with various PDF sizes and formats
- Test navigation between dashboard and medical report screen
- Test that other app features remain unaffected
