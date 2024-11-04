import 'package:event_manager/event/event_data_source.dart';
import 'package:event_manager/event/event_detail.dart';
import 'package:event_manager/event/event_model.dart';
import 'package:event_manager/event/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/appp_localization.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// ignore: camel_case_types
class Event_View extends StatefulWidget {
  const Event_View({super.key});

  @override
  State<Event_View> createState() => _Event_ViewState();
}

// ignore: camel_case_types
class _Event_ViewState extends State<Event_View> {
  final eventService = EventService();
  // Danh sách sự kiện
  List<EventModel> items = [];

  // Tạo CalendarController để điều khiển sfCalendar
  final calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    calendarController.view = CalendarView.day;
    loadEvent();
  }

  Future<void> loadEvent() async {
    final events = await eventService.getAllEvents();
    setState(() {
      items = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    final al = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(al.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => CalendarView.values.map((view) {
              return PopupMenuItem<CalendarView>(
                value: view,
                child: ListTile(
                  title: Text(view.name),
                ),
              );
            }).toList(),
            icon: getCalendarViewIcon(calendarController.view!),
          ),
          IconButton(
            onPressed: () {
              calendarController.displayDate = DateTime.now();
            },
            icon: const Icon(Icons.today_outlined),
          ),
          IconButton(onPressed: loadEvent, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SfCalendar(
        controller: calendarController,
        dataSource: EventDataSource(items),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onLongPress: (details) {
          // không có sự kiện trong cell
          if (details.targetElement == CalendarElement.calendarCell) {
            final newEvent = EventModel(
                startTime: details.date!,
                endTime: details.date!.add(
                  const Duration(hours: 1),
                ),
                subject: "Sự kiện mới");
            // Điều hướng = cách đưa newEvent vào detail view
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EventDetailView(event: newEvent);
              },
            )).then((value) async {
              // sau khi pop ở detail view
              if (value == true) {
                await loadEvent();
              }
            });
          }
        },
        onTap: (details) {
          // không có sự kiện trong cell
          if (details.targetElement == CalendarElement.calendarCell) {
            final EventModel event = details.appointments!.first;
            // Điều hướng = cách đưa event vào detail view
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EventDetailView(event: event);
              },
            )).then((value) async {
              // sau khi pop ở detail view
              if (value == true) {
                await loadEvent();
              }
            });
          }
        },
      ),
    );
  }

  // Hàm lấy icons tương ứng với calendar view
  Icon getCalendarViewIcon(CalendarView view) {
    switch (view) {
      case CalendarView.day:
        return const Icon(Icons.calendar_view_day_outlined);
      case CalendarView.week:
        return const Icon(Icons.calendar_view_week_outlined);
      case CalendarView.workWeek:
        return const Icon(Icons.work_history_outlined);
      case CalendarView.schedule:
        return const Icon(Icons.schedule_outlined);
      default:
        return const Icon(Icons.calendar_today_outlined);
    }
  }
}
