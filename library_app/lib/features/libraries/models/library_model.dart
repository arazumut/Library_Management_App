class LibraryModel {
  final int id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? website;
  final String? description;
  final String? image;
  final double? latitude;
  final double? longitude;
  final String openingHours;
  final DateTime createdAt;
  final DateTime updatedAt;

  LibraryModel({
    required this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.website,
    this.description,
    this.image,
    this.latitude,
    this.longitude,
    required this.openingHours,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a LibraryModel from Django API JSON
  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      openingHours: json['opening_hours'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'opening_hours': openingHours,
    };
  }

  // Convert to JSON map with full data
  Map<String, dynamic> toFullJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
      'opening_hours': openingHours,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Create a copy with some updated fields
  LibraryModel copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? description,
    String? image,
    double? latitude,
    double? longitude,
    String? openingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LibraryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      description: description ?? this.description,
      image: image ?? this.image,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      openingHours: openingHours ?? this.openingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get hasLocation => latitude != null && longitude != null;
  bool get hasContact => phone != null || email != null;
}
