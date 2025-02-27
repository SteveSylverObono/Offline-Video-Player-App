class History {
  String? id;
  String? userId;
  String? communityId;
  String? amount;
  String? date;
  String? communityName;

  History({
    this.id,
    this.userId,
    this.communityId,
    this.amount,
    this.date, 
    this.communityName,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      communityId: json['communityId'].toString(),
      amount: json['amount'].toString(),
      date: json['date'].toString(),
      communityName: json['communityName'].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'communityId': communityId,
      'amount': amount,
      'date': date,
      'communityName':communityName
    };
  }
}
