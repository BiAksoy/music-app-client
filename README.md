# Music App

This is a music app that allows users to authenticate and manage their songs. It is built following the MVVM architectural pattern using Flutter, Riverpod, and http. This frontend is for the backend available [here](https://github.com/BiAksoy/music-app-server).

## Getting Started

By default, the app is configured to run on an emulator or simulator. If you want to run the app on a real device, you need to change the `serverUrl` in the `lib/core/constants/server_constant.dart` file to your local IP address.

```dart
  import 'dart:io';

  class ServerConstant {
    static String serverUrl = 'http://YOUR_LOCAL_IP_ADDRESS:8000';
  }
```
