import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_project/calender_event_listview.dart';
import 'package:form_project/extension.dart';
import 'package:form_project/size_config.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime selectedDay = DateTime.now();
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> get getWeekDates {
    int weekday = selectedDay.weekday == 7 ? 0 : selectedDay.weekday;
    DateTime start = selectedDay.subtract(Duration(days: weekday));

    final result = List.generate(7, (i) {
      return start.add(Duration(days: start.weekday + (i - 7)));
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    getWeekDates;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3F1554),
        title: Text(
          const String.fromEnvironment("APPNAME"),
          style: const TextStyle(fontSize: 32),
          textScaleFactor: SizeConfig.textScaleFactor(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              onDaySelected: (day, focus) {
                selectedDay = day;
                setState(() {});
              },
              availableGestures: AvailableGestures.horizontalSwipe,
              focusedDay: selectedDay,
              currentDay: DateTime.now(),
              selectedDayPredicate: (day) {
                final formated = "$day".toDateFormat('yyyy-MM-dd');
                final selected = "$selectedDay".toDateFormat('yyyy-MM-dd');
                return formated == selected ? true : false;
              },
              calendarFormat:
                  isExpanded ? CalendarFormat.month : CalendarFormat.week,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarStyle: CalendarStyle(
                todayDecoration: const BoxDecoration(
                  color: Color(0xFFEC684A),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(color: Colors.black),
                selectedDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: const Color(0xFFEC684A),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              // eventLoader: (day) {
              //   return [];
              // },
              daysOfWeekHeight: isExpanded ? 40 : 0,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarBuilders: CalendarBuilders(
                dowBuilder: (a, b) => isExpanded ? null : const SizedBox(),
                defaultBuilder: (_, day, focusedDay) {
                  if (isExpanded) return null;

                  final selected = "$selectedDay".toDateFormat("yyyy-MM-dd");
                  final focused = "$day".toDateFormat("yyyy-MM-dd");

                  return UnExpandedDayWidget(
                    day: day,
                    isSelected: focused == selected,
                    isExpanded: isExpanded,
                  );
                },
                disabledBuilder: (context, day, focusedDay) {
                  if (isExpanded) return null;

                  final selected = "$selectedDay".toDateFormat("yyyy-MM-dd");
                  final focused = "$day".toDateFormat("yyyy-MM-dd");

                  return UnExpandedDayWidget(
                    day: day,
                    isSelected: focused == selected,
                    isExpanded: isExpanded,
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  if (isExpanded) return null;

                  final selected = "$selectedDay".toDateFormat("yyyy-MM-dd");
                  final focused = "$day".toDateFormat("yyyy-MM-dd");

                  return UnExpandedDayWidget(
                    day: day,
                    isSelected: focused == selected,
                    isExpanded: isExpanded,
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  if (isExpanded) return null;

                  final selected = "$selectedDay".toDateFormat("yyyy-MM-dd");
                  final focused = "$day".toDateFormat("yyyy-MM-dd");

                  return UnExpandedDayWidget(
                    day: day,
                    isSelected: focused == selected,
                    isExpanded: isExpanded,
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                isExpanded = !isExpanded;
                setState(() {});
              },
              splashRadius: 20,
              icon: Icon(
                isExpanded
                    ? CupertinoIcons.chevron_up
                    : CupertinoIcons.chevron_down,
              ),
            ),
            ListView.separated(
              itemCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (a, b) => const Divider(
                color: Colors.black12,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final day = getWeekDates[index];
                final weekname = "$day".toDateFormat("EE");
                final date = day.day;
                return Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.3,
                      child: Center(
                        child: Text(
                          "$weekname $date",
                          textScaleFactor: SizeConfig.textScaleFactor(context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return IntrinsicHeight(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  ...List.generate(4, (index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const CalenderEventListView();
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: constraints.maxWidth * 0.7,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE3E8ED),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              index.isEven
                                                  ? "InUnity Innovation - Hackathon Man"
                                                  : "eWaste Hackathon",
                                              textScaleFactor:
                                                  SizeConfig.textScaleFactor(
                                                      context),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "10am - 12pm",
                                              textScaleFactor:
                                                  SizeConfig.textScaleFactor(
                                                      context),
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UnExpandedDayWidget extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final bool isExpanded;
  const UnExpandedDayWidget({
    super.key,
    required this.day,
    required this.isSelected,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    print(isSelected);
    return Container(
      width: 40,
      height: 100,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(18),
          top: Radius.circular(18),
        ),
        border: Border.all(
          color: !isExpanded && isSelected
              ? const Color(0xFFEC684A)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$day".toDateFormat("EEE"),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Text(
            day.day.toString(),
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
