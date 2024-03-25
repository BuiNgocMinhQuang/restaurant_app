import 'package:another_flushbar/flushbar.dart';
import 'package:app_restaurant/bloc/login/login_bloc.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

void showConfirmDialog(context, Function confirmEvent) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.question,
          animType: AnimType.rightSlide,
          headerAnimationLoop: true,
          title: 'Bạn có chắc chắn thực hiện tác vụ này!',
          desc: 'Sau khi bạn xác nhận sẽ không thể trở lại.',
          btnOkOnPress: () {
            confirmEvent();
          },
          btnOkText: "Xác Nhận",
          btnCancelOnPress: () {},
          btnCancelText: "Hủy")
      .show();
}

void showFailedModal(context, String? desWhyFail) {
  AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.error,
    showCloseIcon: true,
    title: 'Thất bại',
    desc: desWhyFail,
    btnOkColor: Colors.red,
    btnOkOnPress: () {
      debugPrint('OnClcik');
    },
    btnOkText: 'OK',
    // btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
    },
  ).show();
}

void showLoginSuccesDialog() {
  AwesomeDialog(
    context: navigatorKey.currentContext!,
    autoDismiss: false,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    showCloseIcon: true,
    title: 'Thành công',
    desc: 'Đăng nhập thành công!',

    btnOkOnPress: () {
      debugPrint('OnClcik');
    },
    btnOkText: 'OK',
    // btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
      if (type == DismissType.btnOk) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    },
  ).show();
}

void showUpdateDataSuccesDialog() {
  AwesomeDialog(
    context: navigatorKey.currentContext!,
    autoDismiss: false,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    showCloseIcon: true,
    title: 'Thành công',
    desc: 'Cập nhật dữ liệu thành công!',
    btnOkOnPress: () {},
    btnOkText: 'OK',
    onDismissCallback: (type) {
      if (type == DismissType.btnOk) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    },
  ).show();
}

void showDoYouWantPrintBillDialog(Function printEvent) {
  AwesomeDialog(
    context: navigatorKey.currentContext!,
    autoDismiss: false,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.question,
    showCloseIcon: true,
    title: 'Thanh toán hoàn tất',
    desc: 'Bạn có muốn in hoá đơn này ?',
    btnOkOnPress: () {
      printEvent();
    },
    btnCancelOnPress: () {},
    btnOkText: 'IN',
    btnCancelText: 'ĐÓNG',
    onDismissCallback: (type) {
      if (type == DismissType.btnOk || type == DismissType.btnCancel) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    },
  ).show();
}

void showSomthingWrongDialog() {
  AwesomeDialog(
    context: navigatorKey.currentContext!,
    autoDismiss: false,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.error,
    showCloseIcon: true,
    title: 'Thất bại',
    desc: 'Có lỗi xảy ra, vui lòng thử lại sau!',
    btnOkOnPress: () {},
    btnOkText: 'OK',
    btnOkColor: Colors.red,
    onDismissCallback: (type) {
      if (type == DismissType.btnOk) {
        Navigator.of(navigatorKey.currentContext!).pop();
      }
    },
  ).show();
}

void showChangePasswordSuccessDialog(context) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          headerAnimationLoop: true,
          title: 'Thành công',
          desc: 'Đổi mật khẩu thành công',
          btnCancelColor: Colors.blue,
          btnCancelOnPress: () {},
          btnCancelText: "OK")
      .show();
}

void showWrongOtpDialog(context) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.noHeader,
          animType: AnimType.rightSlide,
          headerAnimationLoop: true,
          title: 'Mã OTP không đúng',
          // desc: 'Sau khi bạn xác nhận sẽ không thể trở lại.',
          // btnOkOnPress: () {
          //   confirmEvent();
          // },
          // btnOkText: "Xác Nhận",
          btnCancelColor: Colors.blue,
          btnCancelOnPress: () {},
          btnCancelText: "OK")
      .show();
}

void showExpiredOtpDialog(context) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          headerAnimationLoop: true,
          title: 'OTP hết hạn',
          desc: 'Mã OTP của bạn đã hết hạn, vui lòng bấm Gửi lại mã mới!',
          // btnOkOnPress: () {
          //   confirmEvent();
          // },
          // btnOkText: "Xác Nhận",
          btnCancelColor: Colors.blue,
          btnCancelOnPress: () {},
          btnCancelText: "OK")
      .show();
}

void showLoginSessionExpiredDialog(context, Function okEvent) {
  AwesomeDialog(
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          headerAnimationLoop: true,
          title: 'Hết thời gian đăng nhập',
          desc: 'Phiên đăng nhập của bạn đã hết. Vui lòng đăng nhập lại!',
          // btnOkOnPress: () {
          //   confirmEvent();
          // },
          // btnOkText: "Xác Nhận",
          btnCancelColor: Colors.blue,
          btnCancelOnPress: () {
            okEvent();
          },
          btnCancelText: "OK")
      .show();
}

showSnackBarTopUpdateSucces(context) async {
  await Flushbar(
    backgroundColor: Colors.green,
    message: "Món ăn được cập nhật thành công",
    duration: const Duration(seconds: 1),
    margin: EdgeInsets.only(bottom: 1.sh - 150.h, left: 25.w, right: 25.w),

    flushbarPosition: FlushbarPosition.TOP,
    // forwardAnimationCurve: ,
    // reverseAnimationCurve: Curves.easeInOutCirc,
  ).show(context);
}

showSnackBarTopCustom(
    {required context, required String mess, required Color color}) async {
  await Flushbar(
    backgroundColor: color,
    message: mess,
    duration: const Duration(seconds: 1),
    margin: EdgeInsets.only(bottom: 1.sh - 150.h, left: 25.w, right: 25.w),

    flushbarPosition: FlushbarPosition.TOP,
    // forwardAnimationCurve: ,
    // reverseAnimationCurve: Curves.easeInOutCirc,
  ).show(context);
}

void launchURL() async {
  final Uri url = Uri.parse('https://thuonghieuvietsol.com/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
