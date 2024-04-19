import 'dart:io';
import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/fake_data.dart';
import 'package:app_restaurant/config/space.dart';
import 'package:app_restaurant/widgets/button/button_gradient.dart';
import 'package:app_restaurant/widgets/dialog/list_custom_dialog.dart';
import 'package:app_restaurant/widgets/box/status_box.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/filename.xlsx');
}

class ListInventory extends StatefulWidget {
  const ListInventory({super.key});

  @override
  State<ListInventory> createState() => _ListInventoryState();
}

class _ListInventoryState extends State<ListInventory> {
  final List<List<dynamic>> data = [
    ['Tên', 'Tuổi', 'Nghề nghiệp'],
    ['Nguyễn Văn A', 20, 'Sinh viên'],
    ['Trần Thị B', 25, 'Nhân viên văn phòng'],
    ['Lê Văn C', 30, 'Kỹ sư'],
  ];

  bool _isSelected = false; // Tracks selection state
  void _onSelectedRowChanged(int selectedIndex) {
    setState(() {
      _isSelected = selectedIndex != null;
    });
  }

  final searchController = TextEditingController();

  String query = '';
  void searchProduct(String query) {
    setState(() {
      this.query = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterItem = myData.where((nameItem) {
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
              Container(
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
                              text: "Xuất danh sách",
                              textColor: Colors.white,
                            ),
                          ),
                          space40W,
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
              Divider(
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
                              // TextFormField(
                              //   onChanged: searchProduct,
                              //   controller: searchController,
                              //   style:
                              //       TextStyle(fontSize: 12, color: Colors.grey),
                              //   cursorColor: Colors.black,
                              //   decoration: InputDecoration(
                              //       filled: true,
                              //       fillColor: Colors.white,
                              //       focusedBorder: OutlineInputBorder(
                              //         borderSide: const BorderSide(
                              //             color:
                              //                 Color.fromRGBO(214, 51, 123, 0.6),
                              //             width: 2.0),
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //       border: OutlineInputBorder(
                              //         borderRadius: BorderRadius.circular(8),
                              //       ),
                              //       isDense: true,
                              //       hintText: "Nhập nội dung bạn muốn tìm kiếm",
                              //       contentPadding: EdgeInsets.all(15)),
                              // ),
                              space20H,
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      SelectableDataTable(
                                        data: myData,
                                        onSelectedRowsChanged: (selectedData) {
                                          // Handle the selected data here (e.g., print, update UI)
                                          print(
                                              'Selected data: ${selectedData.map((data) => data.name).toList()}');
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
  bool _selectAll = false;
  List<MyData> _selectedData = [];
  BuildContext? _context;
  void _handleRowSelected(MyData data, bool selected) {
    setState(() {
      data.isSelected = selected;
      if (selected) {
        _selectedData.add(data);
      } else {
        _selectedData.remove(data);
      }
      _selectAll = _selectedData.length == widget.data.length;
    });
    widget.onSelectedRowsChanged(_selectedData);
    if (widget.onDeleteSelected != null) {
      widget.onDeleteSelected!(_selectedData.toList());
    }
  }

  void _handleSelectAllChanged(bool? value) {
    // Accept a nullable boolean
    setState(() {
      if (value != null) {
        // Check for null before using
        _selectAll = value;
        for (var data in widget.data) {
          data.isSelected = value;
          if (value) {
            _selectedData.add(data);
          } else {
            _selectedData.remove(data);
          }
        }
      }
    });
    widget.onSelectedRowsChanged(_selectedData);
  }

  void _handleDelete(List<MyData> selectedData) {
    // Implement your deletion logic here (e.g., remove from data source, update UI)
    for (var data in selectedData) {
      // Remove data from the data source (replace with your actual logic)
      widget.data.remove(data);
    }
    setState(() {
      _selectedData.clear(); // Clear selected data after deletion
    });
  }

  String _searchText = '';

  List<MyData> _filteredData = [];

  void _handleSearch(String text) {
    setState(() {
      _searchText = text;
      _filteredData = widget.data
          .where((data) => data.name.toLowerCase().contains(text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50.h,
          width: 300.w,
          child: TextFormField(
            onChanged: _handleSearch,
            // controller: searchController,
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
        ),
        ButtonGradient(
            radius: 5.r,
            color1: red,
            color2: yellow,
            event: () {
              _selectedData.isNotEmpty
                  ? () => _handleDelete(_selectedData)
                  : null;
            },
            text: "Xóa mặt hàng đã chọn",
            textColor: Colors.white),
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
      onSelectChanged: (selected) => _handleRowSelected(data, selected!),
    );
  }
}
