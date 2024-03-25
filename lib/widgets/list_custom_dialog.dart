import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:app_restaurant/bloc/bill/bill_bloc.dart';
import 'package:app_restaurant/bloc/brought_receipt/brought_receipt_bloc.dart';
import 'package:app_restaurant/bloc/manager/tables/table_bloc.dart';
import 'package:app_restaurant/bloc/payment/payment_bloc.dart';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/config/text.dart';
import 'package:app_restaurant/config/void_show_dialog.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:app_restaurant/model/list_room_model.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/button/button_app.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/custom_tab.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_formatter/money_formatter.dart';

///Modal quản lí bàn
class BookingTableDialog extends StatefulWidget {
  final int? idRoom;
  final List<Tables>? listTableOfRoom;
  final Tables? currentTable;
  final Function eventSaveButton;
  final String role;
  final String shopID;
  const BookingTableDialog(
      {Key? key,
      this.idRoom,
      this.listTableOfRoom,
      this.currentTable,
      required this.role,
      required this.shopID,
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
      _dateStartController.text = newDateTime.toString();
    });
  }

  final searchController = TextEditingController();

  List<String> selectedCategories = [];
  List<String> listAllCategoriesFood = [];
  List<int> selectedCategoriesIndex = [];
  List<ItemFood> currentFoodList = [];
  final List<TextEditingController> _foodQuantityController = [];

  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
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
  List itemNe = List.generate(10, (index) => index);

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    //
    setState(() {
      listBanDaGhep = widget.listTableOfRoom
              ?.where((table) =>
                  table.orderId == widget.currentTable?.orderId &&
                  table.roomTableId != widget.currentTable?.roomTableId &&
                  table.orderId != null)
              .toList() ??
          [];
    });
    scrollListFoodController.addListener(() {
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        print("LOADD MORE FOOD");
        loadMoreFood();
      }
    });
  }

  bool hasMore = true;
  Future loadMoreFood() async {
    setState(() {
      itemNe.addAll(['', '']);
    });
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    return BlocBuilder<TableBloc, TableState>(
      builder: (context, state) {
        if (state.tableStatus == TableStatus.succes) {
          List<String> foodKindOfShop =
              StorageUtils.instance.getStringList(key: 'food_kinds_list') ?? [];

          var listGetFood = state.foodTableDataModel?.foods?.data;
          List filterProducts = listGetFood?.where((product) {
                final foodTitle = product.foodName?.toLowerCase() ?? '';
                final input = query.toLowerCase();

                return (selectedCategoriesIndex.isEmpty ||
                        selectedCategoriesIndex.contains(product.foodKind)) &&
                    foodTitle.contains(input);
              }).toList() ??
              [];
          listAllCategoriesFood =
              foodKindOfShop; //add data category food vao mang nay de lay index category

          customerNameController.text =
              state.tableModel?.booking?.order?.clientName ?? '';
          customerPhoneController.text =
              state.tableModel?.booking?.order?.clientPhone ?? '';
          _dateStartController.text =
              state.tableModel?.booking?.order?.endBookedTableAt ??
                  _dateStartController.text;
          noteController.text = state.tableModel?.booking?.order?.note ?? '';
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

          return BlocBuilder<TableCancleBloc, TableCancleState>(
              builder: (contextCancleTable, stateCancleTable) {
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
                                    BlocProvider.of<TableBloc>(context)
                                        .add(GetTableInfor(
                                      client: widget.role,
                                      shopId: widget.shopID,
                                      roomId: widget.idRoom.toString(),
                                      tableId: widget.currentTable?.roomTableId
                                              .toString() ??
                                          '',
                                    ));
                                  } else if (index == 1) {
                                    BlocProvider.of<TableBloc>(context).add(
                                        GetTableFoods(
                                            client: widget.role,
                                            shopId: widget.shopID,
                                            roomId: widget.idRoom.toString(),
                                            tableId: widget
                                                    .currentTable?.roomTableId
                                                    .toString() ??
                                                '',
                                            limit: 1000.toString(),
                                            page: 1.toString()));
                                  }
                                },
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
                                  CustomTab(
                                      text: "Đặt món",
                                      icon: Icons.dinner_dining_outlined),
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
                                        TextApp(
                                          text: " Thời gian kết thúc",
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
                                          onTap: pickDateAndTime,
                                          cursorColor: const Color.fromRGBO(
                                              73, 80, 87, 1),
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
                                          controller: customerNameController,
                                          cursorColor: const Color.fromRGBO(
                                              73, 80, 87, 1),
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
                                          controller: customerPhoneController,
                                          cursorColor: const Color.fromRGBO(
                                              73, 80, 87, 1),
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
                                              // dropdownBuilder: (context, selectedItems) => ,
                                              key: _popupCustomValidationKey,
                                              itemAsString: (item) =>
                                                  item.tableName,
                                              items: (listTableNoBooking)
                                                  as List<Tables>,
                                              selectedItems:
                                                  listTableHaveSameOrderID ??
                                                      [],
                                              onChanged: (listSelectedTable) {
                                                setState(() {
                                                  listBanDaGhep =
                                                      listSelectedTable;
                                                });
                                              },
                                              popupProps:
                                                  PopupPropsMultiSelection
                                                      .dialog(
                                                          title: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.w, top: 10.h),
                                                child: TextApp(
                                                  text: "Chọn bàn để ghép",
                                                  fontsize: 16.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: blueText,
                                                ),
                                              )),
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
                                          controller: noteController,
                                          keyboardType: TextInputType.multiline,
                                          minLines: 1,
                                          maxLines: 3,
                                          cursorColor: const Color.fromRGBO(
                                              73, 80, 87, 1),
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
                                                  left:
                                                      1.sw > 600 ? 20.w : 15.w,
                                                  right: 1.sw > 600
                                                      ? 20.w
                                                      : 15.w)),
                                        ),
                                      ],
                                    )),
                                    Container(
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
                                            backgroundColor: Color.fromRGBO(
                                                131, 146, 171, 1),
                                            outlineColor: Color.fromRGBO(
                                                131, 146, 171, 1),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          ButtonApp(
                                            event: () {
                                              //Save infor table

                                              BlocProvider.of<
                                                          TableSaveInforBloc>(
                                                      context)
                                                  .add(SaveTableInfor(
                                                client: "staff",
                                                shopId: getStaffShopID,
                                                roomId:
                                                    widget.idRoom.toString(),
                                                tableId: widget
                                                    .currentTable!.roomTableId
                                                    .toString(),
                                                clientName:
                                                    customerNameController.text,
                                                clientPhone:
                                                    customerPhoneController
                                                        .text,
                                                note: noteController.text,
                                                endDate:
                                                    _dateStartController.text,
                                                tables: listBanDaGhep
                                                        .map((e) =>
                                                            e.roomTableId)
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
                                            backgroundColor:
                                                const Color.fromRGBO(
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
                                Column(
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
                                                          Colors.grey,
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
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1.0,
                                                        ),
                                                      ),
                                                      labelStyle: TextStyle(
                                                          color: selectedCategories
                                                                  .contains(
                                                                      lableFood)
                                                              ? Colors.white
                                                              : Colors.black),
                                                      showCheckmark: false,
                                                      label: TextApp(
                                                        text: lableFood
                                                            .toUpperCase(),
                                                        fontsize: 14.sp,
                                                        color: blueText,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
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
                                                                .add(
                                                                    index); //thêm index category vào mảng
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
                                                      BorderRadius.circular(
                                                          10.r),
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
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextApp(
                                                    text: state
                                                            .foodTableDataModel
                                                            ?.countOrderFoods
                                                            .toString() ??
                                                        "0",
                                                    color: Colors.white,
                                                    fontsize: 14.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  space5W,
                                                  const Icon(
                                                    Icons.shopping_cart,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    const SizedBox(height: 10.0),
                                    Expanded(
                                        child: ListView.builder(
                                            controller:
                                                scrollListFoodController,
                                            itemCount:
                                                // itemNe.length + 1,
                                                filterProducts.length,
                                            itemBuilder: (context, index) {
                                              _foodQuantityController
                                                  .add(TextEditingController());
                                              _foodQuantityController[index]
                                                  .text = state
                                                      .foodTableDataModel
                                                      ?.foods
                                                      ?.data?[index]
                                                      .quantityFood
                                                      .toString() ??
                                                  '0';
                                              void addFodd() {
                                                BlocProvider.of<TableBloc>(
                                                        context)
                                                    .add(AddFoodToTable(
                                                  client: widget.role,
                                                  shopId: widget.shopID,
                                                  roomId:
                                                      widget.idRoom.toString(),
                                                  tableId: widget.currentTable
                                                          ?.roomTableId
                                                          .toString() ??
                                                      '',
                                                  orderId: widget
                                                          .currentTable?.orderId
                                                          .toString() ??
                                                      '',
                                                  foodId: state
                                                          .foodTableDataModel
                                                          ?.foods
                                                          ?.data?[index]
                                                          .foodId
                                                          .toString() ??
                                                      '',
                                                ));
                                                BlocProvider.of<TableBloc>(context)
                                                    .add(GetTableFoods(
                                                        client: widget.role,
                                                        shopId: widget.shopID,
                                                        roomId: widget.idRoom
                                                            .toString(),
                                                        tableId: widget
                                                                .currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        limit: 1000.toString(),
                                                        page: 1.toString()));
                                              }

                                              void updateQuantytiFood() {
                                                BlocProvider.of<TableBloc>(context)
                                                    .add(UpdateQuantytiFoodToTable(
                                                        client: widget.role,
                                                        shopId: widget.shopID,
                                                        roomId: widget.idRoom
                                                            .toString(),
                                                        tableId: widget
                                                                .currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: widget
                                                                .currentTable
                                                                ?.orderId
                                                                .toString() ??
                                                            '',
                                                        foodId: state
                                                                .foodTableDataModel
                                                                ?.foods
                                                                ?.data?[index]
                                                                .foodId
                                                                .toString() ??
                                                            '',
                                                        value:
                                                            _foodQuantityController[index]
                                                                .text));
                                                BlocProvider.of<TableBloc>(context)
                                                    .add(GetTableFoods(
                                                        client: widget.role,
                                                        shopId: widget.shopID,
                                                        roomId: widget.idRoom
                                                            .toString(),
                                                        tableId: widget
                                                                .currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        limit: 1000.toString(),
                                                        page: 1.toString()));
                                              }

                                              void removeFood() {
                                                BlocProvider.of<BillInforBloc>(
                                                        context)
                                                    .add(RemoveFoodToBill(
                                                  client: widget.role,
                                                  shopId: widget.shopID,
                                                  roomId:
                                                      widget.idRoom.toString(),
                                                  tableId: widget.currentTable
                                                          ?.roomTableId
                                                          .toString() ??
                                                      '',
                                                  orderId: widget
                                                          .currentTable?.orderId
                                                          .toString() ??
                                                      '',
                                                  foodId: state
                                                          .foodTableDataModel
                                                          ?.foods
                                                          ?.data?[index]
                                                          .foodId
                                                          .toString() ??
                                                      '',
                                                ));

                                                BlocProvider.of<TableBloc>(context)
                                                    .add(GetTableFoods(
                                                        client: widget.role,
                                                        shopId: widget.shopID,
                                                        roomId: widget.idRoom
                                                            .toString(),
                                                        tableId: widget
                                                                .currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        limit: 1000.toString(),
                                                        page: 1.toString()));
                                              }

                                              return Card(
                                                elevation: 8.0,
                                                margin: const EdgeInsets.all(8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r),
                                                ),
                                                child: Container(
                                                    width: 1.sw,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    15.r)),
                                                    child: Column(
                                                      children: [
                                                        // space15H,
                                                        // SizedBox(
                                                        //     height: 160.w,
                                                        //     child: ClipRRect(
                                                        //       borderRadius: BorderRadius.only(
                                                        //           topLeft: Radius
                                                        //               .circular(
                                                        //                   15.r),
                                                        //           topRight: Radius
                                                        //               .circular(
                                                        //                   15.r)),
                                                        //       child:
                                                        //           Image.asset(
                                                        //         product.image,
                                                        //         fit: BoxFit
                                                        //             .cover,
                                                        //       ),
                                                        //     )),
                                                        space10H,
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextApp(
                                                                text: filterProducts[
                                                                        index]
                                                                    .foodName),
                                                            TextApp(
                                                              text: filterProducts[
                                                                      index]
                                                                  .foodPrice
                                                                  .toString(),
                                                              fontsize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ],
                                                        ),
                                                        const Divider(),

                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.w),
                                                          child: Container(
                                                            width: 1.sw,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          8.r)),
                                                            ),
                                                            child: SizedBox(
                                                              width: 250.w,
                                                              height: 30.h,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      removeFood();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          70.w,
                                                                      height:
                                                                          35.w,
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
                                                                              print('onTapOutside');
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              updateQuantytiFood();
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
                                                                              contentPadding: EdgeInsets.all(8), // Added this
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      addFodd();
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          70.w,
                                                                      height:
                                                                          35.w,
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
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              );
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
                                                cursorColor:
                                                    const Color.fromRGBO(
                                                        73, 80, 87, 1),
                                                decoration: InputDecoration(
                                                    fillColor: const Color
                                                        .fromARGB(
                                                        255, 226, 104, 159),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromRGBO(
                                                              214,
                                                              51,
                                                              123,
                                                              0.6),
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
                                                            bottom: 1.sw >
                                                                    600
                                                                ? 50.w
                                                                : 40.w,
                                                            top: 0,
                                                            left: 1
                                                                        .sw >
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
                                                    BlocProvider.of<TableCancleBloc>(
                                                            context)
                                                        .add(CancleTable(
                                                            client: "staff",
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
          });
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
        var listTableFree = listRoomInit
            ?.map((e) => e.tables); //list tat ca ban cua phong (nhieu phong)
        // debugPrint("listTableFree ${listTableFree}");

        var listTableFreeOfCurrentRoom = listTableFree?.where(
            (e) => e!.isNotEmpty); // list cac ban con trong cua phong hien tai

        var currentRoom = listRoomInit?.where((element) =>
            element.storeRoomId ==
            (listTableFreeOfCurrentRoom?.first?[0].storeRoomId ??
                '')); //check lay ten phong hien taij (check theo roomId)
        var currentRoomName = currentRoom?.first
            .storeRoomName; // lay ten phong hien tai dung cho dropdown menu

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
                                                    client: widget.role,
                                                    shopId: widget.shopID,
                                                    roomId: widget.listIdRoom[
                                                            listNameRoomFree!
                                                                .indexOf(
                                                                    changeRoom)]
                                                        .toString(),
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
                                      itemCount: listTableFreeOfCurrentRoom
                                              ?.first?.length ??
                                          0,
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
                                                      listTableFreeOfCurrentRoom
                                                          ?.first?[index]
                                                          .roomTableId);
                                                } else {
                                                  selectedTable.add(index);
                                                  selectedTableId.add(
                                                      (listTableFreeOfCurrentRoom
                                                              ?.first?[index]
                                                              .roomTableId) ??
                                                          0);
                                                }
                                              });
                                            },
                                            text: listTableFreeOfCurrentRoom
                                                    ?.first![index].tableName ??
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
                                    print(
                                        "LIST ID TABLE NE ${selectedTableId.toList()}");
                                    BlocProvider.of<SwitchTableBloc>(context)
                                        .add(HandleSwitchTable(
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
                                    } else {
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
class SeeBillDialog extends StatelessWidget {
  final Tables? currentTable;
  final String nameRoom;
  final String role;
  final String shopID;
  final String orderID;
  final String roomID;
  SeeBillDialog({
    Key? key,
    required this.currentTable,
    required this.nameRoom,
    required this.role,
    required this.shopID,
    required this.orderID,
    required this.roomID,
  }) : super(key: key);
  final List<TextEditingController> _foodQuantityController = [];

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
                                      text: currentTable?.tableName ?? '',
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
                                      text: nameRoom,
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
                                                          text: formatDateTime(state
                                                                  .billInforModel
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
                                                              "${MoneyFormatter(amount: (state.billInforModel?.order?.orderTotal ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
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
                                          child: (state.billInforModel?.data ==
                                                      null ||
                                                  state.billInforModel!.data!
                                                      .isEmpty)
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
                                                  itemCount: state
                                                          .billInforModel
                                                          ?.data
                                                          ?.length ??
                                                      0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    _foodQuantityController.add(
                                                        TextEditingController());
                                                    _foodQuantityController[
                                                            index]
                                                        .text = state
                                                            .billInforModel
                                                            ?.data?[index]
                                                            .quantityFood
                                                            .toString() ??
                                                        '0';
                                                    void addFodd() {
                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(AddFoodToBill(
                                                        client: role,
                                                        shopId: shopID,
                                                        roomId: roomID,
                                                        tableId: currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: orderID,
                                                        foodId: state
                                                                .billInforModel
                                                                ?.data?[index]
                                                                .foodId
                                                                .toString() ??
                                                            '',
                                                      ));

                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(GetBillInfor(
                                                        client: role,
                                                        shopId: shopID,
                                                        roomId: roomID,
                                                        tableId: currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: orderID,
                                                      ));
                                                    }

                                                    void updateQuantytiFood() {
                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(UpdateQuantytiFoodToBill(
                                                              client: role,
                                                              shopId: shopID,
                                                              roomId: roomID,
                                                              tableId: currentTable
                                                                      ?.roomTableId
                                                                      .toString() ??
                                                                  '',
                                                              orderId: orderID,
                                                              foodId: state
                                                                      .billInforModel
                                                                      ?.data?[
                                                                          index]
                                                                      .foodId
                                                                      .toString() ??
                                                                  '',
                                                              value:
                                                                  _foodQuantityController[
                                                                          index]
                                                                      .text));
                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(GetBillInfor(
                                                        client: role,
                                                        shopId: shopID,
                                                        roomId: roomID,
                                                        tableId: currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: orderID,
                                                      ));
                                                    }

                                                    void removeFood() {
                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(RemoveFoodToBill(
                                                        client: role,
                                                        shopId: shopID,
                                                        roomId: roomID,
                                                        tableId: currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: orderID,
                                                        foodId: state
                                                                .billInforModel
                                                                ?.data?[index]
                                                                .foodId
                                                                .toString() ??
                                                            '',
                                                      ));

                                                      BlocProvider.of<
                                                                  BillInforBloc>(
                                                              context)
                                                          .add(GetBillInfor(
                                                        client: role,
                                                        shopId: shopID,
                                                        roomId: roomID,
                                                        tableId: currentTable
                                                                ?.roomTableId
                                                                .toString() ??
                                                            '',
                                                        orderId: orderID,
                                                      ));
                                                    }

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
                                                                          height:
                                                                              80.w,
                                                                          child:
                                                                              Image.asset(
                                                                            "assets/images/banner1.png",
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        space50W,
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            SizedBox(
                                                                                width: 100.w,
                                                                                child: Center(
                                                                                  child: TextApp(
                                                                                    text: state.billInforModel?.data?[index].foodName ?? '',
                                                                                    fontsize: 14.sp,
                                                                                  ),
                                                                                )),
                                                                            TextApp(
                                                                                text: "${MoneyFormatter(amount: (state.billInforModel?.data?[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
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
                                                                                removeFood();
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
                                                                                        updateQuantytiFood();
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
                                                                                addFodd();
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
  final Tables? currentTable;
  final String nameRoom;
  final String role;
  final String shopID;
  final String? orderID;
  final String roomID;
  final Function eventSaveButton;
  const PayBillDialog({
    Key? key,
    required this.eventSaveButton,
    required this.currentTable,
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
                      Divider(height: 1, color: Colors.black),
                      Flexible(
                          fit: FlexFit.tight,
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
                                        Container(
                                            width: 1.sw,
                                            height: 40.h,
                                            color: Colors.grey,
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5.h),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    TextApp(
                                                      text: "Hóa đơn",
                                                      color: Colors.white,
                                                      fontsize: 14.sp,
                                                    ),
                                                  ],
                                                ))),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // width: 50.w,
                                                  child: TextApp(
                                                    text: "Tên món ăn",
                                                    color: Colors.black,
                                                    fontsize: 14.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // width: 100.w,
                                                  child: TextApp(
                                                    text: "Số lượng",
                                                    color: Colors.black,
                                                    fontsize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // width: 100.w,
                                                  child: TextApp(
                                                    text: "Giá",
                                                    color: Colors.black,
                                                    fontsize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  // width: 100.w,
                                                  child: TextApp(
                                                    text: "Tổng",
                                                    color: Colors.black,
                                                    fontsize: 14.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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

                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 80.w,
                                                        child: TextApp(
                                                          text: state
                                                                  .paymentInforModel
                                                                  ?.data?[index]
                                                                  .foodName ??
                                                              '',
                                                          color: Colors.black,
                                                          fontsize: 14.sp,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 50.w,
                                                        child: TextApp(
                                                          text: state
                                                                  .paymentInforModel
                                                                  ?.data?[index]
                                                                  .quantityFood
                                                                  .toString() ??
                                                              '',
                                                          color: Colors.black,
                                                          fontsize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        // width: 100.w,
                                                        child: TextApp(
                                                          text: MoneyFormatter(
                                                                  amount: priceOfFood
                                                                      .toDouble())
                                                              .output
                                                              .compactNonSymbol
                                                              .toString(),
                                                          color: Colors.black,
                                                          fontsize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // MoneyFormatter(amount:

                                                      SizedBox(
                                                        // width: 100.w,
                                                        child: TextApp(
                                                          text: MoneyFormatter(
                                                                  amount: totalMoneyFood
                                                                      .toDouble())
                                                              .output
                                                              .compactNonSymbol
                                                              .toString(),
                                                          color: Colors.black,
                                                          fontsize: 14.sp,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  color: Colors.black,
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
                                            text: "Tổng",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          TextApp(
                                            text: MoneyFormatter(
                                                    amount: (state
                                                                .paymentInforModel
                                                                ?.order
                                                                ?.orderTotal ??
                                                            0)
                                                        .toDouble())
                                                .output
                                                .compactNonSymbol
                                                .toString(),
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                        ],
                                      ),
                                      space20H,
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextApp(
                                              text: formatDateTime(state
                                                      .paymentInforModel
                                                      ?.order
                                                      ?.createdAt
                                                      .toString() ??
                                                  ''),
                                              fontsize: 14.sp),
                                          space5W,
                                          Icon(
                                            Icons.access_time_filled,
                                            size: 14.sp,
                                            color: Colors.grey,
                                          )
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
                                            text: "Tổng tiền món",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          TextApp(
                                            text: MoneyFormatter(
                                                    amount: (state
                                                                .paymentInforModel
                                                                ?.order
                                                                ?.orderTotal ??
                                                            0)
                                                        .toDouble())
                                                .output
                                                .compactNonSymbol
                                                .toString(),
                                            color: Colors.black,
                                            fontsize: 14.sp,
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
                                            text: "Giảm giá",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          // space35W,
                                          SizedBox(
                                            width: 120.w,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp("[0-9]")),
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
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 226, 104, 159),
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
                                      space20H,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextApp(
                                            text: "Khách cần trả",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          TextApp(
                                            text: MoneyFormatter(
                                                    amount: (state
                                                                .paymentInforModel
                                                                ?.order
                                                                ?.clientCanPay ??
                                                            0)
                                                        .toDouble())
                                                .output
                                                .compactNonSymbol
                                                .toString(),
                                            color: Colors.black,
                                            fontsize: 14.sp,
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
                                            text: "Khách thanh toán",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          // space15W,
                                          Container(
                                            width: 120.w,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp("[0-9]")),
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
                                                  fillColor:
                                                      const Color.fromARGB(
                                                          255, 226, 104, 159),
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
                                      space20H,
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextApp(
                                            text: "Tiền thừa trả khách",
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                          TextApp(
                                            text: MoneyFormatter(
                                                    amount: (state
                                                                .paymentInforModel
                                                                ?.order
                                                                ?.guestPayClient ??
                                                            0)
                                                        .toDouble())
                                                .output
                                                .compactNonSymbol
                                                .toString(),
                                            color: Colors.black,
                                            fontsize: 14.sp,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
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
                              colorText: Colors.white,
                              backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                              outlineColor: Color.fromRGBO(131, 146, 171, 1),
                            ),
                            space15W,
                            ButtonApp(
                              event: () {
                                showConfirmDialog(context, () {
                                  BlocProvider.of<PaymentInforBloc>(context)
                                      .add(ConfirmPayment(
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
                              backgroundColor: Color.fromRGBO(23, 173, 55, 1),
                              outlineColor: Color.fromRGBO(152, 236, 45, 1),
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
  final String orderID;
  final String role;
  final String shopID;
  const ManageBroughtReceiptDialog({
    Key? key,
    required this.orderID,
    required this.role,
    required this.shopID,
  }) : super(key: key);

  @override
  State<ManageBroughtReceiptDialog> createState() =>
      _ManageBroughtReceiptDialogState();
}

class _ManageBroughtReceiptDialogState
    extends State<ManageBroughtReceiptDialog> {
  final searchController = TextEditingController();
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;
  List<String> selectedCategories = [];
  List<ItemFood> currentFoodList = [];
  List<String> listAllCategoriesFood = [];
  List<int> selectedCategoriesIndex = [];
  final List<TextEditingController> _foodQuantityController = [];

  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
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
  Widget build(BuildContext context) {
    return BlocBuilder<ManageBroughtReceiptBloc, BroughtReceiptState>(
        builder: (context, state) {
      if (state.broughtReceiptStatus == BroughtReceiptStatus.succes) {
        List<String> foodKindOfShop =
            StorageUtils.instance.getStringList(key: 'food_kinds_list') ?? [];
        var listGetFood = state.manageBroughtReceiptModel?.data.data;
        List filterProducts = listGetFood?.where((product) {
              final foodTitle = product.foodName.toLowerCase();
              final input = query.toLowerCase();

              return (selectedCategoriesIndex.isEmpty ||
                      selectedCategoriesIndex.contains(product.foodKind)) &&
                  foodTitle.contains(input);
            }).toList() ??
            [];
        listAllCategoriesFood = foodKindOfShop;
        return AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: InkWell(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Container(
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
                                      text: state.manageBroughtReceiptModel
                                              ?.orderTotal
                                              .toString() ??
                                          '',
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
                      // color: Colors.red,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: foodKindOfShop.map((lableFood) {
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: 5.w, left: 5.w),
                                  child: FilterChip(
                                    labelPadding: EdgeInsets.only(
                                        left: 15.w,
                                        right: 15.w,
                                        top: 8.w,
                                        bottom: 8.w),
                                    disabledColor: Colors.grey,
                                    selectedColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                    shadowColor: Colors.black,
                                    selectedShadowColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w),
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                        color: selectedCategories
                                                .contains(lableFood)
                                            ? Colors.white
                                            : Colors.black),
                                    showCheckmark: false,
                                    label: TextApp(
                                      text: lableFood.toUpperCase(),
                                      fontsize: 14.sp,
                                      color: blueText,
                                      fontWeight: FontWeight.bold,
                                      textAlign: TextAlign.center,
                                    ),
                                    selected:
                                        selectedCategories.contains(lableFood),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedCategories.add(
                                              lableFood); //thêm tên category vào mảng
                                          int index = listAllCategoriesFood
                                              .indexOf(lableFood);
                                          selectedCategoriesIndex.add(
                                              index); //thêm index category vào mảng
                                        } else {
                                          selectedCategories.remove(
                                              lableFood); //xoá tên category vào mảng
                                          int index = listAllCategoriesFood
                                              .indexOf(lableFood);
                                          selectedCategoriesIndex.remove(
                                              index); //xoá index category vào mảng
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
                            onChanged: searchProduct,
                            controller: searchController,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
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
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color.fromRGBO(33, 82, 255, 1),
                                    Color.fromRGBO(33, 212, 253, 1)
                                  ],
                                )),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextApp(
                                  text: state.manageBroughtReceiptModel
                                          ?.countOrderFoods
                                          .toString() ??
                                      "0",
                                  color: Colors.white,
                                  fontsize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                space5W,
                                const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.white,
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const SizedBox(height: 10.0),
                  Expanded(
                      child: ListView.builder(
                          itemCount:
                              // itemNe.length + 1,
                              filterProducts.length,
                          itemBuilder: (context, index) {
                            if (index < (filterProducts.length)) {
                              _foodQuantityController
                                  .add(TextEditingController());
                              _foodQuantityController[index].text = state
                                      .manageBroughtReceiptModel
                                      ?.data
                                      .data[index]
                                      .quantityFood
                                      .toString() ??
                                  '0';

                              void addFodd() {
                                BlocProvider.of<ManageBroughtReceiptBloc>(
                                        context)
                                    .add(AddFoodToBroughtReceipt(
                                  client: widget.role,
                                  shopId: widget.shopID,
                                  orderId: state.manageBroughtReceiptModel?.data
                                          .data[index].orderId
                                          .toString() ??
                                      '',
                                  foodId: state.manageBroughtReceiptModel?.data
                                          .data[index].foodId
                                          .toString() ??
                                      '',
                                ));
                                getDetailsBroughtReceiptData(
                                    orderID: state.manageBroughtReceiptModel
                                            ?.data.data[index].orderId
                                            .toString() ??
                                        '');
                              }

                              // void updateQuantytiFood() {
                              //   BlocProvider.of<ManageBroughtReceiptBloc>(
                              //           context)
                              //       .add(UpdateQuantytiFoodToBroughtReceipt(
                              //           client: widget.role,
                              //           shopId: widget.shopID,
                              //           roomId: widget.idRoom.toString(),
                              //           tableId: widget
                              //                   .currentTable?.roomTableId
                              //                   .toString() ??
                              //               '',
                              //           orderId:
                              //               widget
                              //                       .currentTable?.orderId
                              //                       .toString() ??
                              //                   '',
                              //           foodId: state.foodTableDataModel?.foods
                              //                   ?.data?[index].foodId
                              //                   .toString() ??
                              //               '',
                              //           value: _foodQuantityController[index]
                              //               .text));
                              //   BlocProvider.of<ManageBroughtReceiptBloc>(
                              //           context)
                              //       .add(GetDetailsBroughtReceipt(
                              //           client: widget.role,
                              //           shopId: widget.shopID,
                              //           roomId: widget.idRoom.toString(),
                              //           tableId: widget
                              //                   .currentTable?.roomTableId
                              //                   .toString() ??
                              //               '',
                              //           limit: 1000.toString(),
                              //           page: 1.toString()));
                              // }

                              // void removeFood() {
                              //   BlocProvider.of<ManageBroughtReceiptBloc>(
                              //           context)
                              //       .add(RemoveFoodToBroughtReceipt(
                              //     client: widget.role,
                              //     shopId: widget.shopID,
                              //     roomId: widget.idRoom.toString(),
                              //     tableId: widget.currentTable?.roomTableId
                              //             .toString() ??
                              //         '',
                              //     orderId:
                              //         widget.currentTable?.orderId.toString() ??
                              //             '',
                              //     foodId: state.foodTableDataModel?.foods
                              //             ?.data?[index].foodId
                              //             .toString() ??
                              //         '',
                              //   ));

                              //   BlocProvider.of<ManageBroughtReceiptBloc>(
                              //           context)
                              //       .add(GetDetailsBroughtReceipt(
                              //           client: widget.role,
                              //           shopId: widget.shopID,
                              //           roomId: widget.idRoom.toString(),
                              //           tableId: widget
                              //                   .currentTable?.roomTableId
                              //                   .toString() ??
                              //               '',
                              //           limit: 1000.toString(),
                              //           page: 1.toString()));
                              // }

                              return Card(
                                elevation: 8.0,
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Container(
                                    width: 1.sw,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15.r)),
                                    child: Column(
                                      children: [
                                        // space15H,
                                        // SizedBox(
                                        //     height: 160.w,
                                        //     child: ClipRRect(
                                        //       borderRadius: BorderRadius.only(
                                        //           topLeft: Radius
                                        //               .circular(
                                        //                   15.r),
                                        //           topRight: Radius
                                        //               .circular(
                                        //                   15.r)),
                                        //       child:
                                        //           Image.asset(
                                        //         product.image,
                                        //         fit: BoxFit
                                        //             .cover,
                                        //       ),
                                        //     )),
                                        space10H,
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextApp(
                                                text: filterProducts[index]
                                                    .foodName),
                                            TextApp(
                                              text: filterProducts[index]
                                                  .foodPrice
                                                  .toString(),
                                              fontsize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                        const Divider(),
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: Container(
                                              width: 1.sw,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.r)),
                                              ),
                                              child: IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        width: 70.w,
                                                        height: 35.w,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(8
                                                                            .r),
                                                                    bottomLeft:
                                                                        Radius.circular(8
                                                                            .r)),
                                                                gradient:
                                                                    const LinearGradient(
                                                                  begin: Alignment
                                                                      .topRight,
                                                                  end: Alignment
                                                                      .bottomLeft,
                                                                  colors: [
                                                                    Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            82,
                                                                            255,
                                                                            1),
                                                                    Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            212,
                                                                            253,
                                                                            1)
                                                                  ],
                                                                )),
                                                        child: Center(
                                                          child: TextApp(
                                                            text: "-",
                                                            textAlign: TextAlign
                                                                .center,
                                                            color: Colors.white,
                                                            fontsize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 0.4,
                                                            color: Colors.grey),
                                                      ),
                                                      child: Center(
                                                        child: TextApp(
                                                          text: "1",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    )),
                                                    InkWell(
                                                      onTap: () {
                                                        addFodd();
                                                      },
                                                      child: Container(
                                                        width: 70.w,
                                                        height: 35.w,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius: BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(8
                                                                            .r),
                                                                    bottomRight:
                                                                        Radius.circular(8
                                                                            .r)),
                                                                gradient:
                                                                    const LinearGradient(
                                                                  begin: Alignment
                                                                      .topRight,
                                                                  end: Alignment
                                                                      .bottomLeft,
                                                                  colors: [
                                                                    Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            82,
                                                                            255,
                                                                            1),
                                                                    Color
                                                                        .fromRGBO(
                                                                            33,
                                                                            212,
                                                                            253,
                                                                            1)
                                                                  ],
                                                                )),
                                                        child: Center(
                                                          child: TextApp(
                                                            text: "+",
                                                            textAlign: TextAlign
                                                                .center,
                                                            color: Colors.white,
                                                            fontsize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )),
                                        )
                                      ],
                                    )),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          })),
                ],
              ),
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

class PrintBillDialog extends StatelessWidget {
  const PrintBillDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // scrollable: true,
      // contentPadding: const EdgeInsets.all(0),
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
                          text: "Phòng 1",
                          fontsize: 18.sp,
                          color: blueText,
                          fontWeight: FontWeight.bold,
                        ),
                        TextApp(
                          text: "Bàn 1",
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
                      text: "Shop 1",
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
                          text: "123 duong abc",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                      ],
                    )
                  ],
                ),
                space5H,
                // CustomDotsLine(color: Colors.grey),
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
                          text: "16:04:57",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        space20W,
                        TextApp(
                          text: "27-02-2024",
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
                          text: "11:45:19",
                          fontsize: 16.sp,
                          color: blueText,
                        ),
                        space20W,
                        TextApp(
                          text: "29-02-2024",
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
                          text: "Nguyen Van A",
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
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
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
                      text: "45,000",
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
                      text: "20,000",
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
                      text: "45,000",
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
                      text: "45,000",
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
                      text: "Tiền mặt",
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
                      text: "45,000",
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
                      backgroundColor: const Color.fromRGBO(131, 146, 171, 1),
                      outlineColor: const Color.fromRGBO(131, 146, 171, 1),
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
                      backgroundColor: const Color.fromRGBO(23, 193, 232, 1),
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
  }
}

// Modal huỷ hoá đơn
class CancleBillDialog extends StatefulWidget {
  const CancleBillDialog({super.key});

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
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[0],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[0],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[1],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[1],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[2],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[2],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Colors.black,
                          value: optionsCancle[3],
                          groupValue: currentOptions,
                          onChanged: (value) {
                            setState(() {
                              currentOptions = value.toString();
                            });
                          },
                        ),
                        TextApp(
                          text: optionsCancle[3],
                          color: Colors.black,
                          fontsize: 14.sp,
                        )
                      ],
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
                        // widget.eventSaveButton();
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

  const CreateRoomDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateRoomDialog> createState() => _CreateRoomDialogState();
}

class _CreateRoomDialogState extends State<CreateRoomDialog> {
  bool light = false;
  final _formField = GlobalKey<FormState>();
  final roomFieldController = TextEditingController();
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
                          setState(() {
                            light = value;
                          });
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
                    if (_formField.currentState!.validate()) {
                      widget.eventSaveButton();
                      roomFieldController.clear();
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

// Modal tạo cửa hàng và chỉnh sửa cửa hàng

class CreateStoreDialog extends StatefulWidget {
  final List<XFile>? imageFileList;
  final Function eventSaveButton;
  const CreateStoreDialog({
    Key? key,
    required this.imageFileList,
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
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
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
                              text: "Cửa hàng",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                SingleChildScrollView(
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
                            activeColor: const Color.fromRGBO(58, 65, 111, .95),
                            onChanged: (bool value) {
                              setState(() {
                                light = value;
                              });
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
                      Container(
                          width: 1.sw,
                          // height: 250.h,

                          decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right:
                                    BorderSide(width: 1, color: Colors.grey)),
                            borderRadius: BorderRadius.circular(15.w),
                            // color: Colors.amber,
                          ),
                          child: Column(
                            children: [
                              QuillProvider(
                                  configurations: QuillConfigurations(
                                      controller: _controllerQuill),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 1.sw,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                left: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: const QuillToolbar(
                                              configurations:
                                                  QuillToolbarConfigurations(
                                                      toolbarIconAlignment:
                                                          WrapAlignment.center,
                                                      showFontFamily: true,
                                                      showFontSize: false,
                                                      showBoldButton: true,
                                                      showItalicButton: true,
                                                      showSmallButton: false,
                                                      showUnderLineButton: true,
                                                      showStrikeThrough: false,
                                                      showInlineCode: false,
                                                      showColorButton: false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showClearFormat: false,
                                                      showAlignmentButtons:
                                                          true,
                                                      showLeftAlignment: true,
                                                      showCenterAlignment: true,
                                                      showRightAlignment: true,
                                                      showJustifyAlignment:
                                                          true,
                                                      showHeaderStyle: false,
                                                      showListNumbers: true,
                                                      showListBullets: true,
                                                      showListCheck: false,
                                                      showCodeBlock: false,
                                                      showQuote: false,
                                                      showIndent: false,
                                                      showLink: true,
                                                      showUndo: false,
                                                      showRedo: false,
                                                      showDirection: false,
                                                      showSearchButton: false,
                                                      showSubscript: false,
                                                      showSuperscript: false),
                                            ),
                                          )),
                                      // space20H,
                                      Container(
                                        margin: EdgeInsets.all(5.w),
                                        height: 200.h,
                                        child: QuillEditor.basic(
                                          configurations:
                                              const QuillEditorConfigurations(
                                            readOnly: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          )),
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
                            selectImages();
                          },
                          child: Column(
                            children: [
                              Visibility(
                                  visible: widget.imageFileList!.length == 0,
                                  child: SizedBox(width: 1.sw, height: 150.h)),
                              SizedBox(
                                width: double.infinity,
                                child: GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: widget.imageFileList!.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                                    BorderRadius.circular(15.w),
                                                child: Image.file(
                                                  File(widget
                                                      .imageFileList![index]
                                                      .path),
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          space10H,
                                          InkWell(
                                            onTap: () {
                                              deleteImages(
                                                  widget.imageFileList![index]);
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
                    ],
                  ),
                )),
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
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            widget.eventSaveButton();
                            idStoreController.clear();
                            nameStoreController.clear();
                            addressStoreController.clear();
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

  void pickImage() async {
    final returndImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returndImage == null) return;
    setState(() {
      selectedImage = File(returndImage.path);
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

  void selectImages() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      widget.imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  } //selecte multi image

  void deleteImages(data) {
    widget.imageFileList!.remove(data);
    setState(() {});
  }
}

//Modal tạo bàn
class CreateTableDialog extends StatefulWidget {
  final Function eventSaveButton;
  const CreateTableDialog({
    Key? key,
    required this.eventSaveButton,
  }) : super(key: key);

  @override
  State<CreateTableDialog> createState() => _CreateTableDialogState();
}

class _CreateTableDialogState extends State<CreateTableDialog> {
  bool light = false;
  File? selectedImage;
  final _formField = GlobalKey<FormState>();
  final nameTableController = TextEditingController();
  final chairsOfTableController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  QuillController _controllerQuill = QuillController.basic();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
  }

  @override
  Widget build(BuildContext context) {
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
                              text: "Bàn",
                              fontsize: 18.sp,
                              color: blueText,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ],
                    )),
                space15H,
                SingleChildScrollView(
                    child: Form(
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
                        text: "Tên bàn",
                        fontsize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: blueText,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormField(
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
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                          width: 1.sw,
                          // height: 250.h,

                          decoration: BoxDecoration(
                            border: const Border(
                                top: BorderSide(width: 1, color: Colors.grey),
                                bottom:
                                    BorderSide(width: 1, color: Colors.grey),
                                left: BorderSide(width: 1, color: Colors.grey),
                                right:
                                    BorderSide(width: 1, color: Colors.grey)),
                            borderRadius: BorderRadius.circular(15.w),
                            // color: Colors.amber,
                          ),
                          child: Column(
                            children: [
                              QuillProvider(
                                  configurations: QuillConfigurations(
                                      controller: _controllerQuill),
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 1.sw,
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                left: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey),
                                                right: BorderSide(
                                                    width: 0,
                                                    color: Colors.grey)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: const QuillToolbar(
                                              configurations:
                                                  QuillToolbarConfigurations(
                                                      toolbarIconAlignment:
                                                          WrapAlignment.center,
                                                      showFontFamily: true,
                                                      showFontSize: false,
                                                      showBoldButton: true,
                                                      showItalicButton: true,
                                                      showSmallButton: false,
                                                      showUnderLineButton: true,
                                                      showStrikeThrough: false,
                                                      showInlineCode: false,
                                                      showColorButton: false,
                                                      showBackgroundColorButton:
                                                          false,
                                                      showClearFormat: false,
                                                      showAlignmentButtons:
                                                          true,
                                                      showLeftAlignment: true,
                                                      showCenterAlignment: true,
                                                      showRightAlignment: true,
                                                      showJustifyAlignment:
                                                          true,
                                                      showHeaderStyle: false,
                                                      showListNumbers: true,
                                                      showListBullets: true,
                                                      showListCheck: false,
                                                      showCodeBlock: false,
                                                      showQuote: false,
                                                      showIndent: false,
                                                      showLink: true,
                                                      showUndo: false,
                                                      showRedo: false,
                                                      showDirection: false,
                                                      showSearchButton: false,
                                                      showSubscript: false,
                                                      showSuperscript: false),
                                            ),
                                          )),
                                      // space20H,
                                      Container(
                                        margin: EdgeInsets.all(5.w),
                                        height: 100.h,
                                        child: QuillEditor.basic(
                                          configurations:
                                              const QuillEditorConfigurations(
                                            readOnly: false,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          )),

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
                        text: allowOpenTable,
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
                              setState(() {
                                light = value;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                )),
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
                        backgroundColor: Color.fromRGBO(131, 146, 171, 1),
                        outlineColor: Color.fromRGBO(131, 146, 171, 1),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      ButtonApp(
                        event: () {
                          if (_formField.currentState!.validate()) {
                            widget.eventSaveButton();
                            nameTableController.clear();
                            chairsOfTableController.clear();
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
  QuillController _controllerQuill = QuillController.basic();
  bool isHaveddddd = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerQuill;
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
                  child: TabBarView(controller: _tabController, children: [
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
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
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
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    fillColor: const Color.fromARGB(
                                        255, 226, 104, 159),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
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
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
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
                                          color:
                                              Color.fromRGBO(214, 51, 123, 0.6),
                                          width: 2.0),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    // hintText: storeAddress,
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

// Navigator.of(context).pop();
