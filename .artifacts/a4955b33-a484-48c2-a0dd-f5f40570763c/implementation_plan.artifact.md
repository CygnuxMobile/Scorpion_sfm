# Implementation Plan - Standardize Meeting Screen API Responses

The goal is to update the Meeting module's API handling to follow a standardized "Swagger-style" response structure (`success`, `data`, `error`/`message`). This ensures robust error handling and consistency across the application.

## User Review Required

> [!IMPORTANT]
> This change will affect how API responses are parsed. If the backend response structure for any of these endpoints deviates from the `{"success": bool, "data": ..., "error": {"message": ...}}` pattern, it might cause parsing issues.

## Proposed Changes

### Meeting Screen

#### [MODIFY] [meeting_response_model.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting/meeting_screen/meeting_response_model.dart)
- Update `MeetingResponseModel.fromJson` to handle null or empty `data` lists when `success` is false.
- Ensure all fields in `MeetingDatum` are safely parsed (e.g., handling nulls).

#### [MODIFY] [meeting_controller.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting/meeting_screen/meeting_controller.dart)
- Update `getMeetingData`:
    - Check `meetingResponseModel.success`.
    - If `success` is true, process `meetingData`.
    - If `success` is false, show a toast message from the response error and reset `isLoading`.
- Refine `checkInOut` error handling to match the format used in other successful implementations (e.g., `submitMeetingMom`).

### Add Meeting Screen

#### [MODIFY] [edit_meeting_response_model.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting/add_meeting_screen/edit_meeting_response_model.dart)
- Standardize the model to match the `success`/`data` structure.

#### [MODIFY] [add_meeting_controller.dart](file:///E:/Aayush/flutter/Scorpion_sfm-git/lib/modules/meeting/add_meeting_screen/add_meeting_controller.dart)
- Update `editMeeting`:
    - Check `success` before attempting to map fields.
    - Show error toast if `success` is false.
- Update `getCustomer`:
    - Ensure `success` check and proper error messaging.

## Verification Plan

### Manual Verification
- **Meeting List**: Verify that the list loads correctly and error toasts appear on simulated failures.
- **Check-In/Out**: Test check-in/out transitions and success/error messages.
- **Edit Meeting**: Verify that existing meeting details are correctly populated when editing.
- **Add Meeting**: Test customer search and form submission.

### Automated Tests
- Not applicable for this UI/API integration task.
