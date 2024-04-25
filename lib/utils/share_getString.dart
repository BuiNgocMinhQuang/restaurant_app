import 'package:app_restaurant/utils/storage.dart';

var getStaffShopID =
    StorageUtils.instance.getString(key: 'staff_shop_id') ?? '';
var getStaffPosition =
    StorageUtils.instance.getString(key: 'position_staff') ?? '';
