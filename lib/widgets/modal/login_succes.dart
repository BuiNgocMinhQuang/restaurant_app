import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 1.sh,
        color: Colors.black.withOpacity(0.3),
        child: Center(
            child: Padding(
          padding: EdgeInsets.only(
              top: 120.h, bottom: 120.h, left: 35.w, right: 35.w),
          child: Container(
              width: 1.sw,
              height: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.pink,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    color: Colors.green,
                  ),
                  TextApp(
                    text: "Tiltle",
                    fontsize: 20.sp,
                  ),
                  TextApp(
                    text: "Tiltle",
                    fontsize: 14.sp,
                  ),
                  Row(
                    children: [
                      ButtonApp(
                        event: () {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.leftSlide,
                            headerAnimationLoop: false,
                            dialogType: DialogType.success,
                            showCloseIcon: true,
                            title: 'Succes',
                            desc:
                                'Dialog description here..................................................',
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                            },
                            btnOkIcon: Icons.check_circle,
                            onDismissCallback: (type) {
                              debugPrint('Dialog Dissmiss from callback $type');
                            },
                          ).show();
                        },
                        text: "Button 1",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      ButtonApp(
                        event: () {},
                        text: "Button 2",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                    ],
                  )
                ],
              )),
        )));
  }
}
