import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chat_online/teste_composer.dart';

class ChatScren extends StatefulWidget {
  @override
  _ChatScrenState createState() => _ChatScrenState();
}

class _ChatScrenState extends State<ChatScren> {
  void _sendMessage({String text, File imgFile}) async {
    Map<String, dynamic> data = {};

    // salvar a imgem no firebase
    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);
      StorageTaskSnapshot snapshot = await task.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      data['imgUrl'] = url;
    }
    // salvar o texto no firebase
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection("messagens").add({"teste": text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("olá"),
          elevation: 0,
        ),
        backgroundColor: Colors.white,

        // exiber as nossas mensagem
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('mensagens')
                    .snapshots(),
                builder: (context, snapshots) {
                  switch (snapshots.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> documents =
                          snapshots.data.documents.reversed.toList();

                      return ListView.builder(
                          itemCount: documents.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(documents[index].data()['text']),
                            );
                          });
                  }
                },
              ),
            ),
            TesteComposer(_sendMessage),
          ],
        ));
  }
}
