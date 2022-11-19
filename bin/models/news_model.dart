class News {
  final String? id;
  final String title;
  final String description;
  final String image;
  final DateTime publishDate;
  final DateTime? updateDate;

  const News({
    this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.publishDate,
    this.updateDate,
  });

  factory News.fromJsom(Map<String, dynamic> json) => News(
        id: json['id'] ?? '',
        title: json['title'],
        description: json['description'],
        image: json['image'],
        publishDate: DateTime.fromMicrosecondsSinceEpoch((json['publishDate'])),
        updateDate: json['updateDate'] != null
            ? DateTime.fromMicrosecondsSinceEpoch((json['updateDate']))
            : null,
      );

  Map toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'News(id: $id, title: $title, description: $description, image: $image, publishDate: $publishDate, updateDate: $updateDate)';
  }
}
