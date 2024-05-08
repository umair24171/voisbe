import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:social_notes/screens/add_note_screen/provider/note_provider.dart';
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
      String receiverToken,
      context) async {
    try {
      Provider.of<NoteProvider>(context, listen: false).setIsLoading(true);
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
      Provider.of<NoteProvider>(context, listen: false).setIsLoading(false);
    } catch (e) {
      Provider.of<NoteProvider>(context, listen: false).setIsLoading(false);
      log(e.toString());
    }
  }
}
