//
var admin = require('firebase-admin');
// 1. Download a service account key (JSON file) from your Firebase console and add to the example/scripts directory
var serviceAccount = require('./google-services.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

// 2. Copy the token for your device that is printed in the console on app start (`flutter run`) for the FirebaseMessaging example
const token = 'eLlye_A4XUzQp1Ns4c5xMj:APA91bEioegQyS7OoprPtTuiT7gR8jogDuK3Z88Zd--U6xVl751ficRzp8q3OtAYRlQrmvK6aQsWZXAmARQR0i4kE3-2QurDIZgvtZ5y8DrUdEENGwWFBSX_JFFupIKFTLs2jCJjddne';


// 3. From your terminal, root to example/scripts directory & run `npm install`.
// 4. Run `npm run send-message` in the example/scripts directory and your app will receive messages in any state; foreground, background, terminated.
// If you find your messages have stopped arriving, it is extremely likely they are being throttled by the platform. iOS in particular
// are aggressive with their throttling policy.
admin
    .messaging()
    .sendToDevice(
        [token],
        {
            data: {
                foo: 'bar',
                route: '/chat/DmAEOYQpD6PJdonU3ktj'
            },
            notification: {
                title: 'A great title',
                body: 'Great content',
            },
        },
        {
            // Required for background/terminated app state messages on iOS
            contentAvailable: true,
            // Required for background/terminated app state messages on Android
            priority: 'high',
        }
    )
    .then((res) => {
        if (res.failureCount) {
            console.log('Failed', res.results[0].error);
        } else {
            console.log('Success');
        }
    })
    .catch((err) => {
        console.log('Error:', err);
    });