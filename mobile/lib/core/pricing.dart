/// Plan-based daily contact limits & features
class ContactPricing {
  /// Daily contact reveal limits per plan
  static const Map<String, int> dailyLimits = {
    'free': 0,
    'basic': 10,
    'premium': 50,
    'vip': 999999, // unlimited
  };

  /// Plan prices (USD/month)
  static const Map<String, double> prices = {
    'free': 0,
    'basic': 10,
    'premium': 35,
    'vip': 65,
  };

  /// Plan names for display
  static const Map<String, String> planNames = {
    'free': 'Free',
    'basic': 'Basic',
    'premium': 'Premium',
    'vip': 'VIP',
  };

  /// Team members limit per plan
  static const Map<String, int> teamLimit = {
    'free': 1,
    'basic': 1,
    'premium': 3,
    'vip': 5,
  };

  /// Plans with Telegram bot auto-notifications (only VIP)
  static const List<String> telegramNotifyPlans = ['vip'];

  /// Plans with LinkedIn access (Premium+)
  static const List<String> linkedinPlans = ['premium', 'vip'];

  /// Check if plan has LinkedIn access
  static bool hasLinkedin(String plan) => linkedinPlans.contains(plan);

  /// Free trial duration (days)
  static const int freeTrialDays = 20;

  /// Get daily limit for a plan
  static int limitFor(String plan) => dailyLimits[plan] ?? 0;

  /// Is unlimited contacts
  static bool isUnlimited(String plan) => plan == 'vip';
}
