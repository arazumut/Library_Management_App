import 'package:flutter/material.dart';

class ValidationUtils {
  // Email validation
  static bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegExp.hasMatch(email);
  }
  
  // Password validation - at least 8 characters, 1 uppercase, 1 lowercase, 1 digit
  static bool isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }
  
  // Phone number validation
  static bool isValidPhoneNumber(String phoneNumber) {
    final RegExp phoneRegExp = RegExp(
      r'^\+?[0-9]{10,15}$',
    );
    return phoneRegExp.hasMatch(phoneNumber);
  }
  
  // Username validation - alphanumeric, 4-20 characters
  static bool isValidUsername(String username) {
    final RegExp usernameRegExp = RegExp(
      r'^[a-zA-Z0-9_]{4,20}$',
    );
    return usernameRegExp.hasMatch(username);
  }
  
  // Name validation - at least 2 characters, letters and spaces only
  static bool isValidName(String name) {
    final RegExp nameRegExp = RegExp(
      r'^[a-zA-Z\s]{2,}$',
    );
    return nameRegExp.hasMatch(name);
  }
  
  // URL validation
  static bool isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return urlRegExp.hasMatch(url);
  }
  
  // ISBN validation (ISBN-10 or ISBN-13)
  static bool isValidISBN(String isbn) {
    // Remove hyphens and spaces
    isbn = isbn.replaceAll('-', '').replaceAll(' ', '');
    
    // Check for ISBN-10
    if (isbn.length == 10) {
      return _isValidISBN10(isbn);
    }
    
    // Check for ISBN-13
    if (isbn.length == 13) {
      return _isValidISBN13(isbn);
    }
    
    return false;
  }
  
  // ISBN-10 validation
  static bool _isValidISBN10(String isbn) {
    try {
      int sum = 0;
      for (int i = 0; i < 9; i++) {
        int digit = int.parse(isbn[i]);
        sum += digit * (10 - i);
      }
      
      // Check for 'X' in the last position
      String lastChar = isbn[9];
      if (lastChar == 'X' || lastChar == 'x') {
        sum += 10;
      } else {
        sum += int.parse(lastChar);
      }
      
      return sum % 11 == 0;
    } catch (e) {
      return false;
    }
  }
  
  // ISBN-13 validation
  static bool _isValidISBN13(String isbn) {
    try {
      int sum = 0;
      for (int i = 0; i < 12; i++) {
        int digit = int.parse(isbn[i]);
        sum += (i % 2 == 0) ? digit : digit * 3;
      }
      
      int checkDigit = int.parse(isbn[12]);
      int remainder = sum % 10;
      int calculatedCheckDigit = (remainder == 0) ? 0 : 10 - remainder;
      
      return checkDigit == calculatedCheckDigit;
    } catch (e) {
      return false;
    }
  }
  
  // Form validators
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email address is required';
    }
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!isValidPassword(value)) {
      return 'Password must contain uppercase, lowercase and digits';
    }
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!isValidName(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateISBN(String? value) {
    if (value == null || value.isEmpty) {
      return null; // ISBN is optional
    }
    if (!isValidISBN(value)) {
      return 'Please enter a valid ISBN number';
    }
    return null;
  }
}
