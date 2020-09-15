import 'package:flutter/material.dart';
import 'package:instaclone/style.dart';

class CommentRichText extends StatefulWidget {
  final String text;
  final String name;
  CommentRichText({@required this.name,@required this.text});
  
  @override
  _CommentRichTextState createState() => _CommentRichTextState();
}

class _CommentRichTextState extends State<CommentRichText> {
  int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(//Tapすると隠れてるやつ出てくる
      onTap: (){
        setState(() {
          _maxLines = 100;
        });
      },
      child: RichText(
        maxLines: _maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: widget.name,style: commentNameTextStyle),
            TextSpan(text: ' '),
            TextSpan(text: widget.text,style: commentContentTextStyle),
          ]
        ),
      ),
    );
  }
}
