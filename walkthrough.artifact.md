# Walkthrough - MOM Validation Restored

I have restored the mandatory validation for the MOM (Minutes of Meeting) field in the Add/Edit Meeting screen.

## Changes Made

### Meeting Module

#### [add_meeting_screen.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting/add_meeting_screen/add_meeting_screen.dart)
- Restored the `validator` for the MOM `MultiDropdown` widget.
- Set the validation message to **"Please select MOM"**.
- This ensures that when editing a completed meeting, the user must select at least one MOM entry before they can successfully click "Update".

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Please select MOM';
  }
  return null;
},
```

## Verification

### UI Behavior
- Navigate to the Edit Meeting screen for a completed meeting.
- Leave the MOM field empty and click **Update**.
- The field should now highlight in red with the error message "Please select MOM".
- The form will only submit once at least one MOM item is selected.
