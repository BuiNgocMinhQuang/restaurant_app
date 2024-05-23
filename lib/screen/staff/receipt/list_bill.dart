import 'dart:convert';
import 'dart:developer';

import 'package:app_restaurant/bloc/list_bill_shop/list_bill_shop_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/bill/list_bill_model.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';

import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/card/card_receipt_container.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';

class StaffListBill extends StatefulWidget {
  const StaffListBill({super.key});

  @override
  State<StaffListBill> createState() => _StaffListBillState();
}

class _StaffListBillState extends State<StaffListBill>
    with TickerProviderStateMixin {
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;
  void getListBillShop({required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<ListBillShopBloc>(context).add(GetListBillShop(
        token: StorageUtils.instance.getString(key: 'token_staff'),
        client: currentRole,
        shopId: currentShopId,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  @override
  void initState() {
    super.initState();
    getListBillShop(filtersFlg: {"pay_flg": null});
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 4,
      vsync: this,
    );
    return BlocBuilder<ListBillShopBloc, ListBillShopState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: state.listBillShopStatus == ListBillShopStatus.succes
                  ? Padding(
                      padding: EdgeInsets.only(
                          top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 1.sw,
                            // height: 100,
                            child: SizedBox(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 45.h,
                                      color: Colors.white,
                                      child: TabBar(
                                          tabAlignment: TabAlignment.start,
                                          dividerColor: Colors.transparent,
                                          dividerHeight: 0,
                                          onTap: (index) {
                                            if (index == 0) {
                                              getListBillShop(filtersFlg: {
                                                "pay_flg": null
                                              });
                                            } else if (index == 1) {
                                              getListBillShop(
                                                  filtersFlg: {"pay_flg": 1});
                                            } else if (index == 2) {
                                              getListBillShop(
                                                  filtersFlg: {"pay_flg": 0});
                                            } else if (index == 3) {
                                              getListBillShop(filtersFlg: {
                                                "close_order": 1
                                              });
                                            }
                                          },
                                          labelPadding: EdgeInsets.only(
                                              left: 10.w, right: 10.w),
                                          labelColor: Colors.white,
                                          unselectedLabelColor:
                                              Colors.black.withOpacity(0.5),
                                          labelStyle: const TextStyle(
                                              color: Colors.red),
                                          controller: tabController,
                                          isScrollable: true,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          indicator: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                          ),
                                          tabs: [
                                            CustomTab(
                                                text: "Tất cả",
                                                icon: Icons.list_alt),
                                            CustomTab(
                                              text: "Đã thanh toán",
                                              icon: Icons.credit_score,
                                            ),
                                            CustomTab(
                                                text: "Chưa thanh toán",
                                                icon: Icons.credit_card),
                                            CustomTab(
                                                text: "Hóa đơn đã hủy",
                                                icon: Icons.cancel_sharp),
                                          ]),
                                    ))),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Expanded(
                              child: Container(
                            width: 1.sw,
                            color: Colors.white,
                            child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: tabController,
                                children: const [
                                  //Tab All
                                  ListAllBillShop(),
                                  //Tab Paid
                                  ListCompleteBillShop(),

                                  //Tab Unpaid
                                  PendingWidget(),
                                  //Tab Cancle
                                  ListCancleBillShop(),
                                ]),
                          )),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    )
                  : state.listBillShopStatus == ListBillShopStatus.loading
                      ? Center(
                          child: SizedBox(
                            width: 200.w,
                            height: 200.w,
                            child: Lottie.asset(
                                'assets/lottie/loading_7_color.json'),
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Lottie.asset('assets/lottie/error.json'),
                              ),
                              space30H,
                              TextApp(
                                text: state.errorText.toString(),
                                fontsize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              space30H,
                              SizedBox(
                                width: 200,
                                child: ButtonGradient(
                                  color1: color1BlueButton,
                                  color2: color2BlueButton,
                                  event: () {},
                                  text: 'Thử lại',
                                  fontSize: 12.sp,
                                  radius: 8.r,
                                  textColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
            ));
      },
    );
  }
}

