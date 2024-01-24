# firestore_error

A new mini demonstration project done with Dart and Swift to show the error and crash that iOS shows while data is being sent to Firebase at the same time that Dart side sends data to Firebase as well.

## Getting Started

To replicate this error:

1. Run the project.

2. Tap the button: "Request location authorization".

3. On the modal that requests the location authorization, select "While in use the app".

4. Then select "Always".

5. Close the app (no background), kill it, terminate it.

6. Open the app.

7. Tap the button "Send data to Firebase from Flutter".


NOTE: if you are using emulator , add free way drive on the emulator and if you are using physical device try to move more.

**Note:** I realized that these crashes happen while the location sends data to Firebase on the Swift side and at the same time Dart sends data to Firebase as well.
