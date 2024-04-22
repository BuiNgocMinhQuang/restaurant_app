// To parse this JSON data, do
//
//     final listTableOfRoomModel = listTableOfRoomModelFromJson(jsonString);

import 'dart:convert';

ListTableOfRoomModel listTableOfRoomModelFromJson(String str) =>
    ListTableOfRoomModel.fromJson(json.decode(str));

String listTableOfRoomModelToJson(ListTableOfRoomModel data) =>
    json.encode(data.toJson());

class ListTableOfRoomModel {
  int status;
  List<Table> tables;

  ListTableOfRoomModel({
    required this.status,
    required this.tables,
  });

  factory ListTableOfRoomModel.fromJson(Map<String, dynamic> json) =>
      ListTableOfRoomModel(
        status: json["status"],
        tables: List<Table>.from(json["tables"].map((x) => Table.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "tables": List<dynamic>.from(tables.map((x) => x.toJson())),
      };
}

class Table {
  int roomTableId;
  int storeRoomId;
  String? tableName;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;
  int numberOfSeats;
  int status;
  String? description;

  Table({
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

  factory Table.fromJson(Map<String, dynamic> json) => Table(
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
