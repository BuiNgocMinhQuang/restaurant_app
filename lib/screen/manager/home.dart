import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerHome extends StatefulWidget {
  const ManagerHome({super.key});

  @override
  State<ManagerHome> createState() => _ManagerHomeState();
}

class _ManagerHomeState extends State<ManagerHome> {
  bool showModal = true;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _showSuccesModal(context);
    // });
  }

  _showSuccesModal(context) {
    AwesomeDialog(
      context: context,
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
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(
                top: 20.w, left: 20.w, right: 20.w, bottom: 20.w),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Row(
                      children: [
                        Image.network("https://picsum.photos/200"),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                          child: Text(
                            "Every city is good for travel.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                })),
      ),
    ));
  }
}
