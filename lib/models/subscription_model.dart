class SubscriptionModel {
  final String id;
  final String plan;
  final String startedAt;
  final String? expiredAt;
  final bool isActive;
  final bool isValid;

  SubscriptionModel({
    required this.id,
    required this.plan,
    required this.startedAt,
    this.expiredAt,
    required this.isActive,
    required this.isValid,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      plan: json['plan'],
      startedAt: json['started_at'],
      expiredAt: json['expired_at'],
      isActive: json['is_active'],
      isValid: json['is_valid'],
    );
  }

  bool get isPremium => plan == 'premium' && isValid;
}
