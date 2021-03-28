import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/models/chat_message.dart';
import 'package:real_estate/providers/property_provider.dart';
import 'package:url_launcher/url_launcher.dart';
class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      "<https://randomuser.me/api/portraits/men/5.jpg>"),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "مالك العقار",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<PropertiesProvider>(builder:
          (BuildContext context, PropertiesProvider value, Widget child) {
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height - 60,
                child: ListView.builder(
                  itemCount: value.messages.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment:
                            (value.messages[index].messageType == "receiver"
                                ? Alignment.topLeft
                                : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                (value.messages[index].messageType == "receiver"
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            value.messages[index].messageContent,
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: chatController,
                        decoration: InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 15),
                    FloatingActionButton(
                      onPressed: () {
                        value.addMessage(ChatMessage(
                            messageContent: chatController.text,
                            messageType: "sender"));
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          chatController.text = "";
                        });
                      },
                      child: Icon(Icons.send, color: Colors.white, size: 18),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
