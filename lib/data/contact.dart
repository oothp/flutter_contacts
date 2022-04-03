class Contact {
  String name;
  String email;
  String phoneNumber;
  bool isFavorite;

  // constructor with optional params.
  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
  });
}
