class ManagerInforModel {
  int? status;
  String? message;
  String? token;
  String? tokenExpiresAt;
  Data? data;

  ManagerInforModel(
      {this.status, this.message, this.token, this.tokenExpiresAt, this.data});

  ManagerInforModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    tokenExpiresAt = json['token_expires_at'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['token_expires_at'] = this.tokenExpiresAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? userNo;
  String? userFirstName;
  String? userLastName;
  String? userFullName;
  String? userAvatar;
  String? userEmail;
  String? userPhone;
  Null? frontImageCccd;
  Null? backImageCccd;
  Null? holdImageCccd;
  int? userAddress1;
  int? userAddress2;
  int? userAddress3;
  String? userAddress4;
  String? userFullAddress;
  int? userKind;
  int? managerFlg;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.userId,
      this.userNo,
      this.userFirstName,
      this.userLastName,
      this.userFullName,
      this.userAvatar,
      this.userEmail,
      this.userPhone,
      this.frontImageCccd,
      this.backImageCccd,
      this.holdImageCccd,
      this.userAddress1,
      this.userAddress2,
      this.userAddress3,
      this.userAddress4,
      this.userFullAddress,
      this.userKind,
      this.managerFlg,
      this.activeFlg,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userNo = json['user_no'];
    userFirstName = json['user_first_name'];
    userLastName = json['user_last_name'];
    userFullName = json['user_full_name'];
    userAvatar = json['user_avatar'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
    frontImageCccd = json['front_image_cccd'];
    backImageCccd = json['back_image_cccd'];
    holdImageCccd = json['hold_image_cccd'];
    userAddress1 = json['user_address_1'];
    userAddress2 = json['user_address_2'];
    userAddress3 = json['user_address_3'];
    userAddress4 = json['user_address_4'];
    userFullAddress = json['user_full_address'];
    userKind = json['user_kind'];
    managerFlg = json['manager_flg'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_no'] = this.userNo;
    data['user_first_name'] = this.userFirstName;
    data['user_last_name'] = this.userLastName;
    data['user_full_name'] = this.userFullName;
    data['user_avatar'] = this.userAvatar;
    data['user_email'] = this.userEmail;
    data['user_phone'] = this.userPhone;
    data['front_image_cccd'] = this.frontImageCccd;
    data['back_image_cccd'] = this.backImageCccd;
    data['hold_image_cccd'] = this.holdImageCccd;
    data['user_address_1'] = this.userAddress1;
    data['user_address_2'] = this.userAddress2;
    data['user_address_3'] = this.userAddress3;
    data['user_address_4'] = this.userAddress4;
    data['user_full_address'] = this.userFullAddress;
    data['user_kind'] = this.userKind;
    data['manager_flg'] = this.managerFlg;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
