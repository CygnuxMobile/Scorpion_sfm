import 'package:get/get.dart';
import 'package:scorpforce/modules/meeting_mom/meeting_mom_screen.dart';
import '../config/app_routes.dart';
import '../modules/attendance/attendance_binding.dart';
import '../modules/attendance/attendance_screen.dart';
import '../modules/complaint/add_complaint/add_complaint_binding.dart';
import '../modules/complaint/add_complaint/add_complaint_screen.dart';
import '../modules/complaint/add_complaint/escalation_ticket_screen.dart';
import '../modules/complaint/complaint_screen/complaint_binding.dart';
import '../modules/complaint/complaint_screen/complaint_screen.dart';
import '../modules/customer/customer_screen/customer_binding.dart';
import '../modules/customer/customer_screen/customer_screen.dart';
import '../modules/dashbord/dashbord_screen.dart';
import '../modules/expance/add_expense_screen/add_expense_binding.dart';
import '../modules/expance/add_expense_screen/add_expense_screen.dart';
import '../modules/expance/expense_screen/expense_binding.dart';
import '../modules/expance/expense_screen/expense_screen.dart';
import '../modules/expance_general_master/expense_general_master_screen/expense_general_master_binding.dart';
import '../modules/expance_general_master/expense_general_master_screen/expense_general_master_screen.dart';
import '../modules/lead/add_lead/binding/add_lead_binding.dart';
import '../modules/lead/add_lead/view/add_lead_screen.dart';
import '../modules/lead/lead_screen/lead_binding.dart';
import '../modules/lead/lead_screen/lead_screen.dart';
import '../modules/lead/view_lead/view_lead_binding.dart';
import '../modules/login/login_binding.dart';
import '../modules/login/login_screen.dart';
import '../modules/meeting/add_meeting_screen/add_meeting_binding.dart';
import '../modules/meeting/add_meeting_screen/add_meeting_screen.dart';
import '../modules/meeting/meeting_screen/meeting_binding.dart';
import '../modules/meeting/meeting_screen/meeting_screen.dart';
import '../modules/myTask/add_task/binding/add_task_binding.dart';
import '../modules/myTask/add_task/view/add_task_screen.dart';
import '../modules/myTask/task_screen/task_binding.dart';
import '../modules/myTask/task_screen/task_screen.dart';
import '../modules/my_call/add_my_call_screen/add_call_binding.dart';
import '../modules/my_call/add_my_call_screen/add_call_screen.dart';
import '../modules/my_call/my_call_screen/my_call_binding.dart';
import '../modules/my_call/my_call_screen/my_call_screen.dart';
import '../modules/my_call/view_expense/call_view_binding.dart';
import '../modules/splash_screen/splash_binding.dart';
import '../modules/splash_screen/splash_screen.dart';

List<GetPage> getPages = [
  GetPage(name: AppRoutes.splashScreen, page: () => const SplashScreen(), binding: SplashBinding()),
  GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen(), binding: LoginBinding()),
  GetPage(name: AppRoutes.dashboard, page: () => DashboardScreen()),
  GetPage(name: AppRoutes.customer, binding: CustomerBinding(), page: () => const CustomerScreen()),
  GetPage(name: AppRoutes.myLead, binding: LeadBinding(), page: () => const MyLeadScreen()),
  GetPage(name: AppRoutes.myTask, binding: TaskBinding(), page: () => const MyTaskScreen()),
  GetPage(name: AppRoutes.addTask, binding: AddTaskBinding(), page: () => const AddTaskScreen()),
  GetPage(name: AppRoutes.viewLead, binding: ViewLeadBinding(), page: () => const MyLeadScreen()),
  GetPage(name: AppRoutes.addLand, page: () => const AddLeadScreen(), binding: AddLeadBinding()),
  GetPage(name: AppRoutes.myMeeting, page: () => const MyMeetingScreen(), binding: MeetingBinding()),
  GetPage(name: AppRoutes.myMeetingMom, page: () => const MeetingMomScreen(), binding: MeetingBinding()),
  GetPage(name: AppRoutes.addMeeting, page: () => const AddMeetingScreen(), binding: AddMeetingBinding()),
  GetPage(name: AppRoutes.expense, page: () => const ExpenseScreen(), binding: ExpenseBinding()),
  GetPage(name: AppRoutes.expenseGeneralMaster, page: () => const ExpenseGeneralMasterScreen(), binding: ExpenseGeneralMasterBinding()),
  GetPage(name: AppRoutes.addExpense, page: () => const AddExpenseScreen(), binding: AddExpenseBinding()),
  GetPage(name: AppRoutes.call, page: () => const MyCallScreen(), binding: MyCallBinding()),
  GetPage(name: AppRoutes.addCall, page: () => const AddCallScreen(), binding: AddCallBinding()),
  GetPage(name: AppRoutes.viewCall, binding: CallViewBinding(), page: () => const AddCallScreen()),
  GetPage(name: AppRoutes.attendanceScreen, binding: AttendanceBinding(), page: () => AttendanceScreen()),
  GetPage(name: AppRoutes.addComplaintScreen, binding: AddComplaintBinding(), page: () => const AddComplaintScreen()),
  GetPage(name: AppRoutes.escalationTicketScreen, binding: AddComplaintBinding(), page: () => const EscalationTicketScreen()),
  GetPage(name: AppRoutes.complaintScreen, binding: ComplaintBinding(), page: () => const ComplaintScreen()),
];
