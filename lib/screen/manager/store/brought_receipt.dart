import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/brought_receipt/list_brought_receipt_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/card/card_receipt_container.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';

class ManagerBroughtReceipt extends StatefulWidget {
  final String shopID;
  const ManagerBroughtReceipt({
    Key? key,
    required this.shopID,
  }) : super(key: key);

  @override
  State<ManagerBroughtReceipt> createState() => _ManagerBroughtReceiptState();
}

class _ManagerBroughtReceiptState extends State<ManagerBroughtReceipt>
    with TickerProviderStateMixin {
  final String currentRole = "user";
  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';
  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: tokenManager,
        client: currentRole,
        shopId: widget.shopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            token: tokenManager,
            client: 'user',
            shopId: widget.shopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 4, vsync: this);

    return BlocBuilder<BroughtReceiptBloc, BroughtReceiptPageState>(
        builder: (context, statePage) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SafeArea(
                child: statePage.broughtReceiptPageStatus ==
                        BroughtReceiptPageStatus.succes
                    ? Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10.h,
                                left: 25.w,
                                right: 25.w,
                                bottom: 10.h),
                            child: Column(
                              children: [
                                SizedBox(
                                    width: 1.sw,
                                    height: 100,
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
                                                      filtersFlg: {
                                                        "pay_flg": 1
                                                      });
                                                } else if (index == 2) {
                                                  getListBroughtReceiptData(
                                                      filtersFlg: {
                                                        "pay_flg": 0
                                                      });
                                                } else if (index == 3) {
                                                  getListBroughtReceiptData(
                                                      filtersFlg: {
                                                        "pay_flg": 2
                                                      });
                                                }
                                              },
                                              labelPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 20),
                                              labelColor: Colors.black,
                                              unselectedLabelColor:
                                                  Colors.black.withOpacity(0.5),
                                              labelStyle: const TextStyle(
                                                  color: Colors.red),
                                              controller: tabController,
                                              isScrollable: true,
                                              indicatorSize:
                                                  TabBarIndicatorSize.label,
                                              indicator: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  8.r,
                                                ),
                                                color: Colors.blue,
                                                border: Border.all(
                                                    color: Colors.blue),
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
                                Expanded(
                                  child: Container(
                                    width: 1.sw,
                                    // height: 500,
                                    color: Colors.white,
                                    child: TabBarView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: tabController,
                                        children: [
                                          //Tab All
                                          AllWidget(
                                            shopID: widget.shopID,
                                          ),

                                          //Tab Hoàn thành
                                          CompleteWidget(
                                            shopID: widget.shopID,
                                          ),

                                          //Tab đang chế biến
                                          PendingWidget(
                                            shopID: widget.shopID,
                                          ),

                                          //Tab huỷ
                                          CancleWidget(
                                            shopID: widget.shopID,
                                          )
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
                              onPressed: () async {
                                getDetailsBroughtReceiptData(orderID: null);
                                await showDialog(
                                    context: context,
                                    builder: (
                                      BuildContext context,
                                    ) {
                                      return ManageBroughtReceiptDialog(
                                        token: tokenManager,
                                        role: currentRole,
                                        shopID: widget.shopID,
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
                                  child:
                                      Lottie.asset('assets/lottie/error.json'),
                                ),
                                space30H,
                                TextApp(
                                  text: statePage.errorText.toString(),
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
                                    text: 'Đóng',
                                    fontSize: 12.sp,
                                    radius: 8.r,
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
              ),
            ],
          ));
    });
  }
}

class AllWidget extends StatefulWidget {
  final String shopID;
  const AllWidget({
    Key? key,
    required this.shopID,
  }) : super(key: key);
  @override
  State<AllWidget> createState() => _AllWidgetState();
}

