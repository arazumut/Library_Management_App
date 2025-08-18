class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String userType; // Django API'de user_type olarak geliyor
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.userType,
    this.profileImageUrl,
  });

  // Tam isim
  String get fullName => '$firstName $lastName';

  // Admin kontrolü
  bool get isAdmin => userType == 'admin';

  // Member kontrolü
  bool get isMember => userType == 'member';

  // Factory constructor to create a UserModel from Django API JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      userType: json['user_type'] as String? ?? 'member',
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'profile_image_url': profileImageUrl,
    };
  }

  // Create a copy with some updated fields
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? userType,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
