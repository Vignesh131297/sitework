import 'package:url_launcher/url_launcher.dart';

/// Opens the phone's dialer with [phone] filled in.
Future<bool> callPhone(String phone) => launchUrl(Uri(scheme: 'tel', path: phone));

/// Opens a map at the coordinates (Google Maps app or browser).
Future<bool> openMap(double latitude, double longitude, {String? label}) => launchUrl(
  Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': '$latitude,$longitude'}),
  mode: LaunchMode.externalApplication,
);
