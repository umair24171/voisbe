class UserAccount {
  final String name;
  final String email;
  final String password;
  final String profileImage;

  UserAccount({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.password,
  });

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      name: map['name'],
      email: map['email'],
      profileImage: map['profileImage'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'password': password,
    };
  }
}
