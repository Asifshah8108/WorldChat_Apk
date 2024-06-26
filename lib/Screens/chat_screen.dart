import 'package:chat/widgets/chat_messages.dart';
import 'package:chat/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void pushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final Token=await fcm.getToken();
    print(Token);
    await fcm.subscribeToTopic('chat');
  }
  @override
  void initState() {
    super.initState();
    pushNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ChatHub'),
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const FaIcon(FontAwesomeIcons.powerOff),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        body: const Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessages(),
          ],
        ));
  }
}
