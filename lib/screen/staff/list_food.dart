import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// enum ExerciseFilter { walking, running, cycling, hiking }

final List<String> categories = [
  "Combo",
  "Món nướng",
  "Món lẩu",
  "Nước giải khát"
];

class ListFoodStaff extends StatefulWidget {
  const ListFoodStaff({super.key});

  @override
  State<ListFoodStaff> createState() => _ListFoodStaffState();
}

class _ListFoodStaffState extends State<ListFoodStaff> {
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    final filterProducts = listFood.where((product) {
      final foodTitle = product.name.toLowerCase();
      final input = query.toLowerCase();

      return (selectedCategories.isEmpty ||
              selectedCategories.contains(product.category)) &&
          foodTitle.contains(input);
    }).toList();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              Container(
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
              TextFormField(
                onChanged: searchProduct,
                controller: searchController,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 12, color: Colors.grey),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(214, 51, 123, 0.6), width: 2.0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    hintText: "Nhập nội dung bạn muốn tìm kiếm",
                    contentPadding: EdgeInsets.all(15)),
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
                          margin: EdgeInsets.all(8),
                          child: Container(
                              width: 1.sw,
                              height: 100.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.w)),
                              child: Row(
                                children: [
                                  space20W,
                                  Container(
                                      width: 80.w,
                                      height: 80.w,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          product.image,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  space50W,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextApp(text: product.name),
                                      TextApp(
                                        text: product.price,
                                        fontsize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        );
                      })),
            ],
          ),
        )),
      ),
    );
  }
}
