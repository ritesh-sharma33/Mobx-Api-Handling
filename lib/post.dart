
class Post {
  final String id, title, body;

  Post({this.id, this.title, this.body});

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      title: json['title'],
      body: json['body']
    );
  }
}