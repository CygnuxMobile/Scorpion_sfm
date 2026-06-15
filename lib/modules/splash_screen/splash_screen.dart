import 'package:flutter/material.dart';

import '../../config/app_images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.appLogo, scale: 5,),
      ),
    );
  }
}
