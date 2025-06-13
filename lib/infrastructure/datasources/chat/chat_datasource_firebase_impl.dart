import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/conversation.dart';

class ChatDatasourceFirebaseImpl implements ChatDatasource {
  final FirebaseFirestore _firestore;
  ChatDatasourceFirebaseImpl([FirebaseFirestore? instance])
      : _firestore = instance ?? FirebaseFirestore.instance;

  // Conversations collection with converter
  CollectionReference<Conversation> get _convoRef => _firestore
      .collection('conversations')
      .withConverter<Conversation>(
        fromFirestore: (snap, _) => Conversation.fromDoc(snap),
        toFirestore: (conv, _) => conv.toMap(),
      );

  // Helper for message subcollection with converter
  CollectionReference<ChatMessage> _msgRef(String convoId) => _convoRef
      .doc(convoId)
      .collection('messages')
      .withConverter<ChatMessage>(
        fromFirestore: (snap, _) => ChatMessage.fromDoc(snap, convoId),
        toFirestore: (msg, _) => msg.toMap(),
      );

  @override
  Stream<List<Conversation>> getConversations(String userId) {
    return _convoRef
        .where('participantIds', arrayContains: userId)
        .orderBy('lastUpdatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => doc.data())
            .toList());
  }

  @override
  Future<Conversation?> createConversation(Conversation conversation) async {
    try {
      final docRef = _convoRef.doc();
      final convWithId = conversation.copyWith(id: docRef.id);
      await docRef.set(convWithId);
      return convWithId;
    } catch (e) {
      // handle/log error
      return null;
    }
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    final docRef = _convoRef.doc(conversation.id);
    await docRef.set(conversation);
  }

  @override
  Stream<List<ChatMessage>> getMessages(String conversationId) {
    return _msgRef(conversationId)
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => doc.data())
            .toList());
  }

  @override
  Future<ChatMessage?> sendMessage(ChatMessage message) async {
    try {
      final msgRef = _msgRef(message.conversationId).doc();
      final messageWithId = message.copyWith(id: msgRef.id);
      final now = DateTime.now();
      
      // Batch write: add message + update conversation summary
      final batch = _firestore.batch();
      batch.set(msgRef, messageWithId.toMap());
      batch.update(
        _convoRef.doc(message.conversationId),
        {
          'lastMessage': messageWithId.toMap(),
          'lastUpdatedAt': Timestamp.fromDate(now),
        },
      );
      await batch.commit();
      return messageWithId;
    } catch (e) {
      // handle/log error
      return null;
    }
  }

  @override
  Future<void> updateTyping(
      String conversationId, List<String> typingUsers) async {
    await _convoRef.doc(conversationId).update({'typing': typingUsers});
  }

  @override
  Future<void> updateLastRead(
      String conversationId, String userId, DateTime timestamp) async {
    await _convoRef.doc(conversationId).
        update({'lastRead.$userId': timestamp});
  }
}