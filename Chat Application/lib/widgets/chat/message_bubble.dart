import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MesageBubble extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> doc;
  final messages;
  final userId;
  final Timestamp messageTime;
  final name;
  final userColor;
  final String image;
  final bool _isDp;
  final bool _isName;
  MesageBubble(this.doc, this.name, this.messages, this.userId,
      this.messageTime, this.userColor, this.image, this._isDp, this._isName);

  @override
  State<MesageBubble> createState() => _MesageBubbleState();
}

class _MesageBubbleState extends State<MesageBubble> {
  var user = FirebaseAuth.instance.currentUser?.uid ?? 'not you';

  var key1 = GlobalKey();

  bool b = true;

  @override
  Widget build(BuildContext context) {
    var isMe = (user == widget.userId);

    var a = {
      DateFormat.jm().format(DateTime.fromMicrosecondsSinceEpoch(
          widget.messageTime.microsecondsSinceEpoch)),
      DateFormat.yMd().format(DateTime.fromMicrosecondsSinceEpoch(
          widget.messageTime.microsecondsSinceEpoch))
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!b && isMe)
              Column(
                children: [
                  Text(
                    a.first,
                    style: TextStyle(color: Color(0xaa252433)),
                  ),
                  Text(
                    a.last,
                    style: TextStyle(color: Color(0xaa252433)),
                  ),
                ],
              ),
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
              child: InkWell(
                onTap: () {
                  setState(() {
                    b = !b;
                  });
                },
                onLongPress: () {
                  FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    await transaction.delete(widget.doc.reference);
                  });
                  print("haha");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isMe ? Color(0xcc20201d) : Color(0xee222e3a),
                    borderRadius: BorderRadius.only(
                        topLeft: isMe
                            ? Radius.circular(20)
                            : widget._isName
                                ? Radius.circular(20)
                                : Radius.circular(3),
                        topRight: isMe
                            ? widget._isName
                                ? Radius.circular(20)
                                : Radius.circular(3)
                            : Radius.circular(20),
                        bottomLeft: isMe
                            ? Radius.circular(20)
                            : widget._isDp
                                ? Radius.circular(20)
                                : Radius.circular(3),
                        bottomRight: isMe
                            ? widget._isDp
                                ? Radius.circular(20)
                                : Radius.circular(3)
                            : Radius.circular(20)),
                  ),
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                  margin: EdgeInsets.only(
                      left: isMe ? 1 : 40,
                      right: isMe ? 40 : 1,
                      bottom: widget._isDp ? 10 : 1),
                  child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (widget._isName)
                          Text(
                            widget.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(int.parse(widget.userColor))),
                          ),
                        Text(
                          widget.messages,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          key: key1,
                        ),
                      ]),
                ),
              ),
            ),
            if (!b && !isMe)
              Column(
                children: [
                  Text(
                    a.first,
                    style: TextStyle(color: Color(0xaa252433)),
                  ),
                  Text(
                    a.last,
                    style: TextStyle(color: Color(0xaa252433)),
                  ),
                ],
              ),
          ],
        ),
        if (widget._isDp)
          Positioned(
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(widget.image),
            ),
            bottom: 15,
            left: isMe ? null : 5,
            right: isMe ? 5 : null,
          ),
      ],
    );
  }
}
