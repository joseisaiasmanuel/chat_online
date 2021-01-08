import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TesteComposer extends StatefulWidget {
  TesteComposer(this.sendMessage);
  Function({String text, File imgFile}) sendMessage;

  @override
  _TesteComposerState createState() => _TesteComposerState();
}

class _TesteComposerState extends State<TesteComposer> {
  final TextEditingController _controller = TextEditingController();

// comando para abilitar o campo
  bool _iscomposer = true;

  void _resot() {
    _controller.clear();
    setState(() {
      _iscomposer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                final File imgFile =
                    await ImagePicker.pickImage(source: ImageSource.camera);

                if (imgFile == null) return;
                widget.sendMessage(imgFile: imgFile);
              }),
          Expanded(
              child: TextField(
            controller: _controller,
            decoration:
                InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
            onChanged: (text) {
              setState(() {
                _iscomposer = text.isNotEmpty;
              });
            },
            onSubmitted: (text) {
              widget.sendMessage(text: text);
              _resot();
            },
          )),
          IconButton(
              icon: Icon(Icons.send),
              onPressed: _iscomposer
                  ? () {
                      widget.sendMessage(text: _controller.text);
                      _resot();
                    }
                  : null)
        ],
      ),
    );
  }
}
