import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatType { direct, group }

enum MessageType { text, image }

enum MyMessageStatus { sent, delivered, read }

// Conversation (room) model
class Conversation {
  final String id;
  final List<String> participantIds;
  final ChatType type;
  final String? groupName;
  final String? groupImageUrl;
  final ChatMessageModel? lastMessage;
  final DateTime lastUpdatedAt;
  final Map<String, DateTime> lastRead; // userId -> timestamp
  final List<String> typing; // userIds currently typing
  final bool isAnonymous;

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
    this.isAnonymous = false,
  });

  Conversation.empty({
    this.id = '',
    this.participantIds = const [],
    this.type = ChatType.direct,
    this.groupName = '',
    this.groupImageUrl = '',
    ChatMessageModel? lastMessage,
    DateTime? lastUpdatedAt,
    Map<String, DateTime>? lastRead,
    this.isAnonymous = false,
    this.typing = const [],
  }) : lastMessage = lastMessage ?? ChatMessageModel.empty(),
       lastUpdatedAt = lastUpdatedAt ?? DateTime.now(),
       lastRead = lastRead ?? Map.from({});

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
              ? ChatMessageModel.fromMap(
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
      isAnonymous: data['is_anonymous'] as bool? ?? false,
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
    'is_anonymous': isAnonymous,
  };

  Conversation copyWith({
    String? id,
    List<String>? participantIds,
    ChatType? type,
    String? groupName,
    String? groupImageUrl,
    ChatMessageModel? lastMessage,
    DateTime? lastUpdatedAt,
    Map<String, DateTime>? lastRead,
    List<String>? typing,
    bool? isAnonymous,
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
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }

  @override
  bool operator ==(covariant Conversation other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}

// Message model
class ChatMessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String? text;
  final DateTime timestamp;
  final MessageType type;
  final MyMessageStatus status;
  final String? imageUrl;

  ChatMessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.text,
    DateTime? timestamp,
    required this.type,
    this.status = MyMessageStatus.sent,
    this.imageUrl,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessageModel.empty({
    this.id = '',
    this.conversationId = '',
    this.senderId = '',
    this.text = '',
    DateTime? timestamp,
    this.type = MessageType.text,
    this.status = MyMessageStatus.sent,
    this.imageUrl,
  }) : timestamp = timestamp ?? DateTime.now();

  /// For Firestore documents
  factory ChatMessageModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String conversationId,
  ) {
    final data = doc.data()!;
    return ChatMessageModel.fromMap({...data, 'id': doc.id}, conversationId);
  }

  /// For embedded lastMessage maps
  factory ChatMessageModel.fromMap(
    Map<String, dynamic> map,
    String conversationId,
  ) {
    return ChatMessageModel(
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

  Map<String, Object?> toMap() => {
    'id': id,
    'senderId': senderId,
    if (text != null) 'text': text,
    if (imageUrl != null) 'imageUrl': imageUrl,
    'timestamp': Timestamp.fromDate(timestamp),
    'type': type == MessageType.image ? 'image' : 'text',
    'status': _statusToString(status),
  };

  static MyMessageStatus _statusFromString(String? s) {
    switch (s) {
      case 'delivered':
        return MyMessageStatus.delivered;
      case 'read':
        return MyMessageStatus.read;
      case 'sent':
      default:
        return MyMessageStatus.sent;
    }
  }

  static String _statusToString(MyMessageStatus status) {
    switch (status) {
      case MyMessageStatus.delivered:
        return 'delivered';
      case MyMessageStatus.read:
        return 'read';
      case MyMessageStatus.sent:
        return 'sent';
    }
  }

  ChatMessageModel copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? text,
    DateTime? timestamp,
    MessageType? type,
    MyMessageStatus? status,
    String? imageUrl,
  }) {
    return ChatMessageModel(
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
  bool operator ==(covariant ChatMessageModel other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
