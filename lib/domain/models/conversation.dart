import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType { direct, group }

enum MessageType { text, image }

enum MessageStatus { sent, delivered, read }

// Conversation (room) model
class Conversation {
  final String id;
  final List<String> participantIds;
  final ChatType type;
  final String? groupName;
  final String? groupImageUrl;
  final ChatMessage? lastMessage;
  final DateTime lastUpdatedAt;
  final Map<String, DateTime> lastRead; // userId -> timestamp
  final List<String> typing; // userIds currently typing

  Conversation({
    required this.id,
    required this.participantIds,
    required this.type,
    this.groupName,
    this.groupImageUrl,
    this.lastMessage,
    required this.lastUpdatedAt,
    required this.lastRead,
    required this.typing,
  });

  factory Conversation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Conversation(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      type:
          (data['type'] as String) == 'group'
              ? ChatType.group
              : ChatType.direct,
      groupName: data['groupName'] as String?,
      groupImageUrl: data['groupImageUrl'] as String?,
      lastMessage:
          data['lastMessage'] != null
              ? ChatMessage.fromMap(
                Map<String, dynamic>.from(data['lastMessage'] as Map),
                doc.id,
              )
              : null,
      lastUpdatedAt: (data['lastUpdatedAt'] as Timestamp).toDate(),
      lastRead:
          (data['lastRead'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as Timestamp).toDate()),
          ) ??
          {},
      typing: List<String>.from(data['typing'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'participantIds': participantIds,
    'type': type == ChatType.group ? 'group' : 'direct',
    if (groupName != null) 'groupName': groupName,
    if (groupImageUrl != null) 'groupImageUrl': groupImageUrl,
    if (lastMessage != null) 'lastMessage': lastMessage!.toMap(),
    'lastUpdatedAt': Timestamp.fromDate(lastUpdatedAt),
    'lastRead': lastRead.map((k, v) => MapEntry(k, Timestamp.fromDate(v))),
    'typing': typing,
  };

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    ChatType? type,
    String? groupName,
    String? groupImageUrl,
    ChatMessage? lastMessage,
    DateTime? lastUpdatedAt,
    Map<String, DateTime>? lastRead,
    List<String>? typing,
  }) {
    return Conversation(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
      type: type ?? this.type,
      groupName: groupName ?? this.groupName,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      lastRead: lastRead ?? this.lastRead,
      typing: typing ?? this.typing,
    );
  }

  @override
  bool operator ==(covariant Conversation other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

// Message model
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String? text;
  final DateTime timestamp;
  final MessageType type;
  final MessageStatus status;
  final String? imageUrl;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.text,
    required this.timestamp,
    required this.type,
    this.status = MessageStatus.sent,
    this.imageUrl,
  });

  /// For Firestore documents
  factory ChatMessage.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String conversationId,
  ) {
    final data = doc.data()!;
    return ChatMessage.fromMap({...data, 'id': doc.id}, conversationId);
  }

  /// For embedded lastMessage maps
  factory ChatMessage.fromMap(Map<String, dynamic> map, String conversationId) {
    return ChatMessage(
      id: map['id'] as String,
      conversationId: conversationId,
      senderId: map['senderId'] as String,
      text: map['text'] as String?,
      imageUrl: map['imageUrl'] as String?,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      type: map['type'] == 'image' ? MessageType.image : MessageType.text,
      status: _statusFromString(map['status'] as String?),
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    if (text != null) 'text': text,
    if (imageUrl != null) 'imageUrl': imageUrl,
    'timestamp': Timestamp.fromDate(timestamp),
    'type': type == MessageType.image ? 'image' : 'text',
    'status': _statusToString(status),
  };

  static MessageStatus _statusFromString(String? s) {
    switch (s) {
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'sent':
      default:
        return MessageStatus.sent;
    }
  }

  static String _statusToString(MessageStatus status) {
    switch (status) {
      case MessageStatus.delivered:
        return 'delivered';
      case MessageStatus.read:
        return 'read';
      case MessageStatus.sent:
        return 'sent';
    }
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    MessageType? type,
    MessageStatus? status,
    String? imageUrl,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
