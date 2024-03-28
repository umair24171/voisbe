import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_notes/screens/chat_screen.dart/model/chat_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  sendMessage(
      ChatModel chat,
      String chatId,
      String usersId,
      String receiverName,
      String receiverImage,
      String senderToken,
      String receiverToken) async {
    try {
      await _firestore
          .collection('chats')
          .doc(usersId)
          .collection('messages')
          .doc(chatId)
          .set(chat.toMap());
      await _firestore.collection('chats').doc(usersId).set({
        'chatID': chatId,
        'senderToken': senderToken,
        'receiverToken': receiverToken,
        'senderId': chat.senderId,
        'receiverId': chat.receiverId,
        'message': chat.message,
        'time': chat.time,
        'senderImage': chat.avatarUrl,
        'receiverImage': receiverImage,
        'senderName': chat.name,
        'receiverName': receiverName,
        'seen': false,
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
