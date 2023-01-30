import 'dart:convert';
import 'package:chatbot/constant.dart';
import 'package:chatbot/widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;

  final List<Chat> _chatList = [];

  Future<String> generateResponse(String prompt) async {
    const apiKey = chatGptApiKey;

    var url = Uri.https("api.openai.com", "/v1/completions");
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    if (res.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(res.body);
      String resultString = result['choices'][0]['text'];
      resultString = resultString.trim(); // remove '\n' at infront
      return resultString;
    }

    return "Error when fetching data!";
  }

  Future<void> handleSubmit() async {
    _focusNode.unfocus(); // to unfocus textfield after click submit
    String myMessage = _textController.text;
    _textController.clear();
    setState(() {
      _chatList.add(
        Chat(
          isBot: false,
          message: myMessage,
        ),
      );
      _isLoading = true;
    });
    generateResponse(myMessage).then((value) {
      setState(() {
        _chatList.add(
          Chat(isBot: true, message: value),
        );
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            bottom: 10,
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/cartoon robot image.png',
            ),
          ),
        ),
        title: const Text('Chat GeePeeTea'),
        backgroundColor: const Color(0xff181A20),
        toolbarHeight: 60,
      ),
      backgroundColor: const Color(0xff181A20),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                      height: 15), // seperator height in ListView
                  itemCount: _chatList.length,
                  itemBuilder: (context, index) {
                    return _chatList[index];
                  },
                ),
              ),
              Visibility(
                visible: _isLoading,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xff1F222A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        autocorrect: false,
                        decoration: const InputDecoration(
                          hintText: "Ask something...",
                          border: InputBorder.none,
                        ),
                        controller: _textController,
                        focusNode: _focusNode,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff00B1A3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: handleSubmit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
