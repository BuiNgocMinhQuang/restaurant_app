import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
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

void launchURL() async {
  final Uri url = Uri.parse('https://thuonghieuvietsol.com/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
