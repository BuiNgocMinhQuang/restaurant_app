import 'package:app_restaurant/screen/staff/signin.dart';
import 'package:app_restaurant/widgets/background_welcome.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_restaurant/config/colors.dart';

class StaffSignUp extends StatefulWidget {
  const StaffSignUp({super.key});

  @override
  State<StaffSignUp> createState() => _StaffSignUpState();
}

class _StaffSignUpState extends State<StaffSignUp> {
  @override
  Widget build(BuildContext context) {
    bool? isChecked = false;

    var heightView = MediaQuery.sizeOf(context).height;
    var widthView = MediaQuery.sizeOf(context).width;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(248, 249, 250, 1),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: heightView / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/curved9.jpg"),
                                      fit: BoxFit.fill,
                                    )),
                              ),
                              Container(
                                width: double.infinity,
                                height: heightView / 2,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                              const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(30),
                                  ),
                                  BackgroundWelcome()
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: heightView / 4, left: 10, right: 10),
                                child: Container(
                                    width: double.infinity,
                                    // height: heightView / 2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
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
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Đăng ký",
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontFamily: "Icomoon",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: TextField(
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  decoration: InputDecoration(
                                                      fillColor: Color.fromARGB(
                                                          255, 226, 104, 159),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    214,
                                                                    51,
                                                                    123,
                                                                    0.6),
                                                            width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      hintText: 'Họ',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(12)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: TextField(
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: grey),
                                                  cursorColor: grey,
                                                  decoration: InputDecoration(
                                                      fillColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              226,
                                                              104,
                                                              159),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        214,
                                                                        51,
                                                                        123,
                                                                        0.6),
                                                                width: 2.0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      hintText: 'Tên',
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(12)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                fontSize: 14, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Họ và tên',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                fontSize: 14, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                border: OutlineInputBorder(),
                                                hintText: 'Email',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                fontSize: 14, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Số điện thoại',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                fontSize: 14, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Mật khẩu',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextField(
                                            style: TextStyle(
                                                fontSize: 14, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Nhập lại mật khẩu',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12)),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Checkbox(
                                                value: isChecked,
                                                activeColor: Colors.amber,
                                                tristate: true,
                                                onChanged: (bool? newBool) {
                                                  setState(() {
                                                    isChecked = newBool;
                                                    print("press");
                                                  });
                                                },
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "Tôi đồng ý với các",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: const Color
                                                              .fromRGBO(
                                                              52, 71, 103, 1),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontFamily:
                                                              "OpenSans",
                                                        )),
                                                    TextSpan(
                                                        text:
                                                            " Điều khoản và Điều kiện",
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                _launchURL();
                                                                // Single tapped.
                                                              },
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: const Color
                                                              .fromRGBO(
                                                              52, 71, 103, 1),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "OpenSans",
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ButtonGradient(
                                            color1: const Color.fromRGBO(
                                                20, 23, 39, 1),
                                            color2: const Color.fromRGBO(
                                                58, 65, 111, 1),
                                            event: () {
                                              print("hellooopeee");
                                            },
                                            text: "Đăng ký",
                                            radius: 10,
                                            textColor: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "Bạn đã có tài khoản?",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                              52, 71, 103, 1),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: "OpenSans",
                                                    )),
                                                TextSpan(
                                                    text: " Đăng nhập",
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.pop(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            StaffSignUp()));
                                                            // Single tapped.
                                                          },
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          const Color.fromRGBO(
                                                              52, 71, 103, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "OpenSans",
                                                    )),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextApp(
                                            text: "Quên mật khẩu?",
                                            color: const Color.fromRGBO(
                                                52, 71, 103, 1),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "OpenSans",
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                width: widthView / 2,
                                // height: 80,
                                child: const CopyRightText(),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            ],
          )),
        ));
  }
}

_launchURL() async {
  final Uri url = Uri.parse('https://thuonghieuvietsol.com/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
