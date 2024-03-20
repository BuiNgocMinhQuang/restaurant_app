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
        currentTables!.add(new CurrentTables.fromJson(v));
      });
    }
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(new Rooms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.currentTables != null) {
      data['current_tables'] =
          this.currentTables!.map((v) => v.toJson()).toList();
    }
    if (this.rooms != null) {
      data['rooms'] = this.rooms!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_table_id'] = this.roomTableId;
    data['store_room_id'] = this.storeRoomId;
    data['table_name'] = this.tableName;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['number_of_seats'] = this.numberOfSeats;
    data['status'] = this.status;
    data['description'] = this.description;
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
        tables!.add(new Tables.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['store_room_id'] = this.storeRoomId;
    data['store_room_name'] = this.storeRoomName;
    if (this.tables != null) {
      data['tables'] = this.tables!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_table_id'] = this.roomTableId;
    data['store_room_id'] = this.storeRoomId;
    data['table_name'] = this.tableName;
    data['active_flg'] = this.activeFlg;
    data['delete_flg'] = this.deleteFlg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['number_of_seats'] = this.numberOfSeats;
    data['status'] = this.status;
    data['description'] = this.description;
    return data;
  }
}
