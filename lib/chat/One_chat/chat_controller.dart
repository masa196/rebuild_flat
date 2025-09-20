import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../basics/api_url.dart';
import '../../native_service/secure_storage.dart';
import 'get_message_service.dart';

class ChatController extends GetxController {
  var messages = <dynamic>[].obs;
  var messageController = TextEditingController();

  final int employee_id;
  final int customer_id;
  final int conversation_id;

  Timer? _pollingTimer;

  SecureStorage storage = SecureStorage();
  String? token;

  static final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
  static bool _isPusherInitialized = false;

  String? currentChannelName;

  final GetMessageService messageService = GetMessageService();
  final GetStorage box = GetStorage();

  ChatController(this.employee_id, this.customer_id, this.conversation_id);

  @override
  void onInit() {
    super.onInit();
    fetchToken();
    loadCachedMessages();
    loadMessages();
    _initPusherOnce();


    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      loadMessages();
    });
  }

  @override
  void onReady() {
    super.onReady();
    subscribeToConversation();
  }

  @override
  void onClose() {
    unsubscribeFromConversation();
    cacheMessages();
    _pollingTimer?.cancel();
    super.onClose();
  }



  String _convertToSyriaTime(String? utcTime) {
    if (utcTime == null) return 'Time not available';
    DateTime utcDateTime = DateTime.parse(utcTime).toUtc();
    DateTime syriaDateTime = utcDateTime.add(const Duration(hours: 3));
    return DateFormat('hh:mm a').format(syriaDateTime);
  }

  Future<void> fetchToken() async {
    token = await storage.read('token');
  }


  Future<void> loadMessages() async {
    try {
      final fetchedMessages = await messageService.fetchMessages(conversation_id);
      messages.clear();
      for (var msg in fetchedMessages) {
        messages.add({
          'id': msg.id,
          'message': msg.message,
          'sender_name': msg.senderName,
          'sender_type': msg.senderType,
          'created_at': _convertToSyriaTime(msg.createdAt),
        });
      }
      messages.refresh();
      cacheMessages();
      print("✅ Loaded ${messages.length} messages");
    } catch (e) {
      print("❌ Error loading messages: $e");
    }
  }

  void cacheMessages() {
    box.write("conversation_$conversation_id", messages);
    print("💾 Cached ${messages.length} messages");
  }

  void loadCachedMessages() {
    final cached = box.read<List>("conversation_$conversation_id");
    if (cached != null) {
      messages.assignAll(cached);
      print("📦 Loaded ${messages.length} cached messages");
    }
  }

  // ✅ تهيئة Pusher مرة واحدة فقط
  Future<void> _initPusherOnce() async {
    if (!_isPusherInitialized) {
      try {
        await pusher.init(
          apiKey: 'd9a5ec51d25dcea5a3ac',
          cluster: 'mt1',
          onConnectionStateChange: onConnectionStateChange,
          onError: onError,
          onSubscriptionSucceeded: onSubscriptionSucceeded,
          onEvent: onEvent,
        );
        await pusher.connect();
        _isPusherInitialized = true;
        print("🚀 Pusher initialized and connected globally");
      } catch (e) {
        print("❌ Error initializing Pusher: $e");
      }
    }
  }

  Future<void> subscribeToConversation() async {
    try {
      currentChannelName =
      'conversation.${min(employee_id, customer_id)}.${max(employee_id, customer_id)}';
      await pusher.subscribe(channelName: currentChannelName!);
      print("✅ Subscribed to channel: $currentChannelName");
    } catch (e) {
      print("❌ Error subscribing to conversation: $e");
    }
  }

  Future<void> unsubscribeFromConversation() async {
    if (currentChannelName != null) {
      await pusher.unsubscribe(channelName: currentChannelName!);
      print("🚪 Unsubscribed from channel: $currentChannelName");
      currentChannelName = null;
    }
  }

  void onEvent(PusherEvent event) {
    print("📩 Received Event: ${event.data}");
    print(">>> sender_type raw: ${event.data['sender_type']}");
    print(">>> sender_type normalized: '${event.data['sender_type'].toString().trim().toLowerCase()}'");

    if (event.data != null && event.data.isNotEmpty) {
      final data = jsonDecode(event.data);

      if (data.containsKey('message')&&data['sender_type'].toString().trim().toLowerCase() == 'employee') {
        var messageData = {
          'id': data['id'] ?? Random().nextInt(999999),
          'message': data['message'],
          'sender_name': data['sender_name'],
          'sender_type': data['sender_type'],
          'created_at': _convertToSyriaTime(DateTime.now().toIso8601String()),
        };

        messages.add(messageData);
        messages.refresh();
        cacheMessages();
      }
      else {
        print("Received message is not from employee");
      }
    }
  }

  int reconnectAttempt = 0;

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print("Connection State Change: $currentState");
    if (currentState == "DISCONNECTED") {
      reconnectAttempt++;
      final delay = min(30, pow(2, reconnectAttempt)).toInt();
      Future.delayed(Duration(seconds: delay), () {
        print("🔄 Trying to reconnect... Attempt $reconnectAttempt");
        pusher.connect();
      });
    } else if (currentState == "CONNECTED") {
      reconnectAttempt = 0;
    }
  }

  void onError(String message, int? code, dynamic e) {
    print("Pusher Error: $message code: $code exception: $e");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("Subscription Succeeded: $channelName data: $data");
  }

  void sendMessage(String message) async {
    if (token == null) {
      print("⚠️ Token is null, cannot send message");
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(
            "${ServerConfiguration.domainNameServer}/api/conversations/$conversation_id/messages"),
        body: jsonEncode({'message': message}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final newMessage = jsonDecode(response.body);
        if (newMessage['data'] != null) {
          var messageData = newMessage['data'];
          messageData['created_at'] =
              _convertToSyriaTime(messageData['created_at']);

          messages.add(messageData);
          messages.refresh();
          cacheMessages();
          print("✅ Message sent: $messageData");
        }
      } else {
        print("❌ Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }
}
