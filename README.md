# Mayo Flutter Push Notifications

## Features

Receive push notifications using Firebase messaging


## Getting started

- Configure a firebase project manually or using the firebase client

```bash
flutterfire configure
```

- Configure android a iOS propertly

### iOS

```
Firebase Messaging plugin will not work if you disable method swizzling. Please remove or set to true the FirebaseAppDelegateProxyEnabled in your Info.plist file if it exists.
```

- [FCM via APNs Integration](https://firebase.flutter.dev/docs/messaging/apple-integration/)


- [Allow images on notifications](https://firebase.flutter.dev/docs/messaging/apple-integration/#advanced-optional-allowing-notification-images)

```
Your device can now display images in a notification by specifying the `imageUrl` option in your FCM payload. Keep in mind that a 300KB max image size is enforced by the device.
```


## Usage
- Start receiving notifications just calling `initNotifications` method inside `PushNotificationsRepository`

This method triggers the allow notifications permissions dialog

```dart
import 'package:mayo_flutter_push_notifications/mayo_flutter_push_notifications.dart';

final pushNotificationsRepository = PushNotificationRepository();

await pushNotificationsRepository.initNotifications();
```

*You can provide the PushNotificationsRepository across the app using flutter_bloc or provider packages*

- Call to `getToken` method to obtain a valid FCM token where send notifications to user

```dart
final token = await pushNotificationsRepository.getToken()
```

- Subscribe/Unsusbscribe to topic

- TODO: Configure several channels


## Additional information

### Flows

- onMessageOpenedApp
Triggers when the app is opened


- getInitialMessage

