import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// open WhatsApp with an optional pre-filled message.
/// uses a multi-scheme fallback strategy for maximum device compatibility:
///   1. whatsapp://send — direct deep link, most reliable on all Android OEMs
///      (Vivo Funtouch OS, MIUI, Samsung OneUI, etc.)
///   2. https://wa.me  — web fallback for devices where the deep link fails
/// the canLaunchUrl gate is intentionally removed from the primary attempt
/// because on Android 11+ it requires <queries> declarations and still returns
/// false on some Vivo/Funtouch OS builds even when WhatsApp is installed.
Future<void> openWhatsApp([String? message]) async {
  final String phone = '+8801972525821';
  final String encodedText = Uri.encodeComponent(message ?? '');

  // primary: whatsapp:// direct deep link — bypasses browser, works even when
  // the https wa.me URL is not properly associated on some OEM browsers
  final Uri whatsappDirectUri = Uri.parse(
    'whatsapp://send?phone=$phone&text=$encodedText',
  );

  // fallback: wa.me web URL — used when WhatsApp deep link is unavailable
  final Uri whatsappWebUri = Uri.parse(
    'https://wa.me/$phone?text=$encodedText',
  );

  // try direct deep link first
  try {
    final bool canDirect = await canLaunchUrl(whatsappDirectUri);
    if (canDirect) {
      await launchUrl(whatsappDirectUri, mode: LaunchMode.externalApplication);
      return;
    }
  } catch (e) {
    debugPrint('openWhatsApp: direct scheme failed — $e');
  }

  // fallback to wa.me web url (opens in browser if app not found)
  try {
    final bool launched = await launchUrl(
      whatsappWebUri,
      mode: LaunchMode.externalApplication,
    );
    if (launched) return;
  } catch (e) {
    debugPrint('openWhatsApp: wa.me fallback failed — $e');
  }

  // last resort: open in platform default handler without canLaunchUrl check
  try {
    await launchUrl(whatsappWebUri, mode: LaunchMode.platformDefault);
  } catch (e) {
    throw Exception('Could not launch WhatsApp: $e');
  }
}
