// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ngens/data/gallery_options.dart';

import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:ngens/layout/adaptive.dart';
import 'package:ngens/colors.dart';
import 'package:ngens/data.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// A page that shows a status Dashboard.
class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    final alerts = DummyDataService.getAlerts(context);

    if (isDisplayDesktop(context)) {
      const sortKeyName = 'Dashboard';
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Semantics(
                  sortKey: const OrdinalSortKey(1, name: sortKeyName),
                  child: const _DashboardGrid(spacing: 24),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: Container(
                  width: 400,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(2, name: sortKeyName),
                    child: FocusTraversalGroup(
                      child: _AlertsView(alerts: alerts),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _AlertsView(alerts: alerts.sublist(0, 1)),
              const SizedBox(height: 12),
              const _DashboardGrid(spacing: 12),
            ],
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({Key key, @required this.spacing}) : super(key: key);

  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final textScaleFactor =
          GalleryOptions.of(context).textScaleFactor(context);

      // Only display multiple columns when the constraints allow it and we
      // have a regular text scale factor.
      final minWidthForTwoColumns = 600;
      final hasMultipleColumns = isDisplayDesktop(context) &&
          constraints.maxWidth > minWidthForTwoColumns &&
          textScaleFactor <= 2;
      final boxWidth = hasMultipleColumns
          ? constraints.maxWidth / 2 - spacing / 2
          : double.infinity;

      return Wrap(
        runSpacing: spacing,
        children: [
          Container(
            width: boxWidth,
            child: _ScheduleView(title: 'My Schedule'),
          )
        ],
      );
    });
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView({Key key, this.alerts}) : super(key: key);

  final List<AlertData> alerts;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 4, bottom: 4),
      color: RallyColors.cardBackground,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                isDesktop ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: MergeSemantics(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(GalleryLocalizations.of(context).rallyAlerts),
                  if (!isDesktop)
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                      child: Text(GalleryLocalizations.of(context).rallySeeAll),
                    ),
                ],
              ),
            ),
          ),
          for (AlertData alert in alerts) ...[
            Container(color: RallyColors.primaryBackground, height: 1),
            _Alert(alert: alert),
          ]
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert({
    Key key,
    @required this.alert,
  }) : super(key: key);

  final AlertData alert;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: isDisplayDesktop(context)
            ? const EdgeInsets.symmetric(vertical: 8)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(alert.message),
            ),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(alert.iconData, color: RallyColors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleView extends StatelessWidget {
  final String title;
  List<String> subjectCollection;
  List<Color> colorCollection;
  List<Appointment> appointments;
  _DataSource events;
  _ScheduleView({
    this.title,
  }) {
    appointments = <Appointment>[];
    addAppointmentDetails();
    addAppointments();
    events = _DataSource(appointments);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        color: RallyColors.cardBackground,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          getScheduleViewCalendar(
              events: events, scheduleViewBuilder: scheduleViewBuilder)
        ]));
  }

  /// returns the calendar widget based on the properties passed
  SfCalendar getScheduleViewCalendar(
      {_DataSource events, dynamic scheduleViewBuilder}) {
    return SfCalendar(
      allowViewNavigation: true,
      allowedViews: _allowedViews,
      showDatePickerButton: true,
      scheduleViewMonthHeaderBuilder:
          scheduleViewBuilder as ScheduleViewMonthHeaderBuilder,
      view: CalendarView.schedule,
      dataSource: events,
    );
  }

  /// Returns the builder for schedule view.
  Widget scheduleViewBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final monthName = _getMonthDate(details.date.month);
    return Stack(
      children: [
        Image(
            image: ExactAssetImage('images/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }

  /// Creates the required appointment details as a list.
  void addAppointmentDetails() {
    subjectCollection = <String>[];
    subjectCollection.add('General Meeting');
    subjectCollection.add('Plan Execution');
    subjectCollection.add('Project Plan');
    subjectCollection.add('Consulting');
    subjectCollection.add('Support');
    subjectCollection.add('Development Meeting');
    subjectCollection.add('Project Completion');
    subjectCollection.add('Release updates');
    subjectCollection.add('Performance Check');

    colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
    colorCollection.add(const Color(0xFF0A8043));
  }

  /// Method that creates the collection the data source for calendar, with
  /// required information.
  void addAppointments() {
    final random = math.Random();
    final rangeStartDate =
        DateTime.now().add(const Duration(days: -(365 ~/ 2)));
    final rangeEndDate = DateTime.now().add(const Duration(days: 365));
    for (var i = rangeStartDate;
        i.isBefore(rangeEndDate);
        i = i.add(Duration(days: random.nextInt(10)))) {
      final date = i;
      final count = 1 + random.nextInt(3);
      for (var j = 0; j < count; j++) {
        final startDate = DateTime(
            date.year, date.month, date.day, 8 + random.nextInt(8), 0, 0);
        appointments.add(Appointment(
          subject: subjectCollection[random.nextInt(7)],
          startTime: startDate,
          endTime: startDate.add(Duration(hours: random.nextInt(3))),
          color: colorCollection[random.nextInt(9)],
          isAllDay: false,
        ));
      }
    }

    var date = DateTime.now();
    date = DateTime(date.year, date.month, date.day, 11, 0, 0);
    // added recurrence appointment
    appointments.add(Appointment(
        subject: 'Scrum',
        startTime: date,
        endTime: date.add(const Duration(hours: 1)),
        color: colorCollection[random.nextInt(9)],
        isAllDay: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=10'));
  }

  /// Returns the month name based on the month value passed from date.
  String _getMonthDate(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }

  List<Meeting> _getDataSource() {
    var meetings = <Meeting>[];
    final today = DateTime.now();
    final startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
    final endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
  ];
}

/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _DataSource extends CalendarDataSource {
  _DataSource(List<Appointment> source) {
    appointments = source;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from as DateTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to as DateTime;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName as String;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background as Color;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay as bool;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
