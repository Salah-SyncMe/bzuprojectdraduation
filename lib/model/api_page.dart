class PageUser {
  PageUser({
    required this.image,
    required this.name,
    required this.adminName,
    required this.about,
    required this.createdAt,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  late String image;
  late String name;
  late String adminName;
  late String about;
  late String createdAt;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  PageUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    adminName = json['admin_name'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['admin_name'] = adminName;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
