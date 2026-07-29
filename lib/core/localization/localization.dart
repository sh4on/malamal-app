import 'package:get/get.dart';

/// app internationalization translations mapping
class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_name': 'Malamal',
          'loading': 'Loading...',
        },
        'bn_BD': {
          'app_name': 'মালামাল',
          'loading': 'লোড হচ্ছে...',
        },
      };
}
