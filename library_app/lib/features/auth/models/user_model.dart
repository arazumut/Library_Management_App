class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
  });
  
  // Factory constructor to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );
  }
  
  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_image_url': profileImageUrl,
    };
  }
  
  // Create a copy with some updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImageUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
