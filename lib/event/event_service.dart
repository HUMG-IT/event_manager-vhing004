import 'package:localstore/localstore.dart';
import 'event_model.dart';

class EventService {
  final db = Localstore.getInstance(useSupportDir: true);

  final path = 'events';

  Future<List<EventModel>> getAllEvents() async {
    final eventsMap = await db.collection(path).get();

    if (eventsMap != null) {
      return eventsMap.entries.map((entry) {
        final eventData = entry.value as Map<String, dynamic>;
        if (!eventData.containsKey('id')) {
          eventData['id'] = entry.key.split('/').last;
        }
        return EventModel.fromMap(eventData);
      }).toList();
    }
    return [];
  }

// Ham luu 1 su kien vao LocalStore
  Future<void> saveEvent(EventModel item) async {
    // neu id ko to tai thi lay 1 id ngau nhien
    item.id ??= db.collection(path).doc().id;
    await db.collection(path).doc(item.id).set(item.toMap());
  }

  // ham xoa 1 su kien tu localSore
  Future<void> deleteEvent(EventModel item) async {
    await db.collection(path).doc(item.id).delete();
  }
}
