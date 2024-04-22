// To parse this JSON data, do
//
//     final dataRoomDetailsModel = dataRoomDetailsModelFromJson(jsonString);

import 'dart:convert';

DataRoomDetailsModel dataRoomDetailsModelFromJson(String str) =>
    DataRoomDetailsModel.fromJson(json.decode(str));

String dataRoomDetailsModelToJson(DataRoomDetailsModel data) =>
    json.encode(data.toJson());

class DataRoomDetailsModel {
  int status;
  Data data;

  DataRoomDetailsModel({
    required this.status,
    required this.data,
  });

  factory DataRoomDetailsModel.fromJson(Map<String, dynamic> json) =>
      DataRoomDetailsModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int storeRoomId;
  int userId;
  int storeId;
  String? storeRoomName;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;
  String? images;

  Data({
    required this.storeRoomId,
    required this.userId,
    required this.storeId,
    required this.storeRoomName,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeRoomId: json["store_room_id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        storeRoomName: json["store_room_name"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "store_room_id": storeRoomId,
        "user_id": userId,
        "store_id": storeId,
        "store_room_name": storeRoomName,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "images": images,
      };
}
