import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc_firebase_crud/app/core/models/post_model.dart';
import 'package:flutter_bloc_firebase_crud/app/services/shared_pref.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final SharedPreferencesManager _sharedPreferencesManager =
      SharedPreferencesManager();

  Future<void> addPost(dynamic postModel) async {
    await _db.collection("posts").add(postModel);
  }

  Future<void> updatePost(String id, dynamic postModel) async {
    await _db.collection("posts").doc(id).update(postModel);
  }

  Future<void> deletePost(String documentId) async {
    await _db.collection("posts").doc(documentId).delete();
  }

  Future<List<PostModel>> retrieveMyPost(String uid) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("posts").where('userId', isEqualTo: uid).get();
    return snapshot.docs
        .map((docSnapshot) => PostModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<String?> getUserId() {
    return _sharedPreferencesManager.getString('user_id');
  }
}
