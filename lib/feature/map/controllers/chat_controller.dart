// import 'package:get/get.dart';
// import '../../../helpers/remote/data/socket_client.dart';
// import '../domain/models/message.dart';


// class ChatParticipants {
//   final String senderId;
//   final String receiverId;

//   ChatParticipants({
//     required this.senderId,
//     required this.receiverId,
//   });
// }

// class ChatController extends GetxController {
//   // Chat state
//   var messages = <Message>[].obs;
//   var isTyping = false.obs;
//   var isConnected = true.obs;
 
//   String? senderId;
//   String? receiverId;

//   final SocketClient socketClient = SocketClient();

//   ChatParticipants? get participants {
//     if (senderId == null || receiverId == null) return null;
//     return ChatParticipants(
//       senderId: senderId!,
//       receiverId: receiverId!,
//     );
//   }

//   void setParticipants({
//     required String senderId,
//     required String receiverId,
//   }) {
//     this.senderId = senderId;
//     this.receiverId = receiverId;
//   }

//   // Support agent info
//   var supportAgentName = 'Customer Name'.obs;
//   var supportAgentStatus = 'Online'.obs;
//   var supportAgentId = 'agent_001'.obs;
  
//   // Chat settings
//   var isChatActive = false.obs;
//   var unreadCount = 0.obs;
//   var lastMessageTime = Rxn<DateTime>();
  
//   @override
//   void onInit() {
//     super.onInit();
//   }
  
//   // Called from AppController
//   void setConnectionStatus(bool connected) {
//     isConnected.value = connected;
//     supportAgentStatus.value = connected ? 'Online' : 'Offline';
//   }

//   void initializeChat() {
//     messages.add(Message(
//       id: '1',
//       text: 'Hello! I\'m Sarah, your customer support agent. How can I help you today?',
//       isFromUser: false,
//       timestamp: DateTime.now(),
//       status: MessageStatus.delivered,
//     ));
    
//     checkConnection();
//   }
 
//   void checkConnection() {
//     Future.delayed(Duration(seconds: 1), () {
//       isConnected.value = true;
//       supportAgentStatus.value = 'Online';
//     });
//   }

//   // ✅ FIX: Check who sent the message
//   void onIncomingMessage(dynamic data) {
//     try {
//       // Now backend sends full payload with senderId
//       final messageText = data is String ? data : (data['message'] ?? '');
//       final messageSenderId = data is Map ? data['senderId'] : null;
      
//       // ✅ Ignore if this is our own message echoed back (shouldn't happen with socket.to() fix)
//       if (messageSenderId == senderId) {
//         print('⚠️ Ignoring own message echo');
//         return;
//       }

//       final msg = Message(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         text: messageText,
//         isFromUser: false, // This is from the other person
//         timestamp: DateTime.now(),
//         status: MessageStatus.delivered,
//       );

//       messages.add(msg);
//       lastMessageTime.value = DateTime.now();
//       unreadCount.value++;
//     } catch (e) {
//       print('❌ Error in onIncomingMessage: $e');
//     }
//   }
  
//   void sendMessage(String text) {
//     if (text.trim().isEmpty) return;
//     if (senderId == null || receiverId == null) {
//       print('❌ senderId/receiverId not set');
//       return;
//     }

//     final cleanText = text.trim();

//     // 1) Update UI immediately
//     final userMessage = Message(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       text: cleanText,
//       isFromUser: true,
//       timestamp: DateTime.now(),
//       status: MessageStatus.sending,
//     );

//     messages.add(userMessage);
//     lastMessageTime.value = DateTime.now();

//     // 2) Emit through socket
//     socketClient.emit('send-message', {
//       'senderId': senderId,
//       'receiverId': receiverId,
//       'message': cleanText,
//     });

//     // 3) Mark as sent (optimistic)
//     final index = messages.indexWhere((m) => m.id == userMessage.id);
//     if (index != -1) {
//       messages[index] = userMessage.copyWith(status: MessageStatus.sent);
//       messages.refresh();
//     }
//   }

  
//   void simulateAgentResponse(String userMessage) {
//     isTyping.value = true;
    
//     Future.delayed(Duration(seconds: 2), () {
//       isTyping.value = false;
      
//       String response = generateResponse(userMessage);
      
