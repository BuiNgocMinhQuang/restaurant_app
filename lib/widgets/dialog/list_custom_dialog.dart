import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_restaurant/bloc/bill_table/bill_table_bloc.dart';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/manager/room/list_room_bloc.dart';
import 'package:app_restaurant/bloc/manager/stores/list_stores_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/bill_infor_model.dart';
import 'package:app_restaurant/model/brought_receipt/manage_brought_receipt_model.dart';
import 'package:app_restaurant/model/food_table_data_model.dart';
import 'package:app_restaurant/model/list_room_model.dart';
import 'package:app_restaurant/model/manager/store/edit_details_store_model.dart';
import 'package:app_restaurant/model/manager/store/rooms/data_room_details_model.dart';
import 'package:app_restaurant/model/manager/store/rooms/table/table_data_details_model.dart';
import 'package:app_restaurant/routers/app_router_config.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/tabs&drawer/item_drawer_and_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';

///Modal quản lí bàn
class BookingTableDialog extends StatefulWidget {
  final int? idRoom;
  final List<Tables>? listTableOfRoom;
  final Tables? currentTable;
  final Function eventSaveButton;
  final String role;
  final String shopID;
  final String token;
  final String? orderID;
  const BookingTableDialog(
      {Key? key,
      this.idRoom,
      this.listTableOfRoom,
      this.currentTable,
      required this.role,
      required this.shopID,
      required this.token,
      required this.orderID,
      required this.eventSaveButton})
      : super(key: key);

  @override
  State<BookingTableDialog> createState() => _BookingTableDialogState();
}

