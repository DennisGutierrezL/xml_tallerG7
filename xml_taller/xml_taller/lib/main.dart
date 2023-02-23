import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

import 'MentalGames.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mental Games'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  Future<List<MentalGames>> getMentalGamesFromXML(BuildContext context) async {
    final xmlString = await DefaultAssetBundle.of(context)
        .loadString("assets/data/mentalGames.xml");
    print(xmlString);
    List<MentalGames> mentalGames = [];
    var raw = xml.XmlDocument.parse(xmlString);
    var elements = raw.findAllElements("mentalGames");

    for (var item in elements) {
      mentalGames.add(MentalGames(
          item.findElements("module").first.text,
          item.findElements("description").first.text,
          item.findElements("image").first.text));
    }
    print(mentalGames);
    return mentalGames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: FutureBuilder(
          future: getMentalGamesFromXML(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listMentalGames(snapshot.data),
              );
            } else if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        color: Colors.grey,
      ),
    );
  }
}

/*
  List<Widget> mentalGames = [];
  mentalGames.add(const Card(child: Center(child: Text("Página principal"))));
  for (var mentalGames in data) {
    mentalGames.add(Card(
        child: Column(
      children: [
        Text("Módulo: " + mentalGames.module.toString()),
        Text("Descripción: " + mentalGames.description.toString()),
        Text("Edad: " + mentalGames.image.toString())
        //
      ],
    )));
  }
  return mentalGames;
}
*/
List<Widget> _listMentalGames(data) {
  List<Widget> mentalGamesList = [];
  mentalGamesList
      .add(const Card(child: Center(child: Text("Página principal"))));
  for (var mentalGame in data) {
    mentalGamesList.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(mentalGame.image.toString()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Módulo: " + mentalGame.module.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 16),
                    ),
                    Text(
                      "Descripción: " + mentalGame.description.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  return mentalGamesList;
}
