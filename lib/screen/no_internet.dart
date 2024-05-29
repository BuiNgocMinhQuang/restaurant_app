import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextApp(
            text: noInternet,
            fontsize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            width: 300.w,
            height: 300.w,
            child: Lottie.asset('assets/lottie/no_internet.json'),
          ),
          SizedBox(
            height: 50.h,
          ),
          SizedBox(
            width: 300.w,
            child: ButtonGradient(
              color1: color1BlueButton,
              color2: color2BlueButton,
              event: () {
                // if (_formField.currentState!
                //     .validate()) {
                //   context
                //       .go('/manager_home');
                //   emailController.clear();
                //   passworldController
                //       .clear();
                // }
                context.go('/staff_sign_in');
              },
              text: backToHome,
              fontSize: 12.sp,
              radius: 8.r,
              textColor: Colors.white,
            ),
          )
        ],
      ),
    ));
  }
}
