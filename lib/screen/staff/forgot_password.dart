import 'package:app_restaurant/screen/staff/signin.dart';
import 'package:app_restaurant/widgets/button_gradient.dart';
import 'package:app_restaurant/widgets/copy_right_text.dart';
import 'package:app_restaurant/widgets/gradient_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StaffForgotPassword extends StatefulWidget {
  const StaffForgotPassword({super.key});

  @override
  State<StaffForgotPassword> createState() => _StaffForgotPasswordState();
}

class _StaffForgotPasswordState extends State<StaffForgotPassword> {
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
                                      color1:
                                          const Color.fromRGBO(121, 40, 202, 1),
                                      color2:
                                          const Color.fromRGBO(255, 0, 128, 1),
                                      event: () {
                                        Navigator.pop(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StaffForgotPassword()));
                                      },
                                      text: "Đăng nhập với tư cách nhân viên",
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  // const BackgroundWelcome()
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
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          GradientText(
                                            'Quên mật khẩu',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  52, 71, 103, 1),
                                              fontFamily: "Icomoon",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 26,
                                            ),
                                            gradient: LinearGradient(colors: [
                                              Color.fromRGBO(33, 212, 253, 1),
                                              Color.fromRGBO(33, 82, 255, 1),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              "Chúng tôi sẽ gửi mã xác nhận về email của bạn trong vòng 60 giây",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(" Mã cửa hàng"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                cursorColor: Color.fromRGBO(
                                                    73, 80, 87, 1),
                                                decoration: InputDecoration(
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 226, 104, 159),
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
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    hintText: 'Mã cửa hàng',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(12)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(" Email"),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                cursorColor: Color.fromRGBO(
                                                    73, 80, 87, 1),
                                                decoration: InputDecoration(
                                                    fillColor:
                                                        const Color.fromARGB(
                                                            255, 226, 104, 159),
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
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    hintText: 'Email',
                                                    isDense: true,
                                                    contentPadding:
                                                        EdgeInsets.all(12)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          ButtonGradient(
                                            color1: const Color.fromRGBO(
                                                33, 82, 255, 1),
                                            color2: const Color.fromRGBO(
                                                33, 212, 253, 1),
                                            event: () {},
                                            text: "Gửi",
                                            radius: 10,
                                            textColor: Colors.white,
                                          ),
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
