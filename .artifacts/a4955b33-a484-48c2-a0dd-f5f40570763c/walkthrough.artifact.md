# Walkthrough - Fixing Navigator Assertion Error & Updating Submit MOM API

I have resolved the `Navigator` assertion error and updated the `submitMeetingMom` API to match the required multipart form-data format.

## Changes Made

### 1. Fixing Navigator Assertion Error

#### [attendance_screen.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/attendance/attendance_screen.dart)
- Wrapped initialization logic in `initState` with `WidgetsBinding.instance.addPostFrameCallback` to avoid building conflicts.

#### [main.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/main.dart)
- Replaced `context.theme.colorScheme.primary` with `AppColors.primaryColor` in `GetMaterialApp` to prevent rebuild loops.

### 2. Updating Submit MOM API

#### [meeting_mom_controller.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting_mom/meeting_mom_controller.dart)
- Refactored `submitMeetingMom` to move parameters from the query string to `Multipart` form data, as requested.
- The URL now only contains `UserId` as a query parameter.
- All other fields (`MeetingId`, `MeetingMOM`, etc.) are now sent within the `FormData` body.

```dart
      String url = "${ApiEndPoint.submitMeetingMom}?UserId=${Uri.encodeComponent(userId)}";

      Map<String, dynamic> body = {
        "MeetingId": meetingId,
        "MeetingMOM": meetingMom,
        "AttendeeCode": attendeeCode,
        "Remarks": remarks,
        "TransportMode": transportMode,
        "OtherExpenses": otherExpenses,
        "OtherExpenseAmt": otherExpenseAmt,
        "OtherExpenseDocument": docName,
      };

      var formData = dio.FormData.fromMap(body);
```

## Verification Results

### API Update
- The `SubmitMom` API now matches the expected `curl` format.
- Debug logs will show the simplified URL and the structured `FormData` body.

### Stability
- The "Navigator locked" error is resolved, ensuring a smooth app launch and navigation.

> [!TIP]
> When using `Dio` for multipart requests, `FormData.fromMap` is a cleaner way to handle multiple text fields alongside files.
