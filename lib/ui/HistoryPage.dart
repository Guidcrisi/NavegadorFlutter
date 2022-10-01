import 'dart:convert';

import 'package:flutternet/data/history.dart';
import 'package:flutternet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutternet/ui/HomePage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List history = [];

  @override
  void initState() {
    super.initState();
    History.readHistory().then(
      (value) {
        setState(() {
          history = json.decode(value);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico"),
        centerTitle: true,
        backgroundColor: MyApp.background,
        elevation: 0,
      ),
      backgroundColor: MyApp.background,
      body: Column(
        children: [
          Center(
            child: Container(
              height: 400,
              width: 600,
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: const Offset(0, 5),
                    )
                  ],
                  color: MyApp.background),
              child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: ((context, index) =>
                      tileCreator(context, index))),
            ),
          )
        ],
      ),
    );
  }

  tileCreator(context, index) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => HomePage(
                        url: history[index],
                      ))));
        },
        child: Text(
          history[index],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
