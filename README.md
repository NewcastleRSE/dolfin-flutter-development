# dolfin-flutter
The Flutter-based app for the [DOLFIN Project](https://www.npeu.ox.ac.uk/dolfin).   

## About

Babies who are born very early, or who suffer poor blood supply or lack of oxygen to the brain before or around birth, are more likely to have problems with their brain development and child neurological development. This may affect how children think and learn, communicate, play, and interact with the world around them.

DOLFIN aims to answer the research question:

In babies who are born very early or who suffer poor blood supply or lack of oxygen to the brain before or around birth, does giving a nutritional supplement daily for a year improve long-term cognitive development?

The NPEU team have access to the Firebase database using a service account with a private key. This expires around the beginning of June annually. NPEU will give us  a new public key and we upload this to the service account through the Google console. 

### Project Team
**PI(s):** [Jeremy Parr](https://research.ncl.ac.uk/neurodisability/theteam/jeremyparr/)  
**RSE(s):** 
* [Mike Simpson](https://rse.ncldata.dev/mike-simpson) [(@mdsimpson42)](https://github.com/mdsimpson42) 
* [Kate Court](https://rse.ncldata.dev/kate-court) [(@KateCourt)](https://github.com/KateCourt) 
* [Mark Turner](https://rse.ncldata.dev/mark-turner) [(@markdturner)](https://github.com/markdturner)
* [Imre Draskovits](https://rse.ncldata.dev/imre-draskovits) [(@notimre)](https://github.com/notimre)

## Getting Started

### Prerequisites

The application uses Flutter.

* The instructions for installing Flutter on various platforms are [here](https://docs.flutter.dev/get-started/install).
* Instructions for configuring VS Code are [here](https://docs.flutter.dev/development/tools/vs-code). 

These include instructions for installing and configuring the Flutter SDK and Android Studio, including setting up a device emulator.

The project expects environment variables stored in a `.env` file saved at the project root. See `.env.example` for details of what is required.

### Firebase Setup

To get the app to work correctly with Firebase:

* **Android** - download google-services.json for the app on Firebase and copy it to the "android/app" folder.

### Debugging the App (Android)

Once Flutter, Android Studio and VS Code are installed and configured, you can run the app on the Android device emulator. The Android Emulator should appear in the list of available devices in VS Code and, once selected, can be run with "Run -> Start Debugging" (or F5).

### Debugging the App (iOS)

`N/A`

### Installation

#### Android

`N/A`

#### iOS

```
fastlane match development
fastlane match appstore
pod install
bundle install
flutter build ipa
bundle exec fastlane beta
```

### Regenerating the Icons
The base icon image is specified in `pubspec.yaml` and the relevant dependencies should be installed automatically.
To regenerate the icons (for Android and iOS), edit the master image file and then use the following commands:

```
flutter pub get  
flutter pub run flutter_launcher_icons:main
```

## Roadmap

- [x] Initial Development  
- [x] Minimum viable product  
- [x] Feature-Complete

## Acknowledgements
This work was funded by a grant from the UK Research Councils, EPSRC grant ref. EP/L012345/1, “Example project title, please update”.