//       final agentMessage = Message(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         text: response,
//         isFromUser: false,
//         timestamp: DateTime.now(),
//         status: MessageStatus.delivered,
//       );
      
//       messages.add(agentMessage);
//       lastMessageTime.value = DateTime.now();
//     });
//   }
  
//   String generateResponse(String userMessage) {
//     String message = userMessage.toLowerCase();
    
//     if (message.contains('hello') || message.contains('hi')) {
//       return 'Hello! How can I assist you with your ride today?';
//     } else if (message.contains('cancel')) {
//       return 'I can help you cancel your booking. Would you like me to proceed with the cancellation?';
//     } else if (message.contains('driver')) {
//       return 'I can help you with driver-related issues. What specific problem are you experiencing?';
//     } else if (message.contains('payment')) {
//       return 'I can assist with payment issues. Are you having trouble with a specific payment method?';
//     } else if (message.contains('refund')) {
//       return 'I understand you\'re looking for a refund. Let me check your recent trips and see what I can do for you.';
//     } else if (message.contains('location')) {
//       return 'I can help with location issues. Are you having trouble with pickup or destination locations?';
//     } else if (message.contains('price') || message.contains('fare')) {
//       return 'I can explain the fare breakdown for your trip. Would you like me to review the charges?';
//     } else if (message.contains('thank')) {
//       return 'You\'re welcome! Is there anything else I can help you with today?';
//     } else if (message.contains('problem') || message.contains('issue')) {
//       return 'I\'m sorry to hear you\'re experiencing an issue. Can you please provide more details so I can better assist you?';
//     } else {
//       return 'I understand your concern. Let me look into this for you. Can you provide more details about what you\'re experiencing?';
//     }
//   }
  
//   void markMessageAsRead(String messageId) {
//     final index = messages.indexWhere((m) => m.id == messageId);
//     if (index != -1 && !messages[index].isFromUser) {
//       messages[index] = messages[index].copyWith(status: MessageStatus.read);
//       messages.refresh();
      
//       if (unreadCount.value > 0) {
//         unreadCount.value--;
//       }
//     }
//   }
  
//   void markAllMessagesAsRead() {
//     for (int i = 0; i < messages.length; i++) {
//       if (!messages[i].isFromUser && messages[i].status != MessageStatus.read) {
//         messages[i] = messages[i].copyWith(status: MessageStatus.read);
//       }
//     }
//     messages.refresh();
//     unreadCount.value = 0;
//   }
  
//   void clearChat() {
//     messages.clear();
//     unreadCount.value = 0;
//     lastMessageTime.value = null;
//   }
  
//   void startChat() {
//     isChatActive.value = true;
//     markAllMessagesAsRead();
//   }
  
//   void endChat() {
//     isChatActive.value = false;
    
//     final goodbyeMessage = Message(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       text: 'Thank you for contacting support. Have a great day!',
//       isFromUser: false,
//       timestamp: DateTime.now(),
//       status: MessageStatus.delivered,
//     );
    
//     messages.add(goodbyeMessage);
//   }
  
//   void reportMessage(String messageId) {
//     Get.snackbar('Report Submitted', 'Thank you for reporting this message');
//   }
  
//   void blockUser() {
//     Get.snackbar('User Blocked', 'This user has been blocked');
//     endChat();
//   }
  
//   void reconnect() {
//     isConnected.value = false;
//     supportAgentStatus.value = 'Connecting...';
    
//     Future.delayed(Duration(seconds: 2), () {
//       isConnected.value = true;
//       supportAgentStatus.value = 'Online';
//       Get.snackbar('Connected', 'You are now connected to support');
//     });
//   }
  
//   // Utility methods
//   int getUnreadCount() {
//     return messages.where((m) => !m.isFromUser && m.status != MessageStatus.read).length;
//   }
  
//   Message? getLastMessage() {
//     return messages.isNotEmpty ? messages.last : null;
//   }
  
//   List<Message> getMessagesFromToday() {
//     final today = DateTime.now();
//     return messages.where((m) => 
//       m.timestamp.year == today.year &&
//       m.timestamp.month == today.month &&
//       m.timestamp.day == today.day
//     ).toList();
//   }
// }




import 'package:get/get.dart';
import '../../../helpers/custom_snackbar.dart';
import '../../../helpers/remote/data/socket_client.dart';
import '../domain/models/message.dart';

