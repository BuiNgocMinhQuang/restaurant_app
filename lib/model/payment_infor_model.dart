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
        data!.add(Data.fromJson(v));
      });
    }
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (order != null) {
      data['order'] = order!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_food_id'] = orderFoodId;
    data['food_id'] = foodId;
    data['order_id'] = orderId;
    data['quantity_food'] = quantityFood;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['room_table_id'] = roomTableId;
    data['done_flg'] = doneFlg;
    data['user_id'] = userId;
    data['store_id'] = storeId;
    data['store_room_id'] = storeRoomId;
    data['food_name'] = foodName;
    data['food_description'] = foodDescription;
    data['food_images'] = foodImages;
    data['food_price'] = foodPrice;
    data['food_content'] = foodContent;
    data['food_rate'] = foodRate;
    data['food_kind'] = foodKind;
    data['active_flg'] = activeFlg;
    data['delete_flg'] = deleteFlg;
    data['table_name'] = tableName;
    data['number_of_seats'] = numberOfSeats;
    data['status'] = status;
    data['description'] = description;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['user_id'] = userId;
    data['staff_id'] = staffId;
    data['store_id'] = storeId;
    data['store_room_id'] = storeRoomId;
    data['client_id'] = clientId;
    data['deposit'] = deposit;
    data['amount'] = amount;
    data['payment_amount'] = paymentAmount;
    data['client_name'] = clientName;
    data['client_phone'] = clientPhone;
    data['client_email'] = clientEmail;
    data['start_booked_table_at'] = startBookedTableAt;
    data['end_booked_table_at'] = endBookedTableAt;
    data['note'] = note;
    data['cancellation_reason'] = cancellationReason;
    data['discount'] = discount;
    data['guest_pay'] = guestPay;
    data['pay_kind'] = payKind;
    data['order_kind'] = orderKind;
    data['guest_pay_client'] = guestPayClient;
    data['client_can_pay'] = clientCanPay;
    data['order_total'] = orderTotal;
    data['pay_flg'] = payFlg;
    data['close_order'] = closeOrder;
    data['active_flg'] = activeFlg;
    data['delete_flg'] = deleteFlg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
