class AuthDataModel {
  String? token;
  Data? data;

  AuthDataModel({this.token, this.data});

  AuthDataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
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
  Null? frontImageCccd;
  Null? backImageCccd;
  Null? holdImageCccd;
  Null? staffAddress1;
  Null? staffAddress2;
  Null? staffAddress3;
  Null? staffAddress4;
  Null? staffFullAddress;
  Null? staffTwitter;
  Null? staffFacebook;
  Null? staffInstagram;
  int? staffPosition;
  int? staffKind;
  int? activeFlg;
  int? deleteFlg;
  Null? rememberToken;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.staffId,
      this.staffNo,
      this.userId,
      this.storeId,
      this.shopId,
      this.staffFirstName,
      this.staffLastName,
      this.staffFullName,
      this.staffAvatar,
      this.staffEmail,
      this.staffPhone,
      this.password,
      this.frontImageCccd,
      this.backImageCccd,
      this.holdImageCccd,
      this.staffAddress1,
      this.staffAddress2,
      this.staffAddress3,
      this.staffAddress4,
      this.staffFullAddress,
      this.staffTwitter,
      this.staffFacebook,
      this.staffInstagram,
      this.staffPosition,
      this.staffKind,
      this.activeFlg,
      this.deleteFlg,
      this.rememberToken,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    staffId = json['staff_id'];
    staffNo = json['staff_no'];
    userId = json['user_id'];
    storeId = json['store_id'];
    shopId = json['shop_id'];
    staffFirstName = json['staff_first_name'];
    staffLastName = json['staff_last_name'];
    staffFullName = json['staff_full_name'];
    staffAvatar = json['staff_avatar'];
    staffEmail = json['staff_email'];
    staffPhone = json['staff_phone'];
    password = json['password'];
    frontImageCccd = json['front_image_cccd'];
    backImageCccd = json['back_image_cccd'];
    holdImageCccd = json['hold_image_cccd'];
    staffAddress1 = json['staff_address_1'];
    staffAddress2 = json['staff_address_2'];
    staffAddress3 = json['staff_address_3'];
    staffAddress4 = json['staff_address_4'];
    staffFullAddress = json['staff_full_address'];
    staffTwitter = json['staff_twitter'];
    staffFacebook = json['staff_facebook'];
    staffInstagram = json['staff_instagram'];
    staffPosition = json['staff_position'];
    staffKind = json['staff_kind'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff_id'] = this.staffId;
    data['staff_no'] = this.staffNo;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['shop_id'] = this.shopId;
    data['staff_first_name'] = this.staffFirstName;
    data['staff_last_name'] = this.staffLastName;
    data['staff_full_name'] = this.staffFullName;
    data['staff_avatar'] = this.staffAvatar;
    data['staff_email'] = this.staffEmail;
    data['staff_phone'] = this.staffPhone;
    data['password'] = this.password;
    data['front_image_cccd'] = this.frontImageCccd;
    data['back_image_cccd'] = this.backImageCccd;
    data['hold_image_cccd'] = this.holdImageCccd;
    data['staff_address_1'] = this.staffAddress1;
    data['staff_address_2'] = this.staffAddress2;
    data['staff_address_3'] = this.staffAddress3;
    data['staff_address_4'] = this.staffAddress4;
    data['staff_full_address'] = this.staffFullAddress;
    data['staff_twitter'] = this.staffTwitter;
    data['staff_facebook'] = this.staffFacebook;
    data['staff_instagram'] = this.staffInstagram;
    data['staff_position'] = this.staffPosition;
    data['staff_kind'] = this.staffKind;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['remember_token'] = this.rememberToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
