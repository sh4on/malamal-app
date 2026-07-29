import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/auth_response_model.dart';
import '../../../core/services/network_service.dart';

/// user account details controller managing dashboard profile states
class ProfileController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // logged in user details state
  final Rxn<UserProfile> userProfile = Rxn<UserProfile>();

  // token storage state
  final RxString token = ''.obs;

  // check if session is active
  final RxBool isLoggedIn = false.obs;

  // loading state
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthSession();
  }

  /// inspect storage or variables for active user credentials
  Future<void> checkAuthSession() async {
    isLoading.value = true;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? savedToken = prefs.getString('token');
      if (savedToken != null && savedToken.isNotEmpty) {
        await fetchProfile(savedToken);
      }
    } catch (_) {}
    isLoading.value = false;
  }

  /// call profile api directly to update details
  Future<void> fetchProfile(String tokenValue) async {
    isLoading.value = true;
    token.value = tokenValue;
    _networkService.setToken(tokenValue);

    final result = await _networkService.get('/user/profile');
    isLoading.value = false;

    if (result.isSuccess && result.data != null) {
      try {
        final profileData = result.data?['data'] as Map<String, dynamic>?;
        if (profileData != null) {
          userProfile.value = UserProfile.fromJson(profileData);
          isLoggedIn.value = true;
        } else {
          isLoggedIn.value = false;
        }
      } catch (e) {
        isLoggedIn.value = false;
      }
    } else {
      isLoggedIn.value = false;
    }
  }

  /// log out active user session
  void logout() async {
    token.value = '';
    userProfile.value = null;
    isLoggedIn.value = false;
    _networkService.setToken(null);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
    } catch (_) {}
  }
}
