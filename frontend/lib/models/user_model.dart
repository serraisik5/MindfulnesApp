class UserModel {
  final int? id;
  final String email;
  final String password;
  final String firstName;
  final String? lastName;
  final String? gender;
  final String? birthday;

  UserModel({
    this.id,
    required this.email,
    required this.password,
    required this.firstName,
    this.lastName,
    this.gender,
    this.birthday,
  });

  Map<String, dynamic> toRegisterJson() {
    return {
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "gender": gender,
      "birthday": birthday,
    };
  }

  Map<String, dynamic> toLoginJson() {
    return {
      "email": email,
      "password": password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      password: "", // Don’t store password from response
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}
