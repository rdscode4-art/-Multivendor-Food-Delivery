import 'dart:async';
import 'package:dio/dio.dart';

/// Enum representing standard API Exception Types
enum ApiExceptionType {
  network,
  unauthorized,
  forbidden,
  notFound,
  conflict, // 409 Conflict (e.g., cart items from another restaurant)
  badRequest,
  server,
  unknown,
}

/// Custom Exception class for handling API errors gracefully
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final ApiExceptionType type;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.type = ApiExceptionType.unknown,
  });

  @override
  String toString() => 'ApiException: [$statusCode] ($type) $message';
}

/// Singleton API Service implementing all Fast Food Consumer App endpoints using Dio.
/// Formats request, response, and error logs clearly in the terminal.
class ApiService {
  static String baseUrl = 'https://foodbackend.ridealdigitalseva.com';

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  static ApiService get instance => _instance;

  late final Dio _dio;
  String? _accessToken;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  /// Get active access token
  String? get accessToken => _accessToken;

  /// Update Base URL dynamically if testing on local backend (e.g. http://10.0.2.2:5000)
  void updateBaseUrl(String newUrl) {
    _dio.options.baseUrl = newUrl;
    print('ℹ️ ApiService Base URL updated to: $newUrl');
  }

  /// Set access token for Authorization Bearer header
  void setAccessToken(String? token) {
    _accessToken = token;
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Setup custom interceptors for Auth header and Terminal Logging
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null && _accessToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          _logRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          _logError(error);
          return handler.next(error);
        },
      ),
    );
  }

  // Terminal Logging Helpers - Uses direct print() so output ALWAYS appears in terminal
  void _logRequest(RequestOptions options) {
    print('\n==================== 🚀 DIO REQUEST 🚀 ====================');
    print('Method : ${options.method}');
    print('URL    : ${options.baseUrl}${options.path}');
    if (options.queryParameters.isNotEmpty) {
      print('Params : ${options.queryParameters}');
    }
    print('Headers: ${options.headers}');
    if (options.data != null) {
      print('Body   : ${options.data}');
    }
    print('===========================================================\n');
  }

  void _logResponse(Response response) {
    print('\n==================== ✅ DIO RESPONSE ✅ ====================');
    print('URL    : ${response.requestOptions.baseUrl}${response.requestOptions.path}');
    print('Status : ${response.statusCode} ${response.statusMessage ?? ''}');
    print('Data   : ${response.data}');
    print('============================================================\n');
  }

  void _logError(DioException error) {
    print('\n==================== ❌ DIO ERROR ❌ ====================');
    print('URL    : ${error.requestOptions.baseUrl}${error.requestOptions.path}');
    print('Type   : ${error.type}');
    print('Status : ${error.response?.statusCode}');
    print('Message: ${error.message}');
    if (error.error != null) {
      print('Detail : ${error.error}');
    }
    if (error.response?.data != null) {
      print('Data   : ${error.response?.data}');
    }
    print('=========================================================\n');
  }

  /// Converts DioException into a strongly-typed ApiException
  ApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final dynamic data = error.response?.data;
    String message = 'An unexpected error occurred.';

    if (data is Map && data.containsKey('message')) {
      message = data['message'].toString();
    } else if (data is String && data.isNotEmpty) {
      message = data;
    } else if (error.message != null && error.message!.isNotEmpty) {
      message = error.message!;
    }

    ApiExceptionType type = ApiExceptionType.unknown;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        type = ApiExceptionType.network;
        message = 'Connection timed out to server (${_dio.options.baseUrl}). Server is offline or unreachable.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          type = ApiExceptionType.unauthorized;
          if (message == 'An unexpected error occurred.') {
            message = 'Invalid email or password.';
          }
        } else if (statusCode == 403) {
          type = ApiExceptionType.forbidden;
        } else if (statusCode == 404) {
          type = ApiExceptionType.notFound;
        } else if (statusCode == 409) {
          type = ApiExceptionType.conflict;
        } else if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          type = ApiExceptionType.badRequest;
        } else if (statusCode != null && statusCode >= 500) {
          type = ApiExceptionType.server;
        }
        break;
      default:
        type = ApiExceptionType.unknown;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
      type: type,
    );
  }

  // Core Request Wrappers
  Future<dynamic> _get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> _post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> _put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<dynamic> _delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ===========================================================================
  // 1. AUTHENTICATION (`/api/auth`)
  // ===========================================================================

  /// Step 1: User Signup
  Future<dynamic> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    return await _post(
      '/api/auth/signup',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
  }

  /// Step 2: Verify OTP
  Future<dynamic> verifyOtp({
    required String email,
    required String code,
    required String purpose, // e.g. "signup" or "reset_password"
  }) async {
    final responseData = await _post(
      '/api/auth/verify-otp',
      data: {
        'email': email,
        'code': code,
        'purpose': purpose,
      },
    );

    // If token returned upon verification, update service token
    if (responseData is Map && responseData.containsKey('token')) {
      setAccessToken(responseData['token'].toString());
    } else if (responseData is Map && responseData.containsKey('accessToken')) {
      setAccessToken(responseData['accessToken'].toString());
    }

    return responseData;
  }

  /// Resend OTP
  Future<dynamic> resendOtp({
    required String email,
    required String purpose,
  }) async {
    return await _post(
      '/api/auth/resend-otp',
      data: {
        'email': email,
        'purpose': purpose,
      },
    );
  }

  /// Login
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final responseData = await _post(
      '/api/auth/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    if (responseData is Map && responseData.containsKey('token')) {
      setAccessToken(responseData['token'].toString());
    } else if (responseData is Map && responseData.containsKey('accessToken')) {
      setAccessToken(responseData['accessToken'].toString());
    }

    return responseData;
  }

  /// Forgot Password
  Future<dynamic> forgotPassword({required String email}) async {
    return await _post(
      '/api/auth/forgot-password',
      data: {'email': email},
    );
  }

  /// Reset Password
  Future<dynamic> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    return await _post(
      '/api/auth/reset-password',
      data: {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      },
    );
  }

  /// Refresh Token (Uses HTTP-only cookies or endpoint)
  Future<dynamic> refreshToken() async {
    final responseData = await _post('/api/auth/refresh-token');
    if (responseData is Map && responseData.containsKey('accessToken')) {
      setAccessToken(responseData['accessToken'].toString());
    }
    return responseData;
  }

  /// Logout
  Future<dynamic> logout() async {
    final response = await _post('/api/auth/logout');
    setAccessToken(null);
    return response;
  }

  // ===========================================================================
  // 2. USER PROFILE & ADDRESSES (`/api/user`)
  // ===========================================================================

  /// Get User Profile
  Future<dynamic> getProfile() async {
    return await _get('/api/user/profile');
  }

  /// Update User Profile
  Future<dynamic> updateProfile(Map<String, dynamic> profileData) async {
    return await _put('/api/user/profile', data: profileData);
  }

  /// Get All Addresses
  Future<dynamic> getAddresses() async {
    return await _get('/api/user/addresses');
  }

  /// Create Address
  Future<dynamic> createAddress({
    required String label,
    required String street,
    required String city,
    required String zip,
    required String fullAddress,
    double lat = 28.6,
    double lng = 77.1,
  }) async {
    return await _post(
      '/api/user/addresses',
      data: {
        'label': label,
        'street': street,
        'city': city,
        'zip': zip,
        'fullAddress': fullAddress,
        'location': {
          'type': 'Point',
          'coordinates': [lng, lat],
        },
      },
    );
  }

  /// Update Address
  Future<dynamic> updateAddress(String addressId, Map<String, dynamic> addressData) async {
    return await _put('/api/user/addresses/$addressId', data: addressData);
  }

  /// Delete Address
  Future<dynamic> deleteAddress(String addressId) async {
    return await _delete('/api/user/addresses/$addressId');
  }

  /// Get Payment Methods
  Future<dynamic> getPaymentMethods() async {
    return await _get('/api/user/payment-methods');
  }

  /// Add Payment Method
  Future<dynamic> addPaymentMethod({
    required String type,
    required String details,
  }) async {
    return await _post(
      '/api/user/payment-methods',
      data: {
        'type': type,
        'details': details,
      },
    );
  }

  /// Delete Payment Method
  Future<dynamic> deletePaymentMethod(String paymentMethodId) async {
    return await _delete('/api/user/payment-methods/$paymentMethodId');
  }

  // ===========================================================================
  // 3. DISCOVERY & MENU (`/api/restaurants` & `/api/menu`)
  // ===========================================================================

  /// Get Categories
  Future<dynamic> getCategories() async {
    return await _get('/api/restaurants/categories');
  }

  /// Get Featured Restaurants
  Future<dynamic> getFeaturedRestaurants() async {
    return await _get('/api/restaurants/featured');
  }

  /// Get Fastest Restaurants
  Future<dynamic> getFastestRestaurants() async {
    return await _get('/api/restaurants/fastest');
  }

  /// Get Popular Restaurants
  Future<dynamic> getPopularRestaurants() async {
    return await _get('/api/restaurants/popular');
  }

  /// Search Restaurants (by ?q=keyword)
  Future<dynamic> searchRestaurants(String query) async {
    return await _get('/api/restaurants/search', queryParameters: {'q': query});
  }

  /// Get Restaurant Detail
  Future<dynamic> getRestaurantDetail(String restaurantId) async {
    return await _get('/api/restaurants/$restaurantId');
  }

  /// Get Menu for Restaurant
  Future<dynamic> getMenuForRestaurant(String restaurantId) async {
    return await _get('/api/menu/$restaurantId');
  }

  /// Get Specific Menu Item Detail
  Future<dynamic> getMenuItemDetail(String itemId) async {
    return await _get('/api/menu/item/$itemId');
  }

  // ===========================================================================
  // 4. CART (`/api/cart`)
  // ===========================================================================

  /// Get Current Cart
  Future<dynamic> getCart() async {
    return await _get('/api/cart');
  }

  /// Add Item to Cart
  Future<dynamic> addToCart({
    required String menuItemId,
    required int quantity,
    required String restaurantId,
  }) async {
    return await _post(
      '/api/cart',
      data: {
        'menuItemId': menuItemId,
        'quantity': quantity,
        'restaurantId': restaurantId,
      },
    );
  }

  /// Update Cart Item Quantity
  Future<dynamic> updateCartQuantity({
    required String menuItemId,
    required int quantity,
  }) async {
    return await _put(
      '/api/cart',
      data: {
        'menuItemId': menuItemId,
        'quantity': quantity,
      },
    );
  }

  /// Delete Item from Cart
  Future<dynamic> deleteCartItem(String menuItemId) async {
    return await _delete('/api/cart/$menuItemId');
  }

  /// Clear Entire Cart (Used when adding item from different restaurant or clearing)
  Future<dynamic> clearCart() async {
    return await _delete('/api/cart');
  }

  // ===========================================================================
  // 5. WISHLIST (`/api/wishlist`)
  // ===========================================================================

  /// Get Wishlist
  Future<dynamic> getWishlist() async {
    return await _get('/api/wishlist');
  }

  /// Toggle Item in Wishlist
  Future<dynamic> toggleWishlist({
    required String itemType, // "restaurant" or "food"
    required String itemId,
  }) async {
    return await _post(
      '/api/wishlist/toggle',
      data: {
        'itemType': itemType,
        'itemId': itemId,
      },
    );
  }

  // ===========================================================================
  // 6. NOTIFICATIONS (`/api/notifications`)
  // ===========================================================================

  /// Get All Notifications
  Future<dynamic> getNotifications() async {
    return await _get('/api/notifications');
  }

  /// Mark Notification as Read
  Future<dynamic> markNotificationAsRead(String id) async {
    return await _put('/api/notifications/$id/read');
  }

  /// Mark All Notifications as Read
  Future<dynamic> markAllNotificationsAsRead() async {
    return await _put('/api/notifications/read-all');
  }

  // ===========================================================================
  // 7. CHECKOUT & ORDERS (`/api/order` & `/api/payments`)
  // ===========================================================================

  /// Checkout (Creates placed order & clears cart)
  Future<dynamic> checkout({
    required String addressId,
    required String paymentMethod,
  }) async {
    return await _post(
      '/api/order/checkout',
      data: {
        'addressId': addressId,
        'paymentMethod': paymentMethod,
      },
    );
  }

  /// Mock Payment Charge
  Future<dynamic> mockPaymentCharge({
    required String orderId,
    required String method,
    String forceStatus = 'success',
  }) async {
    return await _post(
      '/api/payments/mock-charge',
      data: {
        'orderId': orderId,
        'method': method,
        'forceStatus': forceStatus,
      },
    );
  }

  /// Get Order History
  Future<dynamic> getOrderHistory() async {
    return await _get('/api/order');
  }

  /// Get Order Detail
  Future<dynamic> getOrderDetail(String orderId) async {
    return await _get('/api/order/$orderId');
  }

  /// Cancel Order (Only if status is "placed")
  Future<dynamic> cancelOrder(String orderId) async {
    return await _put('/api/order/$orderId/cancel');
  }

  /// Track Active Order (GPS tracking)
  Future<dynamic> trackOrder(String orderId) async {
    return await _get('/api/order/$orderId/track');
  }

  /// Submit Review for Order
  Future<dynamic> submitReview(
    String orderId, {
    required int rating,
    required String comment,
  }) async {
    return await _post(
      '/api/order/$orderId/review',
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
  }

  /// Get Help / Support Info for Order
  Future<dynamic> getOrderHelp(String orderId) async {
    return await _get('/api/order/$orderId/help');
  }

  // ===========================================================================
  // 8. STATIC CONTENT (`/api/static`)
  // ===========================================================================

  /// Get About Us Content
  Future<dynamic> getAboutUs() async {
    return await _get('/api/static/about');
  }

  /// Get FAQ Content
  Future<dynamic> getFaq() async {
    return await _get('/api/static/faq');
  }

  /// Get Terms & Conditions Content
  Future<dynamic> getTerms() async {
    return await _get('/api/static/terms');
  }
}
