DateTime _date(dynamic v) =>
    v == null ? DateTime.now() : DateTime.parse(v as String).toLocal();

class Profile {
  final String id;
  final String name;
  final String bio;
  final String? avatarUrl;
  final int stars;
  final bool banned;

  const Profile({
    required this.id,
    required this.name,
    this.bio = '',
    this.avatarUrl,
    this.stars = 0,
    this.banned = false,
  });

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as String,
        name: (j['name'] ?? '') as String,
        bio: (j['bio'] ?? '') as String,
        avatarUrl: j['avatar_url'] as String?,
        stars: (j['stars'] ?? 0) as int,
        banned: (j['banned'] ?? false) as bool,
      );
}

/// One row on the home screen.
class ChatSummary {
  final String id;
  final bool isRoom;
  final String title;
  final String? imageUrl;
  final String? otherUserId;
  final String? lastMessage;
  final DateTime lastMessageAt;
  final int unread;

  const ChatSummary({
    required this.id,
    required this.isRoom,
    required this.title,
    this.imageUrl,
    this.otherUserId,
    this.lastMessage,
    required this.lastMessageAt,
    this.unread = 0,
  });

  factory ChatSummary.fromJson(Map<String, dynamic> j) => ChatSummary(
        id: j['id'] as String,
        isRoom: j['kind'] == 'room',
        title: (j['title'] ?? '') as String,
        imageUrl: j['image_url'] as String?,
        otherUserId: j['other_user'] as String?,
        lastMessage: j['last_message'] as String?,
        lastMessageAt: _date(j['last_message_at']),
        unread: (j['unread'] ?? 0) as int,
      );
}

class Room {
  final String id;
  final String name;
  final String description;
  final bool hasPassword;
  final int members;
  final bool isMember;

  const Room({
    required this.id,
    required this.name,
    required this.description,
    required this.hasPassword,
    required this.members,
    required this.isMember,
  });

  factory Room.fromJson(Map<String, dynamic> j) => Room(
        id: j['id'] as String,
        name: (j['name'] ?? '') as String,
        description: (j['description'] ?? '') as String,
        hasPassword: (j['has_password'] ?? false) as bool,
        members: (j['members'] ?? 0) as int,
        isMember: (j['is_member'] ?? false) as bool,
      );
}

class Message {
  final int id;
  final String conversationId;
  final String senderId;
  final String? body;
  final String? imageUrl;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.body,
    this.imageUrl,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> j) => Message(
        id: j['id'] as int,
        conversationId: (j['conversation_id'] ?? '') as String,
        senderId: j['sender_id'] as String,
        body: j['body'] as String?,
        imageUrl: j['image_url'] as String?,
        createdAt: _date(j['created_at']),
      );
}

class ProfileComment {
  final int id;
  final Profile author;
  final String body;
  final DateTime createdAt;

  const ProfileComment({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
  });

  factory ProfileComment.fromJson(Map<String, dynamic> j) => ProfileComment(
        id: j['id'] as int,
        author: Profile.fromJson(j['author'] as Map<String, dynamic>),
        body: j['body'] as String,
        createdAt: _date(j['created_at']),
      );
}

/// An announcement from the app managers, to everyone or to one room.
class Broadcast {
  final int id;
  final String title;
  final String body;
  final String? roomId;
  final String? roomName;
  final DateTime createdAt;

  const Broadcast({
    required this.id,
    required this.title,
    required this.body,
    this.roomId,
    this.roomName,
    required this.createdAt,
  });

  factory Broadcast.fromJson(Map<String, dynamic> j) => Broadcast(
        id: j['id'] as int,
        title: j['title'] as String,
        body: j['body'] as String,
        roomId: j['room_id'] as String?,
        roomName: (j['room'] as Map<String, dynamic>?)?['name'] as String?,
        createdAt: _date(j['created_at']),
      );
}
