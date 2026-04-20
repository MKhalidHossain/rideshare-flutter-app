import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/remote/data/socket_client.dart';
import '../../../home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import '../../../home/domain/reponse_model/request_ride_response_model.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../domain/models/message.dart';

const Color _chatBackground = Color(0xFF2E3747);
const Color _inputBackground = Color(0xFF252D3A);
const Color _incomingBubble = Color(0xFFE9EDF0);
const Color _outgoingBubble = Color(0xFFF1D9D8);
const Color _accentRed = Color(0xFFE53935);

ImageProvider? _avatarImageProvider(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return NetworkImage(path);
  return AssetImage(path);
}

class ChatScreenRTH extends StatefulWidget {
  const ChatScreenRTH({Key? key, 
   this.selectedDriver,
   this.rideBookingInfoFromResponse
   })
    : super(key: key);

  final NearestDriverData? selectedDriver;
      final RequestRideResponseModel ? rideBookingInfoFromResponse;

  @override
  State<ChatScreenRTH> createState() => _ChatScreenRTHState();
}

class _ChatScreenRTHState extends State<ChatScreenRTH> {
  final ChatController chatController = Get.find<ChatController>();
  final AppController appController = Get.find<AppController>();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Worker? _messageWatcher;

   final SocketClient socketClient = SocketClient();

  @override
  void initState() {
    super.initState();
    _messageWatcher = ever<List<Message>>(chatController.messages, (_) {
      _scrollToBottom();
    });
    _setupSocketListeners();
    _joinChatRoom();
  }



  // ✅ UPDATE 7: Updated _joinChatRoom to use rideId instead of senderId/receiverId
void _joinChatRoom() {
  final customerId = widget.rideBookingInfoFromResponse?.notification?.senderId ?? '';
  final driverId = widget.selectedDriver?.driver.userId?.id ?? '';
  
  // ✅ UPDATE 7: Get rideId from your widget (adjust based on your data structure)
  final rideId = widget.rideBookingInfoFromResponse?.data?.rideId ?? '';
                print("Ride ID in chat screen: $rideId");

  // ✅ UPDATE 7: Validate all required fields
  if (customerId.isEmpty || driverId.isEmpty || rideId.isEmpty) {
    print('❌ Missing required data: customerId=$customerId, driverId=$driverId, rideId=$rideId');
    return;
  }

  // ✅ UPDATE 7: Save participants in controller including rideId
  chatController.setParticipants(
    senderId: customerId,
    receiverId: driverId,
    rideId: rideId, // ✅ UPDATE 7: Added rideId
  );

  // ✅ UPDATE 7: Backend now expects only rideId (it validates based on authenticated user)
  socketClient.emit('join-chat', {
    'rideId': rideId,
  });
  
  print('✅ Joining chat room for ride: $rideId');
}


// ✅ UPDATE 8: Updated socket listeners to handle new message format
void _setupSocketListeners() {
  // ✅ UPDATE 8: Handle joined-chat confirmation from backend
  socketClient.on('joined-chat', (data) {
    print('✅ Successfully joined chat room: ${data['rideId']}');
    chatController.isConnected.value = true;
  });

  // ✅ UPDATE 8: Backend now sends full message object with all fields
  socketClient.on('receive-message', (data) {
    // Backend sends: { rideId, senderId, receiverId, message, timestamp }
    print('📨 Received message: $data');
    chatController.onIncomingMessage(data);
  });

  socketClient.on('user-typing', (data) {
    // ✅ UPDATE 8: Optional - check if typing user is the other participant
    final typingUserId = data['userId'] ?? data['senderId'];
    if (typingUserId != chatController.senderId) {
      chatController.isTyping.value = true;
    }
  });

  socketClient.on('user-stop-typing', (data) {
    chatController.isTyping.value = false;
  });
  
  // ✅ UPDATE 8: Handle connection errors
  socketClient.on('error', (data) {
    print('❌ Socket error: $data');
    chatController.isConnected.value = false;
  });
  
  // ✅ UPDATE 8: Handle disconnection
  socketClient.on('disconnect', (data) {
    print('⚠️ Socket disconnected');
    chatController.isConnected.value = false;
  });
  
  // ✅ UPDATE 8: Handle reconnection
  socketClient.on('connect', (data) {
    print('✅ Socket reconnected');
    chatController.isConnected.value = true;
    // Rejoin the chat room after reconnection
    _joinChatRoom();
  });
}


