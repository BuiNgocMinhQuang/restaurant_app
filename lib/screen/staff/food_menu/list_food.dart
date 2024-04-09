import 'dart:convert';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/model/list_food_menu_model.dart';
import 'package:app_restaurant/utils/share_getString.dart';
import 'package:app_restaurant/utils/storage.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:app_restaurant/env/index.dart';
import 'package:app_restaurant/constant/api/index.dart';
import 'package:money_formatter/money_formatter.dart';

class ListFoodStaff extends StatefulWidget {
  const ListFoodStaff({super.key});

  @override
  State<ListFoodStaff> createState() => _ListFoodStaffState();
}

class _ListFoodStaffState extends State<ListFoodStaff> {
  final searchController = TextEditingController();
  final String currentRole = "staff";
  final String currentShopId = getStaffShopID;
  final scrollListFoodController = ScrollController();
  int currentPage = 1;
  List currentFoodList = [];
  List<String> selectedCategories = [];
  List<int> selectedCategoriesIndex = [];
  List<String> listAllCategoriesFood = [];

  String query = '';
  bool hasMore = true;

  void searchProduct(String query) {
    setState(() {
      this.query = query;
      currentPage = 1;
    });
    currentFoodList.clear();
    loadMoreMenuFood(
      page: currentPage,
      keywords: query,
      foodKinds:
          selectedCategoriesIndex.isEmpty ? null : selectedCategoriesIndex,
      filtersFlg: null,
    );
  }

  @override
  void initState() {
    super.initState();
    loadMoreMenuFood(page: 1, filtersFlg: null);
    scrollListFoodController.addListener(() {
      print("SCROLL END");
      if (scrollListFoodController.position.maxScrollExtent ==
          scrollListFoodController.offset) {
        print("LOADD MORE FOOD");
        loadMoreMenuFood(
            page: currentPage,
            keywords: query,
            foodKinds: selectedCategoriesIndex.isEmpty
                ? null
                : selectedCategoriesIndex,
            filtersFlg: null);
      }
    });
  }

  @override
  void dispose() {
    scrollListFoodController.dispose();
    super.dispose();
  }

  void loadMoreMenuFood({
    required int page,
    String? keywords,
    List<int>? foodKinds,
    int? filtersFlg,
  }) async {
    try {
      var token = StorageUtils.instance.getString(key: 'token_staff');
      print("DATA TTTT ${{
        {
          'client': currentRole,
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": filtersFlg
          },
        }
      }}");
      final respons = await http.post(
        Uri.parse('$baseUrl$foodList'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          'client': currentRole,
          'shop_id': getStaffShopID,
          'is_api': true,
          'limit': 15,
          'page': page,
          'filters': {
            "keywords": keywords,
            "food_kinds": foodKinds,
            "pay_flg": filtersFlg
          },
        }),
      );
      final data = jsonDecode(respons.body);
      print("GET DAT FOOD ${data}");
      try {
        if (data['status'] == 200) {
          mounted
              ? setState(() {
                  var listMenuPageRes = ListFoodMenuModel.fromJson(data);
                  // currentFoodList.clear();
                  currentFoodList.addAll(listMenuPageRes.data.data);
                  currentPage++;
                  if (listMenuPageRes.data.data.isEmpty ||
                      listMenuPageRes.data.data.length <= 15) {
                    hasMore = false;
                  }
                  print('LENGHT ${listMenuPageRes.data.data.length}');
                })
              : null;
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
    List<String> foodKindOfShop =
        StorageUtils.instance.getStringList(key: 'food_kinds_list') ?? [];
    listAllCategoriesFood = foodKindOfShop;
    List filterProducts = currentFoodList.where((product) {
      final foodTitle = product.foodName.toLowerCase();
      final input = query.toLowerCase();
      return (selectedCategoriesIndex.isEmpty ||
              selectedCategoriesIndex.contains(product.foodKind)) &&
          foodTitle.contains(input);
    }).toList();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
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
                                      color:
                                          selectedCategories.contains(lableFood)
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
                                        currentPage = 1;
                                        currentFoodList.clear();
                                        loadMoreMenuFood(
                                            page: currentPage,
                                            keywords: query,
                                            foodKinds:
                                                selectedCategoriesIndex.isEmpty
                                                    ? null
                                                    : selectedCategoriesIndex,
                                            filtersFlg: null);
                                      } else {
                                        selectedCategories.remove(
                                            lableFood); //xoá tên category vào mảng
                                        int index = listAllCategoriesFood
                                            .indexOf(lableFood);
                                        selectedCategoriesIndex.remove(
                                            index); //xoá index category vào mảng
                                        currentPage = 1;
                                        currentFoodList.clear();
                                        loadMoreMenuFood(
                                            page: currentPage,
                                            keywords: query,
                                            foodKinds:
                                                selectedCategoriesIndex.isEmpty
                                                    ? null
                                                    : selectedCategoriesIndex,
                                            filtersFlg: null);
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
                TextFormField(
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: searchProduct,
                  controller: searchController,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      contentPadding: EdgeInsets.all(15)),
                ),
                space15H,
                Expanded(
                    child: Container(
                  width: 1.sw,
                  child: ListView.builder(
                      // physics: const ClampingScrollPhysics(),
                      controller: scrollListFoodController,
                      shrinkWrap: true,
                      itemCount: filterProducts.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        var dataLength = filterProducts.length;

                        if (index < dataLength) {
                          // final product = filterProducts[index];
                          var imagePath1 = filterProducts[index]
                              ?.foodImages
                              .replaceAll('["', '');
                          var imagePath2 = imagePath1.replaceAll('"]', '');
                          return Card(
                            elevation: 8.0,
                            margin: EdgeInsets.all(10.w),
                            child: Container(
                                width: 1.sw,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.w)),
                                child: Row(
                                  children: [
                                    space20W,
                                    SizedBox(
                                        width: 100.w,
                                        height: 60.w,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.r),
                                              topRight: Radius.circular(10.r)),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: httpImage + imagePath2,
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

                                          // Image.network(
                                          //   httpImage + imagePath2,
                                          //   fit: BoxFit.contain,
                                          // ),
                                        )),
                                    space50W,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextApp(
                                            text: filterProducts[index]
                                                    .foodName ??
                                                ''),
                                        TextApp(
                                          text:
                                              "${MoneyFormatter(amount: (filterProducts[index].foodPrice ?? 0).toDouble()).output.withoutFractionDigits.toString()} đ",
                                          fontsize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          );
                        } else {
                          return Center(
                            child: hasMore
                                ? CircularProgressIndicator()
                                : Container(),
                          );
                        }
                      }),
                ))
              ],
            ),
          ),
        ));
  }
}
