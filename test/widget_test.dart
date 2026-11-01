import 'package:chatapp/data/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ChatSummary parses RPC row', () {
    final c = ChatSummary.fromJson({
      'id': 'a',
      'kind': 'room',
      'title': 'عام',
      'image_url': null,
      'other_user': null,
      'last_message': 'مرحبا',
      'last_message_at': '2026-10-31T10:00:00Z',
      'unread': 3,
    });
    expect(c.isRoom, isTrue);
    expect(c.unread, 3);
    expect(c.title, 'عام');
  });

  test('Message parses image-only row', () {
    final m = Message.fromJson({
      'id': 1,
      'sender_id': 'u',
      'body': null,
      'image_url': 'https://x/y.jpg',
      'created_at': '2026-10-31T10:00:00Z',
    });
    expect(m.body, isNull);
    expect(m.imageUrl, isNotNull);
  });

  test('Broadcast parses row with room name', () {
    final b = Broadcast.fromJson({
      'id': 7,
      'title': 'تنبيه',
      'body': 'صيانة الليلة',
      'room_id': 'r',
      'created_at': '2026-11-01T10:00:00Z',
      'room': {'name': 'عام'},
    });
    expect(b.roomName, 'عام');
    expect(b.title, 'تنبيه');
  });

  test('Profile reads banned flag', () {
    final p = Profile.fromJson({'id': 'u', 'name': 'سارة', 'banned': true});
    expect(p.banned, isTrue);
  });
}