class _AllWidgetState extends State<AllWidget>
    with AutomaticKeepAliveClientMixin {
  final scrollListFoodController = ScrollController();
  int currentPage = 1;
  List newListFood = [];
  bool hasMore = true;
  bool isRefesh = false;

  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadMoreFood(page: 1, filtersFlg: {"pay_flg": null});

    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
              scrollListFoodController.offset &&
          isRefesh == false) {
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
            token: tokenManager,
            client: 'user',
            shopId: widget.shopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: tokenManager,
        client: 'user',
        shopId: widget.shopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        token: tokenManager,
        client: 'user',
        shopId: widget.shopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenManager,
      client: 'user',
      shopId: widget.shopID,
      orderId: orderID,
    ));
  }

  Future loadMoreFood(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      print("DATA $data");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  newListFood.addAll(broughtReceiptPageRes.data.data);
                  currentPage++;
                  isRefesh = false;

                  if (broughtReceiptPageRes.data.data.isEmpty ||
                      broughtReceiptPageRes.data.data.length <= 15) {
                    hasMore = false;
                  }
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT ALL PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT ALL PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT ALL PAGE 3 $error");
    }
  }

  Future refeshFood(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': filtersFlg,
        }),
      );
      final data = jsonDecode(respons.body);
      print("DATA $data");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  newListFood.clear();
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  newListFood.addAll(broughtReceiptPageRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR BROUGHT RECEIPT ALL PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT ALL PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT ALL PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        refeshFood(page: 1, filtersFlg: {"pay_flg": null});
      },
      child: newListFood.isNotEmpty
          ? ListView.builder(
              controller: scrollListFoodController,
              shrinkWrap: true,
              itemCount: newListFood.length + 1,
              itemBuilder: (BuildContext context, int index) {
                var dataLength = newListFood.length;

                if (index < dataLength) {
                  var statusTextBill = newListFood[index].payFlg.toString();

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
                  log(newListFood[index].createdAt.toString());
                  return Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            newListFood[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (newListFood[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: statusTextBill == "Đang chế biến"
                            ? Container(
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
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        context: context,
                                        builder: (context) => Container(
                                              height: 1.sh / 3,
                                              padding: EdgeInsets.all(20.w),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      getDetailsBroughtReceiptData(
                                                          orderID:
                                                              newListFood[index]
                                                                  .orderId);
                                                      await showDialog(
                                                          context: navigatorKey
                                                              .currentContext!,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ManageBroughtReceiptDialog(
                                                              token:
                                                                  tokenManager,
                                                              role: 'user',
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId,
                                                              shopID:
                                                                  widget.shopID,
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.receipt,
                                                          size: 35.sp,
                                                        ),
                                                        space10W,
                                                        TextApp(
                                                          text:
                                                              "Quản lý hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  space10H,
                                                  Divider(),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      getPaymentData(
                                                        tableId: '',
                                                        orderID:
                                                            newListFood[index]
                                                                .orderId
                                                                .toString(),
                                                      );
                                                      await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PayBillDialog(
                                                              token:
                                                                  tokenManager,
                                                              role: 'user',
                                                              shopID:
                                                                  widget.shopID,
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId
                                                                      .toString(),
                                                              roomID: '',
                                                              nameRoom: '',
                                                              eventSaveButton:
                                                                  () {
                                                                getListBroughtReceiptData(
                                                                    filtersFlg: {
                                                                      "pay_flg":
                                                                          null
                                                                    });
                                                              },
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.monetization_on,
                                                          size: 35.sp,
                                                        ),
                                                        space10W,
                                                        TextApp(
                                                          text:
                                                              "Thanh toán hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  space10H,
                                                  Divider(),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      printBroughtReceipt(
                                                          orderID:
                                                              newListFood[index]
                                                                  .orderId);
                                                      await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PrintBroughtReceiptDialog(
                                                              role: 'user',
                                                              shopID:
                                                                  widget.shopID,
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId
                                                                      .toString(),
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.print,
                                                          size: 35.sp,
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
                                                  Divider(),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CancleBillDialog(
                                                              token:
                                                                  tokenManager,
                                                              eventSaveButton:
                                                                  () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                getListBroughtReceiptData(
                                                                    filtersFlg: {
                                                                      "pay_flg":
                                                                          null
                                                                    });
                                                              },
                                                              role: 'user',
                                                              shopID:
                                                                  widget.shopID,
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId,
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.cancel,
                                                          size: 35.sp,
                                                        ),
                                                        space10W,
                                                        TextApp(
                                                          text: "Huỷ hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                  },
                                  child: Icon(
                                    Icons.more_horiz_outlined,
                                    size: 25.sp,
                                  ),
                                ),
                              )
                            : Container(
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
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        context: context,
                                        builder: (context) => Container(
                                              height: 1.sh / 3,
                                              padding: EdgeInsets.all(20.w),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);

                                                      printBroughtReceipt(
                                                          orderID:
                                                              newListFood[index]
                                                                  .orderId);
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PrintBroughtReceiptDialog(
                                                              role: 'user',
                                                              shopID:
                                                                  widget.shopID,
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId
                                                                      .toString(),
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.print,
                                                          size: 35.sp,
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
                                                  Divider(),
                                                  space10H,
                                                ],
                                              ),
                                            ));
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
}

class CompleteWidget extends StatefulWidget {
  final String shopID;
  const CompleteWidget({
    Key? key,
    required this.shopID,
  }) : super(key: key);

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageComplete = 1;
  List listBillComplete = [];
  bool hasMoreComplete = true;
  bool isRefesh = false;
  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';

  final scrollTabCompleteController = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreComplete(page: 1, filtersFlg: {"pay_flg": 1});
    scrollTabCompleteController.addListener(() {
      if (scrollTabCompleteController.position.maxScrollExtent ==
              scrollTabCompleteController.offset &&
          isRefesh == false) {
        loadMoreComplete(page: currentPageComplete, filtersFlg: {"pay_flg": 1});
      }
    });
  }

  @override
  void dispose() {
    scrollTabCompleteController.dispose();

    super.dispose();
  }

  void loadMoreComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            isRefesh = false;
            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreComplete = false;
            }
          });
        } else {
          log("ERROR BROUGHT RECEIPT COMPLETE PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT COMPLETE PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT COMPLETE PAGE 3 $error");
    }
  }

  void refeshListComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            listBillComplete.clear();
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillComplete.addAll(broughtReceiptPageRes.data.data);
            isRefesh = true;
          });
        } else {
          log("ERROR BROUGHT RECEIPT COMPLETE PAGE 1");
        }
      } catch (error) {
        log("ERROR BROUGHT RECEIPT COMPLETE PAGE 2 $error");
      }
    } catch (error) {
      log("ERROR BROUGHT RECEIPT COMPLETE PAGE 3 $error");
    }
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenManager,
      client: 'user',
      shopId: widget.shopID,
      orderId: orderID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        refeshListComplete(page: 1, filtersFlg: {"pay_flg": 1});
      },
      child: listBillComplete.isNotEmpty
          ? ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
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
                        typePopMenu: Container(
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
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      printBroughtReceipt(
                                                          orderID:
                                                              listBillComplete[
                                                                      index]
                                                                  .orderId);

                                                      return PrintBroughtReceiptDialog(
                                                        role: 'user',
                                                        shopID: widget.shopID,
                                                        orderID:
                                                            listBillComplete[
                                                                    index]
                                                                .orderId
                                                                .toString(),
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.print,
                                                    size: 35.sp,
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
                                            Divider(),
                                            space10H,
                                          ],
                                        ),
                                      ));
                            },
                            child: Icon(
                              Icons.more_horiz_outlined,
                              size: 25.sp,
                            ),
                          ),
                        ),
                        statusText: "Hoàn thành"),
                  );
                } else {
                  return Center(
                    child: hasMoreComplete
                        ? CircularProgressIndicator()
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
  final String shopID;
  const PendingWidget({
    Key? key,
    required this.shopID,
  }) : super(key: key);

  @override
  State<PendingWidget> createState() => _PendingWidgetState();
}

class _PendingWidgetState extends State<PendingWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPagePending = 1;
  List listBillPending = [];
  bool hasMoreComplete = true;
  bool isRefesh = false;

  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';

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

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            token: tokenManager,
            client: 'user',
            shopId: widget.shopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: tokenManager,
        client: 'user',
        shopId: widget.shopID,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getPaymentData(
      {String? roomId,
      required String tableId,
      required String orderID}) async {
    BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
        token: tokenManager,
        client: 'user',
        shopId: widget.shopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenManager,
      client: 'user',
      shopId: widget.shopID,
      orderId: orderID,
    ));
  }

  void loadMorePending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            isRefesh = false;

            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreComplete = false;
            }
          });
        } else {
          print("ERROR BROUGHT RECEIPT PENDING PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PENDING PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT  PENDING PAGE 3 $error");
    }
  }

  void refeshPending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            listBillPending.clear();
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillPending.addAll(broughtReceiptPageRes.data.data);
            isRefesh = true;
          });
        } else {
          print("ERROR BROUGHT RECEIPT PENDING PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PENDING PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT  PENDING PAGE 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        refeshPending(page: 1, filtersFlg: {"pay_flg": 0});
      },
      child: listBillPending.isNotEmpty
          ? ListView.builder(
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
                        typePopMenu: Container(
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
                                          getDetailsBroughtReceiptData(
                                              orderID: listBillPending[index]
                                                  .orderId);
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ManageBroughtReceiptDialog(
                                                  token: tokenManager,
                                                  role: 'user',
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId,
                                                  shopID: widget.shopID,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.receipt,
                                              size: 35.sp,
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "Quản lý hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      Divider(),
                                      space10H,
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          getPaymentData(
                                            tableId: '',
                                            orderID: listBillPending[index]
                                                .orderId
                                                .toString(),
                                          );
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PayBillDialog(
                                                  token: tokenManager,
                                                  role: 'user',
                                                  shopID: widget.shopID,
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId
                                                          .toString(),
                                                  roomID: '',
                                                  nameRoom: '',
                                                  eventSaveButton: () {
                                                    getListBroughtReceiptData(
                                                        filtersFlg: {
                                                          "pay_flg": null
                                                        });
                                                  },
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.monetization_on,
                                              size: 35.sp,
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "Thanh toán hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      space10H,
                                      Divider(),
                                      space10H,
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          printBroughtReceipt(
                                              orderID: listBillPending[index]
                                                  .orderId);

                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBroughtReceiptDialog(
                                                  role: 'user',
                                                  shopID: widget.shopID,
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId
                                                          .toString(),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.print,
                                              size: 35.sp,
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
                                      Divider(),
                                      space10H,
                                      InkWell(
                                        onTap: () async {
                                          Navigator.pop(context);

                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CancleBillDialog(
                                                  eventSaveButton: () {
                                                    Navigator.of(context).pop();

                                                    getListBroughtReceiptData(
                                                        filtersFlg: {
                                                          "pay_flg": 0
                                                        });
                                                  },
                                                  token: tokenManager,
                                                  role: 'user',
                                                  shopID: widget.shopID,
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId,
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.cancel,
                                              size: 35.sp,
                                            ),
                                            space10W,
                                            TextApp(
                                              text: "Huỷ hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      )
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
                        statusText: "Đang chế biến"),
                  );
                } else {
                  return Center(
                    child: hasMoreComplete
                        ? CircularProgressIndicator()
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

class CancleWidget extends StatefulWidget {
  final String shopID;
  const CancleWidget({
    Key? key,
    required this.shopID,
  }) : super(key: key);

  @override
  State<CancleWidget> createState() => _CancleWidgetState();
}

class _CancleWidgetState extends State<CancleWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageCancle = 1;
  List listBillCancle = [];
  bool hasMoreCanle = true;
  bool isRefesh = false;

  var tokenManager =
      StorageUtils.instance.getString(key: 'token_manager') ?? '';

  final scrollTabCancleController2 = ScrollController();
  @override
  void initState() {
    super.initState();
    loadMoreCancle(page: 1, filtersFlg: {"pay_flg": 2});
    scrollTabCancleController2.addListener(() {
      if (scrollTabCancleController2.position.maxScrollExtent ==
              scrollTabCancleController2.offset &&
          isRefesh == false) {
        loadMoreCancle(page: currentPageCancle, filtersFlg: {"pay_flg": 2});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollTabCancleController2.dispose();
  }

  Future loadMoreCancle(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            isRefesh = false;

            if (broughtReceiptPageRes.data.data.isEmpty ||
                broughtReceiptPageRes.data.data.length <= 15) {
              hasMoreCanle = false;
            }
          });
          print("DATA BACK ${data}");
        } else {
          print("ERROR BROUGHT RECEIPT CANCLE PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT CANCLE PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT  CANCLE PAGE 3 $error");
    }
  }

  Future refeshCancle(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': 'user',
          'shop_id': widget.shopID,
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
            listBillCancle.clear();
            var broughtReceiptPageRes = ListBroughtReceiptModel.fromJson(data);
            listBillCancle.addAll(broughtReceiptPageRes.data.data);
            isRefesh = true;
          });
          print("DATA BACK ${data}");
        } else {
          print("ERROR BROUGHT RECEIPT CANCLE PAGE 1");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT CANCLE PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT  CANCLE PAGE 3 $error");
    }
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenManager,
      client: 'user',
      shopId: widget.shopID,
      orderId: orderID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blue,
      onRefresh: () async {
        refeshCancle(page: 1, filtersFlg: {"pay_flg": 2});
      },
      child: listBillCancle.isNotEmpty
          ? ListView.builder(
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
                        typePopMenu: Container(
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
                                          printBroughtReceipt(
                                              orderID: listBillCancle[index]
                                                  .orderId);
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBroughtReceiptDialog(
                                                  role: 'user',
                                                  shopID: widget.shopID,
                                                  orderID: listBillCancle[index]
                                                      .orderId
                                                      .toString(),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.print,
                                              size: 35.sp,
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
                                      Divider(),
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
                        statusText: "Đã huỷ"),
                  );
                } else {
                  return Center(
                    child: hasMoreCanle
                        ? CircularProgressIndicator()
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
