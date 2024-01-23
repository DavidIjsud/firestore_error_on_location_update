# firestore_error

A new mini demostration project done with dart and swift to show the error and crash that ios shows while data is being sent to firebase
at the same time that dart side send data to firebase as well.

## Getting Started


To replicate this error:

1.- Run the project.
2.- Tap the button : "Request location authorization".
3.- on modal that request the location authorization select "While in use the app".
4.- then Select "Always".
5.- Close the app (no background) , kill it , terminate it.
6.- Open the app
7.- Tap de button Send data to firebase from flutter

NOTE: i realized that this crashs happen while the location send data to firebase on swift side and at the same time dart send data to firebase as well.

