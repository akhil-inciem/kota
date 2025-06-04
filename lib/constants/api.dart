class ApiEndpoints {
  // Base URL
  static const String baseUrl = 'https://dev.kbaiota.org/api';

  // Auth
  static const String login = '$baseUrl/news/login';
  static const String register = '$baseUrl/news/register';
  static const String logout = '$baseUrl/news/logout';
  static const String resetPassword = '$baseUrl/news/passwordReset';
  static const String forgotPasswordGuest = '$baseUrl/news/send_token_api';
  static const String verifyGuestOtp = '$baseUrl/news/verify_token_api';
  static const String resetGuestPassword = '$baseUrl/news/reset_password_guest_user';
  static const String forgotupdateGuestPassword = '$baseUrl/news/change_password_api';
  static const String guestSignIn = '$baseUrl/news/guest-signin';

  //Forums
  // Thread APIs
  static const String createThread = '$baseUrl/forums/createThread';
  static const String getAllThreads = '$baseUrl/forums/getAllThreads';
  static const String getThreadDetails = '$baseUrl/forums/getThreadDetails';
  static const String likeThread = '$baseUrl/forums/likeThread/';

  // Comment APIs
  static const String createComment = '$baseUrl/forums/createComment/';
  static const String likeComment = '$baseUrl/forums/likeComment/';

  // Reply APIs
  static const String createCommentReply = '$baseUrl/forums/createCmtReply/';
  static const String likeReply = '$baseUrl/forums/likeReply/';

  // News
  static const String getNews = '$baseUrl/news/get-all-news';
  static const String getNewsById = '$baseUrl/news/getnews_by_id';

  // Events
  static const String getEvents = '$baseUrl/news/get-all-events';
  static const String getEventById = '$baseUrl/news/get_events_id';

  //Favorites
  static const String favorites = '$baseUrl/news/get_favorites';
  static const String updateNewsFavorites = '$baseUrl/news/addnewsfavorite';
  static const String updateEventFavorites = '$baseUrl/news/addeventsfavorite';

  //Updates
  static const String getUpdates = '$baseUrl/news/updates';
  static const String getMemberExpiry = '$baseUrl/news/get-member-details';

  // User
  static const String getUserProfile = '$baseUrl/news/get-user';
  static const String updateUserProfile = '$baseUrl/news/update';

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