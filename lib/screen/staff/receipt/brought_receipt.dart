import 'dart:convert';

import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/brought_receipt/list_brought_receipt_model.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/bill_infor_container.dart';
import 'package:app_restaurant/widgets/brought_receipt_container.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/list_pop_menu.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class StaffBroughtReceipt extends StatefulWidget {
  const StaffBroughtReceipt({super.key});

  @override
  State<StaffBroughtReceipt> createState() => _StaffBroughtReceiptState();
}

class _StaffBroughtReceiptState extends State<StaffBroughtReceipt>
    with TickerProviderStateMixin {
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        client: currentRole,
        shopId: currentShopId,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListBroughtReceiptData(filtersFlg: {"pay_flg": null});
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 4, vsync: this);

    return BlocBuilder<BroughtReceiptBloc, BroughtReceiptPageState>(
        builder: (context, statePage) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: statePage.broughtReceiptPageStatus ==
                  BroughtReceiptPageStatus.succes
              ? Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10.h, left: 25.w, right: 25.w, bottom: 10.h),
                      child: Column(
                        children: [
                          Container(
                            width: 1.sw,
                            height: 100,
                            // color: Colors.red,
                            child: Container(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 40.h,
                                      color: Colors.white,
                                      child: TabBar(
                                          onTap: (index) {
                                            if (index == 0) {
                                              getListBroughtReceiptData(
                                                  filtersFlg: {
                                                    "pay_flg": null
                                                  });
                                            } else if (index == 1) {
                                              getListBroughtReceiptData(
                                                  filtersFlg: {"pay_flg": 1});
                                            } else if (index == 2) {
                                              getListBroughtReceiptData(
                                                  filtersFlg: {"pay_flg": 0});
                                            } else if (index == 3) {
                                              getListBroughtReceiptData(
                                                  filtersFlg: {"pay_flg": 2});
                                            }
                                          },
                                          labelPadding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          labelColor: Colors.white,
                                          unselectedLabelColor:
                                              Colors.black.withOpacity(0.5),
                                          labelStyle:
                                              TextStyle(color: Colors.red),
                                          controller: _tabController,
                                          isScrollable: true,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          indicator: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            color: Colors.blue,
                                            border:
                                                Border.all(color: Colors.blue),
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
                          Expanded(
                            child: Container(
                              width: 1.sw,
                              // height: 500,
                              color: Colors.white,
                              child: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: _tabController,
                                  children: const [
                                    //Tab All
                                    AllWidget(),

                                    //Tab Hoàn thành
                                    CompleteWidget(),

                                    //Tab đang chế biến
                                    PendingWidget(),

                                    //Tab huỷ
                                    CancleWidget()
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 50.h,
                      right: 50.w,
                      child: MaterialButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (
                                BuildContext context,
                              ) {
                                return ManageBroughtReceiptDialog(
                                  role: currentRole,
                                  shopID: currentShopId,
                                  orderID: null,
                                );
                              });
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                        ),
                      ),
                    )
                  ],
                )
              : statePage.broughtReceiptPageStatus ==
                      BroughtReceiptPageStatus.loading
                  ? Center(
                      child: SizedBox(
                        width: 200.w,
                        height: 200.w,
                        child:
                            Lottie.asset('assets/lottie/loading_7_color.json'),
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Lottie.asset('assets/lottie/error.json'),
                          ),
                          space30H,
                          TextApp(
                            text: statePage.errorText.toString(),
                            fontsize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          space30H,
                          Container(
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
        ),
      );
    });
  }
}

class AllWidget extends StatefulWidget {
  const AllWidget({super.key});
  @override
  State<AllWidget> createState() => _AllWidgetState();
}

class _AllWidgetState extends State<AllWidget>
    with AutomaticKeepAliveClientMixin {
  final scrollListFoodController = ScrollController();
  int currentPage = 1;
  List caidaubuoi = [];
  bool hasMore = true;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMoreFood(page: 1, filtersFlg: {"pay_flg": null});

    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        print("LOADD MORE FOOD");
        loadMoreFood(page: currentPage, filtersFlg: {"pay_flg": null});
      }
    });
  }

  @override
  void dispose() {
    scrollListFoodController.dispose();

    super.dispose();
  }

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            client: 'staff',
            shopId: getStaffShopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        client: 'staff',
        shopId: getStaffShopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        client: 'staff',
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
        client: 'staff', shopId: getStaffShopID, orderId: orderID));
  }

  Future loadMoreFood(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
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
          setState(() {
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            caidaubuoi.addAll(broughtReceiptPageRes.data.data);
            currentPage++;
            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMore = false;
            }
          });
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        // Implement logic to refresh data for Tab 1
      },
      child: ListView.builder(
          controller: scrollListFoodController,
          shrinkWrap: true,
          itemCount: caidaubuoi.length + 1,
          itemBuilder: (BuildContext context, int index) {
            var dataLength = caidaubuoi.length;

            if (index < dataLength) {
              var statusTextBill = caidaubuoi[index].payFlg.toString();

              switch (statusTextBill) {
                case "0":
                  statusTextBill = "Đang chế biến";
                  break;

                case "1":
                  statusTextBill = "Hoàn thành";
                  break;

                case "2":
                  statusTextBill = "Đã huỷ";
                  break;
              }
              return Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: BroughtReceiptContainer(
                    dateTime:
                        formatDateTime(caidaubuoi[index].createdAt.toString()),
                    price:
                        "${MoneyFormatter(amount: (caidaubuoi[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                    typePopMenu: statusTextBill == "Đang chế biến"
                        ? PopUpMenuBroughtReceipt(
                            eventButton1: () {
                              getDetailsBroughtReceiptData(
                                  orderID: caidaubuoi[index].orderId);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ManageBroughtReceiptDialog(
                                      role: 'staff',
                                      orderID: caidaubuoi[index].orderId,
                                      shopID: getStaffShopID,
                                    );
                                  });
                            },
                            eventButton2: () {
                              getPaymentData(
                                tableId: '',
                                orderID: caidaubuoi[index].orderId.toString(),
                              );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PayBillDialog(
                                      role: 'staff',
                                      shopID: getStaffShopID,
                                      orderID:
                                          caidaubuoi[index].orderId.toString(),
                                      roomID: '',
                                      nameRoom: '',
                                      eventSaveButton: () {
                                        getListBroughtReceiptData(
                                            filtersFlg: {"pay_flg": null});

                                        // getDataTabIndex(
                                        //   roomId: data.storeRoomId.toString(),
                                        // );
                                      },
                                    );
                                  });
                            },
                            eventButton3: () {
                              printBroughtReceipt(
                                  orderID: caidaubuoi[index].orderId);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PrintBroughtReceiptDialog(
                                      role: 'staff',
                                      shopID: getStaffShopID,
                                      orderID:
                                          caidaubuoi[index].orderId.toString(),
                                    );
                                  });
                            },
                            eventButton4: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CancleBillDialog(
                                      eventSaveButton: () {
                                        Navigator.of(context).pop();
                                        getListBroughtReceiptData(
                                            filtersFlg: {"pay_flg": null});
                                      },
                                      role: 'staff',
                                      shopID: getStaffShopID,
                                      orderID: caidaubuoi[index].orderId,
                                    );
                                  });
                            },
                          )
                        : PopUpMenuPrintBill(
                            eventButton1: () {
                              printBroughtReceipt(
                                  orderID: caidaubuoi[index].orderId);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PrintBroughtReceiptDialog(
                                      role: 'staff',
                                      shopID: getStaffShopID,
                                      orderID:
                                          caidaubuoi[index].orderId.toString(),
                                    );
                                  });
                            },
                          ),
                    statusText: statusTextBill),
              );
            } else {
              return Center(
                child: hasMore
                    ? CircularProgressIndicator()
                    : Text("Đã hết dữ liệu"),
              );
            }
          }),
    );
  }
}

class CompleteWidget extends StatefulWidget {
  const CompleteWidget({super.key});

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageComplete = 1;
  List listBillComplete = [];
  bool hasMoreComplete = true;

