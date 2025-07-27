import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../controllers/chat_controller.dart';
import '../../domain/models/message.dart';
import 'call_screen.dart';

class ChatScreen extends StatelessWidget {
  final ChatController chatController = Get.find<ChatController>();
  final AppController appController = Get.find<AppController>();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2C3E50),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C3E50),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              child: Icon(Icons.support_agent, color: Colors.white),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    chatController.supportAgentName.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Obx(() => Text(
                    chatController.supportAgentStatus.value,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () => Get.to(() => CallScreen()),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status
          Obx(() => !chatController.isConnected.value
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                color: Colors.orange,
                child: Text(
                  'Connection lost. Trying to reconnect...',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              )
            : SizedBox.shrink()),
          
          // Messages List
          Expanded(
            child: Obx(() => ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.all(16),
              itemCount: chatController.messages.length,
              itemBuilder: (context, index) {
                final message = chatController.messages[index];
                return _buildMessageBubble(message);
              },
            )),
          ),
          
          // Typing Indicator
          Obx(() => chatController.isTyping.value
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.support_agent, color: Colors.white, size: 16),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Customer service is typing...',
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink()),
          
          // Message Input
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF34495E),
              border: Border(top: BorderSide(color: Colors.grey[700]!)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: () => Get.snackbar('Info', 'File attachment coming soon!'),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFF2C3E50),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isFromUser 
          ? MainAxisAlignment.end 
          : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey,
              child: Icon(Icons.support_agent, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isFromUser ? Colors.red : Color(0xFF34495E),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isFromUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue,
              child: Text(
                appController.userName.value[0].toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      chatController.sendMessage(messageController.text);
      messageController.clear();
      
      // Scroll to bottom
      Future.delayed(Duration(milliseconds: 100), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFF34495E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.clear_all, color: Colors.white),
              title: Text('Clear Chat', style: TextStyle(color: Colors.white)),
              onTap: () {
                chatController.clearChat();
                Get.back();
                appController.showSnackbar('Info', 'Chat cleared');
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: Colors.red),
              title: Text('Block User', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                appController.showSnackbar('Info', 'User blocked');
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.orange),
              title: Text('Report Issue', style: TextStyle(color: Colors.orange)),
              onTap: () {
                Get.back();
                appController.showSnackbar('Info', 'Issue reported');
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}