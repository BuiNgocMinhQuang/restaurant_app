import 'package:app_restaurant/screen/manager/add_staff.dart';
import 'package:app_restaurant/screen/manager/home.dart';
import 'package:app_restaurant/screen/manager/manager_infor.dart';
import 'package:app_restaurant/screen/manager/notifications.dart';
import 'package:app_restaurant/screen/manager/stores.dart';
import 'package:app_restaurant/screen/staff/brought_receipt.dart';
import 'package:app_restaurant/screen/staff/home.dart';
import 'package:app_restaurant/screen/staff/list_bill.dart';
import 'package:app_restaurant/screen/staff/user_infor.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBottomStaff extends StatefulWidget {
  const NavBottomStaff({super.key});

  @override
  State<NavBottomStaff> createState() => _NavBottomStaffState();
}

class _NavBottomStaffState extends State<NavBottomStaff> {
  int _selectedIndex = 2;
  static const List<Widget> _widgetOptions = <Widget>[
    AddStaff(),
    StaffBroughtReceipt(),
    StaffBookingTable(),
    StaffListBill(),
    StaffUserInformation()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: _widgetOptions.elementAt(_selectedIndex),
      // ),
      body: PageStorage(
        child: _widgetOptions.elementAt(_selectedIndex),
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onItemTapped(2);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Left
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        // _widgetOptions.elementAt(0);
                        // _selectedIndex = 0;
                        _onItemTapped(0);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dinner_dining,
                          size: 32.w,
                          color:
                              _selectedIndex == 0 ? Colors.white : Colors.black,
                        ),
                        TextApp(
                          text: "Món ăn",
                          color:
                              _selectedIndex == 0 ? Colors.white : Colors.black,
                          fontsize: 12.sp,
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        // _widgetOptions.elementAt(0);
                        // _selectedIndex = 0;
                        _onItemTapped(1);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delivery_dining,
                          size: 32.w,
                          color:
                              _selectedIndex == 1 ? Colors.white : Colors.black,
                        ),
                        TextApp(
                          text: "Mang về",
                          color:
                              _selectedIndex == 1 ? Colors.white : Colors.black,
                          fontsize: 12.sp,
                        )
                      ],
                    ),
                  )
                ],
              ),

              //Right

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        // _widgetOptions.elementAt(0);
                        // _selectedIndex = 0;
                        _onItemTapped(3);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 32.w,
                          color:
                              _selectedIndex == 3 ? Colors.white : Colors.black,
                        ),
                        TextApp(
                          text: "Hoá đơn",
                          color:
                              _selectedIndex == 3 ? Colors.white : Colors.black,
                          fontsize: 12.sp,
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {
                      setState(() {
                        // _widgetOptions.elementAt(0);
                        // _selectedIndex = 0;
                        _onItemTapped(4);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 32.w,
                          color:
                              _selectedIndex == 4 ? Colors.white : Colors.black,
                        ),
                        TextApp(
                          text: "Cá nhân",
                          color:
                              _selectedIndex == 4 ? Colors.white : Colors.black,
                          fontsize: 12.sp,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
