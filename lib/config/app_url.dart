import 'package:scorpforce/config/app_shared_key.dart';

class ApiEndPoint {
  // static String baseUrl = "https://sfmapi-sepl.cygnux.in/api/v1/"; ///live
  static String baseUrl = "https://sfmuatapi.cygnux.in/api/v1/";

  ///test
  static String meeting = "${baseUrl}Meeting";
  static String getAppVersionData = "${baseUrl}External/GetAppVersionData";

  static String leadList = "${baseUrl}Lead/leadlistForMobile";
  static String lead = "${baseUrl}Lead/";
  static String addLead = "${baseUrl}Lead";
  static String getLead = "${baseUrl}Lead";
  static String task = "${baseUrl}task";
  static String expense = "${baseUrl}expense";
  static String expenseApprovalList = "${baseUrl}Expense/ApprovalList";
  static String call = "${baseUrl}Call";
  static String calender = "${baseUrl}Calendar?userid=${Pref.getUserId()}";

  ///External
  static String getCity = "${baseUrl}External/city";
  static String expenseApproval = "${baseUrl}Expense/approval";
  static String getBranch = "${baseUrl}external/location";
  static String getUser = "${baseUrl}External/user";
  static String getAssignTo = "${baseUrl}Meeting/AssignToList";
  static String getPriority = "${baseUrl}external/PRIORITY";
  static String getDesignation = "${baseUrl}External/desig";
  static String getLeadSource = "${baseUrl}External/leadsrc";
  static String getComplaintData = "${baseUrl}Complaint/GetDetail/";
  static String getMenu = "${baseUrl}External/Menu?userid=";

  static String genralmaster = "${baseUrl}Lead/LeadCategoryList?codeType=";
  static String getIndustryType = "${baseUrl}External/ind";
  static String getServiceIntegrated = "${baseUrl}External/fltprod";
  static String getTransportMode = "${baseUrl}External/SERCAT";
  static String getCallCategory = "${baseUrl}External/CALLCAT";
  static String getCallPurpose = "${baseUrl}External/CALLPUR";
  static String getCallStatus = "${baseUrl}External/CALLSTATUS";
  static String getLeadCategory = "${baseUrl}external/LEADCAT";
  static String expenseGeneralMaster = "${baseUrl}Expense/generalmaster/";
  static String generalMaster = "${baseUrl}GeneralMaster";
  static String attendanceStatus = "${baseUrl}Attendance/punchinout/";
  static String attendance = "${baseUrl}Attendance";
  static String location = "${baseUrl}location";
  static String getTicketAddressTo = "${baseUrl}Complaint/TicketAddressTo";
  static String getExpenseGeneralMaster = "${baseUrl}Expense/generalmaster/list";

  ///Customer

  // static String getCustomerLead = "${baseUrl}customer/lead";
  static String getCustomer = "${baseUrl}Customer/dropdown";
  static String getCustomerForAddMeeting = "${baseUrl}Meeting/PanIndiaCustomer";
  static String getCustomerList = "${baseUrl}customer";
  static String getCustomerDetail = "${baseUrl}Customer/CustomerDetail?customerCode=";

  ///Login

  static String login = "${baseUrl}External/login";

  /// Complaint
  static String getComplaintType = "${baseUrl}external/CMPLNTYPE";
  static String getComplaintSubType = "${baseUrl}External/CodeSubType";
  static String getComplaintList = "${baseUrl}Complaint/GetList";
  static String getDocData = "${baseUrl}Complaint/GetDocData?docNo=";
  static String getUserData = "${baseUrl}Complaint/GetUser?userid=";
  static String addComplaint = "${baseUrl}Complaint/Add";
  static String updateComplaint = "${baseUrl}Complaint/Update/";
  static String closeComplaint = "${baseUrl}Complaint/close";
  static String addEscTkt = "${baseUrl}Complaint/AddEscTkt";
  static String getDetail = "${baseUrl}Complaint/GetDetail";
  static String assignTo = "${baseUrl}Complaint/AssignTo?BranchCode=";
  static String getUpdateHistory = "${baseUrl}Complaint/UpdateHistory?Id=";
  static String getEscalatedHistory = "${baseUrl}Complaint/EscalatedHistory?Id=";

  /// Meeting

  static String meetingCheckInOut = "${baseUrl}Meeting/checkinout";
  static String getMeetingType = "${baseUrl}external/METNGTYPE";
  static String meetingCheckIn = "${baseUrl}meeting/checkin";
  static String momList = "${baseUrl}Meeting/momlist";
  static String meetingMomList = "${baseUrl}Meeting/Pending-Mom";
  static String submitMeetingMom = "${baseUrl}Meeting/SubmitMom";
}
