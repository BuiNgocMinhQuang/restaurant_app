import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/model/brought_receipt/list_brought_receipt_model.dart';
import 'package:app_restaurant/utils/share_getString.dart';
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

class StaffBroughtReceipt extends StatefulWidget {
  const StaffBroughtReceipt({super.key});

  @override
  State<StaffBroughtReceipt> createState() => _StaffBroughtReceiptState();
}

class _StaffBroughtReceiptState extends State<StaffBroughtReceipt>
    with TickerProviderStateMixin {
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;
  final scrollListFoodController = ScrollController();

  void getBroughtReceiptData() async {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        client: currentRole,
        shopId: currentShopId,
        limit: 15,
        page: 1,
        filters: const []));
  }

  void getDetailsBroughtReceiptData({required String orderID}) async {
    BlocProvider.of<ManageBroughtReceiptBloc>(context).add(
        GetDetailsBroughtReceipt(
            client: currentRole,
            shopId: currentShopId,
            limit: 15,
            page: 1,
            filters: [],
            orderId: orderID));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBroughtReceiptData();
    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        print("LOADD MORE FOOD");
        loadMoreFood();
      }
    });
  }

  bool hasMore = true;

  Future loadMoreFood() async {}

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
                                  controller: _tabController,
                                  children: [
                                    //Tab All
                                    RefreshIndicator(
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        // Implement logic to refresh data for Tab 1
                                      },
                                      child: ListView.builder(
                                          controller: scrollListFoodController,
                                          shrinkWrap: true,
                                          itemCount: statePage
                                                  .listBroughtReceiptModel
                                                  ?.data
                                                  .data
                                                  .length ??
                                              0 + 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var dataLength = statePage
                                                    .listBroughtReceiptModel
                                                    ?.data
                                                    .data
                                                    .length ??
                                                0;
                                            var statusTextBill = statePage
                                                .listBroughtReceiptModel
                                                ?.data
                                                .data[index]
                                                .payFlg
                                                .toString();

                                            switch (statusTextBill) {
                                              case "0":
                                                statusTextBill =
                                                    "Đang chế biến";
                                                break;

                                              case "1":
                                                statusTextBill = "Hoàn thành";
                                                break;

                                              case "2":
                                                statusTextBill = "Đã huỷ";
                                                break;
                                            }
                                            if (index < dataLength) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.w, right: 5.w),
                                                child: BroughtReceiptContainer(
                                                    dateTime: formatDateTime(
                                                        statePage
                                                                .listBroughtReceiptModel
                                                                ?.data
                                                                .data[index]
                                                                .createdAt
                                                                .toString() ??
                                                            ''),
                                                    price:
                                                        "${MoneyFormatter(amount: (statePage.listBroughtReceiptModel?.data.data[index].orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                    typePopMenu:
                                                        PopUpMenuBroughtReceipt(
                                                      eventButton1: () {
                                                        getDetailsBroughtReceiptData(
                                                            orderID: statePage
                                                                    .listBroughtReceiptModel
                                                                    ?.data
                                                                    .data[index]
                                                                    .orderId
                                                                    .toString() ??
                                                                '');
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return ManageBroughtReceiptDialog(
                                                                role:
                                                                    currentRole,
                                                                orderID: statePage
                                                                        .listBroughtReceiptModel
                                                                        ?.data
                                                                        .data[
                                                                            index]
                                                                        .orderId
                                                                        .toString() ??
                                                                    '',
                                                                shopID:
                                                                    currentShopId,
                                                              );
                                                            });
                                                      },
                                                      eventButton2: () {
                                                        showConfirmDialog(
                                                            context, () {});
                                                      },
                                                      eventButton3: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const PrintBillDialog();
                                                            });
                                                      },
                                                      eventButton4: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return const CancleBillDialog();
                                                            });
                                                      },
                                                    ),
                                                    statusText:
                                                        statusTextBill ?? ''),
                                              );
                                            } else {
                                              return Center(
                                                child: hasMore
                                                    ? CircularProgressIndicator()
                                                    : Text("HET R"),
                                              );
                                            }
                                          }),
                                    ),
                                    //Tab Paid
                                    RefreshIndicator(
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        // Implement logic to refresh data for Tab 1
                                      },
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: statePage
                                              .listBroughtReceiptModel
                                              ?.data
                                              .data
                                              .where((element) =>
                                                  element.payFlg == 1)
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List<Datum> listReceipt = [];
                                            listReceipt.addAll(statePage
                                                    .listBroughtReceiptModel
                                                    ?.data
                                                    .data
                                                    .where((element) =>
                                                        element.payFlg == 1)
                                                    .toList() ??
                                                []);

                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, right: 5.w),
                                              child: BroughtReceiptContainer(
                                                dateTime: formatDateTime(
                                                    listReceipt[index]
                                                        .createdAt
                                                        .toString()),
                                                price:
                                                    "${MoneyFormatter(amount: (listReceipt[index].orderTotal).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                typePopMenu: PopUpMenuPrintBill(
                                                  eventButton1: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const PrintBillDialog();
                                                        });
                                                  },
                                                ),

                                                //     PopUpMenuBroughtReceipt(
                                                //   eventButton1: () {
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext
                                                //             context) {
                                                //           return ManageBroughtReceiptDialog(
                                                //             role: currentRole,
                                                //             orderID: statePage
                                                //                     .listBroughtReceiptModel
                                                //                     ?.data
                                                //                     .data[index]
                                                //                     .orderId
                                                //                     .toString() ??
                                                //                 '',
                                                //             shopID:
                                                //                 currentShopId,
                                                //           );
                                                //         });
                                                //   },
                                                //   eventButton2: () {
                                                //     showConfirmDialog(
                                                //         context, () {});
                                                //   },
                                                //   eventButton3: () {
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext
                                                //             context) {
                                                //           return const PrintBillDialog();
                                                //         });
                                                //   },
                                                //   eventButton4: () {
                                                //     showDialog(
                                                //         context: context,
                                                //         builder: (BuildContext
                                                //             context) {
                                                //           return const CancleBillDialog();
                                                //         });
                                                //   },
                                                // ),
                                                statusText: "Hoàn thành",
                                              ),
                                            );
                                          }),
                                    ),

                                    //Tab Unpaid
                                    RefreshIndicator(
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        // Implement logic to refresh data for Tab 1
                                      },
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: statePage
                                              .listBroughtReceiptModel
                                              ?.data
                                              .data
                                              .where((element) =>
                                                  element.payFlg == 0)
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List<Datum> listReceipt = [];
                                            listReceipt.addAll(statePage
                                                    .listBroughtReceiptModel
                                                    ?.data
                                                    .data
                                                    .where((element) =>
                                                        element.payFlg == 0)
                                                    .toList() ??
                                                []);
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, right: 5.w),
                                              child: BroughtReceiptContainer(
                                                dateTime: formatDateTime(
                                                    listReceipt[index]
                                                        .createdAt
                                                        .toString()),
                                                price:
                                                    "${MoneyFormatter(amount: (listReceipt[index].orderTotal).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                typePopMenu:
                                                    PopUpMenuBroughtReceipt(
                                                  eventButton1: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return ManageBroughtReceiptDialog(
                                                            role: currentRole,
                                                            orderID: statePage
                                                                    .listBroughtReceiptModel
                                                                    ?.data
                                                                    .data[index]
                                                                    .orderId
                                                                    .toString() ??
                                                                '',
                                                            shopID:
                                                                currentShopId,
                                                          );
                                                        });
                                                  },
                                                  eventButton2: () {
                                                    showConfirmDialog(
                                                        context, () {});
                                                  },
                                                  eventButton3: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const PrintBillDialog();
                                                        });
                                                  },
                                                  eventButton4: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const CancleBillDialog();
                                                        });
                                                  },
                                                ),
                                                statusText: "Đang chế biến",
                                              ),
                                            );
                                          }),
                                    ),
                                    //Tab cancle
                                    RefreshIndicator(
                                      color: Colors.blue,
                                      onRefresh: () async {
                                        // Implement logic to refresh data for Tab 1
                                      },
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: statePage
                                              .listBroughtReceiptModel
                                              ?.data
                                              .data
                                              .where((element) =>
                                                  element.payFlg == 2)
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            List<Datum> listReceipt = [];

                                            listReceipt.addAll(statePage
                                                    .listBroughtReceiptModel
                                                    ?.data
                                                    .data
                                                    .where((element) =>
                                                        element.payFlg == 2)
                                                    .toList() ??
                                                []);
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, right: 5.w),
                                              child: BroughtReceiptContainer(
                                                  dateTime: formatDateTime(
                                                      listReceipt[index]
                                                          .createdAt
                                                          .toString()),
                                                  price:
                                                      "${MoneyFormatter(amount: (listReceipt[index].orderTotal).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                  typePopMenu:
                                                      PopUpMenuPrintBill(
                                                    eventButton1: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return const PrintBillDialog();
                                                          });
                                                    },
                                                  ),

                                                  //     PopUpMenuBroughtReceipt(
                                                  //   eventButton1: () {
                                                  //     showDialog(
                                                  //         context: context,
                                                  //         builder: (BuildContext
                                                  //             context) {
                                                  //           return ManageBroughtReceiptDialog(
                                                  //             role: currentRole,
                                                  //             orderID: statePage
                                                  //                     .listBroughtReceiptModel
                                                  //                     ?.data
                                                  //                     .data[
                                                  //                         index]
                                                  //                     .orderId
                                                  //                     .toString() ??
                                                  //                 '',
                                                  //             shopID:
                                                  //                 currentShopId,
                                                  //           );
                                                  //         });
                                                  //   },
                                                  //   eventButton2: () {
                                                  //     showConfirmDialog(
                                                  //         context, () {});
                                                  //   },
                                                  //   eventButton3: () {
                                                  //     showDialog(
                                                  //         context: context,
                                                  //         builder: (BuildContext
                                                  //             context) {
                                                  //           return const PrintBillDialog();
                                                  //         });
                                                  //   },
                                                  //   eventButton4: () {
                                                  //     showDialog(
                                                  //         context: context,
                                                  //         builder: (BuildContext
                                                  //             context) {
                                                  //           return const CancleBillDialog();
                                                  //         });
                                                  //   },
                                                  // ),
                                                  statusText: "Đã huỷ"),
                                            );
                                          }),
                                    ),
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
                                builder: (BuildContext context) {
                                  return const ManageBroughtReceiptDialog(
                                    role: '',
                                    orderID: '',
                                    shopID: '',
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
                        ))
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
