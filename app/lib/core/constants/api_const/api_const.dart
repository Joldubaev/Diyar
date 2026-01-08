class ApiConst {
  ApiConst._();
  static const baseUrl = "https://api.diyar.kg/api/v1";
  static const baseUrl1_2 = "https://api.diyar.kg/api/v1.2";
  static const baseUrl2 = "https://api.diyar.kg/api/v2";

  // AUTH
  static const signUp = "$baseUrl2/auth/sign-up";
  // static const signIn = "$baseUrl/auth/sign-in";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const resetPsw = "$baseUrl/user/reset-password";
  static const sendCodeToPhone = "$baseUrl/user/send-code-to-phone";

  // CHECK NUMBER
  static const checkPhone = "$baseUrl2/auth/check-phone-number";

  // SEND SMS CODE
  static const sendCode = "$baseUrl/user/send-code-to-phone";

  // VERIFY CODE
  static const verifyRegister = "$baseUrl2/user/verify-register";
  static const verifyLogin = "$baseUrl2/user/verify-login";

  // USER
  static const getUser = "$baseUrl/user/get-user-info";
  static const updateEmail = "$baseUrl/user/update-email";
  static const codeForUpdateEmail = "$baseUrl/user/send-code-for-update-email";
  static const updateUser = "$baseUrl/user/update-user";
  static const deleteUser = "$baseUrl/user/delete-user";

  // CATEGORIES
  static const getCategories = "$baseUrl/category/get-all-categories";
  static const getAllFoodsByName = "$baseUrl/foods/get-all-foods-by-category-name";
  static const getCountFoddsByCategory = "$baseUrl/categorys/get-quantity-foods-by-category/";
  static const searchFoodsByName = '$baseUrl/foods/search-foods-by-pagination';
  static const getPopularFoods = "$baseUrl/foods/get-popular-foods";

  // Map
  static String getLocations({
    required String apiKey,
    required String lat,
    required String lang,
  }) =>
      "https://geocode-maps.yandex.ru/1.x/?$apiKey&geocode=$lat,$lang&format=json";

  static String getLocationByAdress({
    required String apiKey,
    required String lat,
    required String lang,
  }) =>
      "https://geocode-maps.yandex.ru/1.x/?apikey=$apiKey&geocode=$lat,$lang&format=json";

  static Map<String, String> authMap(String token) => {'Authorization': 'Bearer $token'};
  static const updateUserName = "$baseUrl/user/update-username";
  static const updateUserPhone = "$baseUrl/user/update-user-phone";
  static const getDeliveryPrice = "$baseUrl/districts/find-district-price";

  // about us
  static String getAboutUs = "$baseUrl/about-us/information";
  // sale
  static const getSales = "$baseUrl/sale/get-all-sales";
  //news
  static const getNews = "$baseUrl/news/get-all-news";

  // ORDER
  static const createOrder = "$baseUrl/orders/create-order";
  static const getActualOrders = "$baseUrl/orders/get-all-actual-orders-by-user";
  static const getPickupOrder = "$baseUrl/pickup-orders/create-pickup-order";
  static const getPickupHistoryOrders = "$baseUrl/pickup-orders/get-all-pickup-orders-by-user";
  static const getOrderItem = "$baseUrl/orders/get-order";
  static const getOrderHistory = "$baseUrl/orders/get-history";

  // COURIER
  static const getCuriersFinis = "$baseUrl1_2/courier/finished-orders";
  static const getCuriersAllOrder = "$baseUrl1_2/courier/get-actual-orders-by-courier";
  static const getCuriereOrderHistory = "$baseUrl1_2/courier/get-closed-orders-by-courier";

  // DISTRICTS
  static const getDistricts = "$baseUrl/districts/get-all-districts";

  //payment
  static const finipayCallBack = "$baseUrl/payment/finipay-callback";
  static const checkPaymentMega = "$baseUrl/payment/check-payment-mega";
  static const megaInitiate = "$baseUrl/payment/mega-initiate";
  static const megaStatus = "$baseUrl/payment/mega-status";
  static const mbankInitiate = "$baseUrl/payment/mbank-initiate";
  static const mbankConfirm = "$baseUrl/payment/mbank-confirm";
  static const mbankStatus = "$baseUrl/payment/mbank-status";

  //qr code
  static const generateQRCode = "$baseUrl/payment/qr-generate";
  static const checkQRCodeStatus = "$baseUrl/payment/qr-status";

  // timer
  static const getTimer = "$baseUrl/work-time/get-work-time";

  static String getPrice({String? id}) => "$baseUrl/districts/get-district-price-by-yandex-id/$id";

  static const createTemplate = "$baseUrl/templates/create-template";

  // BONUS
  static const generateBonusQr = "$baseUrl/bonus/generate-qr";
  static const deleteTemplate = "$baseUrl/templates/delete-template";
  // with query templateId
  static const getAllTemplates = "$baseUrl/templates/get-all-templates";
  static const getTemplateById = "$baseUrl/templates/get-template-by-id";
  // with query templateId
  static const updateTemplate = "$baseUrl/templates/update-template";
}