class ChatParticipants {
  final String senderId;
  final String receiverId;
  final String rideId; // ✅ UPDATE 1: Added rideId to participants

  ChatParticipants({
    required this.senderId,
    required this.receiverId,
    required this.rideId, // ✅ UPDATE 1: Added rideId parameter
  });
}

class ChatController extends GetxController {
  // Chat state
  var messages = <Message>[].obs;
  var isTyping = false.obs;
  var isConnected = true.obs;
 
  String? senderId;
  String? receiverId;
  String? rideId; // ✅ UPDATE 2: Added rideId to controller state

  final SocketClient socketClient = SocketClient();

  ChatParticipants? get participants {
    if (senderId == null || receiverId == null || rideId == null) return null; // ✅ UPDATE 3: Check rideId as well
    return ChatParticipants(
      senderId: senderId!,
      receiverId: receiverId!,
      rideId: rideId!, // ✅ UPDATE 3: Include rideId in participants
    );
  }

  void setParticipants({
    required String senderId,
    required String receiverId,
    required String rideId, // ✅ UPDATE 4: Added rideId parameter
  }) {
    this.senderId = senderId;
    this.receiverId = receiverId;
    this.rideId = rideId; // ✅ UPDATE 4: Store rideId
  }

  // Support agent info
  var supportAgentName = 'Customer Name'.obs;
  var supportAgentStatus = 'Online'.obs;
  var supportAgentId = 'agent_001'.obs;
  
  // Chat settings
  var isChatActive = false.obs;
  var unreadCount = 0.obs;
  var lastMessageTime = Rxn<DateTime>();
  
  @override
  void onInit() {
    super.onInit();
  }
  
  // Called from AppController
  void setConnectionStatus(bool connected) {
    isConnected.value = connected;
    supportAgentStatus.value = connected ? 'Online' : 'Offline';
  }

  void initializeChat() {
    messages.add(Message(
      id: '1',
      text: 'Hello! I\'m Sarah, your customer support agent. How can I help you today?',
      isFromUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
    ));
    
    checkConnection();
  }
 
  void checkConnection() {
    Future.delayed(Duration(seconds: 1), () {
      isConnected.value = true;
      supportAgentStatus.value = 'Online';
    });
  }