class _BookingTableDialogState extends State<BookingTableDialog>
    with TickerProviderStateMixin {
  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);

  dynamic listBanDaGhep = [];

  Future<DateTime?> pickDate() => showDatePicker(
      helpText: "Chọn ngày",
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

  Future<TimeOfDay?> pickTime() => showTimePicker(
      helpText: "Chọn thời gian",
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
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

  Future pickDateAndTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;
    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final newDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      dateTime = newDateTime;
      _dateStartController.text = formatDateTime(newDateTime.toString());
    });
  }

  final searchController = TextEditingController();

  List<String> selectedCategories = [];
  List<String> listAllCategoriesFood = [];
  List<int> selectedCategoriesIndex = [];

  final List<TextEditingController> _foodQuantityController = [];
  bool hasMore = true;

  int currentPage = 1;
  int? currentCart;
  List listFoodTableCurrent = [];
  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
    listFoodTableCurrent.clear();
    getListFoodTable(
      tokenReq: widget.token,
      page: currentPage,
      keywords: query,
      foodKinds:
          selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
    );
  }

  TabController? _tabController;
  final _popupCustomValidationKey = GlobalKey<DropdownSearchState<int>>();
  final _dateStartController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerPhoneController = TextEditingController();
  final noteController = TextEditingController();
  final cancleTableReasonController = TextEditingController();
  final _formCancleTable = GlobalKey<FormState>();
  final scrollListFoodController = ScrollController();

  @override
  void dispose() {
    scrollListFoodController.dispose();
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    //
    getListFoodTable(page: 1, tokenReq: widget.token);

    scrollListFoodController.addListener(() {
      log("ENDDDDDD");

      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        currentPage = 2; ////check this
        getListFoodTable(
          tokenReq: widget.token,
          page: currentPage,
          keywords: query,
          foodKinds:
              selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
        );
      }
    });
    setState(() {
      listBanDaGhep = widget.listTableOfRoom
              ?.where((table) =>
                  table.orderId == widget.currentTable?.orderId &&
                  table.roomTableId != widget.currentTable?.roomTableId &&
                  table.orderId != null)
              .toList() ??
          [];
    });
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {});
    }
  }

  void getListFoodTable({
    required int page,
    required String tokenReq,
    String? keywords,
    List<int>? foodKinds,
    int? payFlg,
  }) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$foodsTableApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.idRoom.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": payFlg
          },
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          if (mounted) {
            setState(() {
              var foodTableDataRes = FoodTableDataModel.fromJson(data);
              listFoodTableCurrent.addAll(foodTableDataRes.foods.data);
              currentPage++;
              if (foodTableDataRes.foods.data.isEmpty ||
                  foodTableDataRes.foods.data.length <= 15) {
                hasMore = false;
              }
            });
          }
        } else {
          print("ERROR DATA FOOD TABLE 1 ${data}");
        }
      } catch (error) {
        print("ERROR DATA FOOD TABLE 2 ${error}");
      }
    } catch (error) {
      print("ERROR DATA FOOD TABLE 3 $error");
    }
  }

  void getDetailFoodTable({required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$foodsTableApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.idRoom,
          'table_id': widget.currentTable?.roomTableId,
          'limit': 15,
          'page': 1,
          'order_id': widget.orderID,
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          var foodTableDataRes = FoodTableDataModel.fromJson(data);
          log(foodTableDataRes.countOrderFoods.toString());

          setState(() {
            listFoodTableCurrent.clear();
            currentCart = foodTableDataRes.countOrderFoods;

            listFoodTableCurrent.addAll(foodTableDataRes.foods.data);
          });
        } else {
          print("ERROR DATA FOOD TABLE 1 ${data}");
        }
      } catch (error) {
        print("ERROR DATA FOOD TABLE 2 ${error}");
      }
    } catch (error) {
      print("ERROR DATA FOOD TABLE 3 $error");
    }
  }

  void plusQuantytiFoodToTable(
      {required int foodID, required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.idRoom.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getDetailFoodTable(tokenReq: widget.token);
  }

  void minusQuantytiFoodToTable(
      {required int foodID, required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.idRoom.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getDetailFoodTable(tokenReq: widget.token);
  }

  void updateQuantytiFoodToTable(
      {required int foodID,
      required String quantityFood,
      required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$updateQuantityFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.idRoom.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID,
          'value': quantityFood
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getDetailFoodTable(tokenReq: widget.token);
  }

  void refeshHomePage() async {
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: widget.token,
          client: widget.role,
          shopId: widget.shopID,
          isApi: true,
          roomId: widget.idRoom.toString()),
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        if (state.tableStatus == TableStatus.succes) {
          List<String> foodKindOfShop =
              StorageUtils.instance.getStringList(key: 'food_kinds_list') ?? [];
          List filterProducts = listFoodTableCurrent.where((product) {
            final foodTitle = product.foodName?.toLowerCase() ?? '';
            final input = query.toLowerCase();

            return (selectedCategoriesIndex.isEmpty ||
                    selectedCategoriesIndex.contains(product.foodKind)) &&
                foodTitle.contains(input);
          }).toList();
          listAllCategoriesFood =
              foodKindOfShop; //add data category food vao mang nay de lay index category

          customerNameController.text =
              state.tableModel?.booking?.order?.clientName ??
                  customerNameController.text;
          customerPhoneController.text =
              state.tableModel?.booking?.order?.clientPhone ??
                  customerPhoneController.text;
          _dateStartController.text =
              state.tableModel?.booking?.order?.endBookedTableAt ??
                  _dateStartController.text;
          noteController.text =
              state.tableModel?.booking?.order?.note ?? noteController.text;
          var listTableHaveSameOrderID = widget.listTableOfRoom
              ?.where((table) =>
                  table.orderId == widget.currentTable?.orderId &&
                  table.roomTableId != widget.currentTable?.roomTableId &&
                  table.orderId != null)
              .toList();
          var listTableNoBooking = widget.listTableOfRoom
              ?.where(((table) =>
                  table.bookingStatus == true &&
                  table.roomTableId != widget.currentTable?.roomTableId))
              .toList();

          return AlertDialog(
              contentPadding: const EdgeInsets.all(0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextApp(
                          isOverFlow: false,
                          softWrap: true,
                          text:
                              "Quản lý bàn đặt: ${widget.currentTable?.tableName.toString() ?? ''}",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        space15H,
                        SizedBox(
                          height: 50,
                          child: TabBar(
                              onTap: (index) {
                                if (index == 0) {
                                  BlocProvider.of<TableBloc>(context).add(
                                      GetTableInfor(
                                          token: widget.token,
                                          client: widget.role,
                                          shopId: widget.shopID,
                                          roomId: widget.idRoom.toString(),
                                          tableId: widget
                                                  .currentTable?.roomTableId
                                                  .toString() ??
                                              '',
                                          orderID: widget.currentTable?.orderId
                                              .toString()));
                                } else if (index == 1) {
                                  getDetailFoodTable(tokenReq: widget.token);
                                }
                                // else if (index == 2) {
                                //   // getListFoodTable(page: 1);
                                //   BlocProvider.of<TableBloc>(context).add(
                                //       GetTableFoods(
                                //           client: widget.role,
                                //           shopId: widget.shopID,
                                //           roomId: widget.idRoom,
                                //           tableId:
                                //               widget.currentTable?.roomTableId,
                                //           limit: 15,
                                //           page: 1));
                                //   getDetailFoodTable();
                                // }
                              },
                              tabAlignment: TabAlignment.center,
                              labelPadding:
                                  EdgeInsets.only(left: 20.w, right: 20.w),
                              labelColor: Colors.black,
                              unselectedLabelColor:
                                  Colors.black.withOpacity(0.5),
                              labelStyle: const TextStyle(color: Colors.red),
                              controller: _tabController,
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  8.r,
                                ),
                                color: Colors.blue,
                                border: Border.all(color: Colors.blue),
                              ),
                              tabs: [
                                CustomTab(
                                    text: "Đặt bàn",
                                    icon: Icons.group_add_outlined),
                                Visibility(
                                  visible: state.tableModel?.booking != null,
                                  child: CustomTab(
                                      text: "Đặt món",
                                      icon: Icons.dinner_dining_outlined),
                                ),
                                Visibility(
                                  visible: state.tableModel?.booking != null,
                                  child: CustomTab(
                                      text: "Huỷ bàn",
                                      icon: Icons.group_add_outlined),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          height: 650.h,
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Visibility(
                                        visible:
                                            state.tableModel?.booking == null,
                                        child: TextApp(
                                          textAlign: TextAlign.center,
                                          text: "Bàn chưa có thông tin",
                                          fontsize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      space10H,
                                      Visibility(
                                        visible:
                                            state.tableModel?.booking == null,
                                        child: TextApp(
                                          textAlign: TextAlign.center,
                                          text: "Mở bàn để đặt món",
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: red,
                                        ),
                                      ),
                                      space10H,

                                      TextApp(
                                        text: " Thời gian kết thúc",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      space10H,
                                      TextField(
                                        onTapOutside: (event) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        readOnly: true,
                                        controller: _dateStartController,
                                        onTap: pickDateAndTime,
                                        cursorColor:
                                            const Color.fromRGBO(73, 80, 87, 1),
                                        decoration: InputDecoration(
                                            fillColor: const Color.fromARGB(
                                                255, 226, 104, 159),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      214, 51, 123, 0.6),
                                                  width: 2.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(
                                                1.sw > 600 ? 20.w : 15.w)),
                                      ),
                                      ////////
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      //////
                                      TextApp(
                                        text: 'Tên khách hàng',
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
                                        controller: customerNameController,
                                        cursorColor:
                                            const Color.fromRGBO(73, 80, 87, 1),
                                        decoration: InputDecoration(
                                            fillColor: const Color.fromARGB(
                                                255, 226, 104, 159),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      214, 51, 123, 0.6),
                                                  width: 2.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            hintText: 'Tên khách hàng',
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(
                                                1.sw > 600 ? 20.w : 15.w)),
                                      ),
                                      /////
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      ////
                                      TextApp(
                                        text: " Số điện thoại",
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
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")),
                                        ], // Only numbers can be entered,
                                        controller: customerPhoneController,
                                        cursorColor:
                                            const Color.fromRGBO(73, 80, 87, 1),
                                        decoration: InputDecoration(
                                            fillColor: const Color.fromARGB(
                                                255, 226, 104, 159),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      214, 51, 123, 0.6),
                                                  width: 2.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            hintText: 'Số điện thoại',
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(
                                                1.sw > 600 ? 20.w : 15.w)),
                                      ),
                                      /////
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      ////

                                      TextApp(
                                        text:
                                            "Các bàn đang còn trống của phòng",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.normal,
                                        color: blueText,
                                      ),

                                      ////
                                      TextApp(
                                        text: "Ghép bàn",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Wrap(
                                        children: [
                                          DropdownSearch.multiSelection(
                                            key: _popupCustomValidationKey,
                                            itemAsString: (item) =>
                                                item.tableName,
                                            items: (listTableNoBooking)
                                                as List<Tables>,
                                            selectedItems:
                                                listTableHaveSameOrderID ?? [],
                                            onChanged: (listSelectedTable) {
                                              setState(() {
                                                listBanDaGhep =
                                                    listSelectedTable;
                                              });
                                            },
                                            popupProps:
                                                PopupPropsMultiSelection.dialog(
                                              title: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.w, top: 10.h),
                                                child: TextApp(
                                                  text: "Chọn bàn để ghép",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: blueText,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      TextApp(
                                        text: "Ghi chú",
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
                                        controller: noteController,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 3,
                                        cursorColor:
                                            const Color.fromRGBO(73, 80, 87, 1),
                                        decoration: InputDecoration(
                                            fillColor: const Color.fromARGB(
                                                255, 226, 104, 159),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromRGBO(
                                                      214, 51, 123, 0.6),
                                                  width: 2.0),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            hintText: '',
                                            isDense: true,
                                            contentPadding: EdgeInsets.only(
                                                bottom:
                                                    1.sw > 600 ? 50.w : 40.w,
                                                top: 0,
                                                left: 1.sw > 600 ? 20.w : 15.w,
                                                right:
                                                    1.sw > 600 ? 20.w : 15.w)),
                                      ),
                                    ],
                                  )),
                                  Container(
                                    width: 1.sw,
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ButtonApp(
                                          event: () {
                                            Navigator.of(context).pop();
                                          },
                                          text: "Đóng",
                                          colorText: Colors.white,
                                          backgroundColor:
                                              Color.fromRGBO(131, 146, 171, 1),
                                          outlineColor:
                                              Color.fromRGBO(131, 146, 171, 1),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        ButtonApp(
                                          event: () {
                                            //Save infor table

                                            BlocProvider.of<TableSaveInforBloc>(
                                                    context)
                                                .add(SaveTableInfor(
                                              token: widget.token,
                                              client: widget.role,
                                              shopId: getStaffShopID,
                                              roomId: widget.idRoom.toString(),
                                              tableId: widget
                                                  .currentTable!.roomTableId
                                                  .toString(),
                                              clientName:
                                                  customerNameController.text,
                                              clientPhone:
                                                  customerPhoneController.text,
                                              note: noteController.text,
                                              endDate:
                                                  _dateStartController.text,
                                              tables: listBanDaGhep
                                                      .map((e) => e.roomTableId)
                                                      .toList() ??
                                                  [],
                                            ));

                                            ///check dieu kien succes cho nay
                                            Navigator.of(context).pop();
                                            showUpdateDataSuccesDialog();
                                            widget.eventSaveButton();
                                          },
                                          text: save,
                                          colorText: Colors.white,
                                          backgroundColor: const Color.fromRGBO(
                                              23, 193, 232, 1),
                                          outlineColor: const Color.fromRGBO(
                                              23, 193, 232, 1),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ////Tab2
                              Visibility(
                                visible: state.tableModel?.booking != null,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height: 50,
                                        // color: Colors.red,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: ListView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children: foodKindOfShop
                                                    .map((lableFood) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.w, left: 5.w),
                                                    child: FilterChip(
                                                      labelPadding:
                                                          EdgeInsets.only(
                                                              left: 15.w,
                                                              right: 15.w,
                                                              top: 8.w,
                                                              bottom: 8.w),
                                                      disabledColor:
                                                          Colors.blue,
                                                      selectedColor:
                                                          Colors.blue,
                                                      backgroundColor:
                                                          Colors.white,
                                                      shadowColor: Colors.black,
                                                      selectedShadowColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.w),
                                                        side: BorderSide(
                                                          color: selectedCategories
                                                                  .contains(
                                                                      lableFood)
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.blue,
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                          color: selectedCategories
                                                                  .contains(
                                                                      lableFood)
                                                              ? Colors.white
                                                              : Colors.blue),
                                                      showCheckmark: false,
                                                      label: Text(lableFood
                                                          .toUpperCase()),
                                                      selected:
                                                          selectedCategories
                                                              .contains(
                                                                  lableFood),
                                                      onSelected:
                                                          (bool selected) {
                                                        setState(() {
                                                          if (selected) {
                                                            selectedCategories.add(
                                                                lableFood); //thêm tên category vào mảng
                                                            int index =
                                                                listAllCategoriesFood
                                                                    .indexOf(
                                                                        lableFood);
                                                            selectedCategoriesIndex
                                                                .add(index);
                                                            //thêm index category vào mảng
                                                            listFoodTableCurrent
                                                                .clear();
                                                            currentPage = 1;
                                                            getListFoodTable(
                                                              tokenReq:
                                                                  widget.token,
                                                              page: currentPage,
                                                              keywords: query,
                                                              foodKinds:
                                                                  selectedCategoriesIndex
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedCategoriesIndex,
                                                            );
                                                          } else {
                                                            selectedCategories
                                                                .remove(
                                                                    lableFood); //xoá tên category vào mảng
                                                            int index =
                                                                listAllCategoriesFood
                                                                    .indexOf(
                                                                        lableFood);
                                                            selectedCategoriesIndex
                                                                .remove(
                                                                    index); //xoá index category vào mảng
                                                            listFoodTableCurrent
                                                                .clear();
                                                            currentPage = 1;

                                                            getListFoodTable(
                                                              tokenReq:
                                                                  widget.token,
                                                              page: currentPage,
                                                              keywords: query,
                                                              foodKinds:
                                                                  selectedCategoriesIndex
                                                                          .isEmpty
                                                                      ? null
                                                                      : selectedCategoriesIndex,
                                                            );
                                                          }
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        )),
                                    space30H,
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              onTapOutside: (event) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              onChanged: searchProduct,
                                              controller: searchController,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                              cursorColor: Colors.black,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromRGBO(
                                                                    214,
                                                                    51,
                                                                    123,
                                                                    0.6),
                                                            width: 2.0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  isDense: true,
                                                  hintText:
                                                      "Nhập nội dung bạn muốn tìm kiếm",
                                                  contentPadding:
                                                      const EdgeInsets.all(15)),
                                            ),
                                          ),
                                          space20W,
                                          Container(
                                              width: 80.w,
                                              height: 45.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                border: Border.all(
                                                  color: Colors
                                                      .blue, //                   <--- border color
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextApp(
                                                    text:
                                                        currentCart.toString(),
                                                    color: Colors.blue,
                                                    fontsize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  space5W,
                                                  const Icon(
                                                    Icons
                                                        .shopping_basket_rounded,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                    space15H,
                                    Expanded(
                                        child: ListView.builder(
                                            controller:
                                                scrollListFoodController,
                                            itemCount:
                                                // itemNe.length + 1,
                                                filterProducts.length + 1,
                                            itemBuilder: (context, index) {
                                              if (index <
                                                  filterProducts.length) {
                                                _foodQuantityController.add(
                                                    TextEditingController());
                                                _foodQuantityController[index]
                                                        .text =
                                                    filterProducts[index]
                                                        .quantityFood
                                                        .toString();
                                                var imagePath1 =
                                                    filterProducts[index]
                                                        ?.foodImages;
                                                var listImagePath = jsonDecode(
                                                    imagePath1 ?? '[]');
                                                // var imagePath2 = imagePath1
                                                //     .replaceAll('"]', '');

                                                return Container(
                                                    width: 1.sw,
                                                    margin: EdgeInsets.only(
                                                        bottom: 15.h,
                                                        left: 5.w,
                                                        right: 5.w),
                                                    padding:
                                                        EdgeInsets.all(10.w),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 2,
                                                            blurRadius: 4,
                                                            offset: const Offset(
                                                                0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.r)),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                                width: 80.w,
                                                                height: 80.w,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              40.w),
                                                                  child: imagePath1 ==
                                                                          null
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/images/dish.png',
                                                                          fit: BoxFit
                                                                              .contain,
                                                                        )
                                                                      : CachedNetworkImage(
                                                                          fit: BoxFit
                                                                              .fill,
                                                                          imageUrl:
                                                                              httpImage + listImagePath[0],
                                                                          placeholder: (context, url) =>
                                                                              SizedBox(
                                                                            height:
                                                                                10.w,
                                                                            width:
                                                                                10.w,
                                                                            child:
                                                                                const Center(child: CircularProgressIndicator()),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(Icons.error),
                                                                        ),
                                                                )),
                                                            space15W,
                                                            Expanded(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            80.w,
                                                                        child:
                                                                            TextApp(
                                                                          softWrap:
                                                                              true,
                                                                          isOverFlow:
                                                                              false,
                                                                          text:
                                                                              filterProducts[index].foodName,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      space10H,
                                                                      SizedBox(
                                                                        width:
                                                                            80.w,
                                                                        child:
                                                                            TextApp(
                                                                          softWrap:
                                                                              true,
                                                                          isOverFlow:
                                                                              false,
                                                                          text:
                                                                              "${MoneyFormatter(amount: (filterProducts[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                          fontsize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              blueText2,
                                                                        ),
                                                                      ),
                                                                      space10H,
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              // color: Colors.green,
                                                              width: 80.w,
                                                              // height: 20.h,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      minusQuantytiFoodToTable(
                                                                          tokenReq: widget
                                                                              .token,
                                                                          foodID:
                                                                              filterProducts[index].foodId);
                                                                    },
                                                                    onDoubleTap:
                                                                        () {
                                                                      showCustomDialogModal(
                                                                        typeDialog:
                                                                            "error",
                                                                        context:
                                                                            navigatorKey.currentContext,
                                                                        textDesc:
                                                                            "Bạn thao tác quá nhanh",
                                                                        title:
                                                                            "Thành công",
                                                                        colorButton:
                                                                            Colors.red,
                                                                        btnText:
                                                                            "OK",
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          20.w,
                                                                      // height: 20.w,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                                                                          gradient: const LinearGradient(
                                                                            begin:
                                                                                Alignment.topRight,
                                                                            end:
                                                                                Alignment.bottomLeft,
                                                                            colors: [
                                                                              Color.fromRGBO(33, 82, 255, 1),
                                                                              Color.fromRGBO(33, 212, 253, 1)
                                                                            ],
                                                                          )),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            TextApp(
                                                                          text:
                                                                              "-",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          color:
                                                                              Colors.white,
                                                                          fontsize:
                                                                              18.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                      fit: FlexFit
                                                                          .tight,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border: Border.all(
                                                                              width: 0.4,
                                                                              color: Colors.grey),
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              TextField(
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            inputFormatters: <TextInputFormatter>[
                                                                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                                            ], // Only numbers can be entered,
                                                                            style:
                                                                                TextStyle(fontSize: 12.sp, color: grey),
                                                                            controller:
                                                                                _foodQuantityController[index],

                                                                            onTapOutside:
                                                                                (event) {
                                                                              FocusManager.instance.primaryFocus?.unfocus();

                                                                              updateQuantytiFoodToTable(tokenReq: widget.token, foodID: filterProducts[index].foodId, quantityFood: _foodQuantityController[index].text);
                                                                            },
                                                                            cursorColor:
                                                                                grey,
                                                                            decoration:
                                                                                const InputDecoration(
                                                                              fillColor: Color.fromARGB(255, 226, 104, 159),
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Color.fromRGBO(214, 51, 123, 0.6), width: 2.0),
                                                                              ),

                                                                              hintText: '',
                                                                              isDense: true, // Added this
                                                                              contentPadding: EdgeInsets.all(3), // Added this
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      plusQuantytiFoodToTable(
                                                                          tokenReq: widget
                                                                              .token,
                                                                          foodID:
                                                                              filterProducts[index].foodId);
                                                                    },
                                                                    onDoubleTap:
                                                                        () {
                                                                      showCustomDialogModal(
                                                                        typeDialog:
                                                                            "error",
                                                                        context:
                                                                            navigatorKey.currentContext,
                                                                        textDesc:
                                                                            "Bạn thao tác quá nhanh",
                                                                        title:
                                                                            "Thành công",
                                                                        colorButton:
                                                                            Colors.red,
                                                                        btnText:
                                                                            "OK",
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          20.w,
                                                                      // height: 20.w,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                                                                          gradient: const LinearGradient(
                                                                            begin:
                                                                                Alignment.topRight,
                                                                            end:
                                                                                Alignment.bottomLeft,
                                                                            colors: [
                                                                              Color.fromRGBO(33, 82, 255, 1),
                                                                              Color.fromRGBO(33, 212, 253, 1)
                                                                            ],
                                                                          )),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            TextApp(
                                                                          text:
                                                                              "+",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          color:
                                                                              Colors.white,
                                                                          fontsize:
                                                                              18.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        space15H,
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    TextApp(
                                                                        text:
                                                                            "Tổng số món: "),
                                                                    TextApp(
                                                                      text: filterProducts[index]
                                                                              ?.foodsTotal
                                                                              .toString() ??
                                                                          '0',
                                                                      fontsize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blueText2,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    TextApp(
                                                                        text:
                                                                            "Chờ xác nhận: "),
                                                                    TextApp(
                                                                      text: filterProducts[index]
                                                                              ?.foodsWaiting
                                                                              .toString() ??
                                                                          '0',
                                                                      fontsize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blueText2,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            space20W,
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    TextApp(
                                                                        text:
                                                                            "Đang chuẩn bị: "),
                                                                    TextApp(
                                                                      text: filterProducts[index]
                                                                              ?.foodsCooking
                                                                              .toString() ??
                                                                          '0',
                                                                      fontsize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blueText2,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    TextApp(
                                                                        text:
                                                                            "Đã xong: "),
                                                                    TextApp(
                                                                      text: filterProducts[index]
                                                                              ?.foodsCompleted
                                                                              .toString() ??
                                                                          '0',
                                                                      fontsize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          blueText2,
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ));
                                              } else {
                                                return Center(
                                                  child: hasMore
                                                      ? CircularProgressIndicator()
                                                      : Container(),
                                                );
                                              }
                                            })),
                                    Container(
                                      width: 1.sw,
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ButtonApp(
                                            event: () {
                                              Navigator.of(context).pop();
                                            },
                                            text: "Đóng",
                                            colorText: Colors.white,
                                            backgroundColor: Color.fromRGBO(
                                                131, 146, 171, 1),
                                            outlineColor: Color.fromRGBO(
                                                131, 146, 171, 1),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              ///Tab3
                              Visibility(
                                  visible: state.tableModel?.booking != null,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextApp(
                                            text: "Lý do hủy bàn",
                                            fontsize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                            color: blueText,
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Form(
                                            key: _formCancleTable,
                                            child: TextFormField(
                                              onTapOutside: (event) {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return canNotNull;
                                                } else {
                                                  return null;
                                                }
                                              },
                                              controller:
                                                  cancleTableReasonController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              minLines: 1,
                                              maxLines: 5,
                                              cursorColor: const Color.fromRGBO(
                                                  73, 80, 87, 1),
                                              decoration: InputDecoration(
                                                  fillColor: const Color
                                                      .fromARGB(
                                                      255, 226, 104, 159),
                                                  focusedBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            214, 51, 123, 0.6),
                                                        width: 2.0),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  hintText: '',
                                                  isDense: true,
                                                  contentPadding: EdgeInsets
                                                      .only(
                                                          bottom: 1.sw > 600
                                                              ? 50.w
                                                              : 40.w,
                                                          top: 0,
                                                          left: 1.sw >
                                                                  600
                                                              ? 20.w
                                                              : 15.w,
                                                          right: 1.sw > 600
                                                              ? 20.w
                                                              : 15.w)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 1.sw,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonApp(
                                              event: () {
                                                Navigator.of(context).pop();
                                              },
                                              text: "Đóng",
                                              colorText: Colors.white,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      131, 146, 171, 1),
                                              outlineColor: Color.fromRGBO(
                                                  131, 146, 171, 1),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            ButtonApp(
                                              event: () {
                                                if (_formCancleTable
                                                    .currentState!
                                                    .validate()) {
                                                  BlocProvider.of<TableCancleBloc>(context)
                                                      .add(CancleTable(
                                                          token: widget.token,
                                                          orderId: state
                                                                  .tableModel
                                                                  ?.booking
                                                                  ?.orderId
                                                                  .toString() ??
                                                              '',
                                                          client: widget.role,
                                                          shopId:
                                                              getStaffShopID,
                                                          roomId: state
                                                              .tableModel!
                                                              .booking!
                                                              .order!
                                                              .storeRoomId
                                                              .toString(),
                                                          tableId: state
                                                              .tableModel!
                                                              .booking!
                                                              .roomTableId
                                                              .toString(),
                                                          cancellationReason:
                                                              cancleTableReasonController
                                                                  .text));
                                                  cancleTableReasonController
                                                      .clear();
                                                  Navigator.of(context).pop();
                                                  showUpdateDataSuccesDialog();

                                                  widget.eventSaveButton();
                                                }
                                              },
                                              text: save,
                                              colorText: Colors.white,
                                              backgroundColor: Color.fromRGBO(
                                                  23, 193, 232, 1),
                                              outlineColor: Color.fromRGBO(
                                                  23, 193, 232, 1),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
                ],
              ));
        } else if (state.tableStatus == TableStatus.loading) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
              child: SizedBox(
                width: 1.sw,
                height: 200.w,
                child: Lottie.asset('assets/lottie/loading_7_color.json'),
              ),
            ),
          );
        } else {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              content: Center(
                  child: SizedBox(
                width: 1.sw,
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
                      text: state.errorText.toString(),
                      textAlign: TextAlign.center,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    space30H,
                    Container(
                      width: 200,
                      child: ButtonGradient(
                        color1: color1BlueButton,
                        color2: color2BlueButton,
                        event: () {
                          // getDataTabIndex("");
                          Navigator.pop(context);
                        },
                        text: 'Thử lại',
                        fontSize: 12.sp,
                        radius: 8.r,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )));
        }
      },
    );
  }
}

///Modal chuyển bàn
///
///

class MoveTableDialog extends StatefulWidget {
  final Function eventSaveButton;
  final Tables? currentTable;
  final String token;
  final String nameRoom;
  final String orderID;
  final String role;
  final String shopID;
  final String roomID;
  final List listIdRoom;
  const MoveTableDialog({
    Key? key,
    required this.eventSaveButton,
    required this.currentTable,
    required this.token,
    required this.nameRoom,
    required this.orderID,
    required this.listIdRoom,
    required this.role,
    required this.shopID,
    required this.roomID,
  }) : super(key: key);
  State<MoveTableDialog> createState() => _MoveTableDialogState();
}

class _MoveTableDialogState extends State<MoveTableDialog> {
  // int selectedTable = -1;
  final Set<int> selectedTable = {};
  final Set<int> selectedTableId = {};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      if (state.tableStatus == TableStatus.succes) {
        var listRoomInit =
            state.switchTableDataModel?.rooms?.map((data) => data);
        var listNameRoomFree = listRoomInit
            ?.map((data) => data.storeRoomName)
            .toList(); //list ten cua ban con trong

        var currentRoom = listRoomInit
            ?.where(
                (room) => room.storeRoomId?.toString() == state.currentRoomId)
            .firstOrNull;

        var currentRoomName = currentRoom?.storeRoomName;

        return BlocBuilder<SwitchTableBloc, SwitchTableState>(
          builder: (context, stateSwitchTable) {
            return AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Container(
                                  width: 1.sw,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.w),
                                        topRight: Radius.circular(15.w)),
                                    // color: Colors.amber,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: TextApp(
                                              text: widget
                                                      .currentTable?.tableName
                                                      .toString() ??
                                                  '',
                                              fontsize: 18.sp,
                                              color: blueText,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 20.w),
                                            child: TextApp(
                                              text: widget.nameRoom,
                                              fontsize: 14.sp,
                                              color: blueText,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ))),
                          const Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextApp(
                                    text: "Bàn hiện tại",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.switchTableDataModel
                                              ?.currentTables?.length ??
                                          0,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 65.h),
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (content, index) {
                                        return Padding(
                                          padding: EdgeInsets.all(10.w),
                                          child: ButtonApp(
                                            event: () {},
                                            text: state
                                                    .switchTableDataModel
                                                    ?.currentTables?[index]
                                                    .tableName ??
                                                '',
                                            colorText: Colors.blue,
                                            backgroundColor: Colors.white,
                                            outlineColor: Colors.blue,
                                            radius: 8.r,
                                          ),
                                        );
                                      }),
                                  space10H,
                                  TextApp(
                                    text:
                                        "Lưu ý: Bàn chỉ được ghép khi cùng phòng",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    color: grey,
                                  ),
                                  space10H,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextApp(
                                        text: "Bàn có thể đổi:",
                                        fontsize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: blueText,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: DropdownSearch(
                                          onChanged: (changeRoom) {
                                            BlocProvider.of<TableBloc>(context)
                                                .add(GetTableSwitchInfor(
                                                    token: widget.token,
                                                    client: widget.role,
                                                    shopId: widget.shopID,
                                                    roomId: listRoomInit!
                                                            .firstWhere((element) =>
                                                                element
                                                                    .storeRoomName ==
                                                                changeRoom)
                                                            ?.storeRoomId
                                                            ?.toString() ??
                                                        '',
                                                    tableId: widget.currentTable
                                                            ?.roomTableId
                                                            .toString() ??
                                                        '',
                                                    orderId: widget.orderID));
                                          },
                                          items: listNameRoomFree ?? [],
                                          dropdownButtonProps:
                                              const DropdownButtonProps(),
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
                                              contentPadding:
                                                  EdgeInsets.all(15.w),
                                            ),
                                          ),
                                          selectedItem: currentRoomName,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors
                                                      .blue, //                   <--- border color
                                                  width: 1.w,
                                                ),
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextApp(text: "Đang phục vụ")
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextApp(text: "Bàn trống")
                                        ],
                                      )
                                    ],
                                  ),
                                  space15H,
                                  GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          currentRoom?.tables?.length ?? 0,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisExtent: 65.h),
                                      itemBuilder: (context, index) {
                                        final isSelected =
                                            selectedTable.contains(index);
                                        return Padding(
                                          padding: EdgeInsets.all(10.w),
                                          child: ButtonApp(
                                            event: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedTable.remove(index);
                                                  selectedTableId.remove(
                                                    // listTableFreeOfCurrentRoom
                                                    //     ?.first?[index]
                                                    //     .roomTableId,
                                                    currentRoom?.tables?[index]
                                                        .roomTableId,
                                                  );
                                                } else {
                                                  selectedTable.add(index);
                                                  selectedTableId.add(
                                                      currentRoom
                                                              ?.tables?[index]
                                                              .roomTableId ??
                                                          0);
                                                }
                                              });
                                            },
                                            text: currentRoom?.tables?[index]
                                                    .tableName ??
                                                '',
                                            colorText: isSelected
                                                ? Colors.white
                                                : Colors.blue,
                                            backgroundColor: isSelected
                                                ? Colors.blue
                                                : Colors.white,
                                            outlineColor: Colors.blue,
                                            radius: 8.r,
                                          ),
                                        );
                                      })
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 1.sw,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.w),
                                  bottomRight: Radius.circular(15.w)),
                              // color: Colors.green,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ButtonApp(
                                  event: () {
                                    Navigator.of(context).pop();
                                  },
                                  text: "Đóng",
                                  colorText: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(131, 146, 171, 1),
                                  outlineColor:
                                      const Color.fromRGBO(131, 146, 171, 1),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                ButtonApp(
                                  event: () {
                                    BlocProvider.of<SwitchTableBloc>(context)
                                        .add(HandleSwitchTable(
                                            token: widget.token,
                                            client: widget.role,
                                            shopId: widget.shopID,
                                            roomId: widget.roomID,
                                            tableId: widget
                                                    .currentTable?.roomTableId
                                                    .toString() ??
                                                '',
                                            orderId: widget.orderID,
                                            selectedTableId:
                                                selectedTableId.toList()));
                                    if (stateSwitchTable.switchtableStatus ==
                                        SwitchTableStatus.succes) {
                                      Navigator.of(context).pop();
                                      showUpdateDataSuccesDialog();
                                      widget.eventSaveButton();
                                    } else if (stateSwitchTable
                                            .switchtableStatus ==
                                        SwitchTableStatus.failed) {
                                      Navigator.of(context).pop();
                                      showSomthingWrongDialog();
                                    }
                                  },
                                  text: save,
                                  colorText: Colors.white,
                                  backgroundColor:
                                      const Color.fromRGBO(23, 193, 232, 1),
                                  outlineColor:
                                      const Color.fromRGBO(23, 193, 232, 1),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ));
          },
        );
      } else if (state.tableStatus == TableStatus.loading) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Center(
            child: SizedBox(
              width: 1.sw,
              height: 200.w,
              child: Lottie.asset('assets/lottie/loading_7_color.json'),
            ),
          ),
        );
      } else {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Center(
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
                  text: state.errorText.toString(),
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
        );
      }
    });
  }
}

