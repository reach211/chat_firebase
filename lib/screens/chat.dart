import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  static const String id = "chat_page";
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Chat List",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 18,
          right: 18
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 10
              ),
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.search,
                  ),
                  hintText: " Search",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black26
                    )
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black26
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            userChatContainer(),
            userChatContainer(),
            userChatContainer(),
            userChatContainer(),
            userChatContainer()
          ],
        ),
      ),
    );
  }
  Widget userChatContainer(){
    return Container(
      height: 100,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 70.0,
            height: 70.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://i.imgur.com/BoN9kdC.png"
                  ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "mbtesella"
              ),
              Text(
                  "Can you send me your email? ",
                  style: TextStyle(
                    color: Colors.grey
                  ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
