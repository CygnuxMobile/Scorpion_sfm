import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/add_meeting_controller.dart';
import 'package:scorpforce/modules/meeting/add_meeting_screen/model/get_penindia_customer.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../../config/app_shared_key.dart';
import '../../../config/app_text_style.dart';
import '../../../utils/api_handler.dart';
import '../../lead/add_lead/model/get_branch_response_model.dart';
import '../../lead/lead_screen/lead_screen.dart';
import '../../my_call/add_my_call_screen/call_module_response_model.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';
import '../../widget/toast_message.dart';
import '../meeting_screen/meeting_response_model.dart';

class AddMeetingScreen extends StatefulWidget {
  final bool isEdit;
  final bool? isFromLeadScreen;
  final bool? isFromCustomerScreen;
  final bool? isCreator;
  final bool? isMeetingScreenAdd;
  final AttendanceStatus? isCheckInCheckOutCompleted;
  final String? origin;
  final String? destination;
  final String? meetingId;
  final String? attendeeCode;
  final Data1? data;

  const AddMeetingScreen({
    super.key,
    this.isEdit = false,
    this.attendeeCode,
    this.meetingId,
    this.isFromLeadScreen = false,
    this.isFromCustomerScreen = false,
    this.isMeetingScreenAdd = false,
    this.isCheckInCheckOutCompleted,
    this.data,
    this.isCreator = false,
    this.origin = '',
    this.destination = '',
  });

  @override
  AddMeetingScreenState createState() => AddMeetingScreenState();
}

class AddMeetingScreenState extends State<AddMeetingScreen> {
  AddMeetingController addMeetingController = Get.find<AddMeetingController>();