//Modal xem hoá đơn
class SeeBillDialog extends StatefulWidget {
  final Tables? currentTable;
  final String token;
  final String nameRoom;
  final String role;
  final String shopID;
  final int? orderID;
  final String roomID;
  SeeBillDialog({
    Key? key,
    required this.currentTable,
    required this.token,
    required this.nameRoom,
    required this.role,
    required this.shopID,
    required this.orderID,
    required this.roomID,
  }) : super(key: key);
  @override
  State<SeeBillDialog> createState() => _SeeBillDialogState();
}

class _SeeBillDialogState extends State<SeeBillDialog> {
  final List<TextEditingController> _foodQuantityController = [];
  BillInforModel? listFoodBillCurrent;
  void refeshHomePage() async {
    BlocProvider.of<ListRoomBloc>(context).add(
      GetListRoom(
          token: widget.token,
          client: widget.role,
          shopId: widget.shopID,
          isApi: true,
          roomId: widget.roomID.toString()),
    );
  }

  void getBillData() async {
    try {
      var token = widget.token;
      final respons = await http.post(
        Uri.parse('$baseUrl$showBillInfor'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.roomID,
          'table_id': widget.currentTable?.roomTableId,
          'order_id': widget.orderID
        }),
      );
      final data = jsonDecode(respons.body);
      // print("BILL INFOR $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          setState(() {
            var billTableDataRes = BillInforModel.fromJson(data);
            listFoodBillCurrent = billTableDataRes;
          });
        } else {
          print("ERROR BILL INFOR 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR BILL INFOR 2 $error");
      }
    } catch (error) {
      print("ERROR BILL INFOR 3 $error");
    }
  }

  void plusQuantytiFoodToSeeBillTable({required int foodID}) async {
    try {
      var token = widget.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.roomID.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print('BCBCBCBHCBCBC');
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getBillData();
  }

  void updateQuantytiFoodToSeeBillTable(
      {required int foodID, required String quantityFood}) async {
    try {
      var token = widget.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$updateQuantityFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.roomID.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID,
          'value': quantityFood,
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getBillData();
  }

  void minusQuantytiFoodToSeeBillTable({required int foodID}) async {
    try {
      var token = widget.token;

      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'room_id': widget.roomID.toString(),
          'table_id': widget.currentTable?.roomTableId.toString() ?? '',
          'order_id': widget.currentTable?.orderId,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      print(" DATA ADD FOOD TO TABLE $data");
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO TABLE 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO TABLE 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO TABLE 3 $error");
    }
    refeshHomePage();
    getBillData();
  }

  @override
  void initState() {
    super.initState();
    getBillData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BillInforBloc, BillInforState>(
      builder: (context, state) {
        if (state.billStatus == BillInforStateStatus.succes) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Container(
                width: 1.sw,
                // height: 1.sh,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Container(
                          width: 1.sw,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.w),
                                topRight: Radius.circular(15.w)),
                            // color: Colors.amber,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: TextApp(
                                      text:
                                          widget.currentTable?.tableName ?? '',
                                      fontsize: 18.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: TextApp(
                                      text: widget.nameRoom,
                                      fontsize: 14.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20.w),
                              child: Column(
                                children: [
                                  Container(
                                      width: 1.sw,
                                      // height: 100.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: const Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            // height: 30.h,
                                            decoration: BoxDecoration(
                                              gradient: const LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.bottomLeft,
                                                colors: [
                                                  Color.fromRGBO(
                                                      33, 82, 255, 1),
                                                  Color.fromRGBO(
                                                      33, 212, 253, 1),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.r),
                                                  topRight:
                                                      Radius.circular(10.r)),
                                              color: Colors.blue,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.h,
                                                  left: 10.w,
                                                  bottom: 10.h),
                                              child: TextApp(
                                                text: "Tổng quan",
                                                fontsize: 18.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 1.sw,
                                            // height: 30.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(20.w),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextApp(
                                                          text: formatDateTime(
                                                              listFoodBillCurrent
                                                                      ?.order
                                                                      ?.createdAt
                                                                      .toString() ??
                                                                  ''),
                                                          fontsize: 14.sp),
                                                      SizedBox(
                                                        width: 5.w,
                                                      ),
                                                      Icon(
                                                        Icons
                                                            .access_time_filled,
                                                        size: 14.sp,
                                                        color: Colors.grey,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TextApp(
                                                        text: "Tổng tiền",
                                                        fontsize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      TextApp(
                                                          text:
                                                              "${MoneyFormatter(amount: (listFoodBillCurrent?.order?.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                          fontsize: 14.sp),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 1.sw,
                                          // height: 30.h,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color.fromRGBO(33, 82, 255, 1),
                                                Color.fromRGBO(33, 212, 253, 1),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.r),
                                                topRight:
                                                    Radius.circular(10.r)),
                                            color: Colors.blue,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.h,
                                                left: 10.w,
                                                right: 10.w,
                                                bottom: 10.h),
                                            child: TextApp(
                                              text: "Danh sách món ăn",
                                              fontsize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        //Fix cho nay, height layout

                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: 20.w, right: 20.w),
                                          child: (listFoodBillCurrent?.data ==
                                                      null ||
                                                  listFoodBillCurrent!
                                                      .data!.isEmpty)
                                              ? ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: 1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30.h,
                                                          left: 20.w,
                                                          right: 20.w),
                                                      child: Container(
                                                        width: 1.sw,
                                                        height: 50,
                                                        color: Colors.blue,
                                                        child: Center(
                                                          child: TextApp(
                                                            text:
                                                                "Chưa có món được chọn",
                                                            color: Colors.white,
                                                            fontsize: 14.sp,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                              : ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: listFoodBillCurrent
                                                          ?.data?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    _foodQuantityController.add(
                                                        TextEditingController());
                                                    _foodQuantityController[
                                                                index]
                                                            .text =
                                                        listFoodBillCurrent
                                                                ?.data?[index]
                                                                .quantityFood
                                                                .toString() ??
                                                            '0';

                                                    var imagePath =
                                                        listFoodBillCurrent
                                                                ?.data?[index]
                                                                .foodImages ??
                                                            '';
                                                    log(imagePath);
                                                    var listImagePath =
                                                        jsonDecode(imagePath);
                                                    // var imagePath1 = imagePath
                                                    //     .replaceAll('["', '');
                                                    // var imagePath2 = imagePath1
                                                    //     .replaceAll('"]', '');

                                                    return Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom: 10.h),
                                                          child: SizedBox(
                                                              width: 1.sw,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(10
                                                                            .w),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        SizedBox(
                                                                            width:
                                                                                80.w,
                                                                            height: 80.w,
                                                                            child: ClipRRect(
                                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
                                                                              child: CachedNetworkImage(
                                                                                fit: BoxFit.cover,
                                                                                imageUrl: httpImage + listImagePath[0],
                                                                                placeholder: (context, url) => SizedBox(
                                                                                  height: 10.w,
                                                                                  width: 10.w,
                                                                                  child: const Center(child: CircularProgressIndicator()),
                                                                                ),
                                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                              ),
                                                                              //  Image.network(
                                                                              //   httpImage + imagePath2,
                                                                              //   fit: BoxFit.cover,
                                                                              // ),
                                                                            )),
                                                                        space50W,
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 100.w,
                                                                                child: Center(
                                                                                  child: TextApp(
                                                                                    isOverFlow: false,
                                                                                    softWrap: true,
                                                                                    textAlign: TextAlign.center,
                                                                                    text: listFoodBillCurrent?.data?[index].foodName ?? '',
                                                                                    fontsize: 14.sp,
                                                                                  ),
                                                                                )),
                                                                            TextApp(
                                                                                text: "${MoneyFormatter(amount: (listFoodBillCurrent?.data?[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                                fontsize: 14.sp)
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15.h,
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          1.sw,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(8.r)),

                                                                        // color:
                                                                        //     Colors.pink,
                                                                      ),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            250.w,
                                                                        height:
                                                                            30.h,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.stretch,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                minusQuantytiFoodToSeeBillTable(foodID: listFoodBillCurrent?.data?[index].foodId ?? 0);
                                                                              },
                                                                              onDoubleTap: () {
                                                                                showCustomDialogModal(
                                                                                  typeDialog: "error",
                                                                                  context: navigatorKey.currentContext,
                                                                                  textDesc: "Bạn thao tác quá nhanh",
                                                                                  title: "Thành công",
                                                                                  colorButton: Colors.red,
                                                                                  btnText: "OK",
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                width: 50.w,
                                                                                height: 25.w,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8.r), bottomLeft: Radius.circular(8.r)),
                                                                                    gradient: const LinearGradient(
                                                                                      begin: Alignment.topRight,
                                                                                      end: Alignment.bottomLeft,
                                                                                      colors: [
                                                                                        Color.fromRGBO(33, 82, 255, 1),
                                                                                        Color.fromRGBO(33, 212, 253, 1)
                                                                                      ],
                                                                                    )),
                                                                                child: Center(
                                                                                  child: TextApp(text: "-", textAlign: TextAlign.center, color: Colors.white, fontsize: 14.sp),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                                fit: FlexFit.tight,
                                                                                //check thang nay co the co loi layout
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(width: 0.4, color: Colors.grey),
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: TextField(
                                                                                      textAlign: TextAlign.center,
                                                                                      keyboardType: TextInputType.number,
                                                                                      inputFormatters: <TextInputFormatter>[
                                                                                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                                                                      ], // Only numbers can be entered,
                                                                                      style: TextStyle(fontSize: 12.sp, color: grey),
                                                                                      controller: _foodQuantityController[index],

                                                                                      onTapOutside: (event) {
                                                                                        print('onTapOutside');
                                                                                        FocusManager.instance.primaryFocus?.unfocus();
                                                                                        // updateQuantytiFood();
                                                                                        updateQuantytiFoodToSeeBillTable(
                                                                                          foodID: listFoodBillCurrent?.data?[index].foodId ?? 0,
                                                                                          quantityFood: _foodQuantityController[index].text,
                                                                                        );
                                                                                      },
                                                                                      cursorColor: grey,
                                                                                      decoration: const InputDecoration(
                                                                                        fillColor: Color.fromARGB(255, 226, 104, 159),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                          borderSide: BorderSide(color: Color.fromRGBO(214, 51, 123, 0.6), width: 2.0),
                                                                                        ),

                                                                                        hintText: '',
                                                                                        isDense: true, // Added this
                                                                                        contentPadding: EdgeInsets.all(8), // Added this
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                plusQuantytiFoodToSeeBillTable(foodID: listFoodBillCurrent?.data?[index].foodId ?? 0);
                                                                              },
                                                                              onDoubleTap: () {
                                                                                showCustomDialogModal(
                                                                                  typeDialog: "error",
                                                                                  context: navigatorKey.currentContext,
                                                                                  textDesc: "Bạn thao tác quá nhanh",
                                                                                  title: "Thành công",
                                                                                  colorButton: Colors.red,
                                                                                  btnText: "OK",
                                                                                );
                                                                              },
                                                                              child: Container(
                                                                                width: 50.w,
                                                                                height: 25.w,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.only(topRight: Radius.circular(8.r), bottomRight: Radius.circular(8.r)),
                                                                                    gradient: const LinearGradient(
                                                                                      begin: Alignment.topRight,
                                                                                      end: Alignment.bottomLeft,
                                                                                      colors: [
                                                                                        Color.fromRGBO(33, 82, 255, 1),
                                                                                        Color.fromRGBO(33, 212, 253, 1)
                                                                                      ],
                                                                                    )),
                                                                                child: Center(
                                                                                  child: TextApp(
                                                                                    text: "+",
                                                                                    textAlign: TextAlign.center,
                                                                                    color: Colors.white,
                                                                                    fontsize: 14.sp,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                        const Divider(
                                                          height: 1,
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    );
                                                  }),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 1.sw,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15.w),
                            bottomRight: Radius.circular(15.w)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonApp(
                            event: () {
                              Navigator.of(context).pop();
                            },
                            text: "Đóng",
                            colorText: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                            outlineColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        } else if (state.billStatus == BillInforStateStatus.loading) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
              child: SizedBox(
                width: 1.sw,
                height: 200.w,
                child: Lottie.asset('assets/lottie/loading_7_color.json'),
              ),
            ),
          );
        } else {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              content: Center(
                  child: SizedBox(
                width: 1.sw,
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
                      text: state.errorText.toString(),
                      textAlign: TextAlign.center,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    space30H,
                    Container(
                      width: 200,
                      child: ButtonGradient(
                        color1: color1BlueButton,
                        color2: color2BlueButton,
                        event: () {
                          // getDataTabIndex("");
                          Navigator.pop(context);
                        },
                        text: 'Thử lại',
                        fontSize: 12.sp,
                        radius: 8.r,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )));
        }
      },
    );
  }
}

