# viral_gamification_app

## Getting Started - Running the app on a phone, no compilation necessary

Note that this app currently only works on Android phones.  
Download the APK file from [here](http://deco3801-teamexe.uqcloud.net/static/VIRALITY.apk) to the downloads folder on your phone. Open up the options for that file, and tap install. You may need to enable a setting to allow downloading apps from APKs. All done!

## Getting Started - Compiling the app yourself

This guide will setup the app in IntelliJ.

### Clone Repository

For the tutor marking this, just use the code that was uploaded. Otherwise:
File -> New -> Project from Version Control  
Version Control: Git  
URL: https://github.com/JamesP797/viral_gamification_app.git

### Download Android SDK

File -> Settings -> Appearance & Behavior -> System Settings -> Android SDK  
Click 'Edit' next to Android SDK Location and continue with defaults.  
Once its done, make sure Android API 33 is ticked in the list (We might have to change this to get it to run on specific peoples phones, but it's fine for now just to get things running).  
File -> Project Structure -> Project  
Set Project SDK to Android API 33.  

### Setting up Dart and Flutter

File -> Settings -> Plugins  
Search for Flutter in the marketplace. This will also prompt to install Dart.  
Download and extract the 2.17.6 Dart SDK from https://dart.dev/get-dart/archive and remember the install location.  
File -> Settings -> Languages & Frameworks -> Dart  
Tick enable.  
Set the Dart SDK path to where you installed it e.g. C:\path\to\dart-sdk  
Enable Dart support for Project 'viral_gamification_app'.  

Download and extract 3.0.5 Flutter SDK from https://docs.flutter.dev/get-started/install/windows and the remember location.  
File -> Settings -> Languages & Frameworks -> Flutter  
Set the Flutter SDK path to where you installed it e.g. C:\path\to\flutter    

### Setting up the Emulator

If you're happy to debug on your Android device, you can plug it in and select it from the devices dropdown when you run. Otherwise, you can use an emulator (this is the alternative if you do not have an Android device):  
Tools -> Android -> AVD Manager  
Create a new virtual device. I left as default, Pixel 2. Download the top image in recommended, 'R'. If you are using a machine with an AMD processor, there will also be a recommendation to install Android Emulator Hypervisor for AMD Processes. Do this.  

Now from the AVD menu click the play button on the device. A phone should open on your screen. If it doesn't, just restart IntelliJ.  
This device should automatically get selected in the devices dropdown in the run toolbar, if it doesn't you can manually select it. Note that the phone may take some time to boot before it can be selected here.  
Click run! the first time you run it might take a while to build, but eventually the template app should appear on the emulated phone.  

### Potential Issues

#### Gradle build fails claiming you are using an earlier Java version e.g. 1.8

1. Open cmd as admin  
2. write: setx /M JAVA_HOME "C:\Progra~1\Java\jdk-11.0.6" (You will have to modify this for your own specific JDK version/path, you can find the path/version in Intellij by going file -> Project Structure -> SDKs)  
3. Restart Intellij and Android Studio  

If you're still having issues, there may be some potential solutions here: https://stackoverflow.com/questions/66980512/android-studio-error-android-gradle-plugin-requires-java-11-to-run-you-are-cur  
Thanks Riley!  

Feel free to update this if any step is wrong or unclear, or if you fix an issue that might be helpful to others.  

## Packages used

Although all code has been written by our team, we have used a variety of different third-party packages to assist in the development of some features:  
- nearby_connections: a package to allow Bluetooth communication between devices for infection  
- http: enable http communication  
- requests: enable API requests to our back-end  
- provider: enable global storage across the app to store user and disease related information  
- shared_preferences: enable key-value storage on the device to retain user credentials locally  
- device_info_plus: retrieve standard device information to assist in generating unique tokens for authentication  
- charts_flutter_new: package to create the graph on the home screen  
- expandable: package to create the expandable widgets in the glossary  
We also use the ShareTech font
