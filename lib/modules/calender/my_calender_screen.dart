import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/calender/my_calender_controller.dart';
import 'package:scorpforce/modules/calender/my_calender_response_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../config/app_colors.dart';
import '../meeting/add_meeting_screen/add_meeting_binding.dart';
import '../meeting/add_meeting_screen/add_meeting_controller.dart';
import '../meeting/add_meeting_screen/add_meeting_screen.dart';
import '../my_call/add_my_call_screen/add_call_binding.dart';
import '../my_call/add_my_call_screen/add_call_controller.dart';
import '../my_call/add_my_call_screen/add_call_screen.dart';
import '../widget/toast_message.dart';

class MyCalenderScreen extends StatefulWidget {
  const MyCalenderScreen({super.key});

  @override
  State<MyCalenderScreen> createState() => _MyCalenderScreenState();
}

class _MyCalenderScreenState extends State<MyCalenderScreen> {
  final CalendarController calendarController = CalendarController();

  MyCalenderController myCalenderController = Get.find<MyCalenderController>();
  AddMeetingController addMeetingController = Get.find<AddMeetingController>();
  AddCallController addCallController = Get.find<AddCallController>();


  @override
  void dispose() {
    myCalenderController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    fetchData();
    // TODO: implement initState
    addCallController.getUser();
    addCallController.getCategory();
    addCallController.getLead();
    addCallController.getPurpose();
    addCallController.getStatus();
    addMeetingController.getUser(addCallController: addCallController,);
    addMeetingController.getCustomer();
    addMeetingController.getMeetingType();
    addMeetingController.getBranch();
    addCallController.getCategory();
    addCallController.getLead();
    addCallController.getPurpose();
    addCallController.getStatus();
    super.initState();
  }

  void fetchData() async {
    await myCalenderController.getCalenderData();
    setState(() {}); // Force rebuild
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'My Calender',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SfCalendar(
          allowedViews: const [CalendarView.month, CalendarView.day, CalendarView.week],
          showDatePickerButton: true,
          controller: calendarController,
          view: CalendarView.month,
          dataSource: MeetingDataSource(myCalenderController.calenderData),
          // allowedViews: const [CalendarView.month],
          todayHighlightColor: AppColors.primaryColor,
          todayTextStyle: TextStyle(color: AppColors.whiteColor),
          selectionDecoration: ShapeDecoration(shape: Border.all(color: AppColors.primaryColor)),
          showWeekNumber: false,
          allowViewNavigation: true,
          firstDayOfWeek: 7,
          scheduleViewSettings: const ScheduleViewSettings(
            appointmentItemHeight: 100,
          ),
          headerHeight: 70,
          /*monthCellBuilder: (_, value) {
            return Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(value.appointments.length.toString()),
                    Text(DateFormat("dd").format(value.date)),
                  ],
                ));
          },*/
          cellEndPadding: 100,
          cellBorderColor: const Color(0xffacacac),
          onViewChanged: (v) {
            debugPrint("value === ${v.visibleDates}");
          },
          // headerDateFormat: "dd MMM yyyy",

          allowAppointmentResize: false,
          allowDragAndDrop: true,
          resourceViewSettings: const ResourceViewSettings(size: 100),
          monthViewSettings: const MonthViewSettings(
            monthCellStyle: MonthCellStyle(
              backgroundColor: AppColors.whiteColor,
              todayBackgroundColor: AppColors.whiteColor,
            ),
            showAgenda: true,
            appointmentDisplayCount: 20,
            agendaStyle: AgendaStyle(
              backgroundColor: AppColors.white,
              appointmentTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
            ),
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            navigationDirection: MonthNavigationDirection.vertical,
            numberOfWeeksInView: 6,
            dayFormat: "EEE",
            showTrailingAndLeadingDates: false,
            agendaViewHeight: 260,
            agendaItemHeight: 80,
          ),
          showTodayButton: true,
          showNavigationArrow: true,
          onLongPress: (v) {},
          onTap: (value) {
            if (value.targetElement.name == "appointment") {
              if (value.appointments![0].className == "meeting-event") {
                if (value.appointments![0].isAllDayEvent == false) {
                  debugPrint("dddd == ${value.appointments![0]}");
                  Get.to(
                    () => AddMeetingScreen(
                      isEdit: true,
                      attendeeCode: value.appointments![0].attendeeCode,
                      meetingId: value.appointments![0].meetingId,
                    ),
                    binding: AddMeetingBinding(),
                  );
                }else{
                  toastMessage(text: "Meeting is booked for all day", color: AppColors.primaryColor, isTop: false);
                }
              } else {
                if (value.appointments![0].isAllDayEvent == false) {
                  Get.to(
                    () => AddCallScreen(isEdit: true, callId: value.appointments![0].callId),
                    binding: AddCallBinding(),
                  );
                }
              }
            }
          },
          headerStyle: const CalendarHeaderStyle(textAlign: TextAlign.justify, backgroundColor: Color(0xffcacaca)),
          viewNavigationMode: ViewNavigationMode.snap,
          viewHeaderStyle: const ViewHeaderStyle(backgroundColor: Color(0xffe1e1e1)),
          backgroundColor: const Color(0xfff1f1f1),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Datum> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].className == "meeting-event" ? Colors.blue : Colors.green;
  }

/*@override
  String getRecurrenceRule(int index) {
    return appointments![index].className.toString();
  }*/
}