//Modal thanh toán hoá đơn
class PayBillDialog extends StatefulWidget {
  final String token;
  final Tables? currentTable;
  final String nameRoom;
  final String role;
  final String shopID;
  final String? orderID;
  final String roomID;
  final Function eventSaveButton;
  const PayBillDialog({
    Key? key,
    required this.token,
    required this.eventSaveButton,
    this.currentTable,
    required this.nameRoom,
    required this.role,
    required this.shopID,
    required this.orderID,
    required this.roomID,
  }) : super(key: key);

  @override
  State<PayBillDialog> createState() => _PayBillDialogState();
}

class _PayBillDialogState extends State<PayBillDialog> {
  String currentOptions = optionsPayment[0];
  int paymentMethod = 0;
  final discountController = TextEditingController();
  final clientPayController = TextEditingController();
  String discountMoney = '';
  String payMoney = '';
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentInforBloc, PaymentInforState>(
      builder: (context, state) {
        if (state.paymentStatus == PaymentInforStateStatus.succes) {
          discountController.text = _formatNumber(
              (state.paymentInforModel?.order?.discount.toString() ?? '')
                  .replaceAll(',', ''));
          clientPayController.text = _formatNumber(
              (state.paymentInforModel?.order?.guestPay.toString() ?? '')
                  .replaceAll(',', ''));

          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: InkWell(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<PaymentInforBloc>(context).add(
                    UpdatePaymentInfor(
                        token: widget.token,
                        client: widget.role,
                        shopId: widget.shopID,
                        orderId: widget.orderID ?? '',
                        orderTotal: state.paymentInforModel?.order?.orderTotal
                                .toString() ??
                            '',
                        discount: discountMoney,
                        guestPay: payMoney,
                        payKind: paymentMethod));
                BlocProvider.of<PaymentInforBloc>(context).add(GetPaymentInfor(
                    token: widget.token,
                    client: widget.role,
                    shopId: widget.shopID,
                    orderId: widget.orderID ?? '',
                    roomId: widget.roomID,
                    tableId:
                        widget.currentTable?.roomTableId.toString() ?? ''));
              },
              child: Container(
                  width: 1.sw,
                  // height: 1.sh,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Container(
                            width: 1.sw,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.w),
                                  topRight: Radius.circular(15.w)),
                              // color: Colors.amber,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: TextApp(
                                        text: widget.currentTable?.tableName ??
                                            'Thanh toán hoá đơn',
                                        fontsize: 18.sp,
                                        color: orangeColorApp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: TextApp(
                                        text: widget.nameRoom,
                                        fontsize: 14.sp,
                                        color: greyText,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )),
                      ),
                      Divider(height: 1, color: Colors.black),
                      Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            // color: Colors.green,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Container(
                                      width: 1.sw,
                                      // height: 100.h,
                                      // color: Colors.green,
                                      child: Column(
                                        children: [
                                          space15H,
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: state.paymentInforModel
                                                      ?.data?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                var priceOfFood = state
                                                        .paymentInforModel
                                                        ?.data?[index]
                                                        .foodPrice ??
                                                    0;
                                                var totalMoneyFood = (state
                                                            .paymentInforModel
                                                            ?.data?[index]
                                                            .foodPrice ??
                                                        1) *
                                                    (state
                                                            .paymentInforModel
                                                            ?.data?[index]
                                                            .quantityFood ??
                                                        1);

                                                var imagePath1 = state
                                                    .paymentInforModel
                                                    ?.data?[index]
                                                    .foodImages;
                                                var listImagePath = jsonDecode(
                                                    imagePath1 ?? '[]');

                                                return Container(
                                                  width: 1.sw,
                                                  padding: EdgeInsets.all(10.w),
                                                  margin: EdgeInsets.only(
                                                      bottom: 20.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 2,
                                                        blurRadius: 4,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: 80.w,
                                                          height: 80.w,
                                                          // color: Colors.amber,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40.w),
                                                            child: imagePath1 ==
                                                                    null
                                                                ? Image.asset(
                                                                    'assets/images/dish.png',
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  )
                                                                : CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    imageUrl: httpImage +
                                                                        listImagePath[
                                                                            0],
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            SizedBox(
                                                                      height:
                                                                          10.w,
                                                                      width:
                                                                          10.w,
                                                                      child: const Center(
                                                                          child:
                                                                              CircularProgressIndicator()),
                                                                    ),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        const Icon(
                                                                            Icons.error),
                                                                  ),
                                                          )),
                                                      space15W,
                                                      Expanded(
                                                          child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 100.w,
                                                                child: TextApp(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  softWrap:
                                                                      true,
                                                                  isOverFlow:
                                                                      false,
                                                                  text: state
                                                                          .paymentInforModel
                                                                          ?.data?[
                                                                              index]
                                                                          .foodName ??
                                                                      '',
                                                                  color:
                                                                      blueText,
                                                                  fontsize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              space10H,
                                                              SizedBox(
                                                                width: 100.w,
                                                                child: TextApp(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  softWrap:
                                                                      true,
                                                                  isOverFlow:
                                                                      false,
                                                                  text:
                                                                      "${MoneyFormatter(amount: priceOfFood.toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                  color:
                                                                      greyText,
                                                                  fontsize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              space10H,
                                                              Container(
                                                                  width: 35.w,
                                                                  height: 30.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    color:
                                                                        greyLight,
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        TextApp(
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      text:
                                                                          "x ${state.paymentInforModel?.data?[index].quantityFood.toString() ?? ''}",
                                                                      color:
                                                                          blueText,
                                                                      fontsize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              // MoneyFormatter(amount:

                                                              SizedBox(
                                                                // width: 80.w,
                                                                child: TextApp(
                                                                  softWrap:
                                                                      true,
                                                                  isOverFlow:
                                                                      false,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  text:
                                                                      "${MoneyFormatter(amount: totalMoneyFood.toDouble()).output.withoutFractionDigits.toString()} đ",
                                                                  color:
                                                                      blueText2,
                                                                  fontsize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ))
                                                    ],
                                                  ),
                                                );
                                              })
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: menuGrey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.post_add_rounded,
                                              size: 20.sp,
                                              color: Colors.grey,
                                            ),
                                            space5W,
                                            TextApp(
                                              text: "Giảm giá",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 120.w,
                                          child: TextField(
                                            onTapOutside: (event) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]")),
                                            ], // Only numbers can be entered,
                                            style: TextStyle(
                                                fontSize: 12.sp, color: grey),
                                            controller: discountController,
                                            onChanged: (string) {
                                              discountMoney = string;
                                              if (string.isNotEmpty) {
                                                string =
                                                    '${_formatNumber(string.replaceAll(',', ''))}';
                                                discountController.value =
                                                    TextEditingValue(
                                                  text: string,
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset:
                                                              string.length),
                                                );
                                              }
                                            },
                                            onEditingComplete: () {},
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                hintText: '',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(15.w)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: menuGrey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              size: 20.sp,
                                              color: Colors.grey,
                                            ),
                                            space5W,
                                            TextApp(
                                              text: "Khách thanh toán",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),
                                        // space15W,
                                        Container(
                                          width: 120.w,
                                          child: TextField(
                                            onTapOutside: (event) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[0-9]")),
                                            ], // Only numbers can be entered,
                                            controller: clientPayController,
                                            onChanged: (string) {
                                              if (string.isNotEmpty) {
                                                payMoney = string;

                                                string =
                                                    '${_formatNumber(string.replaceAll(',', ''))}';
                                                clientPayController.value =
                                                    TextEditingValue(
                                                  text: string,
                                                  selection:
                                                      TextSelection.collapsed(
                                                          offset:
                                                              string.length),
                                                );
                                              }
                                            },
                                            style: TextStyle(
                                                fontSize: 12.sp, color: grey),
                                            cursorColor: grey,
                                            decoration: InputDecoration(
                                                fillColor: const Color.fromARGB(
                                                    255, 226, 104, 159),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Color.fromRGBO(
                                                          214, 51, 123, 0.6),
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                hintText: '',
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(15.w)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  space20H,
                                  Wrap(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: Colors.black,
                                            value: optionsPayment[0],
                                            groupValue: currentOptions,
                                            onChanged: (value) {
                                              setState(() {
                                                currentOptions =
                                                    value.toString();
                                                paymentMethod = 0;
                                              });
                                            },
                                          ),
                                          TextApp(
                                            text: optionsPayment[0],
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: Colors.black,
                                            value: optionsPayment[1],
                                            groupValue: currentOptions,
                                            onChanged: (value) {
                                              setState(() {
                                                currentOptions =
                                                    value.toString();
                                                paymentMethod = 1;
                                              });
                                            },
                                          ),
                                          TextApp(
                                            text: optionsPayment[1],
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            activeColor: Colors.black,
                                            value: optionsPayment[2],
                                            groupValue: currentOptions,
                                            onChanged: (value) {
                                              setState(() {
                                                currentOptions =
                                                    value.toString();
                                                paymentMethod = 2;
                                              });
                                            },
                                          ),
                                          TextApp(
                                            text: optionsPayment[2],
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 1,
                                    color: menuGrey,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(10.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextApp(
                                              text: "Tạm tính",
                                              color: greyText,
                                              fontsize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            TextApp(
                                              text:
                                                  "${MoneyFormatter(amount: (state.paymentInforModel?.order?.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                        space20H,

                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextApp(
                                              text: "Tiền thừa trả khách",
                                              color: greyText,
                                              fontsize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            TextApp(
                                              text:
                                                  "${MoneyFormatter(amount: (state.paymentInforModel?.order?.guestPayClient ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                              color: Colors.black,
                                              fontsize: 14.sp,
                                            ),
                                          ],
                                        ),

                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.end,
                                        //   children: [
                                        //     TextApp(
                                        //         text: formatDateTime(state
                                        //                 .paymentInforModel
                                        //                 ?.order
                                        //                 ?.createdAt
                                        //                 .toString() ??
                                        //             ''),
                                        //         fontsize: 14.sp),
                                        //     space5W,
                                        //     Icon(
                                        //       Icons.access_time_filled,
                                        //       size: 14.sp,
                                        //       color: Colors.grey,
                                        //     )
                                        //   ],
                                        // ),
                                        space20H,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextApp(
                                              text: "Tổng cộng",
                                              color: blueText2,
                                              fontsize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            TextApp(
                                              text:
                                                  "${MoneyFormatter(amount: (state.paymentInforModel?.order?.clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                              color: blueText2,
                                              fontsize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                        space20H,
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                        width: 1.sw,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.w),
                              bottomRight: Radius.circular(15.w)),
                          // color: Colors.green,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonApp(
                              event: () {
                                Navigator.of(context).pop();
                              },
                              text: "Đóng",
                              colorText: Colors.blue,
                              backgroundColor: Colors.transparent,
                              outlineColor: Colors.blue,
                            ),
                            space15W,
                            ButtonApp(
                              event: () {
                                showConfirmDialog(context, () {
                                  BlocProvider.of<PaymentInforBloc>(context)
                                      .add(ConfirmPayment(
                                    token: widget.token,
                                    client: widget.role,
                                    shopId: widget.shopID,
                                    orderId: widget.orderID ?? '',
                                  ));
                                  if (state.paymentStatus ==
                                      PaymentInforStateStatus.succes) {
                                    Navigator.of(context).pop();
                                    widget.eventSaveButton();
                                    showDoYouWantPrintBillDialog(() {});
                                  }
                                });
                              },
                              text: "Thanh toán",
                              colorText: Colors.white,
                              backgroundColor: Colors.blue,
                              outlineColor: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
        } else if (state.paymentStatus == PaymentInforStateStatus.loading) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
              child: SizedBox(
                width: 1.sw,
                height: 200.w,
                child: Lottie.asset('assets/lottie/loading_7_color.json'),
              ),
            ),
          );
        } else {
          return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              content: Center(
                  child: SizedBox(
                width: 1.sw,
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
                      text: state.errorText.toString(),
                      textAlign: TextAlign.center,
                      fontsize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    space30H,
                    Container(
                      width: 200,
                      child: ButtonGradient(
                        color1: color1BlueButton,
                        color2: color2BlueButton,
                        event: () {
                          // getDataTabIndex("");
                          Navigator.pop(context);
                        },
                        text: 'Thử lại',
                        fontSize: 12.sp,
                        radius: 8.r,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              )));
        }
      },
    );
  }
}

//Modal quản lí hoá đơn mang về
class ManageBroughtReceiptDialog extends StatefulWidget {
  final int? orderID;
  final String role;
  final String shopID;
  final String token;
  const ManageBroughtReceiptDialog({
    Key? key,
    required this.orderID,
    required this.role,
    required this.shopID,
    required this.token,
  }) : super(key: key);

  @override
  State<ManageBroughtReceiptDialog> createState() =>
      _ManageBroughtReceiptDialogState();
}

