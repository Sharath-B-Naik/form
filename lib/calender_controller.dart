class CalendarController {
  DateTime selectedDay = DateTime.now();
  bool isExpanded = true;

  List<DateTime> get getWeekDates {
    int weekday = selectedDay.weekday == 7 ? 0 : selectedDay.weekday;
    DateTime start = selectedDay.subtract(Duration(days: weekday));

    final result = List.generate(7, (i) {
      return start.add(Duration(days: start.weekday + (i - 7)));
    });
    return result;
  }
}
