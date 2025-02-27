


class Users  {
  String? userId;

  String? name;
  String? username;
  String? email;

  String? role;


  Users({
    required this.userId,

    this.email,

    this.role,
  this.name,
    this.username,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['userId'].toString() ,
      email: json['email'],
      role: json['role'],
      name: json['firstname'],
      username: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,

      'email': email,

      'name': name,
      'role': role,

    };
  }
}
