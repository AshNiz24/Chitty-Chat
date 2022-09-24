import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseServices {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addData(String groupname, String time) async {
    final docRef = await firebaseFirestore.collection('chats').add({
      'group': groupname,
    });
    await docRef.set({
      'group': groupname,
      'id': docRef.id,
      'time': time,
      'last message': '',
      'last user': '',
      'last user mail': '',
    });
  }

  Future<void> addMessage(
      String id, String message, String time, String groupname) async {
    final user = FirebaseAuth.instance.currentUser;
    await firebaseFirestore
        .collection('chats')
        .doc(id)
        .collection('messages')
        .add({
      'Username': user!.displayName,
      'Email': user.email,
      'Profile pic': user.photoURL,
      'Message': message,
      'Time': time,
    }).then((value) {
      firebaseFirestore.collection('chats').doc(id).update({
        'time': time,
        'last message': message,
        'last user':
            user.displayName!.substring(0, user.displayName!.indexOf(' ')),
        'last user mail': user.email,
      });
    });
  }
}
