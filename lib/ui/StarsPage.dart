import 'dart:convert';

import 'package:flutternet/data/stars.dart';
import 'package:flutternet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutternet/ui/HomePage.dart';

class StarsPage extends StatefulWidget {
  const StarsPage({super.key});

  @override
  State<StarsPage> createState() => _StarsPageState();
}

class _StarsPageState extends State<StarsPage> {
  List stars = [];

  @override
  void initState() {
    super.initState();
    Stars.readStars().then(
      (value) {
        setState(() {
          stars = json.decode(value);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
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
                  itemCount: stars.length,
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
                        url: stars[index],
                      ))));
        },
        child: Text(
          stars[index],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
