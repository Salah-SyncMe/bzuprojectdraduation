class Post {
  Post({
    required this.images,
    required this.imageUrl,
    required this.name,
    required this.createAt,
    required this.text,
    required this.id,
    required this.email,
  });
  late final List<String> images;
  late final String imageUrl;
  late final String name;
  late final String createAt;
  late final String text;
  late final String id;
  late final String email;

  Post.fromJson(Map<String, dynamic> json) {
    images = List.castFrom<dynamic, String>(json['images']);
    imageUrl = json['imageUrl'] ?? '';
    name = json['name'] ?? '';
    createAt = json['Create_at'] ?? '';
    text = json['text'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['images'] = images;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['Create_at'] = createAt;
    data['text'] = text;
    data['id'] = id;
    data['email'] = email;
    return data;
  }
}
