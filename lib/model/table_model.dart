class TableModel {
  int? status;
  List<String>? foodKinds;
  Booking? booking;
  List<TablesNoBooking>? tablesNoBooking;

  TableModel({this.status, this.foodKinds, this.booking, this.tablesNoBooking});

  TableModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    foodKinds = json['food_kinds'].cast<String>();
    booking =
        json['booking'] != null ? Booking.fromJson(json['booking']) : null;
    if (json['tables_no_booking'] != null) {
      tablesNoBooking = <TablesNoBooking>[];
      json['tables_no_booking'].forEach((v) {
        tablesNoBooking!.add(TablesNoBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['food_kinds'] = foodKinds;
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    if (tablesNoBooking != null) {
      data['tables_no_booking'] =
          tablesNoBooking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? bookedTableId;
  int? orderId;
  int? roomTableId;
  int? activeFlg;
  String? createdAt;
  String? updatedAt;
  Order? order;

  Booking(
      {this.bookedTableId,
      this.orderId,
      this.roomTableId,
      this.activeFlg,
      this.createdAt,
      this.updatedAt,
      this.order});

  Booking.fromJson(Map<String, dynamic> json) {
    bookedTableId = json['booked_table_id'];
    orderId = json['order_id'];
    roomTableId = json['room_table_id'];
    activeFlg = json['active_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booked_table_id'] = bookedTableId;
    data['order_id'] = orderId;
    data['room_table_id'] = roomTableId;
    data['active_flg'] = activeFlg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (order != null) {
      data['order'] = order!.toJson();
    }
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
  String? deposit;
  String? amount;
  String? paymentAmount;
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

class TablesNoBooking {
  int? roomTableId;
  int? storeRoomId;
  String? tableName;
  int? activeFlg;
  int? deleteFlg;
  String? createdAt;
  String? updatedAt;
  int? numberOfSeats;
  int? status;
  String? description;

  TablesNoBooking(
      {this.roomTableId,
      this.storeRoomId,
      this.tableName,
      this.activeFlg,
      this.deleteFlg,
      this.createdAt,
      this.updatedAt,
      this.numberOfSeats,
      this.status,
      this.description});

  TablesNoBooking.fromJson(Map<String, dynamic> json) {
    roomTableId = json['room_table_id'];
    storeRoomId = json['store_room_id'];
    tableName = json['table_name'];
    activeFlg = json['active_flg'];
    deleteFlg = json['delete_flg'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    numberOfSeats = json['number_of_seats'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['room_table_id'] = roomTableId;
    data['store_room_id'] = storeRoomId;
    data['table_name'] = tableName;
    data['active_flg'] = activeFlg;
    data['delete_flg'] = deleteFlg;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['number_of_seats'] = numberOfSeats;
    data['status'] = status;
    data['description'] = description;
    return data;
  }
}
