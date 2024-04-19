// To parse this JSON data, do
//
//     final chartDataHomeModel = chartDataHomeModelFromJson(jsonString);

import 'dart:convert';

ChartDataHomeModel chartDataHomeModelFromJson(String str) =>
    ChartDataHomeModel.fromJson(json.decode(str));

String chartDataHomeModelToJson(ChartDataHomeModel data) =>
    json.encode(data.toJson());

class ChartDataHomeModel {
  int status;
  List<Series> series;
  List<String> categories;

  ChartDataHomeModel({
    required this.status,
    required this.series,
    required this.categories,
  });

  factory ChartDataHomeModel.fromJson(Map<String, dynamic> json) =>
      ChartDataHomeModel(
        status: json["status"],
        series:
            List<Series>.from(json["series"].map((x) => Series.fromJson(x))),
        categories: List<String>.from(json["categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "series": List<dynamic>.from(series.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x)),
      };
}

class Series {
  String name;
  List<int> data;

  Series({
    required this.name,
    required this.data,
  });

  factory Series.fromJson(Map<String, dynamic> json) => Series(
        name: json["name"],
        data: List<int>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
