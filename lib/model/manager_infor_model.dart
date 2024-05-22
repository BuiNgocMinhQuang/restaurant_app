class ManagerInforModel {
  int? status;
  String? message;
  String? token;
  String? tokenExpiresAt;
  DataManagerInfor? data;

  ManagerInforModel(
      {this.status, this.message, this.token, this.tokenExpiresAt, this.data});

  ManagerInforModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    tokenExpiresAt = json['token_expires_at'];
    data =
        json['data'] != null ? DataManagerInfor.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class DataManagerInfor {
  int? userId;
  int? userNo;
  String? userFirstName;
  String? userLastName;
  String? userFullName;
  String? userAvatar;
  String? userEmail;
  String? userPhone;
  String? frontImageCccd;
  String? backImageCccd;
  String? holdImageCccd;
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

  DataManagerInfor(
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

  DataManagerInfor.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_no'] = userNo;
    data['user_first_name'] = userFirstName;
    data['user_last_name'] = userLastName;
    data['user_full_name'] = userFullName;
    data['user_avatar'] = userAvatar;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    data['front_image_cccd'] = frontImageCccd;
    data['back_image_cccd'] = backImageCccd;
    data['hold_image_cccd'] = holdImageCccd;
    data['user_address_1'] = userAddress1;
    data['user_address_2'] = userAddress2;
    data['user_address_3'] = userAddress3;
    data['user_address_4'] = userAddress4;
    data['user_full_address'] = userFullAddress;
    data['user_kind'] = userKind;
    data['manager_flg'] = managerFlg;
    data['active_flg'] = activeFlg;
    data['delete_flg'] = deleteFlg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
