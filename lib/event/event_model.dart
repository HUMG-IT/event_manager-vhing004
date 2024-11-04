import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class EventModel {
  String? id;
  DateTime startTime;
  DateTime endTime;
  bool isAllDay;
  String subject;
  String? notes;
  String? recurrenceRule;
  EventModel({
    this.id,
    required this.startTime,
    required this.endTime,
    this.isAllDay = false,
    this.subject = '',
    this.notes,
    this.recurrenceRule,
  });

  EventModel copyWith({
    ValueGetter<String?>? id,
    DateTime? startTime,
    DateTime? endTime,
    bool? isAllDay,
    String? subject,
    ValueGetter<String?>? notes,
    ValueGetter<String?>? recurrenceRule,
  }) {
    return EventModel(
      id: id != null ? id() : this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAllDay: isAllDay ?? this.isAllDay,
      subject: subject ?? this.subject,
      notes: notes != null ? notes() : this.notes,
      recurrenceRule:
          recurrenceRule != null ? recurrenceRule() : this.recurrenceRule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'isAllDay': isAllDay,
      'subject': subject,
      'notes': notes,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime']),
      isAllDay: map['isAllDay'] ?? false,
      subject: map['subject'] ?? '',
      notes: map['notes'],
      recurrenceRule: map['recurrenceRule'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EventModel(id: $id, startTime: $startTime, endTime: $endTime, isAllDay: $isAllDay, subject: $subject, notes: $notes, recurrenceRule: $recurrenceRule)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EventModel &&
        other.id == id &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.isAllDay == isAllDay &&
        other.subject == subject &&
        other.notes == notes &&
        other.recurrenceRule == recurrenceRule;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        isAllDay.hashCode ^
        subject.hashCode ^
        notes.hashCode ^
        recurrenceRule.hashCode;
  }
}



extension ExtEventModel on EventModel {
  String get formatedStartTimeString => _formatTimeString(startTime);
  String get formatedEndTimeString => _formatTimeString(endTime);

  String _formatTimeString(DateTime datetime) {
    final DateFormat formatter = DateFormat('H:mm, dd/MM/yyyy');
    return formatter.format(datetime);
  }
}
