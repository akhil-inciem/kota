import 'dart:ui';

Color getBadgeContainerColor(String? badge) {
  switch (badge?.toLowerCase()) {
    case 'news':
      return const Color(0xFF26AE41).withOpacity(0.2); // Green with 20% opacity
    case 'forum':
      return const Color(0xFFF0F2FA); // Light gray (no opacity change)
    case 'event':
      return const Color(0xFFBF5C0F).withOpacity(0.2); // Orange with 20% opacity
    case 'case study':
      return const Color(0xFF9126B7).withOpacity(0.2); // Purple with 20% opacity
    default:
      return const Color(0xFFD3D8FF).withOpacity(0.2); // Default light blue with 20% opacity
  }
}


Color getBadgeTextColor(String? badge) {
  switch (badge?.toLowerCase()) {
    case 'news':
      return const Color(0xFF0E7E16); // News -> Dark Green Text
    case 'forum':
      return const Color(0xFF45515C); // Forum -> Dark Gray Text
    case 'event':
      return const Color(0xFFBF5C0F); // Event -> Orange Text
    case 'case study':
      return const Color(0xFF6B0C75); // Case Study -> Purple Text
    default:
      return const Color(0xFF2640C8); // Default text color
  }
}
