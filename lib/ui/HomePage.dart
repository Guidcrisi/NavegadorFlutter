import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutternet/data/history.dart';
import 'package:flutternet/data/stars.dart';
import 'package:flutternet/main.dart';
import 'package:flutternet/ui/HistoryPage.dart';
import 'package:flutternet/ui/StarsPage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_windows/webview_windows.dart';

class HomePage extends StatefulWidget {
  String? url;
  HomePage({this.url});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController urlController = TextEditingController();
  final _controller = WebviewController();
  List history = [];
  List stars = [];
  bool isStar = false;

  @override
  void initState() {
    super.initState();
    History.readHistory().then(
      (value) {
        history = json.decode(value);
      },
    );
    Stars.readStars().then(
      (value) {
        stars = json.decode(value);
      },
    );
    initWebview();
  }

  initWebview() async {
    try {
      await _controller.initialize();
      _controller.url.listen((url) {
        urlController.text = url;
        setState(() {
          history.add(url);
        });
        History.saveHistory(history);
        setState(() {
          isStar = false;
        });
        for (var i = 0; i < stars.length; i++) {
          if (stars[i] == urlController.text) {
            setState(() {
              isStar = true;
            });
          }
        }
      });

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      if (widget.url == null) {
        await _controller.loadUrl('https://google.com');
      } else {
        await _controller.loadUrl(widget.url as String);
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: sideBar(context),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 60,
            decoration: BoxDecoration(color: MyApp.background, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 7,
                offset: const Offset(0, 5),
              )
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      print(history[history.length - 2]);
                      setState(() {
                        _controller.loadUrl(history[history.length - 2]);
                        if (!mounted) return;
                        setState(() {});
                      });
                    },
                    icon: Icon(
                      FontAwesomeIcons.arrowLeft,
                      color: MyApp.primary,
                    )),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _controller.loadUrl(urlController.text);
                        if (!mounted) return;
                        setState(() {});
                      });
                    },
                    icon: Icon(
                      FontAwesomeIcons.rotateRight,
                      color: MyApp.primary,
                    )),
                Container(
                  width: MediaQuery.of(context).size.width - 200,
                  height: 45,
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    controller: urlController,
                    decoration: InputDecoration(
                        labelText: "Pesquise aqui!",
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (urlController.text.contains("https://www.")) {
                              setState(() {
                                _controller.loadUrl(urlController.text);
                                if (!mounted) return;
                                setState(() {});
                              });
                            } else if (urlController.text.contains(".com")) {
                              String url = "https://www.${urlController.text}";
                              setState(() {
                                _controller.loadUrl(url);
                                if (!mounted) return;
                                setState(() {});
                              });
                            } else {
                              String url =
                                  "https://www.google.com/search?q=${urlController.text}";

                              setState(() {
                                _controller.loadUrl(url);
                                if (!mounted) return;
                                setState(() {});
                              });
                            }
                          },
                          icon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Colors.white,
                          ),
                        ),
                        filled: true,
                        focusColor: Colors.white,
                        fillColor: MyApp.background,
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: MyApp.primary)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: MyApp.primary)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        stars.add(urlController.text);
                        Stars.saveStars(stars);
                        isStar = !isStar;
                      });
                    },
                    icon: Icon(
                      isStar
                          ? FontAwesomeIcons.solidStar
                          : FontAwesomeIcons.star,
                      color: MyApp.primary,
                    )),
                IconButton(
                    onPressed: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    icon: Icon(
                      FontAwesomeIcons.ellipsisVertical,
                      color: MyApp.primary,
                    )),
              ],
            ),
          ),
          Webview(
            _controller,
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height - 60,
          )
        ],
      ),
    );
  }

  Widget sideBar(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(color: MyApp.background),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.house,
                  color: Colors.white,
                ),
                title: const Text(
                  "Início",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _controller.loadUrl('https://google.com');
                    if (!mounted) return;
                    setState(() {});
                    Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.white,
                ),
                title: const Text(
                  "Favoritos",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => StarsPage())));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.fire,
                  color: Colors.white,
                ),
                title: const Text(
                  "Limpar favoritos",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  stars.clear();
                  Stars.saveStars(stars);
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: MyApp.background,
                          icon: const Icon(
                            FontAwesomeIcons.solidStar,
                            color: Colors.lightBlue,
                          ),
                          title: const Text(
                            "Sucesso",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Favoritos limpo com sucesso!",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Ok",
                                  style: TextStyle(color: MyApp.primary),
                                ))
                          ],
                        );
                      });
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.list,
                  color: Colors.white,
                ),
                title: const Text(
                  "Histórico",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => HistoryPage())));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.fire,
                  color: Colors.white,
                ),
                title: const Text(
                  "Limpar histórico",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onTap: () {
                  history.clear();
                  History.saveHistory(history);
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: MyApp.background,
                          icon: const Icon(
                            FontAwesomeIcons.fire,
                            color: Colors.yellow,
                          ),
                          title: const Text(
                            "Sucesso",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Histórico limpo com sucesso!",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Ok",
                                  style: TextStyle(color: MyApp.primary),
                                ))
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
