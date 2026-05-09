class UserRequest {
  String nama;
  String email;
  String? password;

  UserRequest({required this.email, required this.nama, this.password});

  Map<dynamic, String> toJson() => {
    "nama": nama,
    "email": email,
    "password": ?password,
  };
}

class UserResponse {
  String id;
  String nama;
  String email;

  UserResponse({required this.id, required this.nama, required this.email});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json["id"],
      nama: json["nama"],
      email: json["email"],
    );
  }
}
