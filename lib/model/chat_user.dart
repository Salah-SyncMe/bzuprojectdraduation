class ChatUser {
  ChatUser(
      {required this.image,
      required this.name,
      required this.about,
      required this.createdAt,
      required this.isOnline,
      required this.id,
      required this.lastActive,
      required this.email,
      required this.pushToken,
      required this.password,
      required this.subImage});
  late String image;
  late String subImage;
  late String name;
  late String about;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;
  late String password;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    subImage = json['sub_image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    password = json['password'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['sub_image'] = subImage;
    data['name'] = name;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['password'] = password;
    return data;
  }
}