class _ManageBroughtReceiptDialogState
    extends State<ManageBroughtReceiptDialog> {
  final searchController = TextEditingController();
  List<String> selectedCategories = [];

  List<String> listAllCategoriesFood = [];
  List<int> selectedCategoriesIndex = [];
  // List<int> selectedCategoriesIndex22 = [];
  final List<TextEditingController> _foodQuantityController = [];
  final scrollListFoodController = ScrollController();
  bool hasMore = true;

  int currentPage = 1;
  int? currentCartBroughtReceipt;
  String? currentOrderTotalBroughtReceipt;
  int? orderNewIDBroughtReceipt;
  List listFoodCurrent = [];

  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
    listFoodCurrent.clear();

    getDetailsBroughtReceiptData(
      page: currentPage,
      orderID: widget.orderID,
      tokenReq: widget.token,
      keywords: query,
      foodKinds:
          selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
    );
  }

  void getDetailsBroughtReceiptData({
    required int? orderID,
    required String tokenReq,
    required int page,
    String? keywords,
    List<int>? foodKinds,
    int? payFlg,
  }) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$getListFoodBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'limit': 15,
          'page': 1,
          'filters': null,
          'order_id': orderID
        }),
      );

      final data = jsonDecode(respons.body);
      print("DATAE !!! $data");
      var detailsBroughtReceiptRes = ManageBroughtReceiptModel.fromJson(data);
      try {
        if (data['status'] == 200) {
          setState(() {
            // listFoodCurrent.clear();
            currentOrderTotalBroughtReceipt =
                detailsBroughtReceiptRes.orderTotal;
            currentCartBroughtReceipt =
                detailsBroughtReceiptRes.countOrderFoods;
            listFoodCurrent.addAll(detailsBroughtReceiptRes.data.data);
            currentPage++;
            if (detailsBroughtReceiptRes.data.data.isEmpty ||
                detailsBroughtReceiptRes.data.data.length <= 15) {
              hasMore = false;
            }
          });
        } else {
          print("ERROR BROUGHT RECEIPT PAGE 1 CCCC");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
    }
  }

  void getListBroughtReceiptData({required Map<String, int?> filtersFlg}) {
    BlocProvider.of<BroughtReceiptBloc>(context).add(GetListBroughtReceipt(
        token: widget.token,
        client: widget.role,
        shopId: widget.shopID,
        limit: 15,
        page: currentPage,
        filters: filtersFlg));
  }

  void plusQuantityFoodToBroughtReceipt(
      {required int foodID, int? orderID, required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$addFoodToBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'order_id': orderNewIDBroughtReceipt ?? widget.orderID,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          var newOrderId = data['order_id'];
          setState(() {
            currentPage = 1;
            listFoodCurrent.clear();
            orderNewIDBroughtReceipt = newOrderId;
            getListBroughtReceiptData(filtersFlg: {"pay_flg": null});
            getDetailsBroughtReceiptData(
                page: currentPage,
                tokenReq: tokenReq,
                orderID: orderNewIDBroughtReceipt ?? widget.orderID);
          });
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR ADD FOOD TO BROUGHT RECEIPT 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR ADD FOOD TO BROUGHT RECEIPT 2 $error");
      }
    } catch (error) {
      print("ERROR ADD FOOD TO BROUGHT RECEIPT 3 $error");
    }
  }

  void minusQuantityFoodToBroughtReceipt(
      {required int foodID, int? orderID, required String tokenReq}) async {
    try {
      var token = tokenReq;
      final respons = await http.post(
        Uri.parse('$baseUrl$removeFoodToBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'order_id': orderNewIDBroughtReceipt ?? widget.orderID,
          'food_id': foodID
        }),
      );
      final data = jsonDecode(respons.body);
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          var newOrderId = data['order_id'];
          setState(() {
            currentPage = 1;
            listFoodCurrent.clear();
            orderNewIDBroughtReceipt = newOrderId;
            getListBroughtReceiptData(filtersFlg: {"pay_flg": null});
            getDetailsBroughtReceiptData(
                page: currentPage,
                tokenReq: tokenReq,
                orderID: orderNewIDBroughtReceipt ?? widget.orderID);
          });
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR MINUS FOOD TO BROUGHT RECEIPT 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR MINUS FOOD TO BROUGHT RECEIPT 2 $error");
      }
    } catch (error) {
      print("ERROR MINUS FOOD TO BROUGHT RECEIPT 3 $error");
    }
  }

  void updateQuantityFoodToBroughtReceipt(
      {required int foodID,
      int? orderID,
      required String quantityFood,
      required String tokenReq}) async {
    try {
      var token = tokenReq;

      final respons = await http.post(
        Uri.parse('$baseUrl$updateQuantityFoodBroughtReceipt'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': widget.role,
          'shop_id': widget.shopID,
          'is_api': true,
          'order_id': orderNewIDBroughtReceipt ?? widget.orderID,
          'food_id': foodID,
          'value': quantityFood
        }),
      );
      final data = jsonDecode(respons.body);
      final message = data['message'];

      try {
        if (data['status'] == 200) {
          var newOrderId = data['order_id'];
          mounted
              ? setState(() {
                  currentPage = 1;
                  listFoodCurrent.clear();

                  orderNewIDBroughtReceipt = newOrderId;
                  getListBroughtReceiptData(filtersFlg: {"pay_flg": null});
                  getDetailsBroughtReceiptData(
                      page: currentPage,
                      tokenReq: tokenReq,
                      orderID: orderNewIDBroughtReceipt ?? widget.orderID);
                })
              : null;
          showSnackBarTopCustom(
              title: "Thành công",
              context: navigatorKey.currentContext,
              mess: message['title'],
              color: Colors.green);
        } else {
          print("ERROR MINUS FOOD TO BROUGHT RECEIPT 1");
          showSnackBarTopCustom(
              title: "Thất bại",
              context: navigatorKey.currentContext,
              mess: message['text'],
              color: Colors.red);
        }
      } catch (error) {
        print("ERROR MINUS FOOD TO BROUGHT RECEIPT 2 $error");
      }
    } catch (error) {
      print("ERROR MINUS FOOD TO BROUGHT RECEIPT 3 $error");
    }
  }

  @override
  void initState() {
    super.initState();

    getDetailsBroughtReceiptData(
        page: 1, orderID: widget.orderID, tokenReq: widget.token);

    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        getDetailsBroughtReceiptData(
          page: currentPage,
          orderID: widget.orderID,
          tokenReq: widget.token,
          keywords: query,
          foodKinds:
              selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
        );
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
    log(listFoodCurrent.length.toString());
    return BlocBuilder<ManageBroughtReceiptBloc, BroughtReceiptState>(
        builder: (context, state) {
      if (state.broughtReceiptStatus == BroughtReceiptStatus.succes) {
        List<String> foodKindOfShop =
            StorageUtils.instance.getStringList(key: 'food_kinds_list') ?? [];

        List filterProducts2 = listFoodCurrent.where((product) {
          final foodTitle = product.foodName.toLowerCase();
          final input = query.toLowerCase();
          return (selectedCategoriesIndex.isEmpty ||
                  selectedCategoriesIndex.contains(product.foodKind)) &&
              foodTitle.contains(input);
        }).toList();
        listAllCategoriesFood = foodKindOfShop;
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Container(
            width: 1.sw,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextApp(
                      text: "Hóa đơn mang về",
                      fontWeight: FontWeight.bold,
                      fontsize: 18.sp,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                space20H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                Card(
                    elevation: 8.w,
                    margin: EdgeInsets.all(8.w),
                    child: Container(
                        width: 1.sw,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.w)),
                        child: Padding(
                          padding: EdgeInsets.all(10.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TextApp(
                                    text: "Tên khách hàng: ",
                                    fontWeight: FontWeight.bold,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text: "Khách lẻ",
                                    fontsize: 14.sp,
                                  ),
                                ],
                              ),
                              space10H,
                              Row(
                                children: [
                                  TextApp(
                                    text: "Tổng tiền món ăn: ",
                                    fontWeight: FontWeight.bold,
                                    fontsize: 14.sp,
                                  ),
                                  TextApp(
                                    text:
                                        "${currentOrderTotalBroughtReceipt ?? '0'} đ",
                                    fontsize: 14.sp,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ))),
                space30H,
                SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: foodKindOfShop.map((lableFood) {
                              return Padding(
                                padding: EdgeInsets.only(right: 5.w, left: 5.w),
                                child: FilterChip(
                                  labelPadding: EdgeInsets.only(
                                      left: 15.w,
                                      right: 15.w,
                                      top: 8.w,
                                      bottom: 8.w),
                                  disabledColor: Colors.blue,
                                  selectedColor: Colors.blue,
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  selectedShadowColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w),
                                    side: BorderSide(
                                      color:
                                          selectedCategories.contains(lableFood)
                                              ? Colors.grey.withOpacity(0.5)
                                              : Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                      color:
                                          selectedCategories.contains(lableFood)
                                              ? Colors.white
                                              : Colors.blue),
                                  showCheckmark: false,
                                  label: Text(lableFood.toUpperCase()),
                                  // TextApp(
                                  //   text: lableFood.toUpperCase(),
                                  //   fontsize: 14.sp,
                                  //   color: blueText,
                                  //   fontWeight: FontWeight.bold,
                                  //   textAlign: TextAlign.center,
                                  // ),
                                  selected:
                                      selectedCategories.contains(lableFood),
                                  onSelected: (bool selected) {
                                    if (mounted) {
                                      setState(() {
                                        if (selected) {
                                          selectedCategories.add(
                                              lableFood); //thêm tên category vào mảng
                                          int index = listAllCategoriesFood
                                              .indexOf(lableFood);
                                          selectedCategoriesIndex.add(
                                              index); //thêm index category vào mảng
                                          listFoodCurrent.clear();
                                          currentPage = 1;
                                          getDetailsBroughtReceiptData(
                                            page: currentPage,
                                            orderID: widget.orderID,
                                            tokenReq: widget.token,
                                            keywords: query,
                                            foodKinds:
                                                selectedCategoriesIndex.isEmpty
                                                    ? null
                                                    : selectedCategoriesIndex,
                                          );
                                          // getListFood(
                                          //     tokenReq: widget.token,
                                          //     page: currentPage,
                                          //     keywords: query,
                                          //     foodKinds: selectedCategoriesIndex
                                          //             .isEmpty
                                          //         ? null
                                          //         : selectedCategoriesIndex);
                                        } else {
                                          selectedCategories.remove(
                                              lableFood); //xoá tên category vào mảng
                                          int index = listAllCategoriesFood
                                              .indexOf(lableFood);
                                          selectedCategoriesIndex.remove(
                                              index); //xoá index category vào mảng
                                          listFoodCurrent.clear();
                                          currentPage = 1;
                                          getDetailsBroughtReceiptData(
                                            page: currentPage,
                                            orderID: widget.orderID,
                                            tokenReq: widget.token,
                                            keywords: query,
                                            foodKinds:
                                                selectedCategoriesIndex.isEmpty
                                                    ? null
                                                    : selectedCategoriesIndex,
                                          );
                                          // getListFood(
                                          //     tokenReq: widget.token,
                                          //     page: currentPage,
                                          //     keywords: query,
                                          //     foodKinds: selectedCategoriesIndex
                                          //             .isEmpty
                                          //         ? null
                                          //         : selectedCategoriesIndex);
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )),
                space30H,
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: searchProduct,
                          controller: searchController,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              isDense: true,
                              hintText: "Nhập nội dung bạn muốn tìm kiếm",
                              contentPadding: const EdgeInsets.all(15)),
                        ),
                      ),
                      space20W,
                      Container(
                          width: 80.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: Colors
                                  .blue, //                   <--- border color
                              width: 2.0,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextApp(
                                text: currentCartBroughtReceipt.toString(),
                                color: Colors.blue,
                                fontsize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              space5W,
                              const Icon(
                                Icons.shopping_basket_rounded,
                                color: Colors.blue,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 5.0),
                const SizedBox(height: 10.0),
                filterProducts2.isEmpty
                    ? Container()
                    // Container(
                    //     width: 1.sw,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10.r),
                    //         gradient: const LinearGradient(
                    //           begin: Alignment.topRight,
                    //           end: Alignment.bottomLeft,
                    //           colors: [
                    //             Color.fromRGBO(33, 82, 255, 1),
                    //             Color.fromRGBO(33, 212, 253, 1)
                    //           ],
                    //         )),
                    //     child: Center(
                    //       child: TextApp(
                    //         text: "Cửa hàng này chưa có món ăn",
                    //         fontsize: 14.sp,
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ))
                    : Expanded(
                        child: ListView.builder(
                            itemCount: filterProducts2.length + 1,
                            controller: scrollListFoodController,
                            itemBuilder: (context, index) {
                              if (index < filterProducts2.length) {
                                _foodQuantityController
                                    .add(TextEditingController());
                                _foodQuantityController[index].text =
                                    filterProducts2[index]
                                        .quantityFood
                                        .toString();

                                var imagePath1 =
                                    filterProducts2[index]?.foodImages;
                                // var imagePath2 =
                                //     imagePath1.replaceAll('"]', '');
                                var listImagePath =
                                    jsonDecode(imagePath1 ?? '[]');
                                return Container(
                                  width: 1.sw,
                                  margin: EdgeInsets.only(
                                      bottom: 15.h, left: 5.w, right: 5.w),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(15.r)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 80.w,
                                          height: 80.w,
                                          // color: Colors.amber,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(40.w),
                                            child: imagePath1 == null
                                                ? Image.asset(
                                                    'assets/images/dish.png',
                                                    fit: BoxFit.contain,
                                                  )
                                                : CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: httpImage +
                                                        listImagePath[0],
                                                    placeholder:
                                                        (context, url) =>
                                                            SizedBox(
                                                      height: 10.w,
                                                      width: 10.w,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                          )),
                                      space15W,
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 80.w,
                                                  child: TextApp(
                                                    softWrap: true,
                                                    isOverFlow: false,
                                                    text: filterProducts2[index]
                                                            .foodName ??
                                                        '',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                space10H,
                                                SizedBox(
                                                  width: 80.w,
                                                  child: TextApp(
                                                    softWrap: true,
                                                    isOverFlow: false,
                                                    text:
                                                        "${MoneyFormatter(amount: (filterProducts2[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                                    fontsize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: blueText2,
                                                  ),
                                                ),
                                                space10H,
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 80.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (filterProducts2[index]
                                                        .quantityFood !=
                                                    0) {
                                                  minusQuantityFoodToBroughtReceipt(
                                                    tokenReq: widget.token,
                                                    foodID:
                                                        filterProducts2[index]
                                                            .foodId,
                                                  );
                                                } else {
                                                  showSnackBarTopCustom(
                                                      title: "",
                                                      context: navigatorKey
                                                          .currentContext,
                                                      mess:
                                                          "Thao tác không thể thực hiện",
                                                      color: Colors.red);
                                                }
                                              },
                                              onDoubleTap: () {
                                                showCustomDialogModal(
                                                  typeDialog: "error",
                                                  context: navigatorKey
                                                      .currentContext,
                                                  textDesc:
                                                      "Bạn thao tác quá nhanh",
                                                  title: "Thành công",
                                                  colorButton: Colors.red,
                                                  btnText: "OK",
                                                );
                                              },
                                              child: Container(
                                                width: 20.w,
                                                // height: 35.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.r),
                                                            bottomLeft: Radius
                                                                .circular(8.r)),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Color.fromRGBO(
                                                            33, 82, 255, 1),
                                                        Color.fromRGBO(
                                                            33, 212, 253, 1)
                                                      ],
                                                    )),
                                                child: Center(
                                                  child: TextApp(
                                                    text: "-",
                                                    textAlign: TextAlign.center,
                                                    color: Colors.white,
                                                    fontsize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                                fit: FlexFit.tight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.4,
                                                        color: Colors.grey),
                                                  ),
                                                  child: Center(
                                                    child: TextField(
                                                      textAlign:
                                                          TextAlign.center,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                "[0-9]")),
                                                      ], // Only numbers can be entered,
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: grey),
                                                      controller:
                                                          _foodQuantityController[
                                                              index],

                                                      onTapOutside: (event) {
                                                        print('onTapOutside');
                                                        FocusManager.instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                        updateQuantityFoodToBroughtReceipt(
                                                          tokenReq:
                                                              widget.token,
                                                          foodID:
                                                              filterProducts2[
                                                                      index]
                                                                  .foodId,
                                                          quantityFood:
                                                              _foodQuantityController[
                                                                      index]
                                                                  .text,
                                                        );
                                                      },
                                                      cursorColor: grey,
                                                      decoration:
                                                          const InputDecoration(
                                                        fillColor:
                                                            Color.fromARGB(255,
                                                                226, 104, 159),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          214,
                                                                          51,
                                                                          123,
                                                                          0.6),
                                                                  width: 2.0),
                                                        ),

                                                        hintText: '',
                                                        isDense:
                                                            true, // Added this
                                                        contentPadding:
                                                            EdgeInsets.all(
                                                                3), // Added this
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                            InkWell(
                                              onTap: () {
                                                plusQuantityFoodToBroughtReceipt(
                                                  tokenReq: widget.token,
                                                  foodID: filterProducts2[index]
                                                      .foodId,
                                                );
                                              },
                                              onDoubleTap: () {
                                                showCustomDialogModal(
                                                  typeDialog: "error",
                                                  context: navigatorKey
                                                      .currentContext,
                                                  textDesc:
                                                      "Bạn thao tác quá nhanh",
                                                  title: "Thành công",
                                                  colorButton: Colors.red,
                                                  btnText: "OK",
                                                );
                                              },
                                              child: Container(
                                                width: 20.w,
                                                // height: 35.w,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8.r),
                                                            bottomRight: Radius
                                                                .circular(8.r)),
                                                    gradient:
                                                        const LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Color.fromRGBO(
                                                            33, 82, 255, 1),
                                                        Color.fromRGBO(
                                                            33, 212, 253, 1)
                                                      ],
                                                    )),
                                                child: Center(
                                                  child: TextApp(
                                                    text: "+",
                                                    textAlign: TextAlign.center,
                                                    color: Colors.white,
                                                    fontsize: 18.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
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
                            })),
              ],
            ),
          ),
        );
      } else if (state.broughtReceiptStatus == BroughtReceiptStatus.loading) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Center(
            child: SizedBox(
              width: 1.sw,
              height: 200.w,
              child: Lottie.asset('assets/lottie/loading_7_color.json'),
            ),
          ),
        );
      } else {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Center(
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
                  text: state.errorText.toString(),
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
        );
      }
    });
  }
}

//Modal in hoá đơn

class PrintBillDialog extends StatefulWidget {
  final String token;
  final String roomName;
  final String tableName;
  final int orderID;
  final String role;
  const PrintBillDialog(
      {Key? key,
      required this.roomName,
      required this.tableName,
      required this.orderID,
      required this.role,
      required this.token})
      : super(key: key);
  @override
  State<PrintBillDialog> createState() => _PrintBillDialogState();
}

class _PrintBillDialogState extends State<PrintBillDialog> {
  void printBroughtReceipt({required int orderID}) async {
    BlocProvider.of<PrintBroughtReceiptBloc>(context).add(PrintBroughtReceipt(
        token: widget.token,
        client: widget.role,
        shopId: getStaffShopID,
        orderId: orderID));
  }

