import 'dart:convert';
import 'dart:developer';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/model/brought_receipt/list_brought_receipt_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/share_getstring.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/card/card_receipt_container.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  void getListBroughtReceiptData(
      {required Map<String, int?> filtersFlg}) async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: tokenStaff,
        client: currentRole,
        shopId: currentShopId,
        limit: 15,
        page: 1,
        filters: filtersFlg));
  }

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            token: tokenStaff,
            client: 'staff',
            shopId: getStaffShopID,
            limit: 15,
            page: 1,
            filters: null,
            orderId: orderID));
  }

  @override
  void initState() {
    getListBroughtReceiptData(filtersFlg: {"pay_flg": null});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);

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
                          SizedBox(
                            width: 1.sw,
                            // height: 100,
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
                                          getListBroughtReceiptData(
                                              filtersFlg: {"pay_flg": null});
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
                                          left: 10.w, right: 10.w),
                                      labelColor: Colors.white,
                                      unselectedLabelColor:
                                          Colors.black.withOpacity(0.5),
                                      labelStyle:
                                          const TextStyle(color: Colors.red),
                                      controller: tabController,
                                      isScrollable: true,
                                      indicatorSize: TabBarIndicatorSize.label,
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
                                )),
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
                        onPressed: () async {
                          getDetailsBroughtReceiptData(orderID: null);
                          await showDialog(
                              context: context,
                              builder: (
                                BuildContext context,
                              ) {
                                return ManageBroughtReceiptDialog(
                                  token: tokenStaff,
                                  role: currentRole,
                                  shopID: currentShopId,
                                  orderID: null,
                                );
                              });
                        },
                        color: Theme.of(context).colorScheme.primary,
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
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Lottie.asset('assets/lottie/error.json'),
                          ),
                          SizedBox(height: 30.h),
                          TextApp(
                            text: statePage.errorText.toString(),
                            fontsize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: 200,
                            child: ButtonGradient(
                              color1: color1BlueButton,
                              color2: color2BlueButton,
                              event: () {
                                getListBroughtReceiptData(
                                    filtersFlg: {"pay_flg": null});
                              },
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
  const AllWidget({Key? key}) : super(key: key);
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

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    loadMoreFood(page: 1, filtersFlg: {"pay_flg": null});
    newListFood.clear();
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
            token: tokenStaff,
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
        token: tokenStaff,
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
        token: tokenStaff,
        client: 'staff',
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenStaff,
      client: 'staff',
      shopId: getStaffShopID,
      orderId: orderID,
    ));
  }

  void loadMoreFood(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
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
          log("ERROR loadMoreFood 1");
        }
      } catch (error) {
        log("ERROR loadMoreFood 2 $error");
      }
    } catch (error) {
      log("ERROR loadMoreFood 3 $error");
    }
  }

  void refeshFood(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      final respons = await http.post(
        Uri.parse('$baseUrl$getListBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': "Bearer $token"
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
                  newListFood.clear();
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  newListFood.addAll(broughtReceiptPageRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR refeshFood 1");
        }
      } catch (error) {
        log("ERROR refeshFood 2 $error");
      }
    } catch (error) {
      log("ERROR refeshFood 3 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
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
                  return Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            newListFood[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (newListFood[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: statusTextBill == "Đang chế biến"
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                // color: Colors.amber,
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
                                                              token: tokenStaff,
                                                              role: 'staff',
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId,
                                                              shopID:
                                                                  getStaffShopID,
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            width: 35.w,
                                                            height: 35.w,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svg/receipt.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                            )),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextApp(
                                                          text:
                                                              "Quản lý hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Divider(),
                                                  SizedBox(height: 10.h),
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
                                                              token: tokenStaff,
                                                              role: 'staff',
                                                              shopID:
                                                                  getStaffShopID,
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
                                                        SizedBox(
                                                            width: 35.w,
                                                            height: 35.w,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svg/coin.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                            )),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextApp(
                                                          text:
                                                              "Thanh toán hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Divider(),
                                                  SizedBox(height: 10.h),
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
                                                              role: 'staff',
                                                              shopID:
                                                                  getStaffShopID,
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
                                                        SizedBox(
                                                          width: 35.w,
                                                          height: 35.w,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/printing_receipt.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextApp(
                                                          text: "In hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Divider(),
                                                  SizedBox(height: 10.h),
                                                  InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CancleBillDialog(
                                                              token: tokenStaff,
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
                                                              role: 'staff',
                                                              shopID:
                                                                  getStaffShopID,
                                                              orderID:
                                                                  newListFood[
                                                                          index]
                                                                      .orderId,
                                                            );
                                                          });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                            width: 35.w,
                                                            height: 35.w,
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/svg/cancle_icon.svg',
                                                              fit: BoxFit
                                                                  .contain,
                                                            )),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextApp(
                                                          text: "Huỷ hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
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
                            : SizedBox(
                                width: 20,
                                height: 20,
                                // color: Colors.amber,
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
                                                      await showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return PrintBroughtReceiptDialog(
                                                              role: 'staff',
                                                              shopID:
                                                                  getStaffShopID,
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
                                                        SizedBox(
                                                          width: 35.w,
                                                          height: 35.w,
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/svg/printing_receipt.svg',
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        TextApp(
                                                          text: "In hoá đơn",
                                                          color: Colors.black,
                                                          fontsize: 18.sp,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  const Divider(),
                                                  SizedBox(height: 10.h),
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
                      SizedBox(
                          width: 35.w,
                          height: 35.w,
                          child: SvgPicture.asset(
                            'assets/svg/receipt.svg',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 10.h),
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
  const CompleteWidget({super.key});

  @override
  State<CompleteWidget> createState() => _CompleteWidgetState();
}

class _CompleteWidgetState extends State<CompleteWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageComplete = 1;
  List listBillComplete = [];
  bool hasMoreComplete = true;
  bool isRefesh = false;
  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

  final scrollTabCompleteController = ScrollController();
  @override
  void initState() {
    loadMoreComplete(page: 1, filtersFlg: {"pay_flg": 1});

    scrollTabCompleteController.addListener(() {
      if (scrollTabCompleteController.position.maxScrollExtent ==
              scrollTabCompleteController.offset &&
          isRefesh == false) {
        loadMoreComplete(page: currentPageComplete, filtersFlg: {"pay_flg": 1});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollTabCompleteController.dispose();

    super.dispose();
  }

  void loadMoreComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);

                  listBillComplete.addAll(broughtReceiptPageRes.data.data);
                  currentPageComplete++;
                  isRefesh = false;
                  if (broughtReceiptPageRes.data.data.isEmpty ||
                      broughtReceiptPageRes.data.data.length <= 15) {
                    hasMoreComplete = false;
                  }
                })
              : null;
        } else {
          log("ERROR loadMoreComplete 1");
        }
      } catch (error) {
        log("ERROR loadMoreComplete 2 $error");
      }
    } catch (error) {
      log("ERROR loadMoreComplete 3 $error");
    }
  }

  void refeshListComplete(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  listBillComplete.addAll(broughtReceiptPageRes.data.data);
                  isRefesh = true;
                })
              : null;
        } else {
          log("ERROR refeshListComplete 1");
        }
      } catch (error) {
        log("ERROR refeshListComplete 2 $error");
      }
    } catch (error) {
      log("ERROR refeshListComplete 3 $error");
    }
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenStaff,
      client: 'staff',
      shopId: getStaffShopID,
      orderId: orderID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
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
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            listBillComplete[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillComplete[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
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
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                printBroughtReceipt(
                                                    orderID:
                                                        listBillComplete[index]
                                                            .orderId);

                                                return PrintBroughtReceiptDialog(
                                                  role: 'staff',
                                                  shopID: getStaffShopID,
                                                  orderID:
                                                      listBillComplete[index]
                                                          .orderId
                                                          .toString(),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 35.w,
                                                height: 35.w,
                                                child: SvgPicture.asset(
                                                  'assets/svg/receipt.svg',
                                                  fit: BoxFit.contain,
                                                )),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      const Divider(),
                                      SizedBox(height: 10.h),
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
                        statusText: "Hoàn thành"),
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
                      SizedBox(
                          width: 35.w,
                          height: 35.w,
                          child: SvgPicture.asset(
                            'assets/svg/receipt.svg',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 10.h),
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

  void getDetailsBroughtReceiptData({required int? orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            token: tokenStaff,
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
        token: tokenStaff,
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
        token: tokenStaff,
        client: 'staff',
        shopId: getStaffShopID,
        roomId: roomId ?? '',
        tableId: tableId,
        orderId: orderID));
  }

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenStaff,
      client: 'staff',
      shopId: getStaffShopID,
      orderId: orderID,
    ));
  }

  void loadMorePending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  listBillPending.addAll(broughtReceiptPageRes.data.data);
                  currentPagePending++;
                  isRefesh = false;

                  if (broughtReceiptPageRes.data.data.isEmpty ||
                      broughtReceiptPageRes.data.data.length <= 15) {
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

  void refeshPending(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  listBillPending.clear();
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  listBillPending.addAll(broughtReceiptPageRes.data.data);
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
        // Implement logic to refresh data for Tab 1
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
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            listBillPending[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillPending[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                        typePopMenu: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          // color: Colors.amber,
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
                                                    orderID:
                                                        listBillPending[index]
                                                            .orderId);
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ManageBroughtReceiptDialog(
                                                        token: tokenStaff,
                                                        role: 'staff',
                                                        orderID:
                                                            listBillPending[
                                                                    index]
                                                                .orderId,
                                                        shopID: getStaffShopID,
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 35.w,
                                                      height: 35.w,
                                                      child: SvgPicture.asset(
                                                        'assets/svg/receipt.svg',
                                                        fit: BoxFit.contain,
                                                      )),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  TextApp(
                                                    text: "Quản lý hoá đơn",
                                                    color: Colors.black,
                                                    fontsize: 18.sp,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            const Divider(),
                                            SizedBox(height: 10.h),
                                            InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                getPaymentData(
                                                  tableId: '',
                                                  orderID:
                                                      listBillPending[index]
                                                          .orderId
                                                          .toString(),
                                                );
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return PayBillDialog(
                                                        token: tokenStaff,
                                                        role: 'staff',
                                                        shopID: getStaffShopID,
                                                        orderID:
                                                            listBillPending[
                                                                    index]
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
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  TextApp(
                                                    text: "Thanh toán hoá đơn",
                                                    color: Colors.black,
                                                    fontsize: 18.sp,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            const Divider(),
                                            SizedBox(height: 10.h),
                                            InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                printBroughtReceipt(
                                                    orderID:
                                                        listBillPending[index]
                                                            .orderId);

                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return PrintBroughtReceiptDialog(
                                                        role: 'staff',
                                                        shopID: getStaffShopID,
                                                        orderID:
                                                            listBillPending[
                                                                    index]
                                                                .orderId
                                                                .toString(),
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 35.w,
                                                    height: 35.w,
                                                    child: SvgPicture.asset(
                                                      'assets/svg/printing_receipt.svg',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  TextApp(
                                                    text: "In hoá đơn",
                                                    color: Colors.black,
                                                    fontsize: 18.sp,
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            const Divider(),
                                            SizedBox(height: 10.h),
                                            InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CancleBillDialog(
                                                        token: tokenStaff,
                                                        eventSaveButton: () {
                                                          Navigator.of(context)
                                                              .pop();

                                                          getListBroughtReceiptData(
                                                              filtersFlg: {
                                                                "pay_flg": 0
                                                              });
                                                        },
                                                        role: 'staff',
                                                        shopID: getStaffShopID,
                                                        orderID:
                                                            listBillPending[
                                                                    index]
                                                                .orderId,
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 35.w,
                                                      height: 35.w,
                                                      child: SvgPicture.asset(
                                                        'assets/svg/cancle_icon.svg',
                                                        fit: BoxFit.contain,
                                                      )),
                                                  SizedBox(
                                                    width: 10.w,
                                                  ),
                                                  TextApp(
                                                    text: "Huỷ hoá đơn",
                                                    color: Colors.black,
                                                    fontsize: 18.sp,
                                                  )
                                                ],
                                              ),
                                            ),
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
                        statusText: "Đang chế biến"),
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
                      SizedBox(
                          width: 35.w,
                          height: 35.w,
                          child: SvgPicture.asset(
                            'assets/svg/receipt.svg',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 10.h),
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
  const CancleWidget({super.key});

  @override
  State<CancleWidget> createState() => _CancleWidgetState();
}

class _CancleWidgetState extends State<CancleWidget>
    with AutomaticKeepAliveClientMixin {
  int currentPageCancle = 1;
  List listBillCancle = [];
  bool hasMoreCanle = true;
  bool isRefesh = false;

  var tokenStaff = StorageUtils.instance.getString(key: 'token_staff') ?? '';

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
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  listBillCancle.addAll(broughtReceiptPageRes.data.data);
                  currentPageCancle++;
                  isRefesh = false;

                  if (broughtReceiptPageRes.data.data.isEmpty ||
                      broughtReceiptPageRes.data.data.length <= 15) {
                    hasMoreCanle = false;
                  }
                })
              : null;
          log("DATA BACK $data");
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

  Future refeshCancle(
      {required int page, required Map<String, int?> filtersFlg}) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
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
          mounted
              ? setState(() {
                  var broughtReceiptPageRes =
                      ListBroughtReceiptModel.fromJson(data);
                  listBillCancle.addAll(broughtReceiptPageRes.data.data);
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

  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
      token: tokenStaff,
      client: 'staff',
      shopId: getStaffShopID,
      orderId: orderID,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
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
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: index == 0 ? 5.w : 0),
                    child: BroughtReceiptContainer(
                        dateTime: formatDateTime(
                            listBillCancle[index].createdAt.toString()),
                        price:
                            "${MoneyFormatter(amount: (listBillCancle[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
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
                                          printBroughtReceipt(
                                              orderID: listBillCancle[index]
                                                  .orderId);
                                          await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return PrintBroughtReceiptDialog(
                                                  role: 'staff',
                                                  shopID: getStaffShopID,
                                                  orderID: listBillCancle[index]
                                                      .orderId
                                                      .toString(),
                                                );
                                              });
                                        },
                                        child: Row(
                                          children: [
                                            SizedBox(
                                                width: 35.w,
                                                height: 35.w,
                                                child: SvgPicture.asset(
                                                  'assets/svg/receipt.svg',
                                                  fit: BoxFit.contain,
                                                )),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            TextApp(
                                              text: "In hoá đơn",
                                              color: Colors.black,
                                              fontsize: 18.sp,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10.h),
                                      const Divider(),
                                      SizedBox(height: 10.h),
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
                      SizedBox(
                          width: 35.w,
                          height: 35.w,
                          child: SvgPicture.asset(
                            'assets/svg/receipt.svg',
                            fit: BoxFit.contain,
                          )),
                      SizedBox(height: 10.h),
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

class RecipeForChef extends StatefulWidget {
  const RecipeForChef({super.key});

  @override
  State<RecipeForChef> createState() => _RecipeForChefState();
}

class _RecipeForChefState extends State<RecipeForChef> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Công thức món ăn"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              // color: Colors.amber,
              child: Lottie.asset('assets/lottie/no_mess.json'),
            ),
            SizedBox(height: 15.h),
            TextApp(
              text: "Tính năng đang phát triển",
              fontsize: 16.sp,
              fontWeight: FontWeight.bold,
              color: orangeColorApp,
            ),
            SizedBox(height: 15.h),
            TextApp(
              text: "Vui lòng quay lại sau",
              fontsize: 16.sp,
              fontWeight: FontWeight.bold,
              color: blueText,
            ),
          ],
        )),
      ),
    );
  }
}
