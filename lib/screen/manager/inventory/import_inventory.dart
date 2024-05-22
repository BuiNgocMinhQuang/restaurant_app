import 'dart:developer';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ImportInventory extends StatefulWidget {
  const ImportInventory({super.key});

  @override
  State<ImportInventory> createState() => _ImportInventoryState();
}

class _ImportInventoryState extends State<ImportInventory> {
  final List<List<dynamic>> data = [
    ['Tên', 'Tuổi', 'Nghề nghiệp'],
    ['Nguyễn Văn A', 20, 'Sinh viên'],
    ['Trần Thị B', 25, 'Nhân viên văn phòng'],
    ['Lê Văn C', 30, 'Kỹ sư'],
  ];

  final searchController = TextEditingController();

  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    myData.where((nameItem) {
      final itemTitle = nameItem.name.toLowerCase();
      final input = query.toLowerCase();

      return itemTitle.contains(input);
    }).toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                  width: 1.sw,
                  // height: 300,
                  child: Column(
                    children: [
                      space30H,
                      Row(
                        children: [
                          Expanded(
                            child: ButtonGradient(
                                radius: 5.r,
                                color1: color1DarkButton,
                                color2: color2DarkButton,
                                event: () {},
                                text: "Nhập danh sách",
                                textColor: Colors.white),
                          )
                        ],
                      ),
                      space30H,
                      Row(
                        children: [
                          Expanded(
                            child: ButtonGradient(
                              radius: 5.r,
                              color1: color1BlueButton,
                              color2: color2BlueButton,
                              event: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CreateItemDialog(
                                          eventSaveButton: () {});
                                    });
                              },
                              text: "Tạo mặt hàng",
                              textColor: Colors.white,
                            ),
                          ),
                          space40W,
                          Expanded(
                            child: ButtonGradient(
                                radius: 5.r,
                                color1: red,
                                color2: yellow,
                                event: () {},
                                text: "Xóa mặt hàng đã chọn",
                                textColor: Colors.white),
                          )
                        ],
                      ),
                    ],
                  )),
              space25H,
              const Divider(
                height: 1,
                color: Colors.black,
              ),
              space20H,
              Column(
                children: [
                  Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.all(8),
                    child: Container(
                        width: 1.sw,
                        // height: 100.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.w)),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              TextApp(
                                text:
                                    "* Lưu ý: Danh sách mặt hàng sẽ được xuất theo tìm kiếm của bạn",
                                color: Colors.red,
                                fontsize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              space20H,
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SelectableDataTable(
                                        data: myData,
                                        onSelectedRowsChanged: (selectedData) {
                                          // Handle the selected data here (e.g., print, update UI)
                                          log('Selected data: ${selectedData.map((data) => data.name).toList()}');
                                        },
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableDataTable extends StatefulWidget {
  final List<MyData> data;
  final Function(List<MyData>) onSelectedRowsChanged;
  final Function(List<MyData>)? onDeleteSelected;
  const SelectableDataTable({
    Key? key,
    required this.data,
    required this.onSelectedRowsChanged,
    this.onDeleteSelected,
  }) : super(key: key);

  @override
  State<SelectableDataTable> createState() => _SelectableDataTableState();
}

class _SelectableDataTableState extends State<SelectableDataTable> {
  // bool _selectAll = false;
  BuildContext? _context;

  final List<MyData> _filteredData = [];

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50.h,
          width: 300.w,
          child: TextFormField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (cc) {},
            // controller: searchController,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                contentPadding: const EdgeInsets.all(15)),
          ),
        ),
        DataTable(
          columns: dataColumn,
          // rows: widget.data.map((data) => _buildDataRow(data)).toList(),
          rows: _filteredData.isEmpty
              ? widget.data.map(_buildDataRow).toList()
              : _filteredData.map(_buildDataRow).toList(),
        ),
      ],
    );
  }

  DataRow _buildDataRow(MyData data) {
    return DataRow(
      selected: data.isSelected,
      cells: [
        DataCell(Center(
          child: Row(
            children: [
              Text(data.name),
              space10W,
              InkWell(
                onTap: () {
                  showDialog(
                      context: _context!,
                      builder: (BuildContext context) {
                        return CreateItemDialog(eventSaveButton: () {});
                      });
                },
                child: Icon(
                  Icons.edit_note_outlined,
                  size: 25.w,
                ),
              )
            ],
          ),
        )),
        DataCell(Center(
          child: Text(data.unit),
        )),
        DataCell(Center(
          child: Text(data.minQuantity.toString()),
        )),
        DataCell(Center(
          child: Text(data.maxQuantity.toString()),
        )),
        if (data.status == "Còn hàng")
          const DataCell(Center(
            child: StatusBoxStocking(),
          ))
        else
          const DataCell(Center(
            child: StatusBoxOutOfStock(),
          )),
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  width: 30,
                  height: 30,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              space10W,
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  width: 30,
                  height: 30,
                  child:
                      const Icon(Icons.remove, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        )),
      ],
      onSelectChanged: (selected) {},
    );
  }
}