  @override
  void dispose() {
    _messageWatcher?.dispose();
    messageController.dispose();
    scrollController.dispose();

    final p = chatController.participants;
    if (p != null) {
      socketClient.emit('leave-chat', {
        'senderId': p.senderId,
        'receiverId': p.receiverId,
      });
    }


     socketClient.off('receive-message');
  socketClient.off('user-typing');
  socketClient.off('user-stop-typing');
  socketClient.off('joined-chat');
  socketClient.off('error');
  socketClient.off('disconnect');
  socketClient.off('connect');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final driverImage = widget.selectedDriver?.driver.userId?.profileImage;
   // final rideId= widget.rideBookingInfoFromResponse?.data?.rideId ?? '';

final contactName =
        widget.selectedDriver?.driver.userId?.fullName ?? chatController.supportAgentName.value;
    final contactPhone =  widget.selectedDriver?.driver.userId?.phoneNumber ?? '';
    final contactRating =  widget.selectedDriver?.driver.ratings.totalRatings;
    final contactAvatar = _avatarImageProvider(widget.selectedDriver?.driver.userId?.profileImage);
    final subtitleParts = <String>[
    
      if (contactRating != null)
        '${contactRating.toStringAsFixed(1)} rating',
      if (contactPhone.isNotEmpty) contactPhone,
    ];

    return Scaffold(
      backgroundColor: _chatBackground,
      appBar: AppBar(
        backgroundColor: _chatBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: _avatarImageProvider(driverImage),
              child: _avatarImageProvider(driverImage) == null
                  ? const Icon(Icons.person, color: Colors.black87)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectedDriver?.driver.userId?.fullName ?? chatController.supportAgentName.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Obx(
                  () => Text(
                    chatController.supportAgentStatus.value,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => chatController.isConnected.value
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      color: Colors.orange.withOpacity(0.9),
                      child: const Text(
                        'Connection lost. Reconnecting...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  itemCount: chatController.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.messages[index];
                    final showAvatar =
                        !message.isFromUser &&
                        (index == 0 ||
                            chatController.messages[index - 1].isFromUser);
                    return _MessageRow(
                      message: message,
                      showAvatar: showAvatar,
                      userInitial: appController.userName.value.isNotEmpty
                          ? appController.userName.value[0].toUpperCase()
                          : '',
                      receiverName:
                          widget.selectedDriver?.driver.userId?.fullName ??
                          chatController.supportAgentName.value,
                      receiverAvatar: widget.selectedDriver?.driver.userId?.profileImage ?? '',
                    );
                  },
                ),
              ),
            ),
            Obx(
              () => chatController.isTyping.value
                  ? Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 8,
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.support_agent,
                              color: Colors.black87,
                              size: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Customer service is typing...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: _inputBackground.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade800.withOpacity(0.4),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: TextField(
                controller: messageController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: _accentRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    chatController.sendMessage(text);
    messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (!scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }
}

class _MessageRow extends StatelessWidget {
  final Message message;
  final bool showAvatar;
  final String userInitial;
  final String receiverName;
  final String? receiverAvatar;

  const _MessageRow({
    Key? key,
    required this.message,
    required this.showAvatar,
    required this.userInitial,
    required this.receiverName,
    required this.receiverAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isFromUser;
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: isUser ? 60 : 0,
        right: isUser ? 0 : 60,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            showAvatar
                ? CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    backgroundImage: _avatarImageProvider(receiverAvatar),
                    child: _avatarImageProvider(receiverAvatar) == null
                        ? Text(
                            receiverName.isNotEmpty
                                ? receiverName[0].toUpperCase()
                                : 'R',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  )
                : const SizedBox(width: 36),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? _outgoingBubble : _incomingBubble,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUser ? 18 : 8),
                      topRight: Radius.circular(isUser ? 8 : 18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message.timestamp),
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Text(
                userInitial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'pm' : 'am';
    return '$hour:$minute $suffix';
  }
}
