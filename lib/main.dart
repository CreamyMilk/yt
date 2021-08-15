import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YT',
      theme: ThemeData(
        primaryColor: Color(0xff0a0a0a),
        accentColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      darkTheme: ThemeData(
        accentColor: Color(0xff0a0a0a),
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color(0xff0a0a0a),
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.orange,
          displayColor: Colors.blue,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.black,
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const topics = [
    "🧪 Science",
    "✋ Action",
    "✊ Adventure",
    "🐳 Anime",
    "🎉 Comedy",
    "😷 Horror"
  ];

  static const amber = Color(0xFFf9d6a1);
  static const blue = Color(0xFFcbe9fc);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String queryValue;
  @override
  void initState() {
    print("Setting up inital state");
    queryValue = "the";
    super.initState();
  }

  Future getMovies(String name) async {
    final url =
        "https://yts.mx/api/v2/list_movies.json?query_term=$name&limit=50";
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
      });
      var myjson = json.decode(response.body);
      String status = myjson["status"];
      var data = myjson["data"];
      if (status == 'ok' && data != null) {
        //print(myjson["data"]["movies"][0]);
        return data["movies"];
      } else {
        print("The Movie $name wasn't found");
      }
    } catch (err) {
      print(url);
      print(err);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).primaryColor;
    Color darktextColor = Theme.of(context).accentColor;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text("Good Morning ,\nKinyua "),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              CupertinoIcons.search,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: HomePage.amber,
            child: Transform.translate(
              offset: Offset(-1, 2),
              child: Image.network(
                  "https://raw.githubusercontent.com/lesliearkorful/clubhouse-concept/master/assets/images/11.png"),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: SizedBox(
            height: 50,
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InputChip(
                    onPressed: () {},
                    backgroundColor: HomePage.blue.withOpacity(.5),
                    label: Text(
                      "${HomePage.topics[index]}",
                      style: TextStyle(height: 1.2, color: Colors.black),
                    ));
              },
              separatorBuilder: (_, __) => SizedBox(
                width: 10,
              ),
              itemCount: HomePage.topics.length,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          TextField(
            maxLines: 1,
            style: TextStyle(color: textColor),
            onChanged: (String value) {
              setState(() {
                queryValue = value;
              });
            },
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none),
                filled: true,
                hintText: "Type a movie here ...",
                hintStyle: TextStyle(
                  color: textColor.withOpacity(.7),
                )),
          ),
          Expanded(
            child: FutureBuilder(
                future: getMovies(queryValue),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: textColor,
                      ),
                    );
                  if (snapshot.hasData) {
                    final movies = snapshot.data as List;
                    return ListView.separated(
                        separatorBuilder: (_, __) => Divider(
                              thickness: 0.1,
                              color: textColor,
                            ),
                        itemCount: movies.length,
                        itemBuilder: (ctx, index) {
                          int movieYear = movies[index]["year"];
                          String movieTitle = movies[index]["title"];
                          String movieImage =
                              movies[index]["small_cover_image"];
                          String movieUrl = movies[index]["url"];
                          String movieDescription = movies[index]["summary"];
                          dynamic movieRating = movies[index]["rating"];
                          int rawduaration = movies[index]["runtime"];
                          int hours = (rawduaration / 60).floor();
                          int seconds = rawduaration % 60;

                          List<dynamic> movieTorrents =
                              movies[index]["torrents"] as List;

                          return ExpansionTile(
                            expandedAlignment: Alignment.centerLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            childrenPadding:
                                EdgeInsets.symmetric(horizontal: 40),
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                color: darktextColor,
                                child: Text(
                                  "YTS",
                                  style: TextStyle(color: textColor),
                                ),
                                onPressed: () async {
                                  if (await canLaunch(movieUrl)) {
                                    launch(movieUrl);
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("$movieDescription",
                                  style: TextStyle(
                                    color: textColor,
                                  )),
                              //Text("$movieTorrents"),
                              SizedBox(
                                height: 100,
                                child: ListView.separated(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    String torrentHash =
                                        "${movieTorrents[index]["hash"]}";
                                    String torrentUrl =
                                        "${movieTorrents[index]["url"]}";

                                    return InputChip(
                                        onPressed: () async {
                                          if (await canLaunch(torrentUrl)) {
                                            launch(torrentUrl);
                                          }
                                        },
                                        backgroundColor:
                                            HomePage.blue.withOpacity(.5),
                                        label: Text(
                                          "$torrentHash",
                                          style: TextStyle(
                                              height: 1.2, color: Colors.black),
                                        ));
                                  },
                                  separatorBuilder: (_, __) => SizedBox(
                                    width: 10,
                                  ),
                                  itemCount: movieTorrents.length,
                                ),
                              ),
                            ],
                            leading: Container(
                              child: Image.network(
                                movieImage,
                                height: 50,
                                width: 50,
                              ),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  "$movieRating / 10.0",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "$hours Hr - $seconds Sec",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            subtitle: Text("$movieYear",
                                style: TextStyle(color: textColor)),
                            title: Text(
                              "$movieTitle",
                              style: TextStyle(color: textColor),
                            ),
                          );
                        });
                  } else {
                    return Text(
                      "No Movie Found",
                      style: TextStyle(color: textColor),
                    );
                  }
                }),
          )
        ],
      ),
    );
  }
}
