//Auth Staff
const String staffLoginApi = 'staff/login';
const String deleteAvatarStaff = 'staff/delete-avatar';
const String forgotPasswordStaff = 'staff/forgot-password';
const String checkOtpStaff = 'staff/check-otp';
const String changePasswordStaffWhenForget = 'staff/change-password';
const String updateStaffInfor = 'staff/update-profile';
const String changePasswordStaffApi = 'staff/update-password';
const String updateAvatarStaffApi = 'staff/update-avatar';
//Auth Manager
const String managerLoginApi = 'user/login';
const String managerRegister = 'user/register';
const String forgotPasswordManager = 'user/forgot-password';
const String checkOtpManager = 'user/check-otp';
const String changePasswordManagerWhenForget = 'user/change-password';
const String managerUpdatePassword = 'user/update-password';
const String mangerUpdateInfor = 'user/update-profile';
const String managerUpdateAvatar = 'user/update-avatar';
const String managerDeletedAvatar = 'user/delete-avatar';
const String managerCheckPassword = 'user/check-password';
const String managerUpdateCitizenIDApi = 'user/update-citizen-identification';
const String mangaerDataHome = 'user/home';
const String managerChartHome = 'user/home/chart-column';
const String managerGetListFood = 'user/foods/list';
const String managerGetListStores = 'user/stores';
const String deleteFood = 'user/foods/delete';
const String createFood = 'user/foods/create';
const String editFood = 'user/foods/edit';
const String getDetailsFood = 'user/foods/detail';
const String detailStore = 'user/stores/detail/data';
const String detailEditStore = 'user/stores/detail';
const String getChartData = 'user/stores/detail/chart-column-overview-by-store';
const String createStoreApi = 'user/stores/create';
const String editDetailsStoreApi = 'user/stores/detail/edit';
const String getListStaffApi = 'user/staffs/list';
const String addStaffApi = 'user/staffs/add';
const String getStaffInforByManager = 'user/staffs/edit/show';
const String handleEditStaffInforByManager = 'user/staffs/edit/handle';
const String updateStatusStaff = 'user/staffs/active';

//room
const String getDetailsRoomApi = 'user/stores/rooms/detail';
const String getListRoomByManager = 'user/stores/rooms/list';
const String createRoomByManager = 'user/stores/rooms/add';
const String editRoomByManager = 'user/stores/rooms/edit';
const String deleteRoomByManager = 'user/stores/rooms/delete';

//table

const String getListTableOfRoomByManager = 'user/stores/rooms/tables/list';
const String updateOrCreateRoom = 'user/stores/rooms/tables/update-or-create';
const String getDetailsDataOfTable = 'user/stores/rooms/tables/detail';
const String deleteTableByManager = 'user/stores/rooms/tables/delete';

//Shared API
const String logoutApi = 'logout';
const String userInformationApi = 'information';
const String areas = 'areas';
const String bookingApi = 'booking';
const String tableApi = 'booking/table';
const String foodsTableApi = 'booking/table/foods';
const String cancleTable = 'booking/table/close';
const String saveInforTable = 'booking/table/information';
const String getSwitchTable = 'booking/table/switch';
const String handleSwitchTable = 'booking/table/switch/handle';
const String addFoodTable = 'booking/table/foods/plus';
const String removeFoodTable = 'booking/table/foods/minus';
const String updateQuantityFoodTable = 'booking/table/foods/quantity';
const String showPaymentInfor = 'booking/table/bill/payment';
const String updatePaymentInfor = 'booking/table/bill/payment/update';
const String confirmPayment = 'booking/table/bill/paid';
const String showBillInfor = 'booking/table/bill';
const String getTotalPriceBill = 'booking/table/total-price-bill';
const String getListBroughtReceipt = 'take-away/list';
const String getListFoodBroughtReceipt = 'take-away/foods';
const String addFoodToBroughtReceipt = 'take-away/foods/plus';
const String removeFoodToBroughtReceipt = 'take-away/foods/minus';
const String updateQuantityFoodBroughtReceipt = 'take-away/foods/quantity';
const String cancleBroughtReceipt = 'take-away/close';
const String printBroughtReceipt = 'print-bill';
const String foodList = 'foods/list';
const String listBill = 'bills/list';
