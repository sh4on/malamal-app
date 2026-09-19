import 'package:shared_preferences/shared_preferences.dart';

// storage key constants — avoids magic strings scattered across the codebase
const String _kName = 'checkout_name';
const String _kPhone = 'checkout_phone';
const String _kEmail = 'checkout_email';
const String _kAddress = 'checkout_address';
const String _kCity = 'checkout_city';

/// service that persists and restores checkout billing details locally.
/// uses shared_preferences so the data survives app restarts.
/// note: only name, phone, email, address, and city are saved —
/// order notes and coupon codes are intentionally left out as they are
/// typically unique per order.
class CheckoutPreferencesService {
  // singleton pattern — one shared instance across the app
  static final CheckoutPreferencesService _instance =
      CheckoutPreferencesService._internal();

  CheckoutPreferencesService._internal();

  static CheckoutPreferencesService get instance => _instance;

  // ─── save ─────────────────────────────────────────────────────────────────

  /// persists the customer billing details after a successful order
  /// so the form can be pre-populated on the next checkout visit
  Future<void> saveBillingDetails({
    required String name,
    required String phone,
    required String email,
    required String address,
    required String city,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(_kName, name);
    await prefs.setString(_kPhone, phone);
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kAddress, address);
    await prefs.setString(_kCity, city);
  }

  // ─── load ─────────────────────────────────────────────────────────────────

  /// loads previously saved billing details.
  /// returns null for any field that has never been saved yet.
  Future<Map<String, String?>> loadBillingDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString(_kName),
      'phone': prefs.getString(_kPhone),
      'email': prefs.getString(_kEmail),
      'address': prefs.getString(_kAddress),
      'city': prefs.getString(_kCity),
    };
  }

  // ─── clear ────────────────────────────────────────────────────────────────

  /// removes all saved billing details — useful for logout or data reset flows
  Future<void> clearBillingDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(_kName);
    await prefs.remove(_kPhone);
    await prefs.remove(_kEmail);
    await prefs.remove(_kAddress);
    await prefs.remove(_kCity);
  }
}
