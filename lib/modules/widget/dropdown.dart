import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_text_style.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? selectedItem;
  final List<T>? selectedItems; // For multi-select
  final String Function(T item) itemAsString;
  final void Function(List<T>? values)? onMultiChanged; // Multi-select handler
  final void Function(T? value)? onChanged; // Single-select handler
  final String? Function(List<T>? values)? multiValidator; // Multi-select validator
  final String? Function(T? value)? validator; // Single-select validator
  final String? prefixImage; // Single-select validator
  final bool showSearchBox;
  final bool enabled;
  final Function()? onClearTap;

  const CustomDropdown(
      {super.key,
      required this.hintText,
      required this.items,

      required this.itemAsString,
      this.selectedItem,
      this.selectedItems,
      this.onChanged,
      this.onMultiChanged,
      this.validator,
      this.multiValidator,
      this.prefixImage,
      this.showSearchBox = false,
      this.enabled = true,
      this.onClearTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          DropdownSearch<T>(

            enabled: enabled,
            itemAsString: itemAsString,
            clearButtonProps: ClearButtonProps(color: Colors.red, icon: const Icon(Icons.clear), isVisible: true, onPressed: onClearTap),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                fillColor: AppColors.whiteColor,
                filled: true,
                prefixIcon:prefixImage!=null? Image.asset(prefixImage!,scale: 15,):null,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color:  AppColors.boderColor,
                    width: 1,

                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color:Colors.red,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color:  Colors.red,
                    width: 1,
                  ),
                ),
                hintStyle: AppTextStyle.regular.copyWith(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
                labelStyle: AppTextStyle.regular.copyWith(
                  fontSize: 14,
                  color:AppColors.grey,
                ),
                hintText: hintText,
                labelText: hintText,
              ),
            ),
            items: items,
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: showSearchBox,
              itemBuilder: (context, item, isSelected) {
                return ListTile(
                  title: Text(itemAsString(item)),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
                );
              },
            ),
            dropdownBuilder: (context, selectedItem) {
              return Text(
                selectedItem != null ? itemAsString(selectedItem) : hintText,
                style:  TextStyle(fontSize: 16 , color: selectedItem != null ?AppColors.black: AppColors.grey),
              );
            },
            selectedItem: selectedItem,
            onChanged: (value) {
              if (onChanged != null) onChanged!(value);
            },
            validator: validator,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class DropdownSkeleton extends StatefulWidget {
  const DropdownSkeleton({super.key});

  @override
  State<DropdownSkeleton> createState() => _DropdownSkeletonState();
}

class _DropdownSkeletonState extends State<DropdownSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              // icon placeholder
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),

              // text placeholder
              Expanded(
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class RetryDropdown extends StatelessWidget {
  final VoidCallback onTap;
  final String message;

  const RetryDropdown({
    super.key,
    required this.onTap,
    this.message = "Tap to retry",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.redColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.refresh,
                color: AppColors.redColor,
              ),
              const SizedBox(width: 8),

              // 👇 THIS IS THE FIX
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.redColor,
                  ),
                  maxLines: 2, // optional
                  overflow: TextOverflow.ellipsis, // optional
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}