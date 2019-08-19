import 'package:flutter/material.dart';
import 'user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'message.dart';

class ReceiveMessage extends StatefulWidget {
  List<Message> messages;
  ReceiveMessage(this.messages);
  @override
  _ReceiveMessageState createState() => _ReceiveMessageState(messages);
}

class _ReceiveMessageState extends State<ReceiveMessage> {
  List<Message> messages;
  _ReceiveMessageState(this.messages);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildListView(messages),

    );
  }

  ListView _buildListView(List<Message> messages) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, position) {
        Message m = messages[position];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(m.message),
          ),
        );
      },
    );
  }
}
