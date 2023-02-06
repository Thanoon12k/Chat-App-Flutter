import 'package:flutter/material.dart';

class Private extends StatefulWidget {
  const Private({Key? key}) : super(key: key);

  @override
  State<Private> createState() => _PrivateState();
}

class _PrivateState extends State<Private> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('message1'),
                    ),
                    Text('date'),
                  ],
                ),
              ],
            ),
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
