# Flutter app for managing receipts 

Implementing Cloud Firestore, Firebase Storage querying, CURD, pagination, searching, sharing files, user managemnet, camera and gallery for image
All this intregrated together with redux architecture

<img align="left" width="250" height="500" src="https://user-images.githubusercontent.com/45196516/66695800-2db3cc00-ece3-11e9-91af-22db8a9ff910.png">
<img align="right" width="250" height="500" src="https://user-images.githubusercontent.com/45196516/66695635-ae71c880-ece1-11e9-943a-08a9f38a51b5.png">
<img align="center" width="250" height="500" src="https://user-images.githubusercontent.com/45196516/66695767-f513f280-ece2-11e9-85fd-fbb554433159.png">



## Getting Started with prerequisites

1. Migrate the app to AndroidX from android.support libraries
    Or create project with flutter create --androidx project_name
2. Add the following dependencies to your pubspec.yaml
    firebase_auth, google_sign_in, flutter_auth_buttons(optional), image_picker, redux, lutter_redux, redux_thunk, shared_preferences, cloud_firestore, firebase_storage, intl, dio, path_provider, share_extend, http   
3. Go to Firebase website create an account 
4. Create project in the Firebase Console and follow the steps shown there
5. Download the JSON file adn paste it in your app_name/android/app folder
6. Do the changes in project-level and app-level build.gradle file
7. sync the changes in gradle files using an IDE (example-AndroidStudio)
8. For Google sign in you need to add your sha1 fingerprint to your app in Firebase Console / Project Setting
9. Create Cloud FireStore Database and Firebase storage databse

### Note

1. Do not skip any steps

