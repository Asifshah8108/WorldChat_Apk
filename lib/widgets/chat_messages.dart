import 'package:chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});
  @override
  Widget build(context) {
    final AuthenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('CreatedAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No messages found',
              ),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text(
                'Something went wrong',
              ),
            );
          }
          final loadedMessages = chatSnapshots.data!.docs;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 13,
              right: 13,
              bottom: 40,
            ),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              final ChatMessages = loadedMessages[index].data();
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMessageUserId = ChatMessages['user_id'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['user_id'] : null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;
              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: ChatMessages['text'],
                    isMe: AuthenticatedUser.uid == currentMessageUserId);
              } else {
                return MessageBubble.first(
                    userImage: ChatMessages['userImage'],
                    username: ChatMessages['username'],
                    message: ChatMessages['text'],
                    isMe: AuthenticatedUser.uid == currentMessageUserId);
              }
            },
          );
        });
  }
}




