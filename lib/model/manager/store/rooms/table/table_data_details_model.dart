// To parse this JSON data, do
//
//     final tableDataDetailsModel = tableDataDetailsModelFromJson(jsonString);

import 'dart:convert';

TableDataDetailsModel tableDataDetailsModelFromJson(String str) =>
    TableDataDetailsModel.fromJson(json.decode(str));

String tableDataDetailsModelToJson(TableDataDetailsModel data) =>
    json.encode(data.toJson());

class TableDataDetailsModel {
  int status;
  Data data;

  TableDataDetailsModel({
    required this.status,
    required this.data,
  });

  factory TableDataDetailsModel.fromJson(Map<String, dynamic> json) =>
      TableDataDetailsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int roomTableId;
  int storeRoomId;
  String tableName;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  int numberOfSeats;
  int? status;
  String? description;

  Data({
    required this.roomTableId,
    required this.storeRoomId,
    required this.tableName,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.numberOfSeats,
    required this.status,
    required this.description,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        roomTableId: json["room_table_id"],
        storeRoomId: json["store_room_id"],
        tableName: json["table_name"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        numberOfSeats: json["number_of_seats"],
        status: json["status"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "room_table_id": roomTableId,
        "store_room_id": storeRoomId,
        "table_name": tableName,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "number_of_seats": numberOfSeats,
        "status": status,
        "description": description,
      };
}
