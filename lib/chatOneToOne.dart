import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'main.dart';

class chatOnetoOne extends StatefulWidget {
  final String title;

  const chatOnetoOne({Key key, this.title}) : super(key: key);

  @override
  State createState() => new chatOnetoOneState();
}

class chatOnetoOneState extends State<chatOnetoOne> {
  final TextEditingController _textController = new TextEditingController();
  static DateTime now = DateTime.now();
  String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);

  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  final prokey = GlobalKey<FormState>();

  final validCharacters = RegExp(r'^[ ]');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('privatechat')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return new ListView(
                        padding: new EdgeInsets.all(8.0),
                        reverse: true,
                        children: snapshot.data.documents
                            .where((l) =>
                                l.data['senderid'] == uId.toString() &&
                                    l.data['recevierid'] == widget.title ||
                                l.data['recevierid'] == uId.toString() &&
                                    l.data['senderid'] == widget.title)
                            .map((doc) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10.0),
                            child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: new CircleAvatar(
                                      child: Text(doc.data['senderid'][0]),
                                    ),
                                  ) ,
                                  new Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      new Text(
                                        '${doc.data['senderid']}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      new Container(
                                        width: 150,
                                        margin: const EdgeInsets.only(top: 5.0),
                                        child: new Text(
                                          '${doc.data['msg']}',
                                          maxLines: 15,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          );
                        }).toList());
                  } else if (ConnectionState.waiting != null) {
                    return SizedBox(
                      child: CircularProgressIndicator(
                        key: prokey,
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                          child: Text('No Messages yet, be First Sender')),
                    );
                  }
                }),
          ),
          new Divider(
            height: 1.0,
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _textComposerWidget(),
          ),
        ],
      ),
    );
  }


  void createData() async {
    if (_formKey.currentState.validate() == true && _textController.text.isNotEmpty ) {
      _formKey.currentState.save();
      await db.collection('privatechat').add({
        'msg': '${_textController.text}',
        'senderid': uId.toString(),
        'recevierid': widget.title,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString()
      });
    }
  }


  void _handleSubmitted(String text) {
    createData();
    _textController.clear();
  }

  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: Form(
                key: _formKey,
                child: new TextFormField(
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                  controller: _textController,
                  onFieldSubmitted: _handleSubmitted,
                  validator: (value) {
                    if (validCharacters.hasMatch(value)) {
                      return 'edit your message';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            )
          ],
        ),
      ),
    );
  }
}
