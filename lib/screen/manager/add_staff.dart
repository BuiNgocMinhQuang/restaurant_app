import 'package:app_restaurant/widgets/about_staff_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddStaff extends StatefulWidget {
  const AddStaff({super.key});

  @override
  State<AddStaff> createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  bool isShowListStores = false;
  bool isShowListRoles = false;
  void closeListStores() {
    setState(() {
      isShowListStores = false;
    });
  }

  void closeListRoles() {
    setState(() {
      isShowListRoles = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(40.w),
                  child: Container(
                    width: 1.sw,
                    height: 30.h,
                    color: Colors.black,
                  ),
                ),
                AboutStaffModal()
              ],
            ),
          )),
        ),
        // Visibility(
        //   visible: isShowListStores,
        //   child: child),
        //  Visibility(
        //   visible: isShowListRoles,
        //   child: child)
      ],
    ));
  }
}
