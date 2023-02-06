import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.card_membership),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage('assets/icons/girl.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text('name'),
                                  Text('message'),
                                ],
                              ),
                              Text('time'),
                              Icon(Icons.not_accessible),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_back),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextField(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.send),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.emoji_emotions),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
