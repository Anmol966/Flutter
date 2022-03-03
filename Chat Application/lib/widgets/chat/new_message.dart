import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (_enteredMessage.trim().isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats1/tgERAHMl3z8TnQZonRNq/messages')
          .add({
        'text': _enteredMessage,
        'time': Timestamp.now(),
        'userId': user.uid,
        'username': userData['username'],
        'usercolor': userData['color'],
        'userImage': userData['image'],
      });
    }

    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 10, left: 10, right: 10),
      padding: EdgeInsets.only(left: 15, bottom: 0),
      decoration: BoxDecoration(
          color: Color(0xff303030), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 16),
              controller: _controller,
              cursorColor: Colors.blueGrey,
              decoration: InputDecoration(
                  fillColor: Colors.pink,
                  hintText: 'message',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
              iconSize: 35,
              color: Color(0xff4f2dcc), //Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }
}
