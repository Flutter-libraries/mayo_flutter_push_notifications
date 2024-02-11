enum FCMMessageEvent {
  tapped,
  oppenedApp,
  initialMessage,
}

class FCMMessageReceived {
  FCMMessageReceived({
    required this.metadata,
    required this.messageId,
  });

  final String? messageId;
  final Map<String, dynamic> metadata;
}

class FCMEvent {
  FCMEvent({
    required this.message,
    required this.event,
  });

  final FCMMessageReceived message;
  final FCMMessageEvent event;
}
