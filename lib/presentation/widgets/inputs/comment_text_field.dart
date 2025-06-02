import 'package:flutter/material.dart';

class CommentTextField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputAction textInputAction;
  final String placeholderText;
  final Function(String) onSubmit;
  final Function(String)? onChannge;

  const CommentTextField({
    super.key,
    required this.textController,
    required this.textInputAction,
    required this.onSubmit,
    this.onChannge,
    this.placeholderText = '',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      textInputAction: textInputAction,
      onSubmitted: (value) {
        onSubmit(value);
      },
      onChanged: onChannge,
      decoration: InputDecoration(
        hintText: placeholderText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
