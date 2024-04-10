import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/model/manager/manager_list_food_model.dart';
import 'package:app_restaurant/screen/manager/food_menu/edit_food.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_icon.dart';
import 'package:app_restaurant/widgets/status_box.dart';
import 'package:app_restaurant/widgets/text/copy_right_text.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:money_formatter/money_formatter.dart';

List<String> listState = ["Tất cả", "Đang hoạt động", "Đã chặn"];

class ListFoodManager extends StatefulWidget {
  const ListFoodManager({
    Key? key,
  }) : super(key: key);

  @override
  State<ListFoodManager> createState() => _ListFoodManagerState();
}

class _ListFoodManagerState extends State<ListFoodManager> {
  TextEditingController _dateStartController = TextEditingController();
  TextEditingController _dateEndController = TextEditingController();
  final searchController = TextEditingController();

  final scrollListFoodController = ScrollController();
  int currentPage = 1;
  List currentFoodList = [];
  String query = '';
  bool hasMore = true;
  int? selectedFlag;
  String? selectedFlitterFlag = 'Tất cả';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
    currentFoodList.clear();
    loadMoreMenuFood(
      page: currentPage,
      keywords: query,
      // foodKinds:
      //     selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
      filtersFlg: selectedFlag,
    );
  }

  void selectDayStart() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày bắt đầu',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));

    if (picked != null) {
      setState(() {
        _dateStartController.text = picked.toString().split(" ")[0];
      });
    }
  }

  void selectDayEnd() async {
    DateTime? picked = await showDatePicker(
        helpText: 'Chọn ngày kết thúc',
        cancelText: 'Huỷ',
        confirmText: 'Xác nhận',
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025),
        builder: (context, child) => Theme(
              data: ThemeData().copyWith(
                  colorScheme: const ColorScheme.dark(
                      primary: Colors.black,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                      surface: Colors.white),
                  dialogBackgroundColor: Colors.green),
              child: child ?? Container(),
            ));
    if (picked != null) {
      setState(() {
        _dateEndController.text = picked.toString().split(" ")[0];
      });
    }
  }

//   void handleDeleteFood() async{
// try {
//       var token = StorageUtils.instance.getString(key: 'token_manager');

//       final respons = await http.post(
//         Uri.parse('$baseUrl$managerGetListFood'),
//         headers: {
//           'Content-type': 'application/json',
//           'Accept': 'application/json',
//           "Authorization": "Bearer $token"
//         },
//         body: jsonEncode({

