import 'dart:developer';

import 'package:app_restaurant/model/manager/chart/chart_data_model.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BarChartSample4 extends StatefulWidget {
  final ChartDataModel chartDataModel;
  BarChartSample4({Key? key, required this.chartDataModel}) : super(key: key);

  // final Color dark = AppColors.contentColorCyan.darken(60);
  // final Color normal = AppColors.contentColorCyan.darken(30);
  // final Color light = AppColors.contentColorCyan;

  final Color dark = Colors.black12;
  final Color normal = Colors.green;
  final Color light = Colors.blue;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    // String text;
    return Container(
      color: Colors.amber,
      width: 50,
      height: 100,
      child: ListView.builder(
          itemCount: widget.chartDataModel.categories.length,
          itemBuilder: (context, index) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child:
                  Text(widget.chartDataModel.categories[index], style: style),
            );
          }),
    );

    // switch (value.toInt()) {
    //   case 0:
    //     text = widget.chartDataModel.categories[0];
    //     break;
    //   case 1:
    //     text = 'May';
    //     break;
    //   // case 2:
    //   //   text = 'Jun';
    //   //   break;
    //   // case 3:
    //   //   text = 'Jul';
    //   //   break;
    //   // case 4:
    //   //   text = 'Aug';
    //   //   break;
    //   default:
    //     text = '';
    //     break;
    // }
    // return SideTitleWidget(
    //   axisSide: meta.axisSide,
    //   child: Text(text, style: style),
    // );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    // if (value == meta.max) {
    //   return SideTitleWidget(
    //     axisSide: meta.axisSide,
    //     child: Text(
    //       meta.formattedValue,
    //       style: TextStyle(
    //         fontSize: 10,
    //       ),
    //     ),
    //   );
    // }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 4.0 * constraints.maxWidth / 200;
            // final barsWidth = 8.0 * constraints.maxWidth / 400;
            final barsWidth = 8.0 * constraints.maxWidth / 100;
            log(barsSpace.toString());
            log(barsWidth.toString());
            return widget.chartDataModel.series.isEmpty
                ? Container(
                    width: 1.sw,
                    height: 50,
                    color: Colors.blue,
                    child: Center(
                      child: TextApp(
                        text: "Chưa có doanh thu, không thể thống kê",
                        color: Colors.white,
                        fontsize: 14.sp,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        enabled: false,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: bottomTitles,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 10 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.amber,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      groupsSpace: 4,
                      barGroups: getData(
                        barsWidth,
                        barsSpace,
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    return [
      //list cac thang cuar bieu do

      BarChartGroupData(
        x: 0, //cho nay dien categori
        barsSpace: barsSpace,
        barRods: [
          //list series
          BarChartRodData(
            toY: widget.chartDataModel.series[0].data[0].toDouble(),
            // rodStackItems: [
            //   BarChartRodStackItem(0, 2000000000, widget.dark),
            //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
            //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
            // ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: widget.chartDataModel.series[1].data[0].toDouble(),
            color: Colors.green,
            // rodStackItems: [
            //   BarChartRodStackItem(0, 2000000000, widget.dark),
            //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
            //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
            // ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1, //cho nay dien categori
        barsSpace: barsSpace,
        barRods: [
          //list series
          BarChartRodData(
            toY: widget.chartDataModel.series[0].data[1].toDouble(),
            // rodStackItems: [
            //   BarChartRodStackItem(0, 2000000000, widget.dark),
            //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
            //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
            // ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
          BarChartRodData(
            toY: widget.chartDataModel.series[1].data[1].toDouble(),
            color: Colors.green,
            // rodStackItems: [
            //   BarChartRodStackItem(0, 2000000000, widget.dark),
            //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
            //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
            // ],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      ),
    ];
  }
  // List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
  //   return [
  //     //list cac thang cuar bieu do

  //     BarChartGroupData(
  //       x: 1, //cho nay dien categori
  //       barsSpace: barsSpace,
  //       barRods: [
  //         //list series
  //         BarChartRodData(
  //           toY: widget.chartDataModel.series[0].data[0].toDouble(),
  //           // rodStackItems: [
  //           //   BarChartRodStackItem(0, 2000000000, widget.dark),
  //           //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
  //           //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
  //           // ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //         BarChartRodData(
  //           toY: widget.chartDataModel.series[1].data[0].toDouble(),
  //           color: Colors.green,
  //           // rodStackItems: [
  //           //   BarChartRodStackItem(0, 2000000000, widget.dark),
  //           //   BarChartRodStackItem(2000000000, 12000000000, widget.normal),
  //           //   BarChartRodStackItem(12000000000, 17000000000, widget.light),
  //           // ],
  //           borderRadius: BorderRadius.zero,
  //           width: barsWidth,
  //         ),
  //       ],
  //     ),

  //   ];
  // }
}
