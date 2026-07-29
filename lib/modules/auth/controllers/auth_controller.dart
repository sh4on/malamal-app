import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/network_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../profile/controllers/profile_controller.dart';

/// auth flow controller managing screen state and api calls
class AuthController extends GetxController {
  final NetworkService _networkService = NetworkService.instance;

  // controller form text fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  // active form page state switcher (0 = login, 1 = register, 2 = forgot password, 3 = otp verify, 4 = forgot password otp, 5 = reset password)
  final RxInt activeForm = 0.obs;

  // token placeholder for password recovery
  final RxString forgotToken = ''.obs;
  final RxString resetPasswordToken = ''.obs;

  // loading state
  final RxBool isLoading = false.obs;
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.success());

  // validation state
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // remember me checkbox state
  final RxBool rememberMe = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadRememberedCredentials();
  }

  /// load remembered credentials from persistent local storage
  Future<void> loadRememberedCredentials() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool remember = prefs.getBool('remember_me') ?? true;
      rememberMe.value = remember;
      if (remember) {
        emailController.text = prefs.getString('email') ?? '';
        passwordController.text = prefs.getString('password') ?? '';
      }
    } catch (_) {}
  }

  /// switch current active layout view
  void switchForm(int index) {
    activeForm.value = index;
    // clear input fields on form switch
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    otpController.clear();
  }

  /// login request trigger
  Future<void> submitLogin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/signin',
      data: {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      },
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      final String? token = result.data?['data']?['accessToken'];
      final profileController = Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
      if (token != null) {
        _networkService.setToken(token);
        profileController.fetchProfile(token);
      }
      try {
        SharedPreferences.getInstance().then((prefs) {
          if (token != null) {
            prefs.setString('token', token);
          }
          if (rememberMe.value) {
            prefs.setString('email', emailController.text.trim());
            prefs.setString('password', passwordController.text);
            prefs.setBool('remember_me', true);
          } else {
            prefs.remove('email');
            prefs.remove('password');
            prefs.setBool('remember_me', false);
          }
        });
      } catch (_) {}
      Get.snackbar(
        'Success',
        'Logged in successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // fetch cart from api now that user is authenticated
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().fetchCart();
      }
      // transition to base container
      Get.offAllNamed('/base');
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Authentication failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// register request trigger
  Future<void> submitRegister() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/signup',
      data: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
      },
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      Get.snackbar(
        'Success',
        'OTP code sent to your email!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // switch to OTP verification form layout
      activeForm.value = 3;
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Registration failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// verify signup registration OTP code
  Future<void> verifySignupOtp() async {
    if (otpController.text.isEmpty) return;

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/verify-signup-otp',
      data: {
        'userEmail': emailController.text.trim(),
        'otp': otpController.text.trim(),
      },
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      Get.snackbar(
        'Success',
        result.message ?? 'OTP verified successfully! Please log in.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // transition to login layout
      switchForm(0);
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'OTP verification failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// resend signup verification OTP code
  Future<void> resendSignupOtp() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email address is missing.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/send-signup-otp-again',
      data: {'userEmail': emailController.text.trim()},
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      Get.snackbar(
        'Success',
        result.message ?? 'OTP sent again successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Failed to resend OTP.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// request password recovery OTP
  Future<void> submitForgotPassword() async {
    if (emailController.text.isEmpty) return;

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/forgot-password',
      data: {'email': emailController.text.trim()},
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      // token returned in response data mapping
      forgotToken.value = result.data?['data']?['token'] ?? '';
      Get.snackbar(
        'Success',
        'Password recovery token sent to your email!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // switch to forgot password otp validation screen (State 4)
      activeForm.value = 4;
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Password recovery request failed',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// resend forgot password recovery OTP code
  Future<void> resendForgotPasswordOtp() async {
    if (forgotToken.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Verification token is missing. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/send-forgot-password-otp-again',
      data: {'token': forgotToken.value},
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      Get.snackbar(
        'Success',
        result.message ?? 'OTP sent again successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Failed to resend recovery OTP.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// verify forgot password recovery OTP code
  Future<void> verifyForgotPasswordOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'OTP code is required.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (forgotToken.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Recovery token is missing.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/verify-forgot-password-otp',
      data: {'token': forgotToken.value, 'otp': otpController.text.trim()},
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      resetPasswordToken.value =
          result.data?['data']?['resetPasswordToken'] ?? '';
      Get.snackbar(
        'Success',
        'OTP verified successfully! Please enter your new password.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      otpController.clear();
      // transition to Reset Password Screen (State 5)
      activeForm.value = 5;
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'OTP verification failed.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// reset password using verified recovery token
  Future<void> submitResetPassword() async {
    if (newPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'New password is required.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (resetPasswordToken.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Reset token is missing. Please start password recovery process again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    status.value = RxStatus.loading();

    final result = await _networkService.post(
      '/user/reset-password',
      data: {
        'resetPasswordToken': resetPasswordToken.value,
        'newPassword': newPasswordController.text,
      },
    );

    isLoading.value = false;
    if (result.isSuccess) {
      status.value = RxStatus.success();
      Get.snackbar(
        'Success',
        result.message ?? 'Password has been reset successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      newPasswordController.clear();
      resetPasswordToken.value = '';
      forgotToken.value = '';
      // transition to Login view (State 0)
      switchForm(0);
    } else {
      status.value = RxStatus.error(result.message);
      Get.snackbar(
        'Error',
        result.message ?? 'Failed to reset password.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
