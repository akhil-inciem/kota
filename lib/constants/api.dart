class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://kbaiota.org/api';

  // Auth
  static const String login = '$baseUrl/news/login';
  static const String register = 'https://kbaiota.org/index/memberSignUp';
  static const String logout = '$baseUrl/auth/logout';

  // News
  static const String getNews = '$baseUrl/news/get-all-news';
  static const String getNewsById = '$baseUrl/news/{id}';

  // Events
  static const String getEvents = '$baseUrl/news/get-all-events';
  static const String getEventById = '$baseUrl/events/{id}';

  //Favorites
  static const String updateFavorites = '$baseUrl/news/update-badges-favorites';

  //Updates
  static const String getUpdates = '$baseUrl/news/updates';

  // User
  static const String getUserProfile = '$baseUrl/news/get-user?id=';
  static const String updateUserProfile = '$baseUrl/user/update';

  //Drawer
  static const String getVisionMission = '$baseUrl/news/vissionandmission';
  static const String getMembers = '$baseUrl/news/kbaiotamemebers';
}