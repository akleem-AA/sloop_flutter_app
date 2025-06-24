# sixam_mart

The whole project documention 
https://docs.6amtech.com/docs-six-am-mart/mobile-apps/mandatory-setup
A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Here is some update for release build and upload the app on play store and apple store


these command has been used for create abb file in android

make sure update the version befor run the below commands 
pubspace.yaml file 
version: 1.0.0+5 //1.0.0+6
local.properties:-
flutter.versionCode=5 //shoudl be 6

if you have another system to change you
change the file path 


cd path/to/your/flutter_project
flutter clean
flutter pub get
flutter build apk --release
flutter build appbundle --release


make debug apk use below command
flutter clean 
	flutter build apk –split-per-abi

creating the .aab file for android 

fvm flutter clean
fvm flutter pub get
fvm flutter build appbundle --release

we are using the Google Play App singin key for updating the android app
if you don't have keystore.jsk file it will auto manage with GPAS


here is keystore details:- 
password: listandsell



Is CN=sloop, OU=listandsell, O=listandsell, L=berlin, ST=berlin, C=de correct?





