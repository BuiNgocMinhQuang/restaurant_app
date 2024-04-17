// // To parse this JSON data, do
// //
// //     final editDetailsStoreModel = editDetailsStoreModelFromJson(jsonString);

// import 'dart:convert';

// EditDetailsStoreModel editDetailsStoreModelFromJson(String str) =>
//     EditDetailsStoreModel.fromJson(json.decode(str));

// String editDetailsStoreModelToJson(EditDetailsStoreModel data) =>
//     json.encode(data.toJson());

// class EditDetailsStoreModel {
//   int status;
//   Data data;

//   EditDetailsStoreModel({
//     required this.status,
//     required this.data,
//   });

//   factory EditDetailsStoreModel.fromJson(Map<String, dynamic> json) =>
//       EditDetailsStoreModel(
//         status: json["status"],
//         data: Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//       };
// }

// class Data {
//   int storeId;
//   int userId;
//   String shopId;
//   String storeName;
//   String? storeAddress;
//   String? storeDescription;
//   List<StoreImage> storeImages;
//   String? storeLogo;
//   int? activeFlg;
//   int? deleteFlg;
//   String? createdAt;
//   String? updatedAt;

//   Data({
//     required this.storeId,
//     required this.userId,
//     required this.shopId,
//     required this.storeName,
//     required this.storeAddress,
//     required this.storeDescription,
//     required this.storeImages,
//     required this.storeLogo,
//     required this.activeFlg,
//     required this.deleteFlg,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         storeId: json["store_id"],
//         userId: json["user_id"],
//         shopId: json["shop_id"],
//         storeName: json["store_name"],
//         storeAddress: json["store_address"],
//         storeDescription: json["store_description"],
//         storeImages: List<StoreImage>.from(
//             json["store_images"].map((x) => StoreImage.fromJson(x))),
//         storeLogo: json["store_logo"],
//         activeFlg: json["active_flg"],
//         deleteFlg: json["delete_flg"],
//         createdAt: json["created_at"],
//         updatedAt: json["updated_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "store_id": storeId,
//         "user_id": userId,
//         "shop_id": shopId,
//         "store_name": storeName,
//         "store_address": storeAddress,
//         "store_description": storeDescription,
//         "store_images": List<dynamic>.from(storeImages.map((x) => x.toJson())),
//         "store_logo": storeLogo,
//         "active_flg": activeFlg,
//         "delete_flg": deleteFlg,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//       };
// }

// class StoreImage {
//   String? name;
//   int? size;
//   String? path;
//   String? normal;

//   StoreImage({
//     required this.name,
//     required this.size,
//     required this.path,
//     required this.normal,
//   });

//   factory StoreImage.fromJson(Map<String, dynamic> json) => StoreImage(
//         name: json["name"],
//         size: json["size"],
//         path: json["path"],
//         normal: json["normal"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "size": size,
//         "path": path,
//         "normal": normal,
//       };
// }

// To parse this JSON data, do
//
//     final editDetailsStoreModel = editDetailsStoreModelFromJson(jsonString);

import 'dart:convert';

EditDetailsStoreModel editDetailsStoreModelFromJson(String str) =>
    EditDetailsStoreModel.fromJson(json.decode(str));

String editDetailsStoreModelToJson(EditDetailsStoreModel data) =>
    json.encode(data.toJson());

class EditDetailsStoreModel {
  int status;
  Data data;

  EditDetailsStoreModel({
    required this.status,
    required this.data,
  });

  factory EditDetailsStoreModel.fromJson(Map<String, dynamic> json) =>
      EditDetailsStoreModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int storeId;
  int userId;
  String? shopId;
  String? storeName;
  String? storeAddress;
  String? storeDescription;
  List<StoreImage> storeImages;
  StoreLogoImage storeLogo;
  int activeFlg;
  int deleteFlg;
  String? createdAt;
  String? updatedAt;

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        storeId: json["store_id"],
        userId: json["user_id"],
        shopId: json["shop_id"],
        storeName: json["store_name"],
        storeAddress: json["store_address"],
        storeDescription: json["store_description"],
        storeImages: List<StoreImage>.from(
            json["store_images"].map((x) => StoreImage.fromJson(x))),
        storeLogo: StoreLogoImage.fromJson(json["store_logo"]),
        activeFlg: json["active_flg"],
        deleteFlg: json["delete_flg"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "user_id": userId,
        "shop_id": shopId,
        "store_name": storeName,
        "store_address": storeAddress,
        "store_description": storeDescription,
        "store_images": List<dynamic>.from(storeImages.map((x) => x.toJson())),
        "store_logo": storeLogo.toJson(),
        "active_flg": activeFlg,
        "delete_flg": deleteFlg,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class StoreLogoImage {
  String name;
  int size;
  String path;
  String normal;

  StoreLogoImage({
    required this.name,
    required this.size,
    required this.path,
    required this.normal,
  });

  factory StoreLogoImage.fromJson(Map<String, dynamic> json) => StoreLogoImage(
        name: json["name"],
        size: json["size"],
        path: json["path"],
        normal: json["normal"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "path": path,
        "normal": normal,
      };
}

class StoreImage {
  String name;
  int size;
  String path;
  String normal;

  StoreImage({
    required this.name,
    required this.size,
    required this.path,
    required this.normal,
  });

  factory StoreImage.fromJson(Map<String, dynamic> json) => StoreImage(
        name: json["name"],
        size: json["size"],
        path: json["path"],
        normal: json["normal"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "size": size,
        "path": path,
        "normal": normal,
      };
}