  // ✅ UPDATE 5: Updated to handle new backend message format with all fields
  void onIncomingMessage(dynamic data) {
    try {
      // ✅ UPDATE 5: Backend now sends full object with rideId, senderId, receiverId, message, timestamp
      if (data is! Map) {
        print('⚠️ Invalid message format');
        return;
      }

      final messageText = data['message'] ?? '';
      final messageSenderId = data['senderId'];
      final messageRideId = data['rideId'];
      final timestamp = data['timestamp'];
      
      // ✅ UPDATE 5: Ignore if this is our own message echoed back
      if (messageSenderId == senderId) {
        print('⚠️ Ignoring own message echo');
        return;
      }

      // ✅ UPDATE 5: Validate that message belongs to current ride
      if (messageRideId != rideId) {
        print('⚠️ Message from different ride, ignoring');
        return;
      }

      final msg = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: messageText,
        isFromUser: false, // This is from the other person
        timestamp: timestamp != null ? DateTime.parse(timestamp) : DateTime.now(),
        status: MessageStatus.delivered,
      );

      messages.add(msg);
      lastMessageTime.value = DateTime.now();
      unreadCount.value++;
    } catch (e) {
      print('❌ Error in onIncomingMessage: $e');
    }
  }
  
  // ✅ UPDATE 6: Updated sendMessage to include rideId
  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    // ✅ UPDATE 6: Check all required fields including rideId
    if (senderId == null || receiverId == null || rideId == null) {
      print('❌ senderId/receiverId/rideId not set');
      return;
    }

    final cleanText = text.trim();

    // 1) Update UI immediately
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: cleanText,
      isFromUser: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    messages.add(userMessage);
    lastMessageTime.value = DateTime.now();

    // 2) ✅ UPDATE 6: Emit with rideId included (backend expects this)
    socketClient.emit('send-message', {
      'rideId': rideId, // ✅ UPDATE 6: Added rideId
      'senderId': senderId,
      'receiverId': receiverId,
      'message': cleanText,
    });

    // 3) Mark as sent (optimistic)
    final index = messages.indexWhere((m) => m.id == userMessage.id);
    if (index != -1) {
      messages[index] = userMessage.copyWith(status: MessageStatus.sent);
      messages.refresh();
    }
  }

  
  void simulateAgentResponse(String userMessage) {
    isTyping.value = true;
    
    Future.delayed(Duration(seconds: 2), () {
      isTyping.value = false;
      
      String response = generateResponse(userMessage);
      
      final agentMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: response,
        isFromUser: false,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
      );
      
      messages.add(agentMessage);
      lastMessageTime.value = DateTime.now();
    });
  }
  
  String generateResponse(String userMessage) {
    String message = userMessage.toLowerCase();
    
    if (message.contains('hello') || message.contains('hi')) {
      return 'Hello! How can I assist you with your ride today?';
    } else if (message.contains('cancel')) {
      return 'I can help you cancel your booking. Would you like me to proceed with the cancellation?';
    } else if (message.contains('driver')) {
      return 'I can help you with driver-related issues. What specific problem are you experiencing?';
    } else if (message.contains('payment')) {
      return 'I can assist with payment issues. Are you having trouble with a specific payment method?';
    } else if (message.contains('refund')) {
      return 'I understand you\'re looking for a refund. Let me check your recent trips and see what I can do for you.';
    } else if (message.contains('location')) {
      return 'I can help with location issues. Are you having trouble with pickup or destination locations?';
    } else if (message.contains('price') || message.contains('fare')) {
      return 'I can explain the fare breakdown for your trip. Would you like me to review the charges?';
    } else if (message.contains('thank')) {
      return 'You\'re welcome! Is there anything else I can help you with today?';
    } else if (message.contains('problem') || message.contains('issue')) {
      return 'I\'m sorry to hear you\'re experiencing an issue. Can you please provide more details so I can better assist you?';
    } else {
      return 'I understand your concern. Let me look into this for you. Can you provide more details about what you\'re experiencing?';
    }
  }
  
  void markMessageAsRead(String messageId) {
    final index = messages.indexWhere((m) => m.id == messageId);
    if (index != -1 && !messages[index].isFromUser) {
      messages[index] = messages[index].copyWith(status: MessageStatus.read);
      messages.refresh();
      
      if (unreadCount.value > 0) {
        unreadCount.value--;
      }
    }
  }
  
  void markAllMessagesAsRead() {
    for (int i = 0; i < messages.length; i++) {
      if (!messages[i].isFromUser && messages[i].status != MessageStatus.read) {
        messages[i] = messages[i].copyWith(status: MessageStatus.read);
      }
    }
    messages.refresh();
    unreadCount.value = 0;
  }
  
  void clearChat() {
    messages.clear();
    unreadCount.value = 0;
    lastMessageTime.value = null;
  }
  
  void startChat() {
    isChatActive.value = true;
    markAllMessagesAsRead();
  }
  
  void endChat() {
    isChatActive.value = false;
    
    final goodbyeMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: 'Thank you for contacting support. Have a great day!',
      isFromUser: false,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
    );
    
    messages.add(goodbyeMessage);
  }
  
  void reportMessage(String messageId) {
    showAppSnackBar(
      'Report Submitted',
      'Thank you for reporting this message',
      isError: false,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void blockUser() {
    showAppSnackBar(
      'User Blocked',
      'This user has been blocked',
      isError: false,
      snackPosition: SnackPosition.BOTTOM,
    );
    endChat();
  }
  
  void reconnect() {
    isConnected.value = false;
    supportAgentStatus.value = 'Connecting...';
    
    Future.delayed(Duration(seconds: 2), () {
      isConnected.value = true;
      supportAgentStatus.value = 'Online';
      showAppSnackBar(
        'Connected',
        'You are now connected to support',
        isError: false,
        snackPosition: SnackPosition.BOTTOM,
      );
    });
  }
  
  // Utility methods
  int getUnreadCount() {
    return messages.where((m) => !m.isFromUser && m.status != MessageStatus.read).length;
  }
  
  Message? getLastMessage() {
    return messages.isNotEmpty ? messages.last : null;
  }
  
  List<Message> getMessagesFromToday() {
    final today = DateTime.now();
    return messages.where((m) => 
      m.timestamp.year == today.year &&
      m.timestamp.month == today.month &&
      m.timestamp.day == today.day
    ).toList();
  }
}
