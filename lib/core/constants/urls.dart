class Urls {
  // Base URL
  // static const String baseUrl = 'http://localhost:5000/api';
  static const String baseUrl = 'http://10.0.2.2:5001/api';
  // static const String baseUrl = 'https://ridetohealth-backend.onrender.com/api';


    static const String socketUrl = 'http://10.10.5.85:5001'; 
    // static const String socketUrl = 'https://ridetohealth-backend.onrender.com/api'; 
  // ------------------------ Authentication ------------------------

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshAccessToken = '/auth/refresh-token';
  static const String verifyOtp = '/auth/verify-otp';
  static const String forgetPassword = '/auth/request-password-reset';
  static const String resetPasswordWithOtp = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String logOut = '/auth/logout';

  // ------------------------ User Management ------------------------
  static const String getProfile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String uploadProfileImage = '/user/profile/image';
  static const String updateLocation = '/user/location';

  static const String addSavedPlace = '/user/saved-places';
  static const String getSavedPlaces = '/user/saved-places';
  static const String deleteSavedPlace = '/user/saved-places/'; // + {placeId}

  static const String getRecentTrips = '/user/recent-trips';
  static const String addPaymentMethod = '/user/payment-methods';
  static const String getPaymentMethods = '/user/payment-methods';
  static const String deletePaymentMethod =
      '/user/payment-methods/'; // + {methodId}
  static const String updateNotificationSettings =
      '/user/notification-settings';
  static const String getSearchDestinationForFindNearestDrivers = '/user/find-rider?';
  static const String createPayment = '/stripe/payment/create';



  // ------------------------ Category------------------------
  static const String allCategories = '/admin/categories';
  static const String getACategory = 'admin/categories/';
  // static const String uploadProfileImage = '/user/profile/image';
  // static const String updateLocation = '/user/location';


  // ------------------------ Ride Management ------------------------
  static const String requestRide = '/ride/request';
  static const String acceptRide = '/ride/'; // + {rideId}/accept
  static const String getRideStatus = '/ride/'; // + {rideId}/status
  static const String updateRideStatus = '/ride/'; // + {rideId}/status
  static const String cancelRide = '/ride/'; // + {rideId}/cancel
  static const String rateRide = '/ride/'; // + {rideId}/rate

  // ------------------------ Driver Management ------------------------
  static const String registerDriver = '/driver/register';
  static const String getDriverProfile = '/driver/profile';
  static const String updateDriverProfile = '/driver/profile';
  static const String updateDriverLocation = '/driver/location';
  static const String toggleOnlineStatus = '/driver/online-status';
  static const String getTripHistory = '/driver/trip-history';
  static const String getEarnings = '/driver/earnings';
  static const String requestWithdrawal = '/driver/withdrawal';
  static const String getDriverReviews = '/driver/reviews';

  // ------------------------ Service Management ------------------------
  static const String getAllServices = '/service';
  static const String getServiceById = '/service/'; // + {serviceId}
  static const String getNearbyVehicles = '/service/nearby/vehicles';

  // ------------------------ Payment Management ------------------------
  static const String addWalletBalance = '/payment/wallet/add-balance';
  static const String getWalletHistory = '/payment/wallet/history';
  static const String validatePromoCode = '/payment/validate-promo';
  static const String processPayment = '/payment/process';
  static const String getPaymentDetails = '/payment/details/'; // + {rideId}

  // // ------------------------ Admin Management ------------------------
  // static const String getAllUsers = '/admin/users';
  // static const String getUserDetails = '/admin/users/'; // + {userId}
  // static const String updateUserStatus = '/admin/users/'; // + {userId}/status

  // static const String getAllDrivers = '/admin/drivers';
  // static const String getDriverDetails = '/admin/drivers/'; // + {driverId}
  // static const String verifyDriver = '/admin/drivers/'; // + {driverId}/verify

  // static const String getAllRides = '/admin/rides';
  // static const String getRideDetails = '/admin/rides/'; // + {rideId}
  // static const String getSystemStatistics = '/admin/statistics';

  // static const String createServiceType = '/admin/services';
  // static const String updateServiceType = '/admin/services/'; // + {serviceId}
}
