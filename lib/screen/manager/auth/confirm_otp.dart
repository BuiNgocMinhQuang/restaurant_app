import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class ManagerConfirmOTP extends StatefulWidget {
  final String? verificationId;
  const ManagerConfirmOTP({Key? key, this.verificationId}) : super(key: key);

  @override
  State<ManagerConfirmOTP> createState() => _ManagerConfirmOTPState();
}

class _ManagerConfirmOTPState extends State<ManagerConfirmOTP> {
  String otp = "";
  bool showButton = false;
  void handleCheckOtp({
    required String? otp,
  }) async {
    try {
      var tokenCheckOtp = StorageUtils.instance
          .getString(key: 'tokenManagerCheckOTP')
          .toString();
      var emailCheckOtp = StorageUtils.instance
          .getString(key: 'emailManagerCheckOTP')
          .toString();

      final respons = await http.post(
        Uri.parse('$baseUrl$checkOtpManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "email": emailCheckOtp,
          "token": tokenCheckOtp,
          "otp": otp,
        }),
      );
      final data = jsonDecode(respons.body);

      if (data['status'] == 200) {
        StorageUtils.instance.setString(key: 'OTPtoManager', val: otp ?? '');
        final messRes = data['message'];
        final messText = messRes['text'];
        navigatorKey.currentContext?.go('/manager_change_password');

        Future.delayed(const Duration(milliseconds: 300), () {
          showCustomDialogModal(
            typeDialog: "succes",
            context: navigatorKey.currentContext,
            textDesc: messText,
            title: "Thành công",
            colorButton: Colors.green,
            btnText: "OK",
          );
        });
      } else {
        final messRes = data['message'];
        final messFailed = messRes['text'];

        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: messFailed,
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");

        log("ERROR handleCheckOtp 1");
      }
    } catch (error) {
      log("ERROR handleCheckOtp 2 $error");
    }
  }

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
                        space15H,
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
                                              confirmCode,
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
                                                mounted
                                                    ? setState(() {
                                                        showButton = false;
                                                      })
                                                    : null;
                                              },
                                              //runs when every textfield is filled
                                              onSubmit:
                                                  (String verificationCode) {
                                                mounted
                                                    ? setState(() {
                                                        showButton = true;
                                                        otp = verificationCode;
                                                      })
                                                    : null;
                                              }, // end onSubmit
                                            ),
                                            space20H,
                                            CountdownTimer(
                                              duration:
                                                  const Duration(minutes: 5),
                                              onFinish: () {
                                                showExpiredOtpDialog(context);

                                                // Code to execute when the timer finishes
                                              },
                                            ),
                                            space20H,
                                            Visibility(
                                              visible: showButton,
                                              child: ButtonGradient(
                                                height: 60.h,
                                                color1: color1BlueButton,
                                                color2: color2BlueButton,
                                                event: () {
                                                  handleCheckOtp(otp: otp);
                                                },
                                                text: confirm,
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      mounted
          ? setState(() {
              if (_remainingTime > Duration.zero) {
                _remainingTime -= const Duration(seconds: 1);
              } else {
                _timer?.cancel();
                widget.onFinish?.call(); // Call the optional callback
              }
            })
          : null;
    });
  }

  void _resetTimer() {
    mounted
        ? setState(() {
            _remainingTime = widget
                .duration; // Reset the remaining time to the original duration
            _timer?.cancel(); // Cancel the existing timer
            _startTimer(); // Start a new timer from the reset duration
          })
        : null;
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
