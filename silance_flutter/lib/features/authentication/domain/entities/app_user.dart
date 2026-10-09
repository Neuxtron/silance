class AppUser {
  final String id;
  final String? phone;
  final String? username;
  final String displayName;

  new({
    required this.id,
    required this.phone,
    required this.username,
    required this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'username': username,
      'display_name': displayName,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      phone: json['phone'],
      username: json['username'],
      displayName: json['display_name'],
    );
  }
}
