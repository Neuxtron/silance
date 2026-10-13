class HomeUser({
  required final String id,
  required final String phone,
  required final String? username,
  required final String displayName,
}) {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'display_name': displayName,
    };
  }

  factory HomeUser.fromJson(Map<String, dynamic> json) {
    return HomeUser(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
      displayName: json['display_name'],
    );
  }
}
