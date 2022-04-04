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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavourite': isFavorite,
      'imageFilePath': imageFile?.path
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
        name: map['name'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        isFavorite: map['isFavourite'],
        // imageFile: File(map['imageFilePath'] ??= null));
        imageFile: File(map['imageFilePath']));
  }
}
