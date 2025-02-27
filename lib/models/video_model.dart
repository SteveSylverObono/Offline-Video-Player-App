class Video {
  final String id;
  final String title;
  final String filePath;
  final String thumbnailPath;
  final int duration;
  final DateTime addedDate;
  final bool isDownloaded;
  final String? description;

  Video({
    required this.id,
    required this.title,
    required this.filePath,
    required this.thumbnailPath,
    required this.duration,
    required this.addedDate,
    required this.isDownloaded,
    this.description,
  });

  Video copyWith({
    String? id,
    String? title,
    String? description,
    String? filePath,
    String? thumbnailPath,
    int? duration,
    DateTime? addedDate,
    bool? isDownloaded,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      addedDate: addedDate ?? this.addedDate,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
      'duration': duration,
      'addedDate': addedDate.toIso8601String(),
      'isDownloaded': isDownloaded ? 1 : 0,
      'description': description,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map['id'],
      title: map['title'],
      filePath: map['filePath'],
      thumbnailPath: map['thumbnailPath'],
      duration: map['duration'],
      addedDate: DateTime.parse(map['addedDate']),
      isDownloaded: map['isDownloaded'] == 1,
      description: map['description'],
    );
  }
}
