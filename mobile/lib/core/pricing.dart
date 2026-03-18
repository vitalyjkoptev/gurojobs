/// Global contact unlock pricing — editable by admin
class ContactPricing {
  static double telegramPrice = 5.0;
  static double linkedinPrice = 5.0;
  static double chatPrice = 5.0;

  static String get telegramPriceStr => '\$${telegramPrice.toStringAsFixed(0)}';
  static String get linkedinPriceStr => '\$${linkedinPrice.toStringAsFixed(0)}';
  static String get chatPriceStr => '\$${chatPrice.toStringAsFixed(0)}';
}
