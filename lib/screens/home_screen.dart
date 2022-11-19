import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_app/models/recipe_model.dart';
import 'package:recipe_app/screens/recipe_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  String api_key = '704e6ed8e8e3c530317b452ca7fe4c6f';
  String app_id = 'ba94f55d';
  List<RecipeModel> recipes = [];
  bool _loading = false;

  getRecipes(String query) async {
    String url =
        'https://api.edamam.com/search?q=${query}&app_id=${app_id}&app_key=${api_key}';
    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['hits'].forEach((element) {
      RecipeModel recipemodel = RecipeModel();
      recipemodel = RecipeModel.fromMap(element['recipe']);
      recipes.add(recipemodel);
    });
    setState(() {});
    print('${recipes.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0xff213A50), Color(0xFF071930)],
          )),
        ),
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment:
                    kIsWeb ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Text(
                    "Recipe",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "App",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("What are you looking to cook today?",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Overpass',
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 7,
              ),
              Text(
                  "Please enter below the ingredients you have and we will show the best recipes for you",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'OverpassRegular')),
              SizedBox(
                height: 27,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Overpass'),
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Enter ingredients",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.5))),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () {
                      if (textEditingController.text.isNotEmpty) {
                        setState(() {
                          _loading = true;
                        });
                        print("just do it");

                        getRecipes(textEditingController.text);
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        print("it can't happen");
                      }
                    },
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Container(
                child: GridView(
                  // primary: false,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    // childAspectRatio: 2,
                    mainAxisSpacing: 50.0,
                    crossAxisSpacing: 10.0,
                  ),
                  children: List.generate(recipes.length, (index) {
                    return GridTile(
                      child: RecipeTile(
                        title: recipes[index].label!,
                        source: recipes[index].source!,
                        imgurl: recipes[index].imageUrl!,
                        url: recipes[index].url!,
                      ),
                    );
                  }),
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}

class RecipeTile extends StatefulWidget {
  String title;
  String source;
  String imgurl;
  String url;
  RecipeTile(
      {required this.title,
      required this.source,
      required this.imgurl,
      required this.url});

  @override
  State<RecipeTile> createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURl(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      GestureDetector(
        onTap: () {
          if (kIsWeb) {
            _launchURl(widget.url);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return RecipeScreen(widget.url);
            }));
          }
        },
        child: Container(
          margin: EdgeInsets.all(8),
          child: Stack(children: [
            Image.network(
              widget.imgurl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            Container(
              width: 200,
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.white30, Colors.white],
                      begin: FractionalOffset.centerRight,
                      end: FractionalOffset.centerLeft)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        fontFamily: 'Overpass',
                      ),
                    ),
                    Text(
                      widget.source,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                          fontFamily: 'OverpassRegular'),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    ]);
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      this.topColor, this.bottomColor, this.topColorCode, this.bottomColorCode);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
