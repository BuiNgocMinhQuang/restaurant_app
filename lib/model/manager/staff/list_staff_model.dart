import 'dart:convert';

ListStaffDataModel listStaffDataModelFromJson(String str) =>
    ListStaffDataModel.fromJson(json.decode(str));

String listStaffDataModelToJson(ListStaffDataModel data) =>
    json.encode(data.toJson());

class ListStaffDataModel {
  int status;
  Staffs staffs;

  ListStaffDataModel({
    required this.status,
    required this.staffs,
  });

  factory ListStaffDataModel.fromJson(Map<String, dynamic> json) =>
      ListStaffDataModel(
        status: json["status"],
        staffs: Staffs.fromJson(json["staffs"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "staffs": staffs.toJson(),
      };
}

class Staffs {
  int currentPage;
  List<DataListStaff> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  Staffs({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
        currentPage: json["current_page"],
        data: List<DataListStaff>.from(
            json["data"].map((x) => DataListStaff.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class DataListStaff {
  int staffId;
  int staffNo;
  int userId;
  int storeId;
  String shopId;
  String? staffFirstName;
  String? staffLastName;
  String? staffFullName;
  String? staffAvatar;
  String staffEmail;
  String staffPhone;
  String password;
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
  String storeName;

  DataListStaff({
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
    required this.storeName,
  });

  factory DataListStaff.fromJson(Map<String, dynamic> json) => DataListStaff(
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
        storeName: json["store_name"],
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
        "store_name": storeName,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
