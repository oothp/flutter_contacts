import 'dart:io';

class Contact {
  late int id; // key for db
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite,
      'imageFilePath': imageFile?.path
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        name: map['name'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        isFavorite: map['isFavorite'],
        imageFile: map['imageFilePath'] != null ? File(map['imageFilePath']) : null);
  }
}
