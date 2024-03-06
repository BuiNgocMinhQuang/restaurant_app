import 'package:awesome_dialog/awesome_dialog.dart';
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

void launchURL() async {
  final Uri url = Uri.parse('https://thuonghieuvietsol.com/');
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}
