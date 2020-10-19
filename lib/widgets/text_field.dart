import 'package:flutter/material.dart';

class TextFieldLogin extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Function validator;
  final bool isObscureText;
  const TextFieldLogin({
    Key key,
    @required this.controller,
    this.validator,
    this.isObscureText = false,
    @required this.hint,
  }) : super(key: key);

  @override
  _TextFieldLoginState createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: TextFormField(
            validator: widget.validator,
            controller: widget.controller,
            obscureText: widget.isObscureText ? true : false,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize:12, fontWeight: FontWeight.bold),
              hintText: widget.hint,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 25)
      ],
    );
  }
}
