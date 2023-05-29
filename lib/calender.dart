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
  bool isExpanded = false;
  List<DateTime> selectedDayWeekRow = [];

  @override
  void initState() {
    super.initState();
    selectedDayWeekRow = getWeekDates;
  }

  List<DateTime> get getWeekDates {
    final start = selectedDay.subtract(Duration(days: selectedDay.weekday));
    return List.generate(7, (i) {
      return start.add(Duration(days: start.weekday + i));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                selectedDayWeekRow = getWeekDates;
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
                  isExpanded ? CalendarFormat.week : CalendarFormat.month,
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
              daysOfWeekHeight: 40,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
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
                    ? CupertinoIcons.chevron_down
                    : CupertinoIcons.chevron_up,
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
                final day = selectedDayWeekRow[index];
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
