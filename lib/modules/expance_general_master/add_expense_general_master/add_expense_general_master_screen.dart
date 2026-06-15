import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scorpforce/modules/expance_general_master/add_expense_general_master/add_expense_general_master_controller.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_images.dart';
import '../../expance/add_expense_screen/get_transportmode_responce_model.dart';
import '../../widget/TextField.dart';
import '../../widget/dropdown.dart';
import '../../widget/loader.dart';

class AddExpenseGeneralMasterScreen extends StatefulWidget {
  final bool isEdit;
  final bool isActive;
  final String id;
  final TransportMode? transport;
  final TransportMode? designation;
  final String? createdBy;
  final String? modifiedBy;
  final String ratePerKm;

  const AddExpenseGeneralMasterScreen({
    super.key,
    this.isEdit = false,
    this.isActive = false,
    this.id = "",
    this.transport,
    this.ratePerKm = '',
    this.designation,
    this.modifiedBy = '',
    this.createdBy = '',
  });

  @override
  State<AddExpenseGeneralMasterScreen> createState() => _AddExpenseGeneralMasterScreenState();
}

class _AddExpenseGeneralMasterScreenState extends State<AddExpenseGeneralMasterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AddExpenseGeneralMasterController addExpenseGeneralMasterController = Get.find<AddExpenseGeneralMasterController>();

  @override
  void initState() {
    // TODO: implement initState
    addExpenseGeneralMasterController.ctrlClear();
    if (widget.designation != null && widget.transport != null && widget.ratePerKm.isNotEmpty) {
      addExpenseGeneralMasterController.selectedDesignation.value = widget.designation;
      addExpenseGeneralMasterController.selectedTransportMode.value = widget.transport;
      addExpenseGeneralMasterController.ratePerKmController.value.text = widget.ratePerKm;
      addExpenseGeneralMasterController.isActive.value = widget.isActive;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor:  AppColors.primaryColor,
        title: Text(
          widget.isEdit ? "Expense Detail" : 'Add Expense General Master',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<TransportMode>(
                          prefixImage: AppImages.designation,
                          hintText: 'Designation',
                          enabled: widget.isEdit ? false : true,
                          items: addExpenseGeneralMasterController.designationList,
                          itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                          selectedItem: addExpenseGeneralMasterController.selectedDesignation.value,
                          onChanged: (TransportMode? transportMode) {
                            if (transportMode != null) {
                              addExpenseGeneralMasterController.designationId.value = transportMode.codeId;
                              addExpenseGeneralMasterController.selectedDesignation.value = transportMode;
                              addExpenseGeneralMasterController.designationId.refresh();
                              addExpenseGeneralMasterController.selectedDesignation.refresh();
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Designation Mode' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                              Row(
                    children: [
                      Obx(() {
                        return CustomDropdown<TransportMode>(
                          prefixImage: AppImages.transportMode,
                          hintText: 'Transport Mode',
                          enabled: widget.isEdit ? false : true,
                          items: addExpenseGeneralMasterController.transportModeList,
                          itemAsString: (TransportMode transportMode) => transportMode.codeDesc,
                          selectedItem: addExpenseGeneralMasterController.selectedTransportMode.value,
                          onChanged: (TransportMode? transportMode) {
                            if (transportMode != null) {
                              addExpenseGeneralMasterController.transportId.value = transportMode.codeId;
                              addExpenseGeneralMasterController.selectedTransportMode.value = transportMode;
                              addExpenseGeneralMasterController.transportId.refresh();
                              addExpenseGeneralMasterController.selectedTransportMode.refresh();
                            }
                          },
                          validator: (value) => value == null ? 'Please select a Transport Mode' : null,
                          showSearchBox: true,
                        );
                      }),
                    ],
                  ),
                              commonTextField(
                      prefixImage: AppImages.km,
                      needValidation: true,
                      validationMessage: "Rate Per Km",
                      enabledBorder: AppColors.black,
                      labelText: "Rate Per Km",
                      controller: addExpenseGeneralMasterController.ratePerKmController.value,
                      textInputType: TextInputType.number,
                      horizontalPadding: null,
                      textColor: AppColors.black),
                              Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Checkbox(
                            value: addExpenseGeneralMasterController.isActive.value,
                            onChanged: (value) {
                              addExpenseGeneralMasterController.isActive.value = value!;
                            });
                      }),
                      const Text("Active"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: addExpenseGeneralMasterController.isLoading.isTrue
                    ? () {}
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          addExpenseGeneralMasterController.addExpense(
                            id: widget.isEdit ? widget.id : "0",
                            createdBy: widget.createdBy ?? '',
                            modifiedBy: widget.modifiedBy ?? '',
                            loading: true,
                            designationId: addExpenseGeneralMasterController.selectedDesignation.value!.codeId,
                            transportModeId: addExpenseGeneralMasterController.selectedTransportMode.value!.codeId,
                            ratePerKM: addExpenseGeneralMasterController.ratePerKmController.value.text,
                            isEdit: widget.isEdit,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColors.primaryColor,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: addExpenseGeneralMasterController.isLoading.value
                    ? loader()
                    : Text(
                        widget.isEdit ? "Update" : "Add",
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
       /*       ElevatedButton(
                onPressed: () {
                  addExpenseGeneralMasterController.isLoading.value = false;
                  if (widget.isEdit == false) {
                    addExpenseGeneralMasterController.selectedTransportMode.value = null;
                    addExpenseGeneralMasterController.selectedDesignation.value = null;
                  }
                  addExpenseGeneralMasterController.ratePerKmController.value.clear();
                  // Handle clear
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteColor,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: BorderSide(color: AppColors.primaryColor)
                  ),
                ),                child: const Text(
                  "Clear",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),*/
            ],
          ),
        );
      }),
    );
  }
}
