class SwitchTableDataModel {
  int? status;
  List<CurrentTables>? currentTables;
  List<Rooms>? rooms;

  SwitchTableDataModel({this.status, this.currentTables, this.rooms});

  SwitchTableDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['current_tables'] != null) {
      currentTables = <CurrentTables>[];
      json['current_tables'].forEach((v) {
        currentTables!.add(CurrentTables.fromJson(v));
      });
    }
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    if (currentTables != null) {
      data['current_tables'] = currentTables!.map((v) => v.toJson()).toList();
    }
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentTables {
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

  CurrentTables(
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

  CurrentTables.fromJson(Map<String, dynamic> json) {
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

class Rooms {
  int? storeRoomId;
  String? storeRoomName;
  List<Tables>? tables;

  Rooms({this.storeRoomId, this.storeRoomName, this.tables});

  Rooms.fromJson(Map<String, dynamic> json) {
    storeRoomId = json['store_room_id'];
    storeRoomName = json['store_room_name'];
    if (json['tables'] != null) {
      tables = <Tables>[];
      json['tables'].forEach((v) {
        tables!.add(Tables.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_room_id'] = storeRoomId;
    data['store_room_name'] = storeRoomName;
    if (tables != null) {
      data['tables'] = tables!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tables {
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

  Tables(
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

  Tables.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
