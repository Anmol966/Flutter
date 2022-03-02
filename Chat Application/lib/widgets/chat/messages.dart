import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats1/tgERAHMl3z8TnQZonRNq/messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (chatSnapshot.data == null) {
            return Center(
              child: ErrorWidget('You are not authorised to this content'),
            );
          }
          final documents = chatSnapshot.data!.docs;
          return ListView.builder(
              reverse: true,
              itemCount: documents.length,
              itemBuilder: (ctx, index) {
                return MesageBubble(
                  documents[index]['username'],
                  documents[index]['text'],
                  documents[index]['userId'],
                  documents[index]['time'],
                  documents[index]['usercolor'],
                  documents[index]['userImage'],
                  index > 0
                      ? documents[index]['userId'] !=
                          documents[index - 1]['userId']
                      : true,
                  index < documents.length - 1
                      ? documents[index]['userId'] !=
                          documents[index + 1]['userId']
                      : true,
                );
              });
        });
  }
}
