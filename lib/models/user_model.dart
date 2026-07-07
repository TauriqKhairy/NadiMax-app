import 'subscription_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final int? age;
  final double? height;
  final double? weight;
  final String? gender;
  final SubscriptionModel? activeSubscription;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.age,
    this.height,
    this.weight,
    this.gender,
    this.activeSubscription,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};

    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: profile['age'],
      height: profile['height'] != null
          ? double.parse(profile['height'].toString())
          : null,
      weight: profile['weight'] != null
          ? double.parse(profile['weight'].toString())
          : null,
      gender: profile['gender'],
      activeSubscription: json['active_subscription'] != null
          ? SubscriptionModel.fromJson(json['active_subscription'])
          : null,
      createdAt: json['created_at'] ?? '',
    );
  }
}
