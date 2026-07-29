import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/theme/theme.dart';
import 'routes/app_pages.dart';
import 'shared/bindings/initial_binding.dart';

/// main application root widget initializing ScreenUtil and GetMaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // initialize responsive design layout screen dimensions
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: false, // do not apply text scaling auto adaptation
      splitScreenMode: true,
      builder: (context, child) {
        // configure global navigation MaterialApp using GetX
        return GetMaterialApp(
          title: 'Malamal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
