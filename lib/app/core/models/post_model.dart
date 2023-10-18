import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? cover;
  int? status;
  Timestamp? timestamp;
  PostModel({
    this.id,
    this.title,
    this.userId,
    this.description,
    this.cover,
    this.status,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'cover': cover,
      'status': status,
      'timestamp': timestamp
    };
  }

  PostModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        userId = doc.data()!["userId"],
        title = doc.data()!["title"],
        description = doc.data()!["description"],
        cover = doc.data()!["cover"],
        status = doc.data()!["status"],
        timestamp = doc.data()!['timestamp'];

  PostModel copyWith(
      {String? id,
      String? userId,
      String? title,
      String? description,
      String? cover,
      int? status,
      Timestamp? timestamp}) {
    return PostModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        cover: cover ?? this.cover,
        status: status ?? this.status,
        timestamp: timestamp ?? this.timestamp);
  }
}
