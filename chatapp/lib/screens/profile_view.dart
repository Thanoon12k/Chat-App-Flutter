import 'package:flutter/material.dart';

import '../widgets/appbar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 228, 211, 211),
        endDrawer: mydrawer(),
        appBar: myappbar(),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Stack(children: [
                  Image(
                    image: AssetImage('assets/icons/girl.png'),
                  ),
                  Container(
                    child: Text('name'),
                  ),
                  Container(
                    child: Text('status'),
                  ),
                  Container(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('⭐'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('25'),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('audions comments'),
                    ),
                    Row(
                      children: [
                        Image(
                          image: AssetImage('assets/icons/girl.png'),
                        ),
                        Text('you'),
                        TextField(),
                        IconButton(onPressed: () {}, icon: Icon(Icons.send))
                      ],
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('comment1'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('comment2'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('comment3'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('comment4'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text('comment5'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
