class Post {
  Post(
      {required this.type,
      required this.images,
      required this.imageUrl,
      required this.name,
      required this.createAt,
      required this.text,
      required this.id,
      required this.email,
      required this.adminName});
  late final List<String> images;
  late final String imageUrl;
  late final String name;
  late final String createAt;
  late final String text;
  late final String id;
  late final String email;
  late final String adminName;
  late final String type;

  Post.fromJson(Map<String, dynamic> json) {
    images = List.castFrom<dynamic, String>(json['images']);
    imageUrl = json['imageUrl'] ?? '';
    name = json['name'] ?? '';
    adminName = json['admin_name'] ?? '';
    createAt = json['created_at'] ?? '';
    text = json['text'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    type = json['type'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images;
    data['type'] = type;
    data['admin_name'] = adminName;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['created_at'] = createAt;
    data['text'] = text;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
