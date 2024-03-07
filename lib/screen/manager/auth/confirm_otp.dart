import 'dart:async';
import 'package:app_restaurant/config/all_void.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ManagerConfirmOTP extends StatefulWidget {
  final String? verificationId;
  const ManagerConfirmOTP({Key? key, this.verificationId}) : super(key: key);

  @override
  State<ManagerConfirmOTP> createState() => _ManagerConfirmOTPState();
}

class _ManagerConfirmOTPState extends State<ManagerConfirmOTP> {
  String otp = "";
  bool showButton = false;
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 1.sh / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            "assets/images/curved9.jpg"),
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1.sh / 2,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20.w),
                                      child: ButtonGradient(
                                        color1: pupple,
                                        color2: red,
                                        event: () {
                                          context.go("/");
                                        },
                                        fontSize: 12.sp,
                                        text: signInAsManager,
                                        textColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 1.sh > 933 ? 1.sh / 3 : 1.sh / 4,
                                      left: 10.w,
                                      right: 10.w),
                                  child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 7,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.w),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Mã xác nhận",
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    52, 71, 103, 1),
                                                fontFamily: "Icomoon",
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.sp,
                                              ),
                                            ),
                                            space20H,
                                            OtpTextField(
                                              fieldWidth: 50.w,
                                              numberOfFields: 4,
                                              borderColor: pinkPrimary,
                                              focusedBorderColor: pinkPrimary,
                                              cursorColor: Colors.black,
                                              filled: true,
                                              fillColor: lightGrey,
                                              //set to true to show as box or false to show as dash
                                              showFieldAsBox: true,
                                              //runs when a code is typed in
                                              onCodeChanged: (String code) {
                                                //handle validation or checks here
                                                setState(() {
                                                  showButton = false;
                                                });
                                              },
                                              //runs when every textfield is filled
                                              onSubmit:
                                                  (String verificationCode) {
                                                setState(() {
                                                  showButton = true;
                                                  otp = verificationCode;
                                                  print("OTP $otp");
                                                });
                                              }, // end onSubmit
                                            ),
                                            space20H,
                                            CountdownTimer(
                                              duration: Duration(minutes: 5),
                                              onFinish: () {
                                                showExpiredOtpDialog(context);

                                                // Code to execute when the timer finishes
                                              },
                                            ),
                                            space20H,
                                            Visibility(
                                              visible: showButton,
                                              child: ButtonGradient(
                                                color1: color1BlueButton,
                                                color2: color2BlueButton,
                                                event: () {
                                                  if (otp == "1234") {
                                                    showWrongOtpDialog(context);
                                                  } else {
                                                    context.go(
                                                        "/manager_change_password");
                                                  }
                                                },
                                                text: "Xác nhận",
                                                fontSize: 12.sp,
                                                radius: 8.r,
                                                textColor: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                        space30H,
                        SizedBox(
                          width: 1.sw / 2,
                          child: const CopyRightText(),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}

class CountdownTimer extends StatefulWidget {
  final Duration duration; // Set the desired duration for the countdown
  final Function?
      onFinish; // Optional callback function when the timer finishes

  const CountdownTimer({required this.duration, this.onFinish});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel(); // Cancel the timer when the widget is disposed
  }

  Timer? _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > Duration.zero) {
          _remainingTime -= Duration(seconds: 1);
        } else {
          _timer?.cancel();
          widget.onFinish?.call(); // Call the optional callback
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime =
          widget.duration; // Reset the remaining time to the original duration
      _timer?.cancel(); // Cancel the existing timer
      _startTimer(); // Start a new timer from the reset duration
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatDuration(_remainingTime);
    return Column(
      children: [
        TextApp(
          text: formattedTime,
          color: pinkPrimary,
          fontsize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        space10H,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextApp(
              text: havenNotReceivedCodeYet,
              fontsize: 12.sp,
            ),
            InkWell(
              onTap: () {
                _resetTimer();
              },
              child: TextApp(
                text: sendNewOtp,
                color: const Color.fromRGBO(52, 71, 103, 1),
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans",
                fontsize: 12.sp,
              ),
            )
          ],
        )
      ],
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes % 60)} : ${twoDigits(duration.inSeconds % 60)}";
  }
}