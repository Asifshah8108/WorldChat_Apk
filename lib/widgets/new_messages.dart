import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});
  @override
  State<StatefulWidget> createState() {
    return _NewMessagesState();
  }
}

class _NewMessagesState extends State<NewMessages> {
  final _messageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'CreatedAt': Timestamp.now(),
      'user_id': user.uid,
      'username': userData.data()!['Username'],
      'userImage': userData.data()!['imageUrl'],
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Type a message',
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
            ),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.paperPlane),
            // color: Colors.blue,
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
          )
        ],
      ),
    );
  }
}


