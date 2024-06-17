class UserModel {
  String name;
  String email;

  UserModel({ required this.name, required this.email});

  // Firebase'dan kelgan ma'lumotlarni modelga o'girish uchun factory konstruktori
  factory UserModel.fromMap(Map data) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }

  // Modelni Map'ga o'girish uchun metod
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
