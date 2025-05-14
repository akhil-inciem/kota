class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'http://dev.kbaiota.org/api';

  // Auth
  static const String login = '$baseUrl/news/login';
  static const String register = 'https://kbaiota.org/index/memberSignUp';
  static const String logout = '$baseUrl/news/logout';
  static const String resetPassword = '$baseUrl/news/passwordReset';
  static const String guestSignIn = '$baseUrl/news/guest-signin';

  // News
  static const String getNews = '$baseUrl/news/get-all-news';
  static const String getNewsById = '$baseUrl/news/{id}';

  // Events
  static const String getEvents = '$baseUrl/news/get-all-events';
  static const String getEventById = '$baseUrl/events/{id}';

  //Favorites
  static const String favorites = '$baseUrl/news/all_favorites';
  static const String updateNewsFavorites = '$baseUrl/news/update-badges-favorites';
  static const String updateEventFavorites = '$baseUrl/news/updatevent-badges-favorites';

  //Updates
  static const String getUpdates = '$baseUrl/news/updates';
  static const String getMemberExpiry = '$baseUrl/news/get-member-details?member=';

  // User
  static const String getUserProfile = '$baseUrl/news/get-user?id=';
  static const String updateUserProfile = '$baseUrl/user/update';

  //Drawer
  static const String getVisionMission = '$baseUrl/news/vissionandmission';
  static const String getMembers = '$baseUrl/news/kbaiotamemebers';
  static const String memberBenefits = '$baseUrl/news/benifitsofmember';
  static const String faq = '$baseUrl/news/faq';

  //Find
  static const String therapistDropdownData = '$baseUrl/news/finedtherapistform';
  static const String findTherapist = '$baseUrl/news/find-therapist';
  static const String findGovClinic = '$baseUrl/news/findgovclinic';
  static const String findPrivateClinic = '$baseUrl/news/findprivateclinic';

  //Advertisement
  static const String advertisement = '$baseUrl/news/adds';
  static const String advertisementList = '$baseUrl/news/addsformvalues'; 
}