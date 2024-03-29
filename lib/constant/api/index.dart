//Auth Staff
const String staffLoginApi = 'staff/login';
const String staffLogout = 'staff/logout';
const String deleteAvatarStaff = 'staff/delete-avatar';
const String forgotPasswordStaff = 'staff/forgot-password';
const String checkOtpStaff = 'staff/check-otp';
const String changePasswordWhenForget = 'staff/change-password';
const String updateStaffInfor = 'staff/update-profile';
const String changePasswordStaffApi = 'staff/update-password';
const String updateAvatarStaffApi = 'staff/update-avatar';
//Auth Manager
const String managerLoginApi = 'user/login';
const String managerLogout = 'user/logout';
const String managerRegister = 'user/register';
const String managerUpdatePassword = 'user/update-password';
const String managerUpdateAvatar = 'user/update-avatar';
const String managerDeletedAvatar = 'user/delete-avatar';
const String managerCheckPassword = 'user/check-password';
const String managerUpdateCitizenID = 'user/update-citizen-identification';

//Shared API
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
