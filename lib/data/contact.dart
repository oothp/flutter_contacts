import 'dart:io';

class Contact {
  String name;
  String email;
  String phoneNumber;
  bool isFavorite;
  File? imageFile;

  // constructor with optional params.
  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.imageFile,
  });
}