class ListAllBillShop extends StatefulWidget {
  const ListAllBillShop({super.key});

  @override
  State<ListAllBillShop> createState() => _ListAllBillShopState();
}

class _ListAllBillShopState extends State<ListAllBillShop>
    with AutomaticKeepAliveClientMixin {
  final scrollListBillController = ScrollController();
  int currentPage = 1;
  List newListAllBillShop = [];
  bool hasMore = true;
  bool isRefesh = false;

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  @override
  bool get wantKeepAlive => true;
  Future loadMoreBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $tokenStaff"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      // log("DAT BACK LOAD MORE ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  newListAllBillShop.addAll(listBillShopRes.data.data);
                  currentPage++;
                  isRefesh = false;

                  if (listBillShopRes.data.data.isEmpty ||
                      listBillShopRes.data.data.length <= 15) {
                    hasMore = false;
                  }
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  Future refeshBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $tokenStaff"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      // log("DAT BACK LOAD MORE ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  newListAllBillShop.clear();
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  newListAllBillShop.addAll(listBillShopRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  void initState() {
    super.initState();
    loadMoreBill(page: 1, filtersFlg: {"pay_flg": null});

    scrollListBillController.addListener(() {
      if (scrollListBillController.position.maxScrollExtent ==
              scrollListBillController.offset &&
          isRefesh == false) {
        loadMoreBill(page: currentPage, filtersFlg: {"pay_flg": null});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollListBillController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        refeshBill(page: 1, filtersFlg: {"pay_flg": null});
      },
      child: newListAllBillShop.isNotEmpty
          ? ListView.builder(
              controller: scrollListBillController,
              shrinkWrap: true,
              itemCount: newListAllBillShop.length + 1,
              itemBuilder: (BuildContext context, int index) {
                var dataLength = newListAllBillShop.length;
                if (index < dataLength) {
                  var statusTextBill =
                      newListAllBillShop[index].payFlg.toString();
                  var statusCloseBill =
                      newListAllBillShop[index].closeOrder.toString();
                  switch (statusTextBill) {
                    case "0":
                      statusTextBill = "Chưa thanh toán";
                      break;

                    case "1":
                      statusTextBill = "Đã thanh toán";
                      break;
                  }
                  switch (statusCloseBill) {
                    case "1":
                      statusTextBill = "Hoá đơn bị huỷ";
                      break;
                  }

                  log(newListAllBillShop[index]
                      ?.bookedTables
                      ?.map((table) => table?.roomTable?.tableName)
                      ?.join(','));
                  var tableNameBill = newListAllBillShop[index]
                      ?.bookedTables
                      ?.map((table) => table?.roomTable?.tableName)
                      ?.join(',');

                  return Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BillInforContainer(
                        tableName: tableNameBill, //check ghep ban cho nay
                        roomName:
                            newListAllBillShop[index]?.room?.storeRoomName ??
                                '',
                        dateTime: formatDateTime(
                            newListAllBillShop[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (newListAllBillShop[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.r),
                                    topLeft: Radius.circular(25.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => Container(
                                  height: 1.sh / 3,
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBillDialog(
                                                  shopID:
                                                      newListAllBillShop[index]
                                                          .storeId
                                                          .toString(),
                                                  role: 'staff',
                                                  token: tokenStaff,
                                                  orderID:
                                                      newListAllBillShop[index]
                                                          .orderId,
                                                  roomName:
                                                      newListAllBillShop[index]
                                                              ?.room
                                                              ?.storeRoomName ??
                                                          '',
                                                  tableName: tableNameBill,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            // Icon(
                                            //   Icons.receipt,
                                            //   size: 35.sp,
                                            // ),
                                            SizedBox(
                                              width: 35.w,
                                              height: 35.w,
                                              child: Image.asset(
                                                "assets/images/receipt.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      const Divider(),
                                      space10H,
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        statusText: statusTextBill),
                  );
                } else {
                  return Center(
                    child: hasMore
                        ? const CircularProgressIndicator()
                        : Container(),
                  );
                }
              })
          : Center(
              child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.receipt_long_rounded,
                      //   size: 50.h,
                      // ),
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                        child: Image.asset(
                          "assets/images/receipt.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                          text: "Chưa có hoá đơn :(",
                          textAlign: TextAlign.center,
                          fontsize: 16.sp,
                          color: Colors.black),
                    ],
                  )),
            ),
    );
  }
}

class ListCompleteBillShop extends StatefulWidget {
  const ListCompleteBillShop({super.key});

  @override
  State<ListCompleteBillShop> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<ListCompleteBillShop>
    with AutomaticKeepAliveClientMixin {
  int currentPageComplete = 1;
  List listBillComplete = [];
  bool hasMoreComplete = true;
  bool isRefesh = false;

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  final scrollTabCompleteController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreCompleteBill(page: 1, filtersFlg: {"pay_flg": 1});
    scrollTabCompleteController.addListener(() {
      if (scrollTabCompleteController.position.maxScrollExtent ==
              scrollTabCompleteController.offset &&
          isRefesh == false) {
        loadMoreCompleteBill(
            page: currentPageComplete, filtersFlg: {"pay_flg": 1});
      }
    });
  }

  @override
  void dispose() {
    scrollTabCompleteController.dispose();

    super.dispose();
  }

  Future loadMoreCompleteBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      // log("DAT BACK LOAD MORE ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillComplete.addAll(listBillShopRes.data.data);
                  currentPageComplete++;
                  isRefesh = false;
                  if (listBillShopRes.data.data.isEmpty ||
                      listBillShopRes.data.data.length <= 15) {
                    hasMoreComplete = false;
                  }
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  Future refeshCompleteBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      // log("DAT BACK LOAD MORE ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  listBillComplete.clear();
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillComplete.addAll(listBillShopRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        refeshCompleteBill(page: 1, filtersFlg: {"pay_flg": 1});
      },
      child: listBillComplete.isNotEmpty
          ? ListView.builder(
              controller: scrollTabCompleteController,
              shrinkWrap: true,
              itemCount: listBillComplete.length + 1,
              itemBuilder: (BuildContext context, int index) {
                var dataLength = listBillComplete.length;
                if (index < dataLength) {
                  var statusCloseBill =
                      listBillComplete[index].closeOrder.toString();
                  var tableNameBill = listBillComplete[index]
                      ?.bookedTables
                      ?.map((table) => table?.roomTable?.tableName)
                      ?.join(',');
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BillInforContainer(
                        tableName: tableNameBill, //check ghep ban cho nay
                        roomName:
                            listBillComplete[index]?.room?.storeRoomName ?? '',
                        dateTime: formatDateTime(
                            listBillComplete[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillComplete[index].clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.r),
                                    topLeft: Radius.circular(25.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => Container(
                                  height: 1.sh / 3,
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBillDialog(
                                                  shopID:
                                                      listBillComplete[index]
                                                          .storeId
                                                          .toString(),
                                                  role: 'staff',
                                                  token: tokenStaff,
                                                  orderID:
                                                      listBillComplete[index]
                                                          .orderId,
                                                  roomName:
                                                      listBillComplete[index]
                                                              ?.room
                                                              ?.storeRoomName ??
                                                          '',
                                                  tableName: tableNameBill,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            // Icon(
                                            //   Icons.receipt,
                                            //   size: 35.sp,
                                            // ),
                                            SizedBox(
                                              width: 35.w,
                                              height: 35.w,
                                              child: Image.asset(
                                                "assets/images/receipt.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      const Divider(),
                                      space10H,
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        statusText: statusCloseBill == "1"
                            ? "Hoá đơn bị huỷ"
                            : "Đã thanh toán"),
                  );
                } else {
                  return Center(
                    child: hasMoreComplete
                        ? const CircularProgressIndicator()
                        : Container(),
                  );
                }
              })
          : Center(
              child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.receipt_long_rounded,
                      //   size: 50.h,
                      // ),
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                        child: Image.asset(
                          "assets/images/receipt.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                          text: "Chưa có hoá đơn :(",
                          textAlign: TextAlign.center,
                          fontsize: 16.sp,
                          color: Colors.black),
                    ],
                  )),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PendingWidget extends StatefulWidget {
  const PendingWidget({super.key});

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPagePending = 1;
  List listBillPending = [];
  bool hasMoreComplete = true;
  bool isRefesh = false;

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  final scrollTabPendingController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMorePending(page: 1, filtersFlg: {"pay_flg": 0});
    scrollTabPendingController.addListener(() {
      if (scrollTabPendingController.position.maxScrollExtent ==
              scrollTabPendingController.offset &&
          isRefesh == false) {
        loadMorePending(page: currentPagePending, filtersFlg: {"pay_flg": 0});
      }
    });
  }

  @override
  void dispose() {
    scrollTabPendingController.dispose();
    super.dispose();
  }

  Future loadMorePending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillPending.addAll(listBillShopRes.data.data);
                  currentPagePending++;
                  isRefesh = false;

                  if (listBillShopRes.data.data.isEmpty ||
                      listBillShopRes.data.data.length <= 15) {
                    hasMoreComplete = false;
                  }
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  Future refeshPending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  listBillPending.clear();
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillPending.addAll(listBillShopRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        refeshPending(page: 1, filtersFlg: {"pay_flg": 0});
      },
      child: listBillPending.isNotEmpty
          ? ListView.builder(
              controller: scrollTabPendingController,
              shrinkWrap: true,
              itemCount: listBillPending.length + 1,
              itemBuilder: (BuildContext context, int index) {
                var dataLength = listBillPending.length;
                if (index < dataLength) {
                  var tableNameBill = listBillPending[index]
                      ?.bookedTables
                      ?.map((table) => table?.roomTable?.tableName)
                      ?.join(',');
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BillInforContainer(
                        tableName: tableNameBill, //check ghep ban cho nay
                        roomName:
                            listBillPending[index]?.room?.storeRoomName ?? '',
                        dateTime: formatDateTime(
                            listBillPending[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillPending[index].clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.r),
                                    topLeft: Radius.circular(25.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => Container(
                                  height: 1.sh / 3,
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBillDialog(
                                                  shopID: listBillPending[index]
                                                      .storeId
                                                      .toString(),
                                                  role: 'staff',
                                                  token: tokenStaff,
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId,
                                                  roomName:
                                                      listBillPending[index]
                                                              ?.room
                                                              ?.storeRoomName ??
                                                          '',
                                                  tableName: tableNameBill,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            // Icon(
                                            //   Icons.receipt,
                                            //   size: 35.sp,
                                            // ),
                                            SizedBox(
                                              width: 35.w,
                                              height: 35.w,
                                              child: Image.asset(
                                                "assets/images/receipt.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      const Divider(),
                                      space10H,
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        statusText: "Chưa thanh toán"),
                  );
                } else {
                  return Center(
                    child: hasMoreComplete
                        ? const CircularProgressIndicator()
                        : Container(),
                  );
                }
              })
          : Center(
              child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.receipt_long_rounded,
                      //   size: 50.h,
                      // ),
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                        child: Image.asset(
                          "assets/images/receipt.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                          text: "Chưa có hoá đơn :(",
                          textAlign: TextAlign.center,
                          fontsize: 16.sp,
                          color: Colors.black),
                    ],
                  )),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ListCancleBillShop extends StatefulWidget {
  const ListCancleBillShop({super.key});

  @override
  State<ListCancleBillShop> createState() => _ListCancleBillShopState();
}

class _ListCancleBillShopState extends State<ListCancleBillShop>
    with AutomaticKeepAliveClientMixin {
  int currentPageCancle = 1;
  List listBillCancle = [];
  bool hasMoreCancle = true;
  bool isRefesh = false;

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  final scrollTabCancleController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreCancleBill(page: 1, filtersFlg: {"close_order": 1});
    scrollTabCancleController.addListener(() {
      if (scrollTabCancleController.position.maxScrollExtent ==
              scrollTabCancleController.offset &&
          isRefesh == false) {
        loadMoreCancleBill(
            page: currentPageCancle, filtersFlg: {"close_order": 1});
      }
    });
  }

  @override
  void dispose() {
    scrollTabCancleController.dispose();

    super.dispose();
  }

  Future loadMoreCancleBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillCancle.addAll(listBillShopRes.data.data);
                  currentPageCancle++;
                  isRefesh = false;

                  if (listBillShopRes.data.data.isEmpty ||
                      listBillShopRes.data.data.length <= 15) {
                    hasMoreCancle = false;
                  }
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  Future refeshCancleBill(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');

      final respons = await http.post(
        Uri.parse('$baseUrl$listBill'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'staff',
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  listBillCancle.clear();
                  var listBillShopRes = ListBillShopModel.fromJson(data);
                  listBillCancle.addAll(listBillShopRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        refeshCancleBill(page: 1, filtersFlg: {"close_order": 1});
      },
      child: listBillCancle.isNotEmpty
          ? ListView.builder(
              controller: scrollTabCancleController,
              shrinkWrap: true,
              itemCount: listBillCancle.length + 1,
              itemBuilder: (BuildContext context, int index) {
                var dataLength = listBillCancle.length;
                if (index < dataLength) {
                  var tableNameBill = listBillCancle[index]
                      ?.bookedTables
                      ?.map((table) => table?.roomTable?.tableName)
                      ?.join(',');
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BillInforContainer(
                        tableName: tableNameBill, //check ghep ban cho nay
                        roomName:
                            listBillCancle[index]?.room?.storeRoomName ?? '',
                        dateTime: formatDateTime(
                            listBillCancle[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillCancle[index].clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: InkWell(
                            onTap: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(25.r),
                                    topLeft: Radius.circular(25.r),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) => Container(
                                  height: 1.sh / 3,
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBillDialog(
                                                  shopID: listBillCancle[index]
                                                      .storeId
                                                      .toString(),
                                                  role: 'staff',
                                                  token: tokenStaff,
                                                  orderID: listBillCancle[index]
                                                      .orderId,
                                                  roomName:
                                                      listBillCancle[index]
                                                              ?.room
                                                              ?.storeRoomName ??
                                                          '',
                                                  tableName: tableNameBill,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            // Icon(
                                            //   Icons.receipt,
                                            //   size: 35.sp,
                                            // ),
                                            SizedBox(
                                              width: 35.w,
                                              height: 35.w,
                                              child: Image.asset(
                                                "assets/images/receipt.png",
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      const Divider(),
                                      space10H,
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        statusText: "Hoá đơn bị huỷ"),
                  );
                } else {
                  return Center(
                    child: hasMoreCancle
                        ? const CircularProgressIndicator()
                        : Container(),
                  );
                }
              })
          : Center(
              child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(
                      //   Icons.receipt_long_rounded,
                      //   size: 50.h,
                      // ),
                      SizedBox(
                        width: 35.w,
                        height: 35.w,
                        child: Image.asset(
                          "assets/images/receipt.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextApp(
                          text: "Chưa có hoá đơn :(",
                          textAlign: TextAlign.center,
                          fontsize: 16.sp,
                          color: Colors.black),
                    ],
                  )),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
