import 'package:flutter/material.dart';

class Library {
  final int? id;
  final String name;
  final String address;
  final String? phone;
  final String? email;
  final String? website;
  final String? description;
  final String? imageUrl;
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final List<bool> openDays;
  final int userId; // Owner of the library
  final bool isPublic; // Whether the library is public or private

  Library({
    this.id,
    required this.name,
    required this.address,
    this.phone,
    this.email,
    this.website,
    this.description,
    this.imageUrl,
    required this.openingTime,
    required this.closingTime,
    required this.openDays,
    required this.userId,
    required this.isPublic,
  });

  factory Library.fromMap(Map<String, dynamic> map) {
    // Convert string times to TimeOfDay
    final openingTimeParts = map['openingTime'].toString().split(':');
    final closingTimeParts = map['closingTime'].toString().split(':');
    
    // Convert string representation of openDays to List<bool>
    final List<String> openDaysList = map['openDays'].toString().split(',');
    final List<bool> openDays = List.generate(7, (index) => 
      index < openDaysList.length ? openDaysList[index] == '1' : false
    );
    
    return Library(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      website: map['website'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      openingTime: TimeOfDay(
        hour: int.parse(openingTimeParts[0]),
        minute: int.parse(openingTimeParts[1]),
      ),
      closingTime: TimeOfDay(
        hour: int.parse(closingTimeParts[0]),
        minute: int.parse(closingTimeParts[1]),
      ),
      openDays: openDays,
      userId: map['userId'],
      isPublic: map['isPublic'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    // Convert TimeOfDay to string format HH:MM
    final String openingTimeStr = '${openingTime.hour.toString().padLeft(2, '0')}:${openingTime.minute.toString().padLeft(2, '0')}';
    final String closingTimeStr = '${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}';
    
    // Convert List<bool> of openDays to string representation
    final String openDaysStr = openDays.map((isOpen) => isOpen ? '1' : '0').join(',');
    
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'description': description,
      'imageUrl': imageUrl,
      'openingTime': openingTimeStr,
      'closingTime': closingTimeStr,
      'openDays': openDaysStr,
      'userId': userId,
      'isPublic': isPublic ? 1 : 0,
    };
  }
}
