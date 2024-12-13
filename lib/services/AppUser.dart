class AppUser {
  final String id;
  final String email;
  final String firstname;
  final String lastname;
  final String isEmailVerified;

  AppUser({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.isEmailVerified,
  });

  // Factory constructor to create an AppUser from Firestore data
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'] ?? '',
      email: data['email'] ?? '',
      firstname: data['firstname'] ?? '',
      lastname: data['lastname'] ?? '',
      isEmailVerified: data['isEmailVerified'] ?? 'false',
    );
  }
}
