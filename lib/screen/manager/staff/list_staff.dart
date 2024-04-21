import 'dart:convert';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/manager/staff/list_staff_model.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListStaff extends StatefulWidget {
  const ListStaff({super.key});

  @override
  State<ListStaff> createState() => _ListStaffState();
}

class _ListStaffState extends State<ListStaff> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  String accountStatus = "isActive";
  ListStaffDataModel? listStaffDataModel;
  List currentStaffList = [];
  int currentActiveFlag = 1;
  bool hasMore = true;
  bool isRefesh = false;
  int currentPage = 1;
  String query = '';

  final scrollListStaffController = ScrollController();
  void searchStaff(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
    currentStaffList.clear();
    handleGetListStaff(
      page: currentPage,
      keywords: query,
      activeFlg: currentActiveFlag,
      dateStart: _dateStartController.text,
      dateEnd: _dateEndController.text,
    );
  }

  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        // helpText: 'Chọn ngày bắt đầu', // Can be used as title
        // cancelText: 'Huỷ',
        // confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (picked != null) {
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        _dateEndController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void handleGetListStaff({
    required int page,
    String? keywords,
    int? activeFlg,
    String? dateStart,
    String? dateEnd,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getListStaffApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "active_flg": activeFlg,
            "date_range": {"start_date": dateStart, "end_date": dateEnd}
          },
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA CREATE FOOD ${data}");
      try {
        if (data['status'] == 200) {
          // var hahah = DetailsStoreModel.fromJson(data);
          setState(() {
            listStaffDataModel = ListStaffDataModel.fromJson(data);
            currentStaffList.addAll(listStaffDataModel!.staffs.data);
            currentPage++;
            if (listStaffDataModel!.staffs.data.isEmpty ||
                listStaffDataModel!.staffs.data.length <= 15) {
              hasMore = false;
            }
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE $error");
      }
    } catch (error) {
      print("ERROR CREATE $error");
    }
  }

  @override
  void initState() {
    super.initState();
    handleGetListStaff(page: 1);
    scrollListStaffController.addListener(() {
      if (scrollListStaffController.position.maxScrollExtent ==
              scrollListStaffController.offset &&
          isRefesh == false) {
        print("LOADD MORE FOOD");
        handleGetListStaff(
          page: currentPage,
          keywords: query,
          activeFlg: currentActiveFlag,
          dateStart: _dateStartController.text,
          dateEnd: _dateEndController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Container(
            width: 1.sw,
            // height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Từ ngày",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _dateStartController,
                                      onTap: selectDayStart,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          hintText: 'dd/mm/yy',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              ),
                              space20W,
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Đến ngày",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextField(
                                      readOnly: true,
                                      controller: _dateEndController,
                                      onTap: selectDayEnd,
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          suffixIcon:
                                              Icon(Icons.calendar_month),
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          hintText: 'dd/mm/yy',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          space20H,
                          Row(
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Trạng thái",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    DropdownSearch(
                                      // popupProps: PopupProps.menu(
                                      //   showSelectedItems: true,
                                      //   disabledItemFn: (String s) => s.startsWith(''),
                                      // ),
                                      items: listState,

                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                        dropdownSearchDecoration:
                                            InputDecoration(
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w),
                                          hintText: "Tất cả",
                                        ),
                                      ),
                                      onChanged: print,
                                      selectedItem: "Tất cả",
                                    ),
                                  ],
                                ),
                              ),
                              space20W,
                              Flexible(
                                fit: FlexFit.tight,
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextApp(
                                      text: " Tìm kiếm",
                                      fontsize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: blueText,
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    TextField(
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      style: TextStyle(
                                          fontSize: 14.sp, color: grey),
                                      cursorColor: grey,
                                      decoration: InputDecoration(
                                          fillColor: const Color.fromARGB(
                                              255, 226, 104, 159),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    214, 51, 123, 0.6),
                                                width: 2.0),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          // hintText: 'Instagram',
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(15.w)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          space20H,
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 1.sw * 3.5,
                                        height: 400.h,
                                        // color: Colors.amber,
                                        padding: EdgeInsets.all(20.w),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            controller:
                                                scrollListStaffController,
                                            physics:
                                                const ClampingScrollPhysics(),
                                            itemCount: (listStaffDataModel
                                                        ?.staffs.data.length ??
                                                    0) +
                                                1,
                                            itemBuilder: (context, index) {
                                              var dataLength =
                                                  listStaffDataModel?.staffs
                                                          .data.length ??
                                                      0;
                                              if (index < dataLength) {
                                                DataListStaff staffData =
                                                    listStaffDataModel!
                                                        .staffs.data[index];
                                                var avatarStaff =
                                                    staffData.staffAvatar ?? '';
                                                return Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                          dividerColor: Colors
                                                              .transparent),
                                                  child: index > 0
                                                      ? DataTable(
                                                          dividerThickness: 0.0,
                                                          columns: [
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                                label:
                                                                    Text('')),
                                                            DataColumn(
                                                              label: Center(
                                                                  child:
                                                                      Text('')),
                                                            ),
                                                          ],
                                                          rows: [
                                                            DataRow(cells: [
                                                              DataCell(Center(
                                                                  child:
                                                                      IntrinsicHeight(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          80.w,
                                                                      height:
                                                                          80.w,
                                                                      // color: Colors.amber,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        imageUrl:
                                                                            httpImage +
                                                                                avatarStaff,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                SizedBox(
                                                                          height:
                                                                              10.w,
                                                                          width:
                                                                              10.w,
                                                                          child:
                                                                              const Center(child: CircularProgressIndicator()),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                    space10W,
                                                                    SizedBox(
                                                                      width:
                                                                          120.w,
                                                                      child:
                                                                          TextApp(
                                                                        isOverFlow:
                                                                            false,
                                                                        softWrap:
                                                                            true,
                                                                        text: staffData.staffFullName ??
                                                                            '',
                                                                        fontsize:
                                                                            14.sp,
                                                                        color:
                                                                            blueText,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 80.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: staffData
                                                                        .staffPosition
                                                                        .toString(),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: staffData
                                                                        .storeName,
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                  child: staffData
                                                                              .activeFlg ==
                                                                          1
                                                                      ? StatusBoxIsSelling()
                                                                      : StatusBoxNoMoreSelling())),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    child: ButtonIcon(
                                                                        isIconCircle: false,
                                                                        color1: const Color.fromRGBO(23, 193, 232, 1),
                                                                        color2: const Color.fromRGBO(23, 193, 232, 1),
                                                                        event: () {
                                                                          // handleGetDetailsFood(foodID: product.foodId ?? 0);
                                                                        },
                                                                        icon: Icons.edit),
                                                                  ),
                                                                  space15W,
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    child: ButtonIcon(
                                                                        isIconCircle: false,
                                                                        color1: const Color.fromRGBO(234, 6, 6, 1),
                                                                        color2: const Color.fromRGBO(234, 6, 6, 1),
                                                                        event: () {
                                                                          // showConfirmDialog(context, () {
                                                                          //   handleDeleteFood(foodID: product.foodId.toString());
                                                                          //   print("Delete Food");
                                                                          // });
                                                                        },
                                                                        icon: Icons.delete),
                                                                  )
                                                                ],
                                                              ))
                                                            ]),
                                                          ],
                                                        )
                                                      : DataTable(
                                                          dividerThickness: 0.0,
                                                          columns: [
                                                            DataColumn(
                                                                label: Text(
                                                                    'TÊN NHÂN VIÊN')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'CHỨC VỤ')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'LÀM VIỆC TẠI CỬA HÀNG')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'TRẠNG THÁI')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'SÔ ĐIỆN THOẠI')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'EMAIL')),
                                                            DataColumn(
                                                                label: Text(
                                                                    'NGÀY TẠO')),
                                                            DataColumn(
                                                              label: Center(
                                                                  child:
                                                                      Text('')),
                                                            ),
                                                          ],
                                                          rows: [
                                                            DataRow(cells: [
                                                              DataCell(Center(
                                                                  child:
                                                                      IntrinsicHeight(
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          80.w,
                                                                      height:
                                                                          80.w,
                                                                      // color: Colors.amber,
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        imageUrl:
                                                                            httpImage +
                                                                                avatarStaff,
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                SizedBox(
                                                                          height:
                                                                              10.w,
                                                                          width:
                                                                              10.w,
                                                                          child:
                                                                              const Center(child: CircularProgressIndicator()),
                                                                        ),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            const Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                    space10W,
                                                                    SizedBox(
                                                                      width:
                                                                          120.w,
                                                                      child:
                                                                          TextApp(
                                                                        isOverFlow:
                                                                            false,
                                                                        softWrap:
                                                                            true,
                                                                        text: staffData.staffFullName ??
                                                                            '',
                                                                        fontsize:
                                                                            14.sp,
                                                                        color:
                                                                            blueText,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ))),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 80.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: staffData
                                                                            .staffPosition
                                                                            .toString() ??
                                                                        '',
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: staffData
                                                                        .storeName,
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                  child: staffData
                                                                              .activeFlg ==
                                                                          1
                                                                      ? StatusBoxIsSelling()
                                                                      : StatusBoxNoMoreSelling())),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Center(
                                                                child: SizedBox(
                                                                  width: 120.w,
                                                                  child:
                                                                      TextApp(
                                                                    isOverFlow:
                                                                        false,
                                                                    softWrap:
                                                                        true,
                                                                    text: formatDateTime(
                                                                        staffData.createdAt ??
                                                                            ''),
                                                                    fontsize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                              )),
                                                              DataCell(Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    child: ButtonIcon(
                                                                        isIconCircle:
                                                                            false,
                                                                        color1: const Color.fromRGBO(
                                                                            23,
                                                                            193,
                                                                            232,
                                                                            1),
                                                                        color2: const Color
                                                                            .fromRGBO(
                                                                            23,
                                                                            193,
                                                                            232,
                                                                            1),
                                                                        event:
                                                                            () {},
                                                                        icon: Icons
                                                                            .edit),
                                                                  ),
                                                                  space15W,
                                                                  SizedBox(
                                                                    height:
                                                                        30.h,
                                                                    child: ButtonIcon(
                                                                        isIconCircle: false,
                                                                        color1: const Color.fromRGBO(234, 6, 6, 1),
                                                                        color2: const Color.fromRGBO(234, 6, 6, 1),
                                                                        event: () {
                                                                          // showConfirmDialog(context, () {
                                                                          //   handleDeleteFood(foodID: product.foodId.toString());
                                                                          //   print("Delete Food");
                                                                          // });
                                                                        },
                                                                        icon: Icons.delete),
                                                                  )
                                                                ],
                                                              ))
                                                            ]),
                                                          ],
                                                        ),
                                                );
                                              } else {
                                                return Center(
                                                  child: hasMore
                                                      ? CircularProgressIndicator()
                                                      : Container(),
                                                );
                                              }
                                            }),
                                      )
                                    ],
                                  )
                                ],
                              )),
                        ],
                      ),
                    )),
                space30H,
                CopyRightText()
              ],
            ),
          ),
        ),
      )),
    );
  }
}
