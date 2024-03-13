class StaffAuthData {
  int? status;
  String? message;
  String? token;
  String? tokenExpiresAt;
  Data? data;

  StaffAuthData(
      {this.status, this.message, this.token, this.tokenExpiresAt, this.data});

  StaffAuthData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    tokenExpiresAt = json['token_expires_at'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    data['token_expires_at'] = tokenExpiresAt;
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
  String? frontImageCccd;
  String? backImageCccd;
  String? holdImageCccd;
  int? staffAddress1;
  int? staffAddress2;
  String? staffAddress3;
  String? staffAddress4;
  String? staffFullAddress;
  String? staffTwitter;
  String? staffFacebook;
  String? staffInstagram;
  int? staffPosition;
  int? staffKind;
  int? activeFlg;
  int? deleteFlg;
  String? rememberToken;
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
    data['staff_id'] = staffId;
    data['staff_no'] = staffNo;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['shop_id'] = shopId;
    data['staff_first_name'] = staffFirstName;
    data['staff_last_name'] = staffLastName;
    data['staff_full_name'] = staffFullName;
    data['staff_avatar'] = staffAvatar;
    data['staff_email'] = staffEmail;
    data['staff_phone'] = staffPhone;
    data['password'] = password;
    data['front_image_cccd'] = frontImageCccd;
    data['back_image_cccd'] = backImageCccd;
    data['hold_image_cccd'] = holdImageCccd;
    data['staff_address_1'] = staffAddress1;
    data['staff_address_2'] = staffAddress2;
    data['staff_address_3'] = staffAddress3;
    data['staff_address_4'] = staffAddress4;
    data['staff_full_address'] = staffFullAddress;
    data['staff_twitter'] = staffTwitter;
    data['staff_facebook'] = staffFacebook;
    data['staff_instagram'] = staffInstagram;
    data['staff_position'] = staffPosition;
    data['staff_kind'] = staffKind;
    data['active_flg'] = activeFlg;
    data['delete_flg'] = deleteFlg;
    data['remember_token'] = rememberToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
