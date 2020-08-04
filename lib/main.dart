import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DataModel> chats = [];

  Future<void> getChats() async {
    List<DataModel> placeHolder = [];
    var response = await http.get("https://jsonplaceholder.typicode.com/posts");
    var data = json.decode(response.body);
    for (var d in data) {
      placeHolder.add(DataModel(
        data: d['body'],
        id: d['id'],
      ));
    }
    setState(() {
      chats = placeHolder;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getChats();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      'Gualtiero Cea',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: Icon(
                      FontAwesomeIcons.phone,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var chat = chats[index];
                      return chat.id % 2 == 0 ? receiverBox(chat.data, context) : senderBox(chat.data, context);
                    },
                    itemCount: chats.isEmpty ? 0 : chats.length,
                  ),
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Type your message...',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.green[800],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget receiverBox(String content, BuildContext ctx) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          width: MediaQuery.of(ctx).size.width * 0.7,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '6:55 AM',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget senderBox(String content, BuildContext ctx) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              )),
          width: MediaQuery.of(ctx).size.width * 0.7,
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '6:55 AM',
                style: TextStyle(color: Colors.grey[500]),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.check,
                size: 14,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class DataModel {
  String data;
  var id;

  DataModel({
    this.data,
    this.id,
  });
}
