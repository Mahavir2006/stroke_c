/// Conditional export: uses native camera on Android/iOS,
/// web camera (getUserMedia) on Flutter Web.
export 'native_camera_view.dart' if (dart.library.html) 'web_camera_view.dart';
