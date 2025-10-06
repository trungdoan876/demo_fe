class ApiUser {
  final String id;
  final String email;
  final String name;
  final String? createdAt;
  final String? updatedAt;

  const ApiUser({
    required this.id,
    required this.email,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });
  //Convert từ API JSON
  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