  @override
  void initState() {
    super.initState();
    printBroughtReceipt(orderID: widget.orderID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrintBroughtReceiptBloc, PrintBroughtReceiptState>(
      builder: (context, state) {
        if (state.printBroughtReceiptStatus ==
            PrintBroughtReceiptStatus.succes) {
          var payKind =
              state.printBroughtReceiptModel?.order.payKind.toString();
          switch (payKind) {
            case "0":
              payKind = "Tiền mặt";
              break;
            case "1":
              payKind = "Thẻ";
            case "2":
              payKind = "Chuyển khoản";
          }
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: widget.roomName,
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: widget.tableName,
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      space10H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextApp(
                            text: state.printBroughtReceiptModel?.store
                                    .storeName ??
                                '',
                            fontsize: 18.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          space5W,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextApp(
                                text: "Địa chỉ: ",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              space10W,
                              TextApp(
                                text: state.printBroughtReceiptModel?.store
                                        .storeAddress ??
                                    '',
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          )
                        ],
                      ),
                      space5H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      Wrap(
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Giờ vào: ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: formatDateTime(state
                                        .printBroughtReceiptModel
                                        ?.order
                                        .createdAt
                                        .toString() ??
                                    ''),
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextApp(
                                text: "Giờ ra:  ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: formatDateTime(state
                                        .printBroughtReceiptModel
                                        ?.order
                                        .updatedAt
                                        .toString() ??
                                    ''),
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              space20W,
                            ],
                          )
                        ],
                      ),
                      space5H,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Tên khách hàng: ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: state.printBroughtReceiptModel?.order
                                        .clientName ??
                                    'Khách lẻ',
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      space20H,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tên hàng",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "SL",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "Đ.giá",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "TT",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                        ],
                      ),
                      space5H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              state.printBroughtReceiptModel?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: TextApp(
                                            isOverFlow: false,
                                            softWrap: true,
                                            text: state.printBroughtReceiptModel
                                                    ?.data[index].foodName ??
                                                '',
                                            fontsize: 14.sp,
                                            color: blueText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: 20.w,
                                      child: Center(
                                        child: TextApp(
                                          isOverFlow: false,
                                          softWrap: true,
                                          text: state.printBroughtReceiptModel
                                                  ?.data[index].quantityFood
                                                  .toString() ??
                                              '',
                                          fontsize: 14.sp,
                                          color: blueText,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.green,
                                      width: 50.w,
                                      child: TextApp(
                                        isOverFlow: false,
                                        softWrap: true,
                                        text:
                                            "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.data[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                        fontsize: 14.sp,
                                        color: blueText,
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.yellow,
                                      width: 50.w,
                                      child: TextApp(
                                        isOverFlow: false,
                                        softWrap: true,
                                        text:
                                            "${MoneyFormatter(amount: ((state.printBroughtReceiptModel!.data[index].foodPrice * state.printBroughtReceiptModel!.data[index].quantityFood)).toDouble()).output.withoutFractionDigits.toString()} đ",
                                        fontsize: 14.sp,
                                        color: blueText,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                space10H
                              ],
                            );
                          }),
                      space35H,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tổng tiền món ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Giảm giá ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.discount ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Khách cần trả ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Khách thanh toán ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.guestPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Loại thanh toán ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text: payKind ?? '',
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tiền thừa trả khách ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.guestPayClient ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      space15H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      state.printBroughtReceiptModel?.order
                                  .cancellationReason !=
                              null
                          ? Column(
                              children: [
                                TextApp(
                                  text: "Hoá đơn bị huỷ ",
                                  fontsize: 16.sp,
                                  color: red,
                                  fontWeight: FontWeight.bold,
                                ),
                                space10H,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(
                                      text: "Lý do huỷ: ",
                                      fontsize: 16.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    TextApp(
                                      text: state.printBroughtReceiptModel
                                          ?.order.cancellationReason,
                                      fontsize: 16.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(),
                      space15H,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonApp(
                            event: () {
                              Navigator.of(context).pop();
                            },
                            text: "Đóng",
                            colorText: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                            outlineColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          ButtonApp(
                            event: () {
                              // widget.eventSaveButton();
                            },
                            text: "In",
                            colorText: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(23, 193, 232, 1),
                            outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (state.printBroughtReceiptStatus ==
            PrintBroughtReceiptStatus.loading) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
              child: SizedBox(
                width: 1.sw,
                height: 200.w,
                child: Lottie.asset('assets/lottie/loading_7_color.json'),
              ),
            ),
          );
        } else {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
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
                    text: state.errorText.toString(),
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
          );
        }
      },
    );
  }
}

//Modal in hoa dang mang ve

class PrintBroughtReceiptDialog extends StatelessWidget {
  final String role;
  final String shopID;
  final String orderID;
  const PrintBroughtReceiptDialog({
    Key? key,
    required this.role,
    required this.shopID,
    required this.orderID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrintBroughtReceiptBloc, PrintBroughtReceiptState>(
      builder: (context, state) {
        if (state.printBroughtReceiptStatus ==
            PrintBroughtReceiptStatus.succes) {
          var payKind =
              state.printBroughtReceiptModel?.order.payKind.toString();
          switch (payKind) {
            case "0":
              payKind = "Tiền mặt";
              break;
            case "1":
              payKind = "Thẻ";
            case "2":
              payKind = "Chuyển khoản";
          }
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                text: "In hoá đơn",
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      ),
                      space10H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextApp(
                            text: state.printBroughtReceiptModel?.store
                                    .storeName ??
                                '',
                            fontsize: 18.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          space5W,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextApp(
                                text: "Địa chỉ: ",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                              space10W,
                              TextApp(
                                text: state.printBroughtReceiptModel?.store
                                        .storeAddress ??
                                    '',
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          )
                        ],
                      ),
                      space5H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      Wrap(
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Giờ vào: ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: formatDateTime(state
                                        .printBroughtReceiptModel
                                        ?.order
                                        .createdAt
                                        .toString() ??
                                    ''),
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextApp(
                                text: "Giờ ra:  ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: formatDateTime(state
                                        .printBroughtReceiptModel
                                        ?.order
                                        .updatedAt
                                        .toString() ??
                                    ''),
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          )
                        ],
                      ),
                      space5H,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Tên khách hàng: ",
                                fontsize: 16.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: "Khách lẻ",
                                fontsize: 16.sp,
                                color: blueText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      space20H,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tên hàng",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "SL",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "Đ.giá",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                          TextApp(
                            text: "TT",
                            fontsize: 16.sp,
                            color: blueText,
                          ),
                        ],
                      ),
                      space5H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              state.printBroughtReceiptModel?.data.length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // SizedBox(
                                    //   width: 80.w,
                                    //   child: TextApp(
                                    //     text: state.printBroughtReceiptModel
                                    //             ?.data[index].foodName ??
                                    //         '',
                                    //     fontsize: 16.sp,
                                    //     color: blueText,
                                    //   ),
                                    // ),
                                    Wrap(
                                      children: [
                                        SizedBox(
                                          width: 100.w,
                                          child: TextApp(
                                            isOverFlow: false,
                                            softWrap: true,
                                            text: state.printBroughtReceiptModel
                                                    ?.data[index].foodName ??
                                                '',
                                            fontsize: 14.sp,
                                            color: blueText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: 10.w,
                                      child: Center(
                                        child: TextApp(
                                          text: state.printBroughtReceiptModel
                                                  ?.data[index].quantityFood
                                                  .toString() ??
                                              '',
                                          fontsize: 14.sp,
                                          color: blueText,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.green,
                                      width: 50.w,
                                      child: TextApp(
                                        isOverFlow: false,
                                        softWrap: true,
                                        text:
                                            "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.data[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                        fontsize: 14.sp,
                                        color: blueText,
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.yellow,
                                      width: 50.w,
                                      child: TextApp(
                                        isOverFlow: false,
                                        softWrap: true,
                                        text:
                                            "${MoneyFormatter(amount: ((state.printBroughtReceiptModel!.data[index].foodPrice * state.printBroughtReceiptModel!.data[index].quantityFood)).toDouble()).output.withoutFractionDigits.toString()} đ",
                                        fontsize: 14.sp,
                                        color: blueText,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 1,
                                  color: Colors.black,
                                ),
                                space10H
                              ],
                            );
                          }),
                      space35H,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tổng tiền món ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Giảm giá ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.discount ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Khách cần trả ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.clientCanPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Khách thanh toán ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.guestPay ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Loại thanh toán ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text: payKind ?? '',
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextApp(
                            text: "Tiền thừa trả khách ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                          TextApp(
                            text:
                                "${MoneyFormatter(amount: (state.printBroughtReceiptModel?.order.guestPayClient ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                            fontsize: 16.sp,
                            color: blueText,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      space15H,
                      const Divider(
                        height: 1,
                        color: Colors.black,
                      ),
                      space10H,
                      state.printBroughtReceiptModel?.order
                                  .cancellationReason !=
                              null
                          ? Column(
                              children: [
                                TextApp(
                                  text: "Hoá đơn bị huỷ ",
                                  fontsize: 16.sp,
                                  color: red,
                                  fontWeight: FontWeight.bold,
                                ),
                                space10H,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(
                                      text: "Lý do huỷ: ",
                                      fontsize: 16.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    TextApp(
                                      text: state.printBroughtReceiptModel
                                          ?.order.cancellationReason,
                                      fontsize: 16.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(),
                      space15H,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonApp(
                            event: () {
                              Navigator.of(context).pop();
                            },
                            text: "Đóng",
                            colorText: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                            outlineColor:
                                const Color.fromRGBO(131, 146, 171, 1),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          ButtonApp(
                            event: () {
                              // widget.eventSaveButton();
                            },
                            text: "In",
                            colorText: Colors.white,
                            backgroundColor:
                                const Color.fromRGBO(23, 193, 232, 1),
                            outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (state.printBroughtReceiptStatus ==
            PrintBroughtReceiptStatus.loading) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
              child: SizedBox(
                width: 1.sw,
                height: 200.w,
                child: Lottie.asset('assets/lottie/loading_7_color.json'),
              ),
            ),
          );
        } else {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            content: Center(
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
                    text: state.errorText.toString(),
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
          );
        }
      },
    );
  }
}

// Modal huỷ hoá đơn
class CancleBillDialog extends StatefulWidget {
  final String token;
  final String role;
  final String shopID;
  final int? orderID;
  final Function eventSaveButton;

  const CancleBillDialog({
    Key? key,
    required this.eventSaveButton,
    required this.token,
    required this.role,
    required this.shopID,
    required this.orderID,
  }) : super(key: key);

  @override
  State<CancleBillDialog> createState() => _CancleBillDialogState();
}

class _CancleBillDialogState extends State<CancleBillDialog> {
  String currentOptions = optionsCancle[0];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Container(
          width: 1.sw,
          // height: 1.sh / 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 20.w, bottom: 20.w, left: 10.w, right: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Hủy đơn",
                      fontsize: 18.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                space10H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space10H,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextApp(
                      text: "Lý do hủy đơn",
                      fontsize: 14.sp,
                      color: blueText,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                space5H,
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            currentOptions = optionsCancle[0].toString();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Radio(
                            activeColor: Colors.black,
                            value: optionsCancle[0],
                            groupValue: currentOptions,
                            onChanged: (value) {
                              // if (mounted) {
                              //   setState(() {
                              //     currentOptions = value.toString();
                              //   });
                              // }
                            },
                          ),
                          TextApp(
                            text: optionsCancle[0],
                            color: Colors.black,
                            fontsize: 14.sp,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            currentOptions = optionsCancle[1].toString();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Radio(
                            activeColor: Colors.black,
                            value: optionsCancle[1],
                            groupValue: currentOptions,
                            onChanged: (value) {
                              // if (mounted) {
                              //   setState(() {
                              //     currentOptions = value.toString();
                              //   });
                              // }
                            },
                          ),
                          TextApp(
                            text: optionsCancle[1],
                            color: Colors.black,
                            fontsize: 14.sp,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            currentOptions = optionsCancle[2].toString();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Radio(
                            activeColor: Colors.black,
                            value: optionsCancle[2],
                            groupValue: currentOptions,
                            onChanged: (value) {
                              // if (mounted) {
                              //   setState(() {
                              //     currentOptions = value.toString();
                              //   });
                              // }
                            },
                          ),
                          TextApp(
                            text: optionsCancle[2],
                            color: Colors.black,
                            fontsize: 14.sp,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            currentOptions = optionsCancle[3].toString();
                          });
                        }
                      },
                      child: Row(
                        children: [
                          Radio(
                            activeColor: Colors.black,
                            value: optionsCancle[3],
                            groupValue: currentOptions,
                            onChanged: (value) {
                              // if (mounted) {
                              //   setState(() {
                              //     currentOptions = value.toString();
                              //   });
                              // }
                            },
                          ),
                          TextApp(
                            text: optionsCancle[3],
                            color: Colors.black,
                            fontsize: 14.sp,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                space15H,
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                space15H,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonApp(
                      event: () {
                        Navigator.of(context).pop();
                      },
                      text: "Đóng".toUpperCase(),
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    ButtonApp(
                      event: () {
                        widget.eventSaveButton();
                        BlocProvider.of<CancleBroughtReceiptBloc>(context).add(
                            CancleBroughtReceipt(
                                token: widget.token,
                                client: widget.role,
                                shopId: widget.shopID,
                                orderId: widget.orderID,
                                cancellationReason: currentOptions));

                        BlocBuilder<CancleBroughtReceiptBloc,
                            CancleBroughtReceiptState>(
                          builder: (context, state) {
                            if (state.cancleBroughtReceiptStatus ==
                                CancleBroughtReceiptStatus.succes) {
                              showUpdateDataSuccesDialog();
                            } else {}
                            return Container();
                          },
                        );
                      },
                      text: "Xác nhận".toUpperCase(),
                      colorText: Colors.white,
                      backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                      outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

//Modal tạo phòng

class CreateRoomDialog extends StatefulWidget {
  final Function eventSaveButton;
  final String shopID;

  const CreateRoomDialog({
    Key? key,
    required this.eventSaveButton,
    required this.shopID,
  }) : super(key: key);

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  bool light = false;
  final _formField = GlobalKey<FormState>();
  final roomFieldController = TextEditingController();
  void handleCreateRoom({
    required String roomName,
    required String shopID,
    required int activeFlg,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$createRoomByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'room_name': roomName,
          'shop_id': shopID,
          'room_active_flg': activeFlg
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);

      try {
        if (data['status'] == 200) {
          roomFieldController.clear();
          Navigator.of(navigatorKey.currentContext!).pop();

          Future.delayed(Duration(milliseconds: 500), () {
            showCustomDialogModal(
              typeDialog: "succes",
              context: navigatorKey.currentContext,
              textDesc: "Thêm mới phòng thành công",
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
            );
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 1.sw,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: TextApp(
                          text: "Phòng",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                    text: "Tên phòng",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: roomFieldController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return canNotNull;
                      } else {
                        return null;
                      }
                    },
                    cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                    decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 226, 104, 159),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(214, 51, 123, 0.6),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        hintText: "Tên phòng",
                        isDense: true,
                        contentPadding:
                            EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                  ),
                  space20H,
                  TextApp(
                    text: "Chế độ hiển thị",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextApp(
                    text: allowFoodReady,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.w,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoSwitch(
                        value: light,
                        activeColor: const Color.fromRGBO(58, 65, 111, .95),
                        onChanged: (bool value) {
                          if (mounted) {
                            setState(() {
                              light = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.sw,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonApp(
                  event: () {
                    Navigator.of(context).pop();
                  },
                  text: "Đóng",
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                  outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
                ButtonApp(
                  event: () {
                    if (_formField.currentState!.validate()) {
                      handleCreateRoom(
                          roomName: roomFieldController.text,
                          shopID: widget.shopID,
                          activeFlg: light ? 1 : 0);

                      widget.eventSaveButton();
                    }
                  },
                  text: save,
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                  outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//Modal chinh sua phong

class EditRoomDataDialog extends StatefulWidget {
  final Function eventSaveButton;
  final String roomID;
  final String shopID;

  const EditRoomDataDialog({
    Key? key,
    required this.eventSaveButton,
    required this.roomID,
    required this.shopID,
  }) : super(key: key);

  @override
  State<EditRoomDataDialog> createState() => _EditRoomDataDialogState();
}

class _EditRoomDataDialogState extends State<EditRoomDataDialog> {
  bool light = false;
  final _formField = GlobalKey<FormState>();
  final roomFieldController = TextEditingController();
  DataRoomDetailsModel? dataRoomDetailsModel;
  void handleGetDataRoom() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getDetailsRoomApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'room_id': widget.roomID,
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);

      try {
        if (data['status'] == 200) {
          // roomFieldController.clear();
          // Navigator.of(navigatorKey.currentContext!).pop();

          // Future.delayed(Duration(milliseconds: 500), () {
          //   showCustomDialogModal(
          //     typeDialog: "succes",
          //     context: navigatorKey.currentContext,
          //     textDesc: "Cập nhật dữ liệu thành công",
          //     title: "Thành công",
          //     colorButton: Colors.green,
          //     btnText: "OK",
          //   );
          // });
          setState(() {
            dataRoomDetailsModel = DataRoomDetailsModel.fromJson(data);
            roomFieldController.text =
                dataRoomDetailsModel?.data.storeRoomName ?? '';
            light = dataRoomDetailsModel?.data.activeFlg == 1 ? true : false;
          });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  void handleEditRoomData({
    required String nameRoom,
    required int activeFlg,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$editRoomByManager'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'store_room_id': widget.roomID,
          'room_name': nameRoom,
          'room_active_flg': activeFlg,
          'shop_id': widget.shopID
        }),
      );
      final data = jsonDecode(respons.body);
      print(data);

      try {
        if (data['status'] == 200) {
          // roomFieldController.clear();
          Navigator.of(navigatorKey.currentContext!).pop();

          Future.delayed(Duration(milliseconds: 500), () {
            showCustomDialogModal(
              typeDialog: "succes",
              context: navigatorKey.currentContext,
              textDesc: "Cập nhật dữ liệu thành công",
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
            );
          });
          // setState(() {
          //   dataRoomDetailsModel = DataRoomDetailsModel.fromJson(data);
          //   roomFieldController.text =
          //       dataRoomDetailsModel?.data.storeRoomName ?? '';
          //   light = dataRoomDetailsModel?.data.activeFlg == 1 ? true : false;
          // });
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  @override
  void initState() {
    super.initState();
    handleGetDataRoom();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 1.sw,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: TextApp(
                          text: "Phòng",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formField,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextApp(
                    text: "Tên phòng",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    controller: roomFieldController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return canNotNull;
                      } else {
                        return null;
                      }
                    },
                    cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                    decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 226, 104, 159),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(214, 51, 123, 0.6),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        hintText: "Tên phòng",
                        isDense: true,
                        contentPadding:
                            EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                  ),
                  space20H,
                  TextApp(
                    text: "Chế độ hiển thị",
                    fontsize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextApp(
                    text: allowFoodReady,
                    fontsize: 12.sp,
                    fontWeight: FontWeight.normal,
                    color: blueText,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 50.w,
                    height: 30.w,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoSwitch(
                        value: light,
                        activeColor: const Color.fromRGBO(58, 65, 111, .95),
                        onChanged: (bool value) {
                          if (mounted) {
                            setState(() {
                              light = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1.sw,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonApp(
                  event: () {
                    Navigator.of(context).pop();
                  },
                  text: "Đóng",
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                  outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
                ButtonApp(
                  event: () {
                    if (_formField.currentState!.validate()) {
                      // handleCreateRoom(
                      //     roomName: roomFieldController.text,
                      //     shopID: widget.shopID,
                      //     activeFlg: light ? 1 : 0);
                      handleEditRoomData(
                          nameRoom: roomFieldController.text,
                          activeFlg: light ? 1 : 0);
                      widget.eventSaveButton();
                    }
                  },
                  text: save,
                  colorText: Colors.white,
                  backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                  outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                ),
                SizedBox(
                  width: 20.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Modal tạo cửa hàng

class CreateStoreDialog extends StatefulWidget {
  // final List<XFile>? imageFileList;
  final Function eventSaveButton;

  CreateStoreDialog({
    Key? key,
    // required this.imageFileList,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateStoreDialog> createState() => _CreateStoreDialogState();
}

class _CreateStoreDialogState extends State<CreateStoreDialog> {
  bool light = false;
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final idStoreController = TextEditingController();
  final nameStoreController = TextEditingController();
  final addressStoreController = TextEditingController();
  final desController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  // QuillController _controllerQuill = QuillController.basic();
  String currentStoreLogo = 'assets/img/no-image.png';
  List<File>? imageFileList = [];
  List<String> listImageStore = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _controllerQuill;
  }

  void pickImageLogoStore() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
      if (selectedImage != null) {
        Uint8List imagebytes = selectedImage!.readAsBytesSync();
        String base64string = base64Encode(imagebytes);
        currentStoreLogo = base64string;
      }
    });
    // openImage();
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      var pathImage = File(returndImage.path);
      imageFileList!.add(pathImage);
      if (pathImage != null) {
        Uint8List imagebytes = pathImage.readAsBytesSync(); //convert to bytes
        String base64string = base64Encode(imagebytes);
        listImageStore.add(base64string);
      }
    });
  } //selecte one picture

  void takeImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
    });
  }

  void getListStore() async {
    BlocProvider.of<ListStoresBloc>(context).add(GetListStores(
      token: StorageUtils.instance.getString(key: 'token_manager') ?? '',
    ));
  }

  void deleteImages(data) {
    imageFileList!.remove(data);
    listImageStore.remove(data);
    setState(() {});
  }

  void handleCreateStore({
    required String nameStore,
    required String addressStore,
    required String shopID,
    required String descriptionStore,
    required String logoStore,
    required List<String> imagesStore,
    required bool activeFlag,
  }) async {
    try {
      print({
        "active_flg": activeFlag,
        'store_logo': logoStore,
        'description': descriptionStore,
        "shop_id": shopID,
        'name': nameStore,
        'address': addressStore,
        'images': imagesStore,
      });
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$createStoreApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'active_flg': activeFlag,
          'images': imagesStore,
          'store_logo': logoStore,
          'description': descriptionStore,
          'shop_id': shopID,
          'name': nameStore,
          'address': addressStore
        }),
      );
      final data = jsonDecode(respons.body);
      log(data.toString());
      try {
        if (data['status'] == 200) {
          getListStore();
          Navigator.of(navigatorKey.currentContext!).pop();

          Future.delayed(Duration(milliseconds: 500), () {
            showCustomDialogModal(
              typeDialog: "succes",
              context: navigatorKey.currentContext,
              textDesc: "Thêm mới cửa hàng thành công",
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
            );
          });

          // ignore: use_build_context_synchronously
          // Navigator.of(context).pop();
        } else {
          print("ERROR DATA FOOD TABLE 1 ${data}");
          var messFailed = data['errors'];
          var messErrorShopId1 = messFailed['shop_id'].toString();
          var messErrorShopId2 = messErrorShopId1.replaceAll("[", "");
          var messErrorShopId3 = messErrorShopId2.replaceAll("]", "");
          var messErrorShopId4 =
              messErrorShopId3.replaceAll("Nội dung", "Mã cửa hàng");

          var messErrorNameShop1 = messFailed['name'].toString();
          var messErrorNameShop2 = messErrorNameShop1.replaceAll("[", "");
          var messErrorNameShop3 = messErrorNameShop2.replaceAll("]", "");
          var messErrorNameShop4 =
              messErrorNameShop3.replaceAll("Nội dung", "Tên cửa hàng");

          var messErrorAddressShop1 = messFailed['address'].toString();
          var messErrorAddressShop2 = messErrorAddressShop1.replaceAll("[", "");
          var messErrorAddressShop3 = messErrorAddressShop2.replaceAll("]", "");
          var messErrorAddressShop4 =
              messErrorAddressShop3.replaceAll("Nội dung", "Địa chỉ cửa hàng");

          var messError =
              '$messErrorShopId4\n  ${messErrorNameShop4 == 'null' ? '' : messErrorNameShop4}\n ${messErrorAddressShop4 == 'null' ? '' : messErrorAddressShop4}\n';
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: messError,
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        print("ERROR DATA FOOD TABLE 2 ${error}");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("ERROR DATA FOOD TABLE 3 $error");
      showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Có lỗi xảy ra",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Container(
        width: 1.sw,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                  child: Container(
                      width: 1.sw,
                      height: 50,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(15.w),
                      //       topRight: Radius.circular(15.w)),
                      //   // color: Colors.amber,
                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Cửa hàng",
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Form(
                    key: _formField,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: storeId,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          maxLength: 12,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: idStoreController,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else if (value.length < 6) {
                              return "Độ dài ít nhất 6 kí tự";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeId,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        ////////
                        SizedBox(
                          height: 30.h,
                        ),
                        //////
                        TextApp(
                          text: storeName,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          maxLength: 32,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: nameStoreController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeName,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        /////
                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: storeAddress,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: addressStoreController,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeAddress,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        /////
                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: displayMode,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          child: TextApp(
                            isOverFlow: false,
                            softWrap: true,
                            text: allowOpenStore,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 50.w,
                          height: 30.w,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CupertinoSwitch(
                              value: light,
                              activeColor:
                                  const Color.fromRGBO(58, 65, 111, .95),
                              onChanged: (bool value) {
                                if (mounted) {
                                  setState(() {
                                    light = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: desStore,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          child: TextApp(
                            isOverFlow: false,
                            softWrap: true,
                            text: describeDetailSotre,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextApp(
                              text: " Mô tả",
                              fontsize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: blueText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              maxLength: 255,
                              onTapOutside: (event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: desController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 3,
                              cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                              decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 226, 104, 159),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(214, 51, 123, 0.6),
                                        width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  hintText: '',
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      bottom: 1.sw > 600 ? 50.w : 40.w,
                                      top: 0,
                                      left: 1.sw > 600 ? 20.w : 15.w,
                                      right: 1.sw > 600 ? 20.w : 15.w)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        TextApp(
                          text: storeImage,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),

                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.grey, width: 1), //
                            ),
                            onPressed: () {
                              pickImage();
                            },
                            child: Column(
                              children: [
                                imageFileList!.isEmpty
                                    ? SizedBox(
                                        width: double.infinity,
                                        height: 200.h,
                                        // color: Colors.red,
                                        child: Center(
                                          child: TextApp(
                                            text: addPictureHere,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        width: double.infinity,
                                        child: GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: imageFileList!.length,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                      width: 100.w,
                                                      height: 100.w,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.w),
                                                        child: Image.file(
                                                          File(imageFileList![
                                                                  index]
                                                              .path),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )),
                                                  space10H,
                                                  InkWell(
                                                    onTap: () {
                                                      deleteImages(
                                                          imageFileList![
                                                              index]);
                                                      deleteImages(
                                                          listImageStore[
                                                              index]);
                                                    },
                                                    child: TextApp(
                                                      text: deleteImage,
                                                      color: Colors.blue,
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                      )
                              ],
                            )),

                        SizedBox(
                          height: 30.h,
                        ),
                        TextApp(
                          text: "Logo của của hàng",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Colors.grey, width: 1), //
                            ),
                            onPressed: () {
                              pickImageLogoStore();
                            },
                            child: Container(
                                width: 1.sw,
                                height: 150.h,
                                margin: EdgeInsets.all(20.h),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: SizedBox(
                                      width: 100.w,
                                      height: 100.w,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.w),
                                          child: selectedImage != null
                                              ? Image.file(
                                                  selectedImage!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container())),
                                ))),
                      ],
                    ),
                  ),
                )),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    // border: const Border(
                    //     top: BorderSide(width: 1, color: Colors.grey),
                    //     bottom: BorderSide(width: 0, color: Colors.grey),
                    //     left: BorderSide(width: 0, color: Colors.grey),
                    //     right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            if (listImageStore.isNotEmpty &&
                                selectedImage != null) {
                              handleCreateStore(
                                nameStore: nameStoreController.text,
                                addressStore: addressStoreController.text,
                                shopID: idStoreController.text,
                                descriptionStore: desController.text,
                                logoStore: currentStoreLogo,
                                imagesStore: listImageStore,
                                activeFlag: light,
                              );
                            } else {
                              showCustomDialogModal(
                                  context: navigatorKey.currentContext,
                                  textDesc:
                                      "Bạn cần ít nhất một ảnh và logo cho cửa hàng ",
                                  title: "Thất bại",
                                  colorButton: Colors.red,
                                  btnText: "OK",
                                  typeDialog: "error");
                            }
                          } else {
                            if (listImageStore.isEmpty) {
                              showCustomDialogModal(
                                  context: navigatorKey.currentContext,
                                  textDesc:
                                      "Bạn cần ít nhất một ảnh cho cửa hàng",
                                  title: "Thất bại",
                                  colorButton: Colors.red,
                                  btnText: "OK",
                                  typeDialog: "error");
                            } else if (selectedImage == null) {
                              showCustomDialogModal(
                                  context: navigatorKey.currentContext,
                                  textDesc: "Bạn cần logo cho cửa hàng",
                                  title: "Thất bại",
                                  colorButton: Colors.red,
                                  btnText: "OK",
                                  typeDialog: "error");
                            } else {
                              showCustomDialogModal(
                                  context: navigatorKey.currentContext,
                                  textDesc:
                                      "Vui lòng kiểm tra lại các thông tin đã điền",
                                  title: "Thất bại",
                                  colorButton: Colors.red,
                                  btnText: "OK",
                                  typeDialog: "error");
                            }
                          }
                        },
                        text: save,
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditDetailStoreDialog extends StatefulWidget {
  // final List<XFile>? imageFileList;
  final Function eventSaveButton;
  EditDetailsStoreModel? editDetailsStoreModel;

  EditDetailStoreDialog({
    Key? key,
    // required this.imageFileList,
    required this.eventSaveButton,
    required this.editDetailsStoreModel,
  }) : super(key: key);

  @override
  State<EditDetailStoreDialog> createState() => _EditDetailStoreDialogState();
}

class _EditDetailStoreDialogState extends State<EditDetailStoreDialog> {
  bool light = false;
  File? selectedLogoImage;
  final _formField = GlobalKey<FormState>();
  final idStoreController = TextEditingController();
  final nameStoreController = TextEditingController();
  final addressStoreController = TextEditingController();
  final desStoreController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  String currentStoreLogo = 'assets/img/no-image.png';
  List<StoreImage> listDataImage = [];
  // List<File>? imageFileList = [];
  List<dynamic> listDynamicImage = [];
  List<String> listImageStore = [];

  void pickImageLogoStore() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedLogoImage = File(returndImage.path);
      if (selectedLogoImage != null) {
        Uint8List imagebytes = selectedLogoImage!.readAsBytesSync();
        String base64string = base64Encode(imagebytes);
        currentStoreLogo = base64string;
      }
    });
    // openImage();
  }

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      var pathImage = File(returndImage.path);
      listDynamicImage.add(pathImage);
      if (pathImage != null) {
        Uint8List imagebytes = pathImage.readAsBytesSync(); //convert to bytes
        String base64string = base64Encode(imagebytes);
        listImageStore.add(base64string);
      }
    });
  } //selecte one picture

  void deleteImages(data) {
    listDynamicImage.remove(data);
    listImageStore.remove(data);
    setState(() {});
  }

  void init() async {
    mounted
        ? nameStoreController.text =
            widget.editDetailsStoreModel?.data.storeName ?? ''
        : null;
    mounted
        ? idStoreController.text =
            widget.editDetailsStoreModel?.data.shopId ?? ''
        : null;
    mounted
        ? addressStoreController.text =
            widget.editDetailsStoreModel?.data.storeAddress ?? ''
        : null;

    mounted
        ? widget.editDetailsStoreModel?.data.activeFlg == 1
            ? light = true
            : light = false
        : null;

    mounted
        ? widget.editDetailsStoreModel?.data.storeImages.where((element) {
              var heheh = element.path;
              listDynamicImage.add(heheh);
              return true;
            }).toList() ??
            []
        : null;
    mounted
        ? currentStoreLogo =
            widget.editDetailsStoreModel?.data.storeLogo.normal ??
                currentStoreLogo
        : currentStoreLogo;
    mounted
        ? listDataImage = widget.editDetailsStoreModel?.data.storeImages ?? []
        : null;
    mounted
        ? desStoreController.text =
            widget.editDetailsStoreModel?.data.storeDescription ?? ''
        : null;
    listDataImage.where((element) {
      if (element.name != null) {
        listImageStore.add(element.normal);
      } else {
        return false;
      }
      return true;
    }).toList();
  }

  void getListStore() async {
    BlocProvider.of<ListStoresBloc>(context).add(GetListStores(
      token: StorageUtils.instance.getString(key: 'token_manager') ?? '',
    ));
  }

  void handleEditStore({
    required String storeID,
    required String shopId,
    required String nameStore,
    required String addressStore,
    required String descStore,
    required List<String> imagesStore,
    required String imageLogoStore,
    required bool activeFlag,
  }) async {
    print({
      'store_id': storeID,
      'shop_id': shopId,
      'name': nameStore,
      'address': addressStore,
      'description': descStore,
      'store_logo': imageLogoStore,
      'active_flg': activeFlag,
      'images': imagesStore,
    });
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$editDetailsStoreApi'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'store_id': storeID,
          'shop_id': shopId,
          'name': nameStore,
          'address': addressStore,
          'description': descStore,
          'images': imagesStore,
          'store_logo': imageLogoStore,
          'active_flg': activeFlag,
        }),
      );
      final data = jsonDecode(respons.body);
      print("UPDATE DATA STORE ${data}");
      try {
        if (data['status'] == 200) {
          Navigator.of(navigatorKey.currentContext!).pop();
          Navigator.pop(navigatorKey.currentContext!);
          getListStore();
          Future.delayed(Duration(milliseconds: 300), () {
            showCustomDialogModal(
              typeDialog: "succes",
              context: navigatorKey.currentContext,
              textDesc: "Cập nhật cửa hàng thành công",
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
            );
          });
        } else {
          print("ERROR LIST FOOOD RECEIPT PAGE 1");
          showCustomDialogModal(
              context: navigatorKey.currentContext,
              textDesc: "Có lỗi xảy ra",
              title: "Thất bại",
              colorButton: Colors.red,
              btnText: "OK",
              typeDialog: "error");
        }
      } catch (error) {
        print("ERROR BROUGHT RECEIPT PAGE 2 $error");
        showCustomDialogModal(
            context: navigatorKey.currentContext,
            textDesc: "Có lỗi xảy ra",
            title: "Thất bại",
            colorButton: Colors.red,
            btnText: "OK",
            typeDialog: "error");
      }
    } catch (error) {
      print("ERROR BROUGHT RECEIPT PAGE 3 $error");
      showCustomDialogModal(
          context: navigatorKey.currentContext,
          textDesc: "Có lỗi xảy ra",
          title: "Thất bại",
          colorButton: Colors.red,
          btnText: "OK",
          typeDialog: "error");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Container(
        width: 1.sw,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.w, left: 15.w, right: 15.w),
                  child: Container(
                      width: 1.sw,
                      height: 50,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(15.w),
                      //       topRight: Radius.circular(15.w)),
                      //   // color: Colors.amber,
                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text: "Cửa hàng ",
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                              TextApp(
                                text: widget.editDetailsStoreModel?.data
                                        .storeName ??
                                    '',
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                SingleChildScrollView(
                    child: Padding(
                  padding: EdgeInsets.all(15.w),
                  child: Form(
                    key: _formField,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: storeId,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: idStoreController,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeId,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        ////////
                        SizedBox(
                          height: 30.h,
                        ),
                        //////
                        TextApp(
                          text: storeName,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          controller: nameStoreController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeName,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        /////
                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: storeAddress,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          controller: addressStoreController,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: storeAddress,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        /////
                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: displayMode,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextApp(
                          text: allowOpenStore,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 50.w,
                          height: 30.w,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CupertinoSwitch(
                              value: light,
                              activeColor:
                                  const Color.fromRGBO(58, 65, 111, .95),
                              onChanged: (bool value) {
                                if (mounted) {
                                  setState(() {
                                    light = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: desStore,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextApp(
                          text: describeDetailSotre,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextFormField(
                          maxLength: 255,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: desStoreController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: '',
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  bottom: 1.sw > 600 ? 50.w : 40.w,
                                  top: 0,
                                  left: 1.sw > 600 ? 20.w : 15.w,
                                  right: 1.sw > 600 ? 20.w : 15.w)),
                        ),

                        SizedBox(
                          height: 30.h,
                        ),
                        TextApp(
                          text: storeImage,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            backgroundColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.grey, width: 1), //
                          ),
                          onPressed: () {
                            listDynamicImage.length >= 3
                                ? showCustomDialogModal(
                                    context: navigatorKey.currentContext,
                                    textDesc: "Số ảnh tối đa là 3",
                                    title: "Thất bại",
                                    colorButton: Colors.red,
                                    btnText: "OK",
                                    typeDialog: "error")
                                : pickImage();
                          },
                          child: listDataImage.isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 200.h,
                                  // color: Colors.red,
                                  child: Center(
                                    child: TextApp(
                                      text: addPictureHere,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: listDynamicImage.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (listDynamicImage[index]
                                                .toString()
                                                .length >
                                            150) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100.w,
                                                height: 100.w,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.w),
                                                    child: Image.file(
                                                      listDynamicImage[index],
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                              space10H,
                                              InkWell(
                                                onTap: () {
                                                  deleteImages(
                                                      listDynamicImage[index]);
                                                  deleteImages(
                                                      listImageStore[index]);
                                                },
                                                child: TextApp(
                                                  text: deleteImage,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 100.w,
                                                height: 100.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.w),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: listDynamicImage[
                                                            index] ??
                                                        '',
                                                    placeholder:
                                                        (context, url) =>
                                                            SizedBox(
                                                      height: 10.w,
                                                      width: 10.w,
                                                      child: const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              space10H,
                                              InkWell(
                                                onTap: () {
                                                  deleteImages(
                                                      listDynamicImage[index]);
                                                  deleteImages(
                                                      listImageStore[index]);
                                                },
                                                child: TextApp(
                                                  text: deleteImage,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      }),
                                ),
                        ),

                        SizedBox(
                          height: 30.h,
                        ),
                        TextApp(
                          text: "Logo của của hàng",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),

                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              backgroundColor: Colors.white,
                              side: const BorderSide(
                                  color: Colors.grey, width: 1), //
                            ),
                            onPressed: () {
                              pickImageLogoStore();
                            },
                            child: Container(
                                width: 1.sw,
                                height: 150.h,
                                margin: EdgeInsets.all(20.h),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: SizedBox(
                                      width: 100.w,
                                      height: 100.w,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.w),
                                        child: selectedLogoImage != null
                                            ? Image.file(
                                                selectedLogoImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: httpImage +
                                                    currentStoreLogo,
                                                placeholder: (context, url) =>
                                                    SizedBox(
                                                  height: 10.w,
                                                  width: 10.w,
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                      )),
                                ))),
                      ],
                    ),
                  ),
                )),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    // border: const Border(
                    //     top: BorderSide(width: 1, color: Colors.grey),
                    //     bottom: BorderSide(width: 0, color: Colors.grey),
                    //     left: BorderSide(width: 0, color: Colors.grey),
                    //     right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            if (listImageStore.isNotEmpty) {
                              handleEditStore(
                                  storeID: widget
                                          .editDetailsStoreModel?.data.storeId
                                          .toString() ??
                                      '',
                                  shopId: idStoreController.text,
                                  nameStore: nameStoreController.text,
                                  addressStore: addressStoreController.text,
                                  descStore: desStoreController.text,
                                  imagesStore: listImageStore,
                                  imageLogoStore: currentStoreLogo,
                                  activeFlag: light);
                            } else {
                              showCustomDialogModal(
                                  context: navigatorKey.currentContext,
                                  textDesc:
                                      "Bạn cần ít nhất một ảnh cho món ăn",
                                  title: "Thất bại",
                                  colorButton: Colors.red,
                                  btnText: "OK",
                                  typeDialog: "error");
                            }
                          } else {
                            showCustomDialogModal(
                                context: navigatorKey.currentContext,
                                textDesc: "Bạn o món ăn",
                                title: "Thất bại",
                                colorButton: Colors.red,
                                btnText: "OK",
                                typeDialog: "error");
                          }
                        },
                        text: save,
                        colorText: Colors.white,
                        backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//Modal tạo bàn
class CreateTableDialog extends StatefulWidget {
  final Function eventSaveButton;
  final String? roomTableID;
  final String? storeRoomID;
  const CreateTableDialog({
    Key? key,
    required this.eventSaveButton,
    required this.roomTableID,
    required this.storeRoomID,
  }) : super(key: key);

  @override
  State<CreateTableDialog> createState() => _CreateTableDialogState();
}

class _CreateTableDialogState extends State<CreateTableDialog> {
  bool light = false;
  final _formField = GlobalKey<FormState>();
  final nameTableController = TextEditingController();
  final chairsOfTableController = TextEditingController();
  final desController = TextEditingController();
  TableDataDetailsModel? tableDataDetailsModel;
  void handleGetDataTable() async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$getDetailsDataOfTable'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'room_table_id': widget.roomTableID,
          'is_api': true,
        }),
      );
      final data = jsonDecode(respons.body);

      try {
        if (data['status'] == 200) {
          setState(() {
            tableDataDetailsModel = TableDataDetailsModel.fromJson(data);
          });
          intitData();
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  void handleUpdateDataTable({
    required String? roomTableID,
    required String? storeRoomID,
    required String numberOfSeat,
    required String description,
    required String tableName,
    required bool activeFlg,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_manager');

      final respons = await http.post(
        Uri.parse('$baseUrl$updateOrCreateRoom'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'is_api': true,
          'room_table_id': roomTableID,
          'store_room_id': storeRoomID,
          'number_of_seats': numberOfSeat,
          'description': description,
          'table_name': tableName,
          'table_active_flg': activeFlg
        }),
      );
      final data = jsonDecode(respons.body);
      try {
        if (data['status'] == 200) {
          var mess = data['message'];
          Navigator.of(navigatorKey.currentContext!).pop();

          showCustomDialogModal(
              context: navigatorKey.currentContext!,
              textDesc: mess,
              title: "Thành công",
              colorButton: Colors.green,
              btnText: "OK",
              typeDialog: "succes");
          widget.eventSaveButton();
        } else {
          print("ERROR CREATE FOOOD");
        }
      } catch (error) {
        print("ERROR CREATE 112212 $error");
      }
    } catch (error) {
      print("ERROR CREATE 44444 $error");
    }
  }

  void intitData() async {
    mounted
        ? nameTableController.text = tableDataDetailsModel?.data.tableName ?? ''
        : null;
    mounted
        ? chairsOfTableController.text =
            tableDataDetailsModel?.data.numberOfSeats.toString() ?? ''
        : null;
    mounted
        ? desController.text = tableDataDetailsModel?.data.description ?? ''
        : null;
    mounted
        ? tableDataDetailsModel?.data.activeFlg == 1
            ? light = true
            : light = false
        : null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleGetDataTable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: Padding(
        padding: EdgeInsets.all(20.w),
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: 1.sw,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              TextApp(
                                text:
                                    "Bàn ${tableDataDetailsModel?.data.tableName ?? ''}",
                                fontsize: 18.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ],
                      )),
                  Divider(),
                  space10H,
                  SingleChildScrollView(
                      child: Form(
                    key: _formField,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextApp(
                          text: "Tên bàn",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          maxLength: 12,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: nameTableController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              // hintText: storeName,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),
                        /////
                        SizedBox(
                          height: 30.h,
                        ),
                        ////
                        TextApp(
                          text: "Số ghế trong bàn",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          ],
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: chairsOfTableController,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return canNotNull;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              // hintText: storeAddress,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.all(1.sw > 600 ? 20.w : 15.w)),
                        ),

                        SizedBox(
                          height: 20.h,
                        ),
                        TextApp(
                          text: "Mô tả",
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        space10H,
                        TextFormField(
                          maxLength: 255,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          controller: desController,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          maxLines: 3,
                          cursorColor: const Color.fromRGBO(73, 80, 87, 1),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 226, 104, 159),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(214, 51, 123, 0.6),
                                    width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              hintText: '',
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  bottom: 1.sw > 600 ? 50.w : 40.w,
                                  top: 0,
                                  left: 1.sw > 600 ? 20.w : 15.w,
                                  right: 1.sw > 600 ? 20.w : 15.w)),
                        ),

                        ////
                        TextApp(
                          isOverFlow: false,
                          softWrap: true,
                          text: displayMode,
                          fontsize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: blueText,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 1.sw,
                          child: TextApp(
                            isOverFlow: false,
                            softWrap: true,
                            text: allowOpenTable,
                            fontsize: 12.sp,
                            fontWeight: FontWeight.normal,
                            color: blueText,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 50.w,
                          height: 30.w,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: CupertinoSwitch(
                              value: light,
                              activeColor:
                                  const Color.fromRGBO(58, 65, 111, .95),
                              onChanged: (bool value) {
                                setState(() {
                                  light = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  space15H,
                  Container(
                    width: 1.sw,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonApp(
                          event: () {
                            Navigator.of(context).pop();
                          },
                          text: "Đóng",
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                          outlineColor: Color.fromRGBO(131, 146, 171, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        ButtonApp(
                          event: () {
                            if (_formField.currentState!.validate()) {
                              handleUpdateDataTable(
                                roomTableID: widget.roomTableID,
                                storeRoomID: widget.storeRoomID,
                                numberOfSeat: chairsOfTableController.text,
                                description: desController.text,
                                tableName: nameTableController.text,
                                activeFlg: light,
                              );
                              // nameTableController.clear();
                              // chairsOfTableController.clear();
                            }
                          },
                          text: save,
                          colorText: Colors.white,
                          backgroundColor: Color.fromRGBO(23, 193, 232, 1),
                          outlineColor: Color.fromRGBO(23, 193, 232, 1),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateItemDialog extends StatefulWidget {
  final Function eventSaveButton;
  const CreateItemDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateItemDialog> createState() => _CreateItemDialogState();
}

class _CreateItemDialogState extends State<CreateItemDialog>
    with TickerProviderStateMixin {
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final _formField2 = GlobalKey<FormState>();
  final nameItemController = TextEditingController();
  final initalQuantityController = TextEditingController();
  final minQuantityController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  bool isHaveddddd = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(
      length: 2,
      vsync: this,
    );
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 1.sw,
                    height: 50,
                    decoration: BoxDecoration(
                      border: const Border(
                          top: BorderSide(width: 0, color: Colors.grey),
                          bottom: BorderSide(width: 1, color: Colors.grey),
                          left: BorderSide(width: 0, color: Colors.grey),
                          right: BorderSide(width: 0, color: Colors.grey)),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.w),
                          topRight: Radius.circular(15.w)),
                      // color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            TextApp(
                              text: "Quản lý mặt hàng",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                TabBar(
                    labelPadding: const EdgeInsets.only(left: 20, right: 20),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.black.withOpacity(0.5),
                    labelStyle: const TextStyle(color: Colors.red),
                    controller: _tabController,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(text: "Thông tin chung"),
                      Tab(
                        text: "Quy đổi đơn vị",
                      ),
                    ]),
                Container(
                  width: 1.sw,
                  height: 400.h,
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ListView(
                          shrinkWrap: true,
                          children: [
                            Form(
                              key: _formField,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ////////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  //////
                                  TextApp(
                                    text: "Tên mặt hàng",
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
                                    controller: nameItemController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return canNotNull;
                                      } else {
                                        return null;
                                      }
                                    },
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
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
                                        // hintText: storeName,
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),
                                  /////
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  TextApp(
                                    text: "Đơn vị",
                                    fontsize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: blueText,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  DropdownSearch(
                                    validator: (value) {
                                      if (value == "Nhập đơn vị") {
                                        // setState(() {
                                        //   isHaveddddd = false;
                                        // });
                                        return canNotNull;
                                      } else {
                                        return null;
                                      }
                                    },
                                    items: listMeasure,
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
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
                                        hintText: "Nhập đơn vị",
                                      ),
                                    ),
                                    onChanged: print,
                                    selectedItem: "Nhập đơn vị",
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  ////
                                  TextApp(
                                    text: "Số lượng ban đầu",
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
                                    controller: initalQuantityController,
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return canNotNull;
                                      } else {
                                        return null;
                                      }
                                    },
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
                                        // hintText: storeAddress,
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),

                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  ////
                                  TextApp(
                                    text: "Số lượng tối thiểu",
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
                                    controller: minQuantityController,
                                    cursorColor:
                                        const Color.fromRGBO(73, 80, 87, 1),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return canNotNull;
                                      } else {
                                        return null;
                                      }
                                    },
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
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(
                                            1.sw > 600 ? 20.w : 15.w)),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),

                                  SizedBox(
                                    height: 30.h,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Tab2

                        ListView(
                          shrinkWrap: true,
                          children: [
                            Form(
                              key: _formField2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ////////
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  //////
                                  isHaveddddd
                                      ? TextApp(
                                          text:
                                              "* Lưu ý: Chỉ số nhập vào bé nhất là 1 và đơn vị quy đổi không được trùng lặp",
                                          fontsize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        )
                                      : Container(
                                          width: 1.sw,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.w),
                                              color: Colors.red),
                                          child: Center(
                                            child: TextApp(
                                              text: "Chưa chọn đơn vị quy đổi",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontsize: 14.sp,
                                            ),
                                          ),
                                        ),

                                  SizedBox(
                                    width: 20.w,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                space15H,
                Container(
                  width: 1.sw,
                  height: 80,
                  decoration: BoxDecoration(
                    border: const Border(
                        top: BorderSide(width: 1, color: Colors.grey),
                        bottom: BorderSide(width: 0, color: Colors.grey),
                        left: BorderSide(width: 0, color: Colors.grey),
                        right: BorderSide(width: 0, color: Colors.grey)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15.w),
                        bottomRight: Radius.circular(15.w)),
                    // color: Colors.green,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonApp(
                        event: () {
                          Navigator.of(context).pop();
                        },
                        text: "Đóng",
                        colorText: Colors.white,
                        backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: const Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate() &&
                              _formField2.currentState!.validate()) {
                            widget.eventSaveButton();
                            nameItemController.clear();
                            initalQuantityController.clear();
                            minQuantityController.clear();
                          }
                        },
                        text: "Lưu mặt hàng",
                        colorText: Colors.white,
                        backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
                        outlineColor: const Color.fromRGBO(23, 193, 232, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