  Timer? _debounce;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _editSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: addMeetingController.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != addMeetingController.selectedDate) {
      addMeetingController.selectedDate = picked;
      addMeetingController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);
      _checkAndSetDefaultTime(picked);
    }
  }

  Future<DateTime?> _selectDate(BuildContext context, bool? isFromCustomerScreen) async {
    DateTime leadDate = addMeetingController.leadDate.value == ""
        ? DateTime.now()
        : DateFormat('dd/MM/yyyy').parse(addMeetingController.leadDate.value);

    DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));

    DateTime firstSelectableDate = leadDate.isBefore(yesterday) ? DateTime.now() : leadDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromCustomerScreen!
          ? DateTime.now()
          : addMeetingController.selectedDate.isAfter(firstSelectableDate)
          ? addMeetingController.selectedDate
          : firstSelectableDate,
      firstDate: isFromCustomerScreen ? DateTime.now() : firstSelectableDate,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != addMeetingController.selectedDate) {
      addMeetingController.selectedDate = picked;

      addMeetingController.dateController.value.text = DateFormat('dd/MM/yyyy').format(picked);

      _checkAndSetDefaultTime(picked);
    }

    return picked;
  }

  void _checkAndSetDefaultTime(DateTime picked) {
    DateTime now = DateTime.now();
    if (picked.year == now.year && picked.month == now.month && picked.day == now.day) {
      if (addMeetingController.isAllDayEvent.isFalse) {
        final DateTime startDT = DateTime.now();
        final DateTime endDT = startDT.add(const Duration(minutes: 5));

        String startStr = DateFormat('HH:mm').format(startDT);
        String endStr = DateFormat('HH:mm').format(endDT);

        addMeetingController.startTimeController.value.text = startStr;
        addMeetingController.startTime.value = startStr;
        addMeetingController.endTimeController.value.text = endStr;
        addMeetingController.endTime.value = endStr;
        setState(() {});
      }
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    debugPrint("in this");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isEdit!) {
        await addMeetingController
            .editMeeting(
              id: "${widget.attendeeCode}?UserId=${Pref.getUserId()}",
              attendeesController: addMeetingController.controller.value,
              addMomController: addMeetingController.momController.value,
            )
            .whenComplete(() {
              setState(() {});
            });
      } else if (widget.isFromLeadScreen! || widget.isFromCustomerScreen!) {
        if (widget.isFromLeadScreen!) {
          addMeetingController.leadDate.value = widget.data!.leadDate ?? "";
          debugPrint("lead Id === ${widget.data!.customerId}");
        }
        addMeetingController.contactPersonController.value.text = widget.data!.contactPerson ?? "";
        addMeetingController.emailIdController.value.text = widget.data!.email ?? "";
        addMeetingController.addressController.value.text = widget.data!.address ?? "";
        addMeetingController.contactNoController.value.text = widget.data!.mobile ?? "";
        addMeetingController.selectedCustomer.value = PanIndiaCustomer(
          customerCode: widget.data!.customerId,
          customerName: widget.data!.customerName,
        );
        debugPrint("customer code === ${addMeetingController.selectedCustomer.value!.customerCode}");
        debugPrint("customer code === ${addMeetingController.selectedCustomer.value!.customerName}");

        addMeetingController.customerId.value = widget.data!.customerId;
      }
    });
    super.initState();
  }

  bool isCreatorCheck() {
    if (widget.isMeetingScreenAdd!) {
      return true;
    } else if (widget.isFromCustomerScreen! || widget.isFromLeadScreen!) {
      return true;
    } else if (widget.isCheckInCheckOutCompleted == AttendanceStatus.completed) {
      return false;
    } else if (widget.isCreator!) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          widget.isEdit! ? 'Edit My Meeting' : 'Add My Meeting',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom, left: 8, right: 8, top: 10),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: widget.isMeetingScreenAdd == true
                        ? () {
                            Get.bottomSheet(
                              SafeArea(
                                child: Container(
                                  height: MediaQuery.of(context).size.height * 0.65,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  child: Column(
                                    children: [
                                      /// 🔹 Drag Handle
                                      Container(
                                        margin: const EdgeInsets.symmetric(vertical: 10),
                                        height: 4,
                                        width: 40,
                                        decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
                                      ),

                                      /// 🔹 Title
                                      const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Select Customer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        ),
                                      ),

                                      /// 🔹 Search Box
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: commonTextField(
                                          onChange: (value) {
                                            if (_debounce?.isActive ?? false) _debounce?.cancel();
                                            _debounce = Timer(const Duration(milliseconds: 500), () {
                                              if (value.length >= 2) {
                                                addMeetingController.getCustomer(isLoading: true, value: value);
                                              }
                                            });
                                          },

                                          labelText: 'Search customer...',
                                        ),
                                      ),

                                      /// 🔹 Customer List
                                      Expanded(
                                        child: Obx(() {
                                          if (addMeetingController.isCustomerLoading.value) {
                                            return const Center(child: CircularProgressIndicator());
                                          }

                                          if (addMeetingController.customerList.isEmpty) {
                                            return const Center(child: Text("No customers found"));
                                          }

                                          return ListView.separated(
                                            padding: const EdgeInsets.only(bottom: 20),
                                            itemCount: addMeetingController.customerList.length,
                                            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
                                            itemBuilder: (context, index) {
                                              final customer = addMeetingController.customerList[index];

                                              return ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.red.shade500,
                                                  child: Text(
                                                    customer.customerName[0].toUpperCase(),
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                  ),
                                                ),
                                                title: Text(customer.customerName, style: const TextStyle(fontWeight: FontWeight.w500)),
                                                subtitle: Text("Code: ${customer.customerCode}", style: TextStyle(color: Colors.grey.shade600)),
                                                onTap: () {
                                                  addMeetingController.selectedCustomer.value = customer;
                                                  addMeetingController.customerId.value = customer.customerCode;
                                                  addMeetingController.getCustomerDetail(customerCode: customer.customerCode);
                                                  Get.back();
                                                },
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              isScrollControlled: true,
                              enableDrag: true,
                              backgroundColor: Colors.transparent,
                            );
                          }
                        : null,

                    child: Container(
                      decoration: BoxDecoration(color: Colors.transparent),
                      child: Row(
                        children: [
                          Obx(() {
                            return CustomDropdown<PanIndiaCustomer>(
                              enabled: false,
                              // prefixImage AppImages.companyName,
                              hintText: 'Customer Name*',
                              items: addMeetingController.customerList,
                              selectedItem: addMeetingController.selectedCustomer.value,
                              itemAsString: (PanIndiaCustomer data) => data.customerName,
                              onChanged: (PanIndiaCustomer? data) {
                                if (data != null) {
                                  addMeetingController.selectedCustomer.value = data;
                                  addMeetingController.customerId.value = data.customerCode;
                                  debugPrint("meet id === ${data.customerCode}");
                                }
                              },
                              validator: (value) => value == null ? 'Please select a Customer Name' : null,
                              showSearchBox: true,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    return Container(
                      child: addMeetingController.isCustomerDetailLoading.isTrue
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Center(child: loader()),
                            )
                          : Column(
                              children: [
                                commonTextField(
                                  enable: isCreatorCheck(),
                                  // prefixImage AppImages.contactName,
                                  needValidation: true,
                                  readOnly: widget.isEdit ? true : false,
                                  validationMessage: "Contact Name*",
                                  enabledBorder: AppColors.primaryColor,
                                  labelText: "Contact Name",
                                  controller: addMeetingController.contactPersonController.value,
                                  textInputType: TextInputType.text,
                                  horizontalPadding: null,
                                  textColor: AppColors.black,
                                ),
                                commonTextField(
                                  enable: isCreatorCheck(),
                                  // prefixImage AppImages.address,
                                  needValidation: true,
                                  readOnly: widget.isEdit ? true : false,
                                  validationMessage: "Address*",
                                  enabledBorder: AppColors.black,
                                  labelText: "Address",
                                  controller: addMeetingController.addressController.value,
                                  textInputType: TextInputType.text,
                                  horizontalPadding: null,
                                  textColor: AppColors.black,
                                ),
                                commonTextField(
                                  enable: isCreatorCheck(),
                                  // prefixImage AppImages.contactNo,
                                  needValidation: true,
                                  readOnly: widget.isEdit ? true : false,
                                  validationMessage: "Contact No*",
                                  isPhoneNumberValidator: true,
                                  enabledBorder: AppColors.black,
                                  labelText: "Contact No*",
                                  isOnlyInputDigits: true,
                                  controller: addMeetingController.contactNoController.value,
                                  textInputType: TextInputType.phone,
                                  horizontalPadding: null,
                                  textColor: AppColors.black,
                                ),

                                commonTextField(
                                  enable: isCreatorCheck(),
                                  // prefixImage AppImages.email,
                                  needValidation: true,
                                  readOnly: widget.isEdit ? true : false,
                                  validationMessage: "Email*",
                                  isEmailValidator: true,
                                  enabledBorder: AppColors.black,
                                  labelText: "Email*",
                                  controller: addMeetingController.emailIdController.value,
                                  textInputType: TextInputType.emailAddress,
                                  horizontalPadding: null,
                                  textColor: AppColors.black,
                                ),
                              ],
                            ),
                    );
                  }),

                  // _buildTextField("Email Id *", addMeetingController.emailIdController.value, keyboardType: TextInputType.emailAddress),
                  commonTextField(
                    enable: isCreatorCheck(),
                    // prefixImage AppImages.meetingPurpose,
                    needValidation: true,
                    validationMessage: "Meeting Purpose*",
                    enabledBorder: AppColors.black,
                    labelText: "Meeting Purpose*",
                    controller: addMeetingController.meetingPurposeController.value,
                    textInputType: TextInputType.text,
                    horizontalPadding: null,
                    textColor: AppColors.black,
                  ),
                  commonTextField(
                    enable: isCreatorCheck(),
                    // prefixImage AppImages.date,
                    needValidation: true,
                    validationMessage: "Meeting Date*",
                    readOnly: true,
                    enabledBorder: AppColors.black,
                    labelText: "Meeting Date*",
                    controller: addMeetingController.dateController.value,
                    textInputType: TextInputType.emailAddress,
                    horizontalPadding: null,
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    onTap: () async {
                      if (!widget.isEdit!) {
                        DateTime? pickedDate = await _selectDate(context, widget.isFromCustomerScreen);

                        if (pickedDate != null) {
                          addMeetingController.selectedDate = pickedDate;

                          DateTime now = DateTime.now();

                          bool isToday = pickedDate.year == now.year && pickedDate.month == now.month && pickedDate.day == now.day;

                          if (addMeetingController.isAllDayEvent.value == true) {
                            if (isToday) {
                              DateTime now = DateTime.now();
                              TimeOfDay current = TimeOfDay.now();

                              if (current.hour > 18 || (current.hour == 18 && current.minute > 0)) {
                                toastMessage(text: "All day event cannot be set after 6:00 PM", color: AppColors.redColor);
                                return;
                              }

                              DateTime updatedTime = now.add(const Duration(minutes: 1));

                              String time = "${updatedTime.hour.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')}";
                              addMeetingController.startTimeController.value.text = time;
                              addMeetingController.startTime.value = time;
                            } else {
                              addMeetingController.startTimeController.value.text = "10:00";
                              addMeetingController.endTimeController.value.text = "18:00";

                              addMeetingController.startTime.value = "10:00";
                              addMeetingController.endTime.value = "18:00";
                            }
                          }
                        }
                      } else {
                        _editSelectDate(context);
                      }
                    },
                    textColor: AppColors.black,
                  ),

                  Obx(() {
                    return Row(
                      children: [
                        Expanded(
                          child: commonTextField(
                            enable: isCreatorCheck(),
                            // prefixImage AppImages.time,
                            needValidation: true,
                            readOnly: true,
                            onTap: () async {
                              if (addMeetingController.isAllDayEvent.isFalse) {
                                final TimeOfDay? startTime = await showTimePicker(
                                  context: context,
                                  initialEntryMode: TimePickerEntryMode.dialOnly,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (startTime != null) {
                                  DateTime now = DateTime.now();
                                  DateTime selectedDate = addMeetingController.selectedDate;
                                  bool isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;

                                  if (isToday) {
                                    TimeOfDay nowTime = TimeOfDay.now();
                                    if (startTime.hour < nowTime.hour || (startTime.hour == nowTime.hour && startTime.minute < nowTime.minute)) {
                                      toastMessage(text: "Start time cannot be in the past", color: AppColors.redColor);
                                      return;
                                    }
                                  }

                                  String formattedTime =
                                      "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
                                  addMeetingController.startTimeController.value.text = formattedTime;
                                  addMeetingController.startTime.value = formattedTime;

                                  // Auto set End Time to Start Time + 5
                                  DateTime startDT = DateTime(
                                    selectedDate.year,
                                    selectedDate.month,
                                    selectedDate.day,
                                    startTime.hour,
                                    startTime.minute,
                                  );
                                  DateTime endDT = startDT.add(const Duration(minutes: 5));
                                  String formattedEndTime = "${endDT.hour.toString().padLeft(2, '0')}:${endDT.minute.toString().padLeft(2, '0')}";
                                  addMeetingController.endTimeController.value.text = formattedEndTime;
                                  addMeetingController.endTime.value = formattedEndTime;

                                  addMeetingController.update();
                                }
                                setState(() {});
                              }
                            },
                            validationMessage: "Start Time*",
                            enabledBorder: AppColors.black,
                            labelText: "Start Time*",
                            controller: addMeetingController.startTimeController.value,
                            textInputType: TextInputType.text,
                            horizontalPadding: null,
                            textColor: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Obx(() {
                            // final startTimeText = addMeetingController.startTimeController.value.text;
                            // print("Start time var >>>><<<< $startTimeText");
                            // print("addMeetingController.startTimeController.value.text >>>><<<< $addMeetingController.startTimeController.value.text");
                            return commonTextField(
                              enable: isCreatorCheck(),
                              // prefixImage AppImages.time,
                              needValidation: true,
                              readOnly: true,
                              onTap: () async {
                                if (addMeetingController.isAllDayEvent.value == false) {
                                  if (addMeetingController.startTimeController.value.text.isEmpty) {
                                    toastMessage(text: "Please select Start Time first", color: AppColors.redColor);
                                    return;
                                  }

                                  var startParts = addMeetingController.startTimeController.value.text.split(":");
                                  int startHour = int.parse(startParts[0]);
                                  int startMin = int.parse(startParts[1]);

                                  DateTime startDate = addMeetingController.selectedDate;
                                  DateTime startDT = DateTime(startDate.year, startDate.month, startDate.day, startHour, startMin);
                                  DateTime minEndDT = startDT.add(const Duration(minutes: 5));

                                  final TimeOfDay? pickedEndTime = await showTimePicker(
                                    context: context,
                                    initialEntryMode: TimePickerEntryMode.dialOnly,
                                    initialTime: TimeOfDay.fromDateTime(minEndDT),
                                  );

                                  if (pickedEndTime != null) {
                                    if (pickedEndTime.hour < minEndDT.hour ||
                                        (pickedEndTime.hour == minEndDT.hour && pickedEndTime.minute < minEndDT.minute)) {
                                      toastMessage(text: "End time must be at least 5 minutes after Start Time", color: AppColors.redColor);
                                      return;
                                    }

                                    String formattedTime =
                                        "${pickedEndTime.hour.toString().padLeft(2, '0')}:${pickedEndTime.minute.toString().padLeft(2, '0')}";
                                    addMeetingController.endTimeController.value.text = formattedTime;
                                    addMeetingController.endTime.value = formattedTime;
                                    addMeetingController.update();
                                  }
                                  setState(() {});
                                }
                              },
                              validationMessage: "End time*",
                              enabledBorder: AppColors.black,
                              labelText: "End Time*",
                              controller: addMeetingController.endTimeController.value,
                              textInputType: TextInputType.text,
                              horizontalPadding: null,
                              textColor: AppColors.black,
                              startTime: addMeetingController.startTimeController.value.text,
                              isTimeValidator: true,
                            );
                          }),
                        ),
                      ],
                    );
                  }),

                  SizedBox(
                    child: Row(
                      children: [
                        Obx(() {
                          return CustomDropdown<CallType>(
                            enabled: isCreatorCheck(),
                            // prefixImage AppImages.meetingType,
                            hintText: 'Meeting Type*',
                            items: addMeetingController.meetingTypeList,
                            selectedItem: addMeetingController.selectedMeetingType.value,
                            itemAsString: (CallType data) => data.codeDesc,
                            // Display the user's name
                            onChanged: (CallType? data) {
                              if (data != null) {
                                addMeetingController.selectedMeetingType.value = data;
                                addMeetingController.meetingTypeId.value = data.codeId;
                              }
                            },
                            validator: (value) => value == null ? 'Please select a meeting type' : null,
                            showSearchBox: true,
                          );
                        }),
                      ],
                    ),
                  ),

                  SizedBox(
                    child: MultiDropdown(
                      enabled: isCreatorCheck(),
                      closeOnBackButton: true,
                      items: addMeetingController.callUserList.value.map((e) {
                        return DropdownItem(label: "${e.userId} : ${e.name}", value: e);
                      }).toList(),
                      controller: addMeetingController.controller.value,
                      searchEnabled: true,
                      fieldDecoration: FieldDecoration(
                        /*prefixIcon: Image.asset(
                            AppImages.attendance,
                            scale: 15,
                          ),*/
                        animateSuffixIcon: true,
                        hintText: 'Add Attendees',
                        backgroundColor: AppColors.whiteColor,
                        labelText: "Add Attendees",
                        hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                        labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                        showClearIcon: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
                        ),
                      ),
                      chipDecoration: const ChipDecoration(backgroundColor: AppColors.grey, wrap: false, runSpacing: 5, spacing: 5),
                      dropdownDecoration: const DropdownDecoration(
                        marginTop: 6,
                        maxHeight: 500,
                        header: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            'Select user from the list',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        backgroundColor: AppColors.green100,
                      ),
                      dropdownItemDecoration: DropdownItemDecoration(
                        selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                        disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                      ),
                      onSelectionChange: (selectedItems) {
                        addMeetingController.selectedUser.value = selectedItems;
                        debugPrint("OnSelectionChange: ${selectedItems.map((e) => e)}");
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Row(
                      children: [
                        Obx(() {
                          return CustomDropdown<Branch>(
                            enabled: isCreatorCheck(),
                            // prefixImage AppImages.meetingLocation,
                            hintText: 'Meeting Location*',
                            items: addMeetingController.branchList,
                            selectedItem: addMeetingController.selectedBranch.value,
                            itemAsString: (Branch data) => data.locName,
                            // Display the user's name
                            onChanged: (Branch? data) {
                              if (data != null) {
                                addMeetingController.selectedBranch.value = data;
                                addMeetingController.branchId.value = data.locCode;
                              }
                            },
                            validator: (value) => value == null ? 'Please select a Meeting Location' : null,
                            showSearchBox: true,
                          );
                        }),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: addMeetingController.meetingLocationController.value,
                        enabled: true,
                        googleAPIKey: "AIzaSyAMPBtu5A1HbgJuxwzj-y6mcqCIj0vf5cA",
                        focusNode: FocusNode(canRequestFocus: true),
                        inputDecoration: InputDecoration(
                          hintText: 'Search Geo Location',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          border: InputBorder.none,
                        ),
                        boxDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                          color: AppColors.whiteColor,
                        ),
                        debounceTime: 800,
                        countries: ['in'],
                        isLatLngRequired: true,
                        getPlaceDetailWithLatLng: (Prediction prediction) {
                          if (prediction.lat == null || prediction.lng == null) {
                            debugPrint("❌ Error: No lat/lng found for ${prediction.description}");
                          } else {
                            debugPrint("✅ Place Selected: ${prediction.description}");
                            debugPrint("📍 Lat: ${prediction.lat}, Lng: ${prediction.lng}");

                            addMeetingController.latitude.value = double.parse(prediction.lat!);
                            addMeetingController.longitude.value = double.parse(prediction.lng!);
                          }
                        },

                        itemClick: (Prediction prediction) {
                          addMeetingController.meetingLocationController.value.text = prediction.description!;
                          addMeetingController.meetingLocationController.value.selection = TextSelection.fromPosition(
                            TextPosition(offset: prediction.description!.length),
                          );

                          debugPrint("🔹 Item clicked: ${prediction.description}");
                        },

                        itemBuilder: (context, index, Prediction prediction) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppColors.boderColor)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.grey.shade600),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(prediction.description ?? "N/A", style: const TextStyle(fontSize: 14, color: Colors.black)),
                                ),
                              ],
                            ),
                          );
                        },
                        seperatedBuilder: const Divider(height: 1, color: AppColors.boderColor),
                        isCrossBtnShown: true,
                        containerHorizontalPadding: 10,
                        placeType: null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  if (widget.isEdit! && widget.isCheckInCheckOutCompleted == AttendanceStatus.completed)
                    Column(
                      children: [
                        SizedBox(
                          child: addMeetingController.isMomLoading.value
                              ? const DropdownSkeleton()
                              : addMeetingController.isMomError.value && addMeetingController.momList.value == null
                              ? RetryDropdown(
                                  onTap: () async {
                                    await addMeetingController.getMomList(showLoader: true);
                                  },
                                  message: "MOM not loaded. Please try again.",
                                )
                              : MultiDropdown(
                                  closeOnBackButton: true,
                                  items: addMeetingController.momList.value!.map((e) {
                                    return DropdownItem(label: e.moM ?? '', value: e);
                                  }).toList(),
                                  controller: addMeetingController.momController.value,
                                  searchEnabled: true,
                                  fieldDecoration: FieldDecoration(
                                    prefixIcon: Image.asset(AppImages.attendance, scale: 15),
                                    animateSuffixIcon: true,
                                    hintText: 'Add MOM*',
                                    labelText: "Add MOM*",
                                    hintStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                                    labelStyle: AppTextStyle.regular.copyWith(fontSize: 14, color: AppColors.grey),
                                    showClearIcon: false,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppColors.boderColor, width: 1),
                                    ),
                                  ),
                                  chipDecoration: const ChipDecoration(backgroundColor: AppColors.grey, wrap: false, runSpacing: 5, spacing: 5),
                                  dropdownDecoration: const DropdownDecoration(
                                    marginTop: 6,
                                    maxHeight: 500,
                                    header: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Select MOM from the list',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    backgroundColor: AppColors.green100,
                                  ),
                                  dropdownItemDecoration: DropdownItemDecoration(
                                    selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                                    disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                                  ),
                                  /* validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select a user';
                                        }
                                        return null;
                                      },*/
                                  onSelectionChange: (selectedItems) {
                                    addMeetingController.selectedMom.value = selectedItems;
                                  },
                                ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                  /* if (widget.isEdit!)
                      Row(
                        children: [
                          Obx(() {
                            return CustomDropdown<MomListDatum>(
                              // prefixImage AppImages.meeting,
                              hintText: 'Meeting MOM*',
                              items: addMeetingController.momList.value!,
                              selectedItem: addMeetingController.selectedMom.value,
                              itemAsString: (MomListDatum data) => data.moM,
                              onChanged: (MomListDatum? data) {
                                if (data != null) {
                                  addMeetingController.selectedMom.value = data;
                                  addMeetingController.momId.value = data.id.toString();
                                }
                              },
                              validator: (value) => value == null ? 'Please select a Meeting MOM' : null,
                              showSearchBox: true,
                            );
                          }),
                        ],
                      ),*/
                  widget.isEdit! == true
                      ? commonTextField(
                          // prefixImage AppImages.remark
                          enabledBorder: AppColors.black,
                          labelText: "Remarks",
                          controller: addMeetingController.remarksController.value,
                          textInputType: TextInputType.streetAddress,
                          horizontalPadding: null,
                          textColor: AppColors.black,
                        )
                      : SizedBox(),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const Expanded(child: Text("All day event")),
                          Switch(
                            activeTrackColor: AppColors.primaryColor,
                            value: addMeetingController.isAllDayEvent.value,
                            onChanged: (value) {
                              DateTime selectedDate = addMeetingController.selectedDate;
                              DateTime now = DateTime.now();

                              bool isToday = selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;

                              if (value == true && isToday) {
                                TimeOfDay current = TimeOfDay.now();

                                if (current.hour > 18 || (current.hour == 18 && current.minute > 0)) {
                                  toastMessage(text: "All day event cannot be set after 6:00 PM", color: AppColors.redColor);

                                  return;
                                }
                              }

                              addMeetingController.isAllDayEvent.value = value;

                              if (value == true) {
                                if (isToday) {
                                  TimeOfDay current = TimeOfDay.now();
                                  String time = "${current.hour.toString().padLeft(2, '0')}:${current.minute.toString().padLeft(2, '0')}";

                                  addMeetingController.startTimeController.value.text = time;
                                  addMeetingController.startTime.value = time;

                                  addMeetingController.endTimeController.value.text = "18:00";
                                  addMeetingController.endTime.value = "18:00";
                                } else {
                                  addMeetingController.startTimeController.value.text = "10:00";
                                  addMeetingController.endTimeController.value.text = "18:00";
                                  addMeetingController.startTime.value = '10:00';
                                  addMeetingController.endTime.value = '18:00';
                                }
                              } else {
                                addMeetingController.startTimeController.value.text = "";
                                addMeetingController.endTimeController.value.text = "";
                                addMeetingController.startTime.value = '10:00';
                                addMeetingController.endTime.value = '18:00';
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  Obx(() {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!await ApiHandler.hasInternet()) {
                            toastMessage(text: "No internet connection", color: AppColors.redColor);
                            return;
                          }

                          if (_formKey.currentState!.validate()) {
                            if (addMeetingController.startTime.value != "" && addMeetingController.endTime.value != "") {
                              var data = {
                                "meetingTypeId": addMeetingController.meetingTypeId.value,
                                "meetingDate": addMeetingController.dateController.value.text,
                                "customerName": addMeetingController.selectedCustomer.value!.customerName,
                                if (widget.isFromCustomerScreen! || widget.isMeetingScreenAdd!)
                                  "customerCode": addMeetingController.selectedCustomer.value!.customerCode,
                                "leadId": widget.isFromLeadScreen!
                                    ? widget.data!.customerId
                                    : widget.isEdit!
                                    ? addMeetingController.customerId.value
                                    : "",
                                "email": addMeetingController.emailIdController.value.text,
                                "contactNo": addMeetingController.contactNoController.value.text,
                                "address": addMeetingController.addressController.value.text,
                                "contactName": addMeetingController.contactPersonController.value.text,
                                "meetingPurpose": addMeetingController.meetingPurposeController.value.text,
                                if (widget.isEdit!)
                                  "meetingMOM": addMeetingController.selectedMom.value!.isNotEmpty
                                      ? addMeetingController.selectedMom.value!.map((user) => user.moM.toString()).join(',')
                                      : "",
                                "meetingLocation": addMeetingController.selectedBranch.value!.locCode,
                                "geoLocation": addMeetingController.meetingLocationController.value.text,
                                "startTime": addMeetingController.startTimeController.value.text,
                                "endTime": addMeetingController.endTimeController.value.text,
                                "latitude": addMeetingController.latitude.value,
                                "longitude": addMeetingController.longitude.value,
                                "remarks": addMeetingController.remarksController.value.text,
                                "attendeeIDs": addMeetingController.selectedUser.value != null && addMeetingController.selectedUser.value != []
                                    ? addMeetingController.selectedUser.value!.map((user) => user.userId.toString()).join(',')
                                    : "",
                                "isAllDayEvent": addMeetingController.isAllDayEvent.value,
                                "CreateBy": widget.isEdit! ? addMeetingController.createByController.value.text : Pref.getUserId(),
                                "ModifiedBy": widget.isEdit! ? Pref.getUserId() : "",
                                if (widget.isEdit!) "attendeeCode": widget.attendeeCode,
                                if (widget.isEdit!) "distanceInKM": addMeetingController.distanceInKm.value,
                              };
                              debugPrint("meeting data == $data");
                              await addMeetingController.addMeeting(
                                data: data,
                                a: addMeetingController.controller.value,
                                loading: true,
                                id: widget.attendeeCode,
                                isUpdate: widget.isEdit!,
                              );
                            } else {
                              toastMessage(color: AppColors.redColor, isTop: false, text: "Start time and End time both are required");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          minimumSize: const Size(150, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: addMeetingController.isLoading.value
                            ? loader(loaderColor: AppColors.whiteColor)
                            : Text(widget.isEdit! ? "Update" : "Add", style: const TextStyle(color: Colors.white)),
                      ),
                    );
                  }),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
