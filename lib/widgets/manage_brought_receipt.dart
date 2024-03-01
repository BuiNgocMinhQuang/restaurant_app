import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final List<String> categories = [
  "Combo",
  "Món nướng",
  "Món lẩu",
  "Nước giải khát"
];

class ManageBroughtReceipt extends StatefulWidget {
  const ManageBroughtReceipt({super.key});

  @override
  State<ManageBroughtReceipt> createState() => _ManageBroughtReceiptState();
}

class _ManageBroughtReceiptState extends State<ManageBroughtReceipt> {
  final searchController = TextEditingController();

  List<String> selectedCategories = [];
  List<ItemFood> currentFoodList = [];
  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterProducts = listFood.where((product) {
      final foodTitle = product.name.toLowerCase();
      final input = query.toLowerCase();

      return (selectedCategories.isEmpty ||
              selectedCategories.contains(product.category)) &&
          foodTitle.contains(input);
    }).toList();
    return InkWell(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          // appBar: AppBar(),

          body: SafeArea(
              child: Padding(
        padding: EdgeInsets.all(20.w),
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
                                text: "28,000 đ",
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
                        children: categories.map((exercise) {
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
                                  color: selectedCategories.contains(exercise)
                                      ? Colors.white
                                      : Colors.black),
                              showCheckmark: false,
                              label: TextApp(
                                text: exercise.toUpperCase(),
                                fontsize: 14.sp,
                                color: blueText,
                                fontWeight: FontWeight.bold,
                                textAlign: TextAlign.center,
                              ),
                              selected: selectedCategories.contains(exercise),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    selectedCategories.add(exercise);
                                  } else {
                                    selectedCategories.remove(exercise);
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                            text: "1",
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
                    itemCount: filterProducts.length,
                    itemBuilder: (context, index) {
                      final product = filterProducts[index];
                      return Card(
                        elevation: 8.0,
                        margin: const EdgeInsets.all(8),
                        child: Container(
                            width: 1.sw,
                            // height: 100.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.w)),
                            child: Column(
                              children: [
                                space15H,
                                SizedBox(
                                    height: 160.w,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                space10H,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextApp(text: product.name),
                                    TextApp(
                                      text: product.price,
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
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 70.w,
                                                height: 35.w,
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
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )),
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                width: 70.w,
                                                height: 35.w,
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
                                      )),
                                )
                              ],
                            )),
                      );
                    })),
          ],
        ),
      ))),
    );
  }
}
