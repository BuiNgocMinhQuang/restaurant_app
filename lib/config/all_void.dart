import 'package:awesome_dialog/awesome_dialog.dart';

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
