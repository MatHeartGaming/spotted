import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotted/config/config.dart';
import 'package:spotted/domain/datasources/datasources.dart';
import 'package:spotted/domain/models/conversation.dart';

class ChatDatasourceFirebaseImpl implements ChatDatasource {
  final FirebaseFirestore _firestore;
  ChatDatasourceFirebaseImpl([FirebaseFirestore? instance])
    : _firestore = instance ?? FirebaseFirestore.instance;

  CollectionReference<Conversation> get _convoRef => _firestore
      .collection(FirestoreDbCollections.conversations)
      .withConverter<Conversation>(
        fromFirestore: (snap, _) => Conversation.fromDoc(snap),
        toFirestore: (conv, _) => conv.toMap(),
      );

  CollectionReference<ChatMessageModel> _msgRef(String convoId) => _convoRef
      .doc(convoId)
      .collection('Messages')
      .withConverter<ChatMessageModel>(
        fromFirestore: (snap, _) => ChatMessageModel.fromDoc(snap, convoId),
        toFirestore: (msg, _) => msg.toMap(),
      );

  @override
  Stream<List<Conversation>> getConversations(String userId) {
    return _convoRef
        .where('participantIds', arrayContains: userId)
        .orderBy('lastUpdatedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  @override
  Future<Conversation> getConversation(String id) async {
    // Fetch the document snapshot, with your converter attached
    final docSnap = await _convoRef.doc(id).get();

    // .data() returns Conversation? because the doc might not exist
    final convo = docSnap.data();
    if (convo == null) {
      // Handle the “not found” case as you prefer:
      throw StateError('Conversation with id "$id" not found');
      // Or if you’d rather return null instead of throwing:
      // return Future.value(null);
    }

    return convo;
  }

  @override
  Future<Conversation?> createConversation(Conversation conversation) async {
    try {
      final docRef = _convoRef.doc();
      final convWithId = conversation.copyWith(id: docRef.id);
      await docRef.set(convWithId);
      return convWithId;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> updateConversation(Conversation conversation) =>
      _convoRef.doc(conversation.id).set(conversation);

  @override
  Stream<List<ChatMessageModel>> getMessages(String conversationId) {
    return _msgRef(conversationId)
        .orderBy('timestamp')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  @override
  Future<ChatMessageModel?> sendMessage(ChatMessageModel message) async {
    try {
      final msgRef = _msgRef(message.conversationId).doc();
      final messageWithId = message.copyWith(id: msgRef.id);
      final now = DateTime.now();
      final batch = _firestore.batch();
      batch.set(msgRef, messageWithId);
      batch.update(_convoRef.doc(message.conversationId), {
        'lastMessage': messageWithId.toMap().cast<String, Object?>(),
        'lastUpdatedAt': Timestamp.fromDate(now),
      });
      await batch.commit();
      return messageWithId;
    } catch (error) {
      logger.e('Error sending message $error');
      return null;
    }
  }

  @override
  Future<void> updateTyping(String conversationId, List<String> typingUsers) =>
      _convoRef.doc(conversationId).update({'typing': typingUsers});

  @override
  Future<void> updateLastRead(
    String conversationId,
    String userId,
    DateTime timestamp,
  ) => _convoRef.doc(conversationId).update({
    'lastRead.$userId': Timestamp.fromDate(timestamp),
  });

  @override
  Future<Conversation> getOrCreateDirectChat(String userA, String userB) async {
    // 1) Try to find an existing direct chat
    final snap =
        await _convoRef
            .where('type', isEqualTo: 'direct')
            .where('participantIds', arrayContains: userA)
            .get();
    for (var doc in snap.docs) {
      final convo = doc.data();
      if (convo.participantIds.contains(userB)) {
        return convo;
      }
    }

    // 2) Not found ⇒ create new
    final now = DateTime.now();
    final newConvo = Conversation(
      id: '', // will be set by Firestore
      participantIds: [userA, userB],
      type: ChatType.direct,
      lastUpdatedAt: now,
      lastRead: {userA: now, userB: now},
      typing: [],
      lastMessage: null,
      groupName: null,
      groupImageUrl: null,
    );

    final created = await createConversation(newConvo);
    // we know it cannot be null here
    return created!;
  }
}
