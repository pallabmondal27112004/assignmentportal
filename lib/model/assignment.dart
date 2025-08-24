class Assignment {
  final int id;
  final String title;
  final String fileUrl;

  Assignment({required this.id, required this.title, required this.fileUrl});

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'],
      title: json['title'],
      fileUrl: json['file_path'],
    );
  }
}
