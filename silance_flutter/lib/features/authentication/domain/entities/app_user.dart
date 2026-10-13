import 'package:equatable/equatable.dart';

class const AppUser({
  required final String id,
  required final String phone,
  required final String? username,
  required final String displayName,
}) extends Equatable {
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

  @override
  List<Object?> get props => [id, phone, username, displayName];
}
