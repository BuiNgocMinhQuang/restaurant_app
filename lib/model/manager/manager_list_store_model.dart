// To parse this JSON data, do
//
//     final listStoreModel = listStoreModelFromJson(jsonString);

import 'dart:convert';

ListStoreModel listStoreModelFromJson(String str) =>
    ListStoreModel.fromJson(json.decode(str));

String listStoreModelToJson(ListStoreModel data) => json.encode(data.toJson());

class ListStoreModel {
  int status;
  String message;
  List<DataListStore> data;

  ListStoreModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ListStoreModel.fromJson(Map<String, dynamic> json) => ListStoreModel(
        status: json["status"],
        message: json["message"],
        data: List<DataListStore>.from(
            json["data"].map((x) => DataListStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataListStore {
  int? storeId;
  int? userId;
  String shopId;
  String? storeName;
  String? storeAddress;
  String? storeDescription;
  String? storeImages;
  String? storeLogo;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  List<Staff> staffs;

  DataListStore({
    required this.storeId,
    required this.userId,
    required this.shopId,
    required this.storeName,
    required this.storeAddress,
    required this.storeDescription,
    required this.storeImages,
    required this.storeLogo,
    required this.activeFlg,
    required this.deleteFlg,
    required this.createdAt,
    required this.updatedAt,
    required this.staffs,
  });

  factory DataListStore.fromJson(Map<String, dynamic> json) => DataListStore(
        storeId: json["store_id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        storeName: json["store_name"],
        storeAddress: json["store_address"],
        storeDescription: json["store_description"],
        storeImages: json["store_images"],
        storeLogo: json["store_logo"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        staffs: List<Staff>.from(json["staffs"].map((x) => Staff.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "shop_id": shopId,
        "store_name": storeName,
        "store_address": storeAddress,
        "store_description": storeDescription,
        "store_images": storeImages,
        "store_logo": storeLogo,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "staffs": List<dynamic>.from(staffs.map((x) => x.toJson())),
      };
}

class Staff {
  int? staffId;
  int? staffNo;
  int? userId;
  int? storeId;
  String? shopId;
  String? staffFirstName;
  String? staffLastName;
  String? staffFullName;
  String? staffAvatar;
  String? staffEmail;
  String? staffPhone;
  String? password;
  String? frontImageCccd;
  String? backImageCccd;
  String? holdImageCccd;
  int? staffAddress1;
  int? staffAddress2;
  int? staffAddress3;
  String? staffAddress4;
  String? staffFullAddress;
  String? staffTwitter;
  String? staffFacebook;
  String? staffInstagram;
  int staffPosition;
  int staffKind;
  int activeFlg;
  int deleteFlg;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;

  Staff({
    required this.staffId,
    required this.staffNo,
    required this.userId,
    required this.storeId,
    required this.shopId,
    required this.staffFirstName,
    required this.staffLastName,
    required this.staffFullName,
    required this.staffAvatar,
    required this.staffEmail,
    required this.staffPhone,
    required this.password,
    required this.frontImageCccd,
    required this.backImageCccd,
    required this.holdImageCccd,
    required this.staffAddress1,
    required this.staffAddress2,
    required this.staffAddress3,
    required this.staffAddress4,
    required this.staffFullAddress,
    required this.staffTwitter,
    required this.staffFacebook,
    required this.staffInstagram,
    required this.staffPosition,
    required this.staffKind,
    required this.activeFlg,
    required this.deleteFlg,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
        staffId: json["staff_id"],
        staffNo: json["staff_no"],
        userId: json["user_id"],
        storeId: json["store_id"],
        shopId: json["shop_id"],
        staffFirstName: json["staff_first_name"],
        staffLastName: json["staff_last_name"],
        staffFullName: json["staff_full_name"],
        staffAvatar: json["staff_avatar"],
        staffEmail: json["staff_email"],
        staffPhone: json["staff_phone"],
        password: json["password"],
        frontImageCccd: json["front_image_cccd"],
        backImageCccd: json["back_image_cccd"],
        holdImageCccd: json["hold_image_cccd"],
        staffAddress1: json["staff_address_1"],
        staffAddress2: json["staff_address_2"],
        staffAddress3: json["staff_address_3"],
        staffAddress4: json["staff_address_4"],
        staffFullAddress: json["staff_full_address"],
        staffTwitter: json["staff_twitter"],
        staffFacebook: json["staff_facebook"],
        staffInstagram: json["staff_instagram"],
        staffPosition: json["staff_position"],
        staffKind: json["staff_kind"],
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "staff_id": staffId,
        "staff_no": staffNo,
        "user_id": userId,
        "store_id": storeId,
        "shop_id": shopId,
        "staff_first_name": staffFirstName,
        "staff_last_name": staffLastName,
        "staff_full_name": staffFullName,
        "staff_avatar": staffAvatar,
        "staff_email": staffEmail,
        "staff_phone": staffPhone,
        "password": password,
        "front_image_cccd": frontImageCccd,
        "back_image_cccd": backImageCccd,
        "hold_image_cccd": holdImageCccd,
        "staff_address_1": staffAddress1,
        "staff_address_2": staffAddress2,
        "staff_address_3": staffAddress3,
        "staff_address_4": staffAddress4,
        "staff_full_address": staffFullAddress,
        "staff_twitter": staffTwitter,
        "staff_facebook": staffFacebook,
        "staff_instagram": staffInstagram,
        "staff_position": staffPosition,
        "staff_kind": staffKind,
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
