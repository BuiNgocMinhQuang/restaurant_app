import 'dart:developer';

import 'package:app_restaurant/config/colors.dart';
import 'package:app_restaurant/config/date_time_format.dart';
import 'package:app_restaurant/model/manager/chart/chart_data_model.dart';
import 'package:app_restaurant/widgets/text/text_app.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_formatter/money_formatter.dart';

class BarChartSample4 extends StatefulWidget {
  final ChartDataModel chartDataModel;
  BarChartSample4({Key? key, required this.chartDataModel}) : super(key: key);

  final Color dark = Colors.black12;
  final Color normal = Colors.green;
  final Color light = Colors.blue;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;

    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 2:
        text = '2';
        break;
      case 3:
        text = '3';
        break;
      case 4:
        text = '4';
        break;
      case 5:
        text = '5';
        break;
      case 6:
        text = '6';
        break;
      case 7:
        text = '7';
        break;
      case 8:
        text = '8';
        break;
      case 9:
        text = '9';
        break;
      case 10:
        text = '10';
        break;
      case 11:
        text = '11';
        break;
      case 12:
        text = '12';
        break;
      default:
        text = '';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
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

  int touchedGroupIndex = -1;
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
                        enabled: true,
                        handleBuiltInTouches: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => Colors.white,
                          tooltipMargin: 0,
                          getTooltipItem: (
                            BarChartGroupData group,
                            int groupIndex,
                            BarChartRodData rod,
                            int rodIndex,
                          ) {
                            return BarTooltipItem(
                              "${MoneyFormatter(amount: rod.toY.toDouble()).output.withoutFractionDigits.toString()} đ",
                              // rod.toY.toString(),
                              TextStyle(
                                fontWeight: FontWeight.bold,
                                color: rod.color,
                                fontSize: 14.sp,
                                //
                              ),
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event.isInterestedForInteractions &&
                              response != null &&
                              response.spot != null) {
                            log("TOUCHCHHHCHCHC");
                            log(response.spot?.touchedRodData.toY.toString() ??
                                'NOOO');
                            setState(() {
                              touchedGroupIndex =
                                  response.spot!.touchedBarGroupIndex;
                            });
                          } else {
                            log("COKKKK");
                          }
                        },
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
                          color: greyText,
                          strokeWidth: 1,
                        ),
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          left: BorderSide(width: 1, color: Colors.black),
                          bottom: BorderSide(width: 1, color: Colors.black),
                        ),
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
    final _categories = widget.chartDataModel.categories;
    final _series = widget.chartDataModel.series;

    return [
      for (var i = 0; i < _categories.length; i++)
        BarChartGroupData(
          showingTooltipIndicators: touchedGroupIndex ==
                  getMonthFromDateString(
                      dateString: widget.chartDataModel.categories[i])
              ? [0]
              : [],
          x: getMonthFromDateString(
              dateString:
                  widget.chartDataModel.categories[i]), //cho nay dien categori
          barsSpace: barsSpace,
          barRods: [
            for (var j = 0;
                j < _series.map((serie) => serie.data[i]).toList().length;
                j++)
              BarChartRodData(
                  toY: _series
                      .map((serie) => serie.data[i])
                      .toList()[j]
                      .toDouble(),
                  borderRadius: BorderRadius.zero,
                  width: barsWidth,
                  color: j == 0 ? Colors.green : Colors.blue),
          ],
        ),
    ];
  }
}
