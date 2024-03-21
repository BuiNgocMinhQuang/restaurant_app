// class ListFoodModel {
//   int? status;
//   Data? data;
//   int? countOrderFoods;
//   String? orderTotal;

//   ListFoodModel(
//       {this.status, this.data, this.countOrderFoods, this.orderTotal});

//   ListFoodModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//     countOrderFoods = json['count_order_foods'];
//     orderTotal = json['order_total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['count_order_foods'] = this.countOrderFoods;
//     data['order_total'] = this.orderTotal;
//     return data;
//   }
// }

// class Data {
//   int? currentPage;
//   List<Data>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   String? nextPageUrl;
//   String? path;
//   int? perPage;
//   Null? prevPageUrl;
//   int? to;
//   int? total;

//   Data(
//       {this.currentPage,
//       this.data,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.links,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total});

//   Data.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     firstPageUrl = json['first_page_url'];
//     from = json['from'];
//     lastPage = json['last_page'];
//     lastPageUrl = json['last_page_url'];
//     if (json['links'] != null) {
//       links = <Links>[];
//       json['links'].forEach((v) {
//         links!.add(new Links.fromJson(v));
//       });
//     }
//     nextPageUrl = json['next_page_url'];
//     path = json['path'];
//     perPage = json['per_page'];
//     prevPageUrl = json['prev_page_url'];
//     to = json['to'];
//     total = json['total'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = this.currentPage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['first_page_url'] = this.firstPageUrl;
//     data['from'] = this.from;
//     data['last_page'] = this.lastPage;
//     data['last_page_url'] = this.lastPageUrl;
//     if (this.links != null) {
//       data['links'] = this.links!.map((v) => v.toJson()).toList();
//     }
//     data['next_page_url'] = this.nextPageUrl;
//     data['path'] = this.path;
//     data['per_page'] = this.perPage;
//     data['prev_page_url'] = this.prevPageUrl;
//     data['to'] = this.to;
//     data['total'] = this.total;
//     return data;
//   }
// }

// class Data {
//   int? foodId;
//   int? userId;
//   int? storeId;
//   Null? storeRoomId;
//   String? foodName;
//   String? foodDescription;
//   String? foodImages;
//   int? foodPrice;
//   String? foodContent;
//   int? foodRate;
//   int? foodKind;
//   int? activeFlg;
//   int? deleteFlg;
//   String? createdAt;
//   String? updatedAt;
//   int? quantityFood;
//   int? orderFoodId;
//   int? orderId;

//   Data(
//       {this.foodId,
//       this.userId,
//       this.storeId,
//       this.storeRoomId,
//       this.foodName,
//       this.foodDescription,
//       this.foodImages,
//       this.foodPrice,
//       this.foodContent,
//       this.foodRate,
//       this.foodKind,
//       this.activeFlg,
//       this.deleteFlg,
//       this.createdAt,
//       this.updatedAt,
//       this.quantityFood,
//       this.orderFoodId,
//       this.orderId});

//   Data.fromJson(Map<String, dynamic> json) {
//     foodId = json['food_id'];
//     userId = json['user_id'];
//     storeId = json['store_id'];
//     storeRoomId = json['store_room_id'];
//     foodName = json['food_name'];
//     foodDescription = json['food_description'];
//     foodImages = json['food_images'];
//     foodPrice = json['food_price'];
//     foodContent = json['food_content'];
//     foodRate = json['food_rate'];
//     foodKind = json['food_kind'];
//     activeFlg = json['active_flg'];
//     deleteFlg = json['delete_flg'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     quantityFood = json['quantity_food'];
//     orderFoodId = json['order_food_id'];
//     orderId = json['order_id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['food_id'] = this.foodId;
//     data['user_id'] = this.userId;
//     data['store_id'] = this.storeId;
//     data['store_room_id'] = this.storeRoomId;
//     data['food_name'] = this.foodName;
//     data['food_description'] = this.foodDescription;
//     data['food_images'] = this.foodImages;
//     data['food_price'] = this.foodPrice;
//     data['food_content'] = this.foodContent;
//     data['food_rate'] = this.foodRate;
//     data['food_kind'] = this.foodKind;
//     data['active_flg'] = this.activeFlg;
//     data['delete_flg'] = this.deleteFlg;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['quantity_food'] = this.quantityFood;
//     data['order_food_id'] = this.orderFoodId;
//     data['order_id'] = this.orderId;
//     return data;
//   }
// }

// class Links {
//   String? url;
//   String? label;
//   bool? active;

//   Links({this.url, this.label, this.active});

//   Links.fromJson(Map<String, dynamic> json) {
//     url = json['url'];
//     label = json['label'];
//     active = json['active'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['url'] = this.url;
//     data['label'] = this.label;
//     data['active'] = this.active;
//     return data;
//   }
// }
