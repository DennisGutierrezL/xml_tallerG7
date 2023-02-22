import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart' as xml;

import 'Contact.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  Future<List<Contact>> getContactsFromXML(BuildContext context) async {
    final xmlString = await DefaultAssetBundle.of(context)
        .loadString("assets/data/contacts.xml");
    print(xmlString);
    List<Contact> contacts = [];
    var raw = xml.parse(xmlString);
    var elements = raw.findAllElements("contact");

    for (var item in elements) {
      contacts.add(Contact(
          item.findElements("name").first.text,
          item.findElements("email").first.text,
          int.parse(item.findElements("age").first.text)));
    }
    print(contacts);
    return contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: FutureBuilder(
          future: getContactsFromXML(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listContacts(snapshot.data),
              );
            } else if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

List<Widget> _listContacts(data) {
  List<Widget> contacts = [];
  contacts.add(const Card(child: Text("Extraído desde XML")));
  for (var contact in data) {
    contacts.add(Card(
        child: Column(
      children: [
        Text("Nombre: " + contact.name.toString()),
        Text("Correo: " + contact.email.toString()),
        Text("Edad: " + contact.age.toString())
      ],
    )));
  }
  return contacts;
}