//         }),
//       );
//       final data = jsonDecode(respons.body);
//       print("GET DATA LIST FOOD ${data}");
//       try {
//         if (data['status'] == 200) {
//           setState(() {
//             var listMenuPageRes = ManagerListFoodModel.fromJson(data);
//             currentFoodList.addAll(listMenuPageRes.data.data);
//             currentPage++;
//             if (listMenuPageRes.data.data.isEmpty ||
//                 listMenuPageRes.data.data.length <= 15) {
//               hasMore = false;
//             }
//             // currentPage++;
//             // if (listMenuPageRes.data.data.isEmpty) {
//             //   hasMore = false;
//             // }
//             log('LENGHT ${listMenuPageRes.data.data.length}');
//           });
//         } else {
//           print("ERROR LIST FOOOD RECEIPT PAGE 1");
//         }
//       } catch (error) {
//         print("ERROR BROUGHT RECEIPT PAGE 2 $error");
//       }
//     } catch (error) {
//       print("ERROR BROUGHT RECEIPT PAGE 3 $error");
//     }
//   }

  void loadMoreMenuFood({
    required int page,
    String? keywords,
    List<int>? foodKinds,
    int? filtersFlg,
    int? activeFlg,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$managerGetListFood'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": filtersFlg,
            "active_flg": activeFlg,
          },
        }),
      );
      final data = jsonDecode(respons.body);
      print("GET DATA LIST FOOD ${data}");
      try {
        if (data['status'] == 200) {
          setState(() {
            var listMenuPageRes = ManagerListFoodModel.fromJson(data);
            currentFoodList.addAll(listMenuPageRes.data.data);
            currentPage++;
            if (listMenuPageRes.data.data.isEmpty ||
                listMenuPageRes.data.data.length <= 15) {
              hasMore = false;
            }
            // currentPage++;
            // if (listMenuPageRes.data.data.isEmpty) {
            //   hasMore = false;
            // }
            log('LENGHT ${listMenuPageRes.data.data.length}');
          });
        } else {
          print("ERROR LIST FOOOD RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => loadMoreMenuFood(page: 1, filtersFlg: null));
    });
    scrollListFoodController.addListener(() {
      print("SCROLL END");
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        print("LOADD MORE FOOD");
        loadMoreMenuFood(
            page: currentPage,
            keywords: query,
            // foodKinds: selectedCategoriesIndex.isEmpty
            //     ? null
            //     : selectedCategoriesIndex,
            filtersFlg: selectedFlag);
      }
    });
  }

  @override
  void dispose() {
    scrollListFoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List filterProducts = currentFoodList.where((product) {
      final foodTitle = product.foodName.toLowerCase();
      final input = query.toLowerCase();
      return (foodTitle.contains(input));
    }).toList();
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                  text: "Tất cả món ăn",
                                  fontsize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: blueText),
                              TextApp(
                                text: allYourFoodHere,
                                fontsize: 14.sp,
                                color: blueText.withOpacity(0.6),
                              ),
                            ],
                          ),
                          space40H,
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
                                      items: listState,
                                      onChanged: (changeFlag) {
                                        // getListArea(
                                        //     city: listState.indexOf(changeCity),
                                        //     district: null);
                                        setState(() {
                                          selectedFlitterFlag = changeFlag;
                                          currentPage = 1;
                                        });
                                        var hehe = listState.indexOf(
                                                    changeFlag ?? '') ==
                                                0
                                            ? null
                                            : listState.indexOf(
                                                        changeFlag ?? '') ==
                                                    2
                                                ? 0
                                                : listState
                                                    .indexOf(changeFlag ?? '');
                                        log(hehe.toString());
                                        currentFoodList.clear();

                                        loadMoreMenuFood(
                                          page: currentPage,
                                          keywords: query,
                                          // filtersFlg: hehe,
                                          activeFlg: hehe,
                                        );
                                      },
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
                                      // onChanged: print,
                                      selectedItem: selectedFlitterFlag,
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
                                    TextFormField(
                                      onTapOutside: (event) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      onChanged: searchProduct,
                                      controller: searchController,
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
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Column(
                                children: [
                                  // Container(
                                  //   width: 1.sw * 2.4,
                                  //   height: 50.h,
                                  //   color: Colors.amber,
                                  // ),
                                  SizedBox(
                                    width: 1.sw * 2.5,
                                    height: 500.h,
                                    child: ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        // scrollDirection: Axis.horizontal,
                                        controller: scrollListFoodController,
                                        shrinkWrap: true,
                                        itemCount: filterProducts.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var dataLength =
                                              filterProducts.length;

                                          if (index < dataLength) {
                                            DataFoodAllStore product =
                                                filterProducts[index];
                                            var imagePath1 =
                                                filterProducts[index]
                                                    ?.foodImages
                                                    .replaceAll('["', '');
                                            var imagePath2 =
                                                imagePath1.replaceAll('"]', '');
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                  dividerColor:
                                                      Colors.transparent),
                                              child: DataTable(
                                                dividerThickness: 0.0,
                                                columns: const [
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(label: Text('')),
                                                  DataColumn(
                                                    label:
                                                        Center(child: Text('')),
                                                  ),
                                                ],
                                                rows: [
                                                  DataRow(cells: [
                                                    DataCell(Center(
                                                        child: IntrinsicHeight(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            width: 80.w,
                                                            height: 80.w,
                                                            // color: Colors.amber,
                                                            child:
                                                                CachedNetworkImage(
                                                              fit: BoxFit.fill,
                                                              imageUrl:
                                                                  httpImage +
                                                                      imagePath2,
                                                              placeholder:
                                                                  (context,
                                                                          url) =>
                                                                      SizedBox(
                                                                height: 10.w,
                                                                width: 10.w,
                                                                child: const Center(
                                                                    child:
                                                                        CircularProgressIndicator()),
                                                              ),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  const Icon(Icons
                                                                      .error),
                                                            ),
                                                          ),
                                                          space10W,
                                                          SizedBox(
                                                            width: 120.w,
                                                            child: TextApp(
                                                              isOverFlow: false,
                                                              softWrap: true,
                                                              text: product
                                                                      .foodName ??
                                                                  '',
                                                              fontsize: 14.sp,
                                                              color: blueText,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ))),
                                                    DataCell(Center(
                                                      child: SizedBox(
                                                        width: 80.w,
                                                        child: TextApp(
                                                          isOverFlow: false,
                                                          softWrap: true,
                                                          text: product
                                                                  .storeName ??
                                                              '',
                                                          fontsize: 14.sp,
                                                        ),
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                      child: SizedBox(
                                                        width: 120.w,
                                                        child: TextApp(
                                                          isOverFlow: false,
                                                          softWrap: true,
                                                          text:
                                                              "${MoneyFormatter(amount: (product.foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                          fontsize: 14.sp,
                                                        ),
                                                      ),
                                                    )),
                                                    DataCell(Center(
                                                        child: product
                                                                    .activeFlg ==
                                                                1
                                                            ? StatusBoxIsSelling()
                                                            : StatusBoxNoMoreSelling())),
                                                    DataCell(Center(
                                                      child: SizedBox(
                                                        width: 120.w,
                                                        child: TextApp(
                                                          isOverFlow: false,
                                                          softWrap: true,
                                                          text: formatDateTime(
                                                              product.createdAt ??
                                                                  ''),
                                                          fontsize: 14.sp,
                                                        ),
                                                      ),
                                                    )),
                                                    DataCell(Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 30.h,
                                                          child: ButtonIcon(
                                                              isIconCircle:
                                                                  false,
                                                              color1:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      23,
                                                                      193,
                                                                      232,
                                                                      1),
                                                              color2:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      23,
                                                                      193,
                                                                      232,
                                                                      1),
                                                              event: () {
                                                                // context.go(
                                                                //     "/manager_edit_staff_info");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              EditFood()),
                                                                );
                                                              },
                                                              icon: Icons.edit),
                                                        ),
                                                        space15W,
                                                        SizedBox(
                                                          height: 30.h,
                                                          child: ButtonIcon(
                                                              isIconCircle:
                                                                  false,
                                                              color1:
                                                                  const Color.fromRGBO(
                                                                      234,
                                                                      6,
                                                                      6,
                                                                      1),
                                                              color2:
                                                                  const Color
                                                                      .fromRGBO(
                                                                      234,
                                                                      6,
                                                                      6,
                                                                      1),
                                                              event: () {
                                                                showConfirmDialog(
                                                                    context,
                                                                    () {
                                                                  print(
                                                                      "ConFIRM");
                                                                });
                                                              },
                                                              icon:
                                                                  Icons.delete),
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
                            ]),
                          )
                        ],
                      ),
                    )),
                space30H,
                const CopyRightText()
              ],
            ),
          ),
        ),
      )),
    );
  }
}
