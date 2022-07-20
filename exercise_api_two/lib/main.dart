import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exercise API 2',
      home: HomePage(title: 'GIF API'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  List<String> gifUrls = [];

  void getGifUrls(String word) async {
    var data = await http.get(Uri.parse(
        "https://api.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8"));

    var dataParsed = jsonDecode(data.body);
    gifUrls.clear();
    for (int i = 0; i < 8; i++) {
      print(dataParsed['results'][i]['media'][0]['tinygif']['url']);
      gifUrls.add(dataParsed['results'][i]['media'][0]['tinygif']['url']);
    }
    setState(() {});
  }

  @override
  void initState() {
    getGifUrls('batman');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: _controller,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(color: Colors.deepOrangeAccent),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  getGifUrls(_controller.text);
                },
                child: const Text('Gif ara'),
              ),
              gifUrls.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.separated(
                          itemBuilder: (_, int index) {
                            return GifCard(
                              gifUrls[index]
                            );
                          },
                          separatorBuilder: (_, __) {
                            return const Divider(
                              color: Colors.green,
                              thickness: 5,
                              height: 5,
                            );
                          },
                          itemCount: 8),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;
  const GifCard(this.gifUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image(
      fit: BoxFit.cover,
      image: NetworkImage(gifUrl),
    );
  }
}

