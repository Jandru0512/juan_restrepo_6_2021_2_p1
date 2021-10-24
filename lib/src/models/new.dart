class New {
  String author = '';
  String content = '';
  String date = '';
  String imageUrl = '';
  String? readMoreUrl;
  String time = '';
  String title = '';
  String url = '';

  New(
      {required this.author,
      required this.content,
      required this.date,
      required this.imageUrl,
      this.readMoreUrl,
      required this.time,
      required this.title,
      required this.url});

  New.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    author = json['author'];
    date = json['date'];
    imageUrl = json['imageUrl'];
    readMoreUrl = json['readMoreUrl'];
    time = json['time'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['author'] = author;
    data['date'] = date;
    data['imageUrl'] = imageUrl;
    data['readMoreUrl'] = readMoreUrl;
    data['time'] = time;
    data['title'] = title;
    data['url'] = url;
    return data;
  }
}
