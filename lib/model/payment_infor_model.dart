class PaymentInforModel {
  int? status;
  List<Data>? data;
  Order? order;

  PaymentInforModel({this.status, this.data, this.order});

  PaymentInforModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Data {
  int? orderFoodId;
  int? foodId;
  int? orderId;
  int? quantityFood;
  String? createdAt;
  String? updatedAt;
  int? roomTableId;
  int? doneFlg;
  int? userId;
  int? storeId;
  int? storeRoomId;
  String? foodName;
  String? foodDescription;
  String? foodImages;
  int? foodPrice;
  String? foodContent;
  int? foodRate;
  int? foodKind;
  int? activeFlg;
  int? deleteFlg;
  String? tableName;
  int? numberOfSeats;
  int? status;
  String? description;

  Data(
      {this.orderFoodId,
      this.foodId,
      this.orderId,
      this.quantityFood,
      this.createdAt,
      this.updatedAt,
      this.roomTableId,
      this.doneFlg,
      this.userId,
      this.storeId,
      this.storeRoomId,
      this.foodName,
      this.foodDescription,
      this.foodImages,
      this.foodPrice,
      this.foodContent,
      this.foodRate,
      this.foodKind,
      this.activeFlg,
      this.deleteFlg,
      this.tableName,
      this.numberOfSeats,
      this.status,
      this.description});

  Data.fromJson(Map<String, dynamic> json) {
    orderFoodId = json['order_food_id'];
    foodId = json['food_id'];
    orderId = json['order_id'];
    quantityFood = json['quantity_food'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    roomTableId = json['room_table_id'];
    doneFlg = json['done_flg'];
    userId = json['user_id'];
    storeId = json['store_id'];
    storeRoomId = json['store_room_id'];
    foodName = json['food_name'];
    foodDescription = json['food_description'];
    foodImages = json['food_images'];
    foodPrice = json['food_price'];
    foodContent = json['food_content'];
    foodRate = json['food_rate'];
    foodKind = json['food_kind'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    tableName = json['table_name'];
    numberOfSeats = json['number_of_seats'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_food_id'] = this.orderFoodId;
    data['food_id'] = this.foodId;
    data['order_id'] = this.orderId;
    data['quantity_food'] = this.quantityFood;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['room_table_id'] = this.roomTableId;
    data['done_flg'] = this.doneFlg;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['store_room_id'] = this.storeRoomId;
    data['food_name'] = this.foodName;
    data['food_description'] = this.foodDescription;
    data['food_images'] = this.foodImages;
    data['food_price'] = this.foodPrice;
    data['food_content'] = this.foodContent;
    data['food_rate'] = this.foodRate;
    data['food_kind'] = this.foodKind;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['table_name'] = this.tableName;
    data['number_of_seats'] = this.numberOfSeats;
    data['status'] = this.status;
    data['description'] = this.description;
    return data;
  }
}

class Order {
  int? orderId;
  int? userId;
  int? staffId;
  int? storeId;
  int? storeRoomId;
  int? clientId;
  int? deposit;
  int? amount;
  int? paymentAmount;
  String? clientName;
  String? clientPhone;
  String? clientEmail;
  String? startBookedTableAt;
  String? endBookedTableAt;
  String? note;
  String? cancellationReason;
  int? discount;
  int? guestPay;
  int? payKind;
  int? orderKind;
  int? guestPayClient;
  int? clientCanPay;
  int? orderTotal;
  int? payFlg;
  int? closeOrder;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.orderId,
      this.userId,
      this.staffId,
      this.storeId,
      this.storeRoomId,
      this.clientId,
      this.deposit,
      this.amount,
      this.paymentAmount,
      this.clientName,
      this.clientPhone,
      this.clientEmail,
      this.startBookedTableAt,
      this.endBookedTableAt,
      this.note,
      this.cancellationReason,
      this.discount,
      this.guestPay,
      this.payKind,
      this.orderKind,
      this.guestPayClient,
      this.clientCanPay,
      this.orderTotal,
      this.payFlg,
      this.closeOrder,
      this.activeFlg,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    userId = json['user_id'];
    staffId = json['staff_id'];
    storeId = json['store_id'];
    storeRoomId = json['store_room_id'];
    clientId = json['client_id'];
    deposit = json['deposit'];
    amount = json['amount'];
    paymentAmount = json['payment_amount'];
    clientName = json['client_name'];
    clientPhone = json['client_phone'];
    clientEmail = json['client_email'];
    startBookedTableAt = json['start_booked_table_at'];
    endBookedTableAt = json['end_booked_table_at'];
    note = json['note'];
    cancellationReason = json['cancellation_reason'];
    discount = json['discount'];
    guestPay = json['guest_pay'];
    payKind = json['pay_kind'];
    orderKind = json['order_kind'];
    guestPayClient = json['guest_pay_client'];
    clientCanPay = json['client_can_pay'];
    orderTotal = json['order_total'];
    payFlg = json['pay_flg'];
    closeOrder = json['close_order'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['staff_id'] = this.staffId;
    data['store_id'] = this.storeId;
    data['store_room_id'] = this.storeRoomId;
    data['client_id'] = this.clientId;
    data['deposit'] = this.deposit;
    data['amount'] = this.amount;
    data['payment_amount'] = this.paymentAmount;
    data['client_name'] = this.clientName;
    data['client_phone'] = this.clientPhone;
    data['client_email'] = this.clientEmail;
    data['start_booked_table_at'] = this.startBookedTableAt;
    data['end_booked_table_at'] = this.endBookedTableAt;
    data['note'] = this.note;
    data['cancellation_reason'] = this.cancellationReason;
    data['discount'] = this.discount;
    data['guest_pay'] = this.guestPay;
    data['pay_kind'] = this.payKind;
    data['order_kind'] = this.orderKind;
    data['guest_pay_client'] = this.guestPayClient;
    data['client_can_pay'] = this.clientCanPay;
    data['order_total'] = this.orderTotal;
    data['pay_flg'] = this.payFlg;
    data['close_order'] = this.closeOrder;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
