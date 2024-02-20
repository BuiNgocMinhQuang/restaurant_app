import 'package:app_restaurant/screen/staff/forgot_password.dart';
import 'package:app_restaurant/screen/staff/sigup.dart';
import 'package:app_restaurant/widgets/background_welcome.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_restaurant/config/colors.dart';

class StaffSignIn extends StatefulWidget {
  const StaffSignIn({super.key});

  @override
  State<StaffSignIn> createState() => _StaffSignInState();
}

class _StaffSignInState extends State<StaffSignIn> {
  bool light = true;
  @override
  Widget build(BuildContext context) {
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
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: ButtonGradient(
                                      color1: pupple,
                                      color2: red,
                                      event: () {},
                                      text: "Đăng nhập với tư cách nhân viên",
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  const BackgroundWelcome()
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
                                            "Đăng nhập",
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
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.amber,
                                                gradient: const LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    organe,
                                                    yellow,
                                                  ],
                                                )),
                                            child: const Center(
                                              child: Text(
                                                "Bạn đang đăng nhập với tư cách chủ cửa hàng!",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Icomoon",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
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
                                                hintText: 'Mật khẩu',
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
                                              SizedBox(
                                                width: 50,
                                                height: 30,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: CupertinoSwitch(
                                                    // This bool value toggles the switch.
                                                    value: light,
                                                    activeColor: Color.fromRGBO(
                                                        58, 65, 111, .95),
                                                    onChanged: (bool value) {
                                                      // This is called when the user toggles the switch.
                                                      setState(() {
                                                        light = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                "Ghi nhớ tài khoản",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: grey,
                                                    fontFamily: "OpenSans",
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ButtonGradient(
                                            color1: const Color.fromRGBO(
                                                33, 82, 255, 1),
                                            color2: const Color.fromRGBO(
                                                33, 212, 253, 1),
                                            event: () {},
                                            text: "Đăng nhập",
                                            radius: 10,
                                            textColor: Colors.white,
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
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StaffSignUp()));
                                            },
                                            text: "Đăng ký",
                                            radius: 10,
                                            textColor: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          StaffForgotPassword()));
                                            },
                                            child: TextApp(
                                              text: "Quên mật khẩu?",
                                              color: const Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "OpenSans",
                                            ),
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
