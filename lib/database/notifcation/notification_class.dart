class Notifications {
  String? id;
  String? userId;
  String? description;
  String? date;
  String? title;

  Notifications({
    this.title,
    this.id,
    this.userId,
    this.description,
    this.date,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      title: json['title'],
      userId: json['userId'],
      description: json['description'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
