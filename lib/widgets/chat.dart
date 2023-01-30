import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  final bool isBot;
  final String message;
  const Chat({Key? key, required this.isBot, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: isBot
              ? const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
          color: isBot ? const Color(0xff35383F) : const Color(0xff00B1A3),
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
