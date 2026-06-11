class User {
  final String id;
  final String phone;
  final String nickname;
  final String? avatar;
  final String? gender;
  final String? birthDate;
  final String createdAt;

  User({
    required this.id,
    required this.phone,
    required this.nickname,
    this.avatar,
    this.gender,
    this.birthDate,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      phone: json['phone'] ?? '',
      nickname: json['nickname'] ?? '',
      avatar: json['avatar'],
      gender: json['gender'],
      birthDate: json['birth_date'],
      createdAt: json['created_at'] ?? '',
    );
  }
}