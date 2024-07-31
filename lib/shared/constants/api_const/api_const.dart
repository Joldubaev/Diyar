class ApiConst {
  ApiConst._();
  static const baseUrl = "https://api.diyar.kg";
  // static const baseUrl = "http://176.126.164.230:8088";
  // static const baseUrl = "http://20.55.72.226:8080";

  // AUTH
  static const signUp = "$baseUrl/auth/sign-up";
  static const signIn = "$baseUrl/auth/sign-in";
  static const refreshToken = "$baseUrl/auth/refresh-token";
  static const resetPsw = "$baseUrl/auth/reset-password";
  static const sendCodeToPhone = "$baseUrl/auth/send-code-to-phone";

  // USER
  static const getUser = "$baseUrl/user/get-user-info";
  static const updateEmail = "$baseUrl/user/update-email";
  static const codeForUpdateEmail = "$baseUrl/user/send-code-for-update-email";
  static const updateUser = "$baseUrl/user/update-user";
  static const deleteUser = "$baseUrl/user/delete-user";

  // CATEGORIES
  static const getCategories =
      "$baseUrl/categorys/get-all-category-with-foods/";
  static const getCountFoddsByCategory =
      "$baseUrl/categorys/get-quantity-foods-by-category/";
  static const searchFoodsByName = '$baseUrl/foods/search-food-by-pagination';
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

  static Map<String, String> authMap(String token) =>
      {'Authorization': 'Bearer $token'};
  static const updateUserName = "$baseUrl/user/update-username";
  static const updateUserPhone = "$baseUrl/user/update-user-phone";

  // about us
  static String getAboutUs({required String type}) =>
      "$baseUrl/about-us/information?about=$type";
  // sale
  static const getSales = "$baseUrl/sale/get-all-sales";
  //news
  static const getNews = "$baseUrl/news/get-all-news";

  // ORDER
  static const createOrder = "$baseUrl/orders/create-order";
  static const getActualOrders =
      "$baseUrl/orders/get-all-actual-orders-by-user";
  static const getPickupOrder = "$baseUrl/pickup-orders/create-pickup-order";
  static const getPickupHistoryOrders =
      "$baseUrl/pickup-orders/get-all-pickup-orders-by-user";
  static const getOrderItem = "$baseUrl/orders/get-order";
  static const getOrderHistory = "$baseUrl/orders/get-history";

  // COURIER
  static const getCuriersFinis = "$baseUrl/courier/finished-order";
  static const getCuriersAllOrder =
      "$baseUrl/courier/get-actual-orders-by-courier";
  static const getCuriereOrderHistory =
      "$baseUrl/courier/get-closed-orders-by-courier";
}