  final scrollTabCompleteController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreComplete(page: 1, filtersFlg: {"pay_flg": 1});
    scrollTabCompleteController.addListener(() {
      if (scrollTabCompleteController.position.maxScrollExtent ==
          scrollTabCompleteController.offset) {
        loadMoreComplete(page: currentPageComplete, filtersFlg: {"pay_flg": 1});
      }
    });
  }

  @override
  void dispose() {
    scrollTabCompleteController.dispose();

    super.dispose();
  }

  Future loadMoreComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
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
          setState(() {
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillComplete.addAll(broughtReceiptPageRes.data.data);
            currentPageComplete++;

            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreComplete = false;
            }
          });
          print("DATA BACK ${data}");
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        // Implement logic to refresh data for Tab 1
      },
      child: listBillComplete.isNotEmpty
          ? ListView.builder(
              controller: scrollTabCompleteController,
              shrinkWrap: true,
              itemCount: listBillComplete.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index < listBillComplete.length) {
                  return Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            listBillComplete[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillComplete[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: PopUpMenuPrintBill(
                          eventButton1: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return PrintBroughtReceiptDialog(
                                    role: 'staff',
                                    shopID: getStaffShopID,
                                    orderID: listBillComplete[index]
                                        .orderId
                                        .toString(),
                                  );
                                });
                          },
                        ),
                        statusText: "Hoàn thành"),
                  );
                } else {
                  return Center(
                    child: hasMoreComplete
                        ? CircularProgressIndicator()
                        : Text("Đã hết dữ liệu"),
                  );
                }
              })
          : Center(
              child: SizedBox(
                  width: 1.sw,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 50.h,
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

  final scrollTabPendingController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreComplete(page: 1, filtersFlg: {"pay_flg": 0});
    scrollTabPendingController.addListener(() {
      if (scrollTabPendingController.position.maxScrollExtent ==
          scrollTabPendingController.offset) {
        loadMoreComplete(page: currentPagePending, filtersFlg: {"pay_flg": 0});
      }
    });
  }

  @override
  void dispose() {
    scrollTabPendingController.dispose();

    super.dispose();
  }

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            client: 'staff',
            shopId: getStaffShopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        client: 'staff',
        shopId: getStaffShopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        client: 'staff',
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  Future loadMoreComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
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
          setState(() {
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillPending.addAll(broughtReceiptPageRes.data.data);
            currentPagePending++;

            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreComplete = false;
            }
          });
          print("DATA BACK ${data}");
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        // Implement logic to refresh data for Tab 1
      },
      child: ListView.builder(
          controller: scrollTabPendingController,
          shrinkWrap: true,
          itemCount: listBillPending.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < listBillPending.length) {
              return Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: BroughtReceiptContainer(
                    dateTime: formatDateTime(
                        listBillPending[index].createdAt.toString()),
                    price:
                        "${MoneyFormatter(amount: (listBillPending[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                    typePopMenu: PopUpMenuBroughtReceipt(
                      eventButton1: () {
                        getDetailsBroughtReceiptData(
                            orderID: listBillPending[index].orderId);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ManageBroughtReceiptDialog(
                                role: 'staff',
                                orderID: listBillPending[index].orderId,
                                shopID: getStaffShopID,
                              );
                            });
                      },
                      eventButton2: () {
                        getPaymentData(
                          tableId: '',
                          orderID: listBillPending[index].orderId.toString(),
                        );
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PayBillDialog(
                                role: 'staff',
                                shopID: getStaffShopID,
                                orderID:
                                    listBillPending[index].orderId.toString(),
                                roomID: '',
                                nameRoom: '',
                                eventSaveButton: () {
                                  getListBroughtReceiptData(
                                      filtersFlg: {"pay_flg": null});

                                  // getDataTabIndex(
                                  //   roomId: data.storeRoomId.toString(),
                                  // );
                                },
                              );
                            });
                      },
                      eventButton3: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PrintBroughtReceiptDialog(
                                role: 'staff',
                                shopID: getStaffShopID,
                                orderID:
                                    listBillPending[index].orderId.toString(),
                              );
                            });
                      },
                      eventButton4: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CancleBillDialog(
                                eventSaveButton: () {
                                  Navigator.of(context).pop();

                                  getListBroughtReceiptData(
                                      filtersFlg: {"pay_flg": 0});
                                },
                                role: 'staff',
                                shopID: getStaffShopID,
                                orderID: listBillPending[index].orderId,
                              );
                            });
                      },
                    ),
                    statusText: "Đang chế biến"),
              );
            } else {
              return Center(
                child: hasMoreComplete
                    ? CircularProgressIndicator()
                    : Text("Đã hết dữ liệu"),
              );
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CancleWidget extends StatefulWidget {
  const CancleWidget({super.key});

  @override
  State<CancleWidget> createState() => _CancleWidgetState();
}

class _CancleWidgetState extends State<CancleWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageCancle = 1;
  List listBillCancle = [];
  bool hasMoreCanle = true;

  final scrollTabCancleController2 = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreCancle(page: 1, filtersFlg: {"pay_flg": 2});
    scrollTabCancleController2.addListener(() {
      if (scrollTabCancleController2.position.maxScrollExtent ==
          scrollTabCancleController2.offset) {
        loadMoreCancle(page: currentPageCancle, filtersFlg: {"pay_flg": 2});
      }
    });
  }

  @override
  void dispose() {
    scrollTabCancleController2.dispose();

    super.dispose();
  }

  Future loadMoreCancle(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
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
          setState(() {
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillCancle.addAll(broughtReceiptPageRes.data.data);
            currentPageCancle++;

            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreCanle = false;
            }
          });
          print("DATA BACK ${data}");
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        // Implement logic to refresh data for Tab 1
      },
      child: ListView.builder(
          controller: scrollTabCancleController2,
          shrinkWrap: true,
          itemCount: listBillCancle.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index < listBillCancle.length) {
              return Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w),
                child: BroughtReceiptContainer(
                    dateTime: formatDateTime(
                        listBillCancle[index].createdAt.toString()),
                    price:
                        "${MoneyFormatter(amount: (listBillCancle[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                    typePopMenu: PopUpMenuPrintBill(
                      eventButton1: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return PrintBroughtReceiptDialog(
                                role: 'staff',
                                shopID: getStaffShopID,
                                orderID:
                                    listBillCancle[index].orderId.toString(),
                              );
                            });
                      },
                    ),
                    statusText: "Đã huỷ"),
              );
            } else {
              return Center(
                child: hasMoreCanle
                    ? CircularProgressIndicator()
                    : Text("Đã hết dữ liệu"),
              );
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
