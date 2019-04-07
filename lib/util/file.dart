import 'package:flutter/material.dart';

class File extends StatelessWidget {
  final String name;
  final backTextField = new TextEditingController();

  File({Key key, this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("File"),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text(name),
            ),
            new ListTile(
              title: new TextField(
                controller: backTextField,
              ),
            ),
            new ListTile(
              title: new FlatButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'info': backTextField.text,
                  });
                },
                child: new Text("Send back"),
              ),
            )
          ],
        ),
      ),

      // body: new Container(
      //   child: new Text(
      //     name,
      //     style: TextStyle(fontSize: 25.9, color: Colors.black),
      //   ),
      // ),
    );
  }
}
