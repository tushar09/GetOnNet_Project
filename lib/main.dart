import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getonnet_project/model/CategoryResponseDto.dart';
import 'package:getonnet_project/model/CategoryResponseDto.dart';
import 'package:getonnet_project/model/CategoryResponseDto.dart';
import 'package:getonnet_project/model/MovieListResponseDto.dart';
import 'package:getonnet_project/utils/strings.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:http/http.dart' as http;

import 'model/CategoryResponseDto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'OnNetGo Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final controller = ScrollController();
  bool isNext = true;
  bool isLoading = false;
  int page = 1;

  late CategoryResponseDto categoryListResponseDto;
  late MovieListResponseDto movieListResponseDto;

  Future<List<CategoryResponseDto>> getCategory() async {
    final String _baseUrl = CustomStrings.baseUrl;
    final response = await http.get(
      Uri.parse(_baseUrl + "3/genre/movie/list?language=en"),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNzc4ZjdiNzY5ZmY1YjkyN2U0MjRlMGFmYjk5ZGFjZSIsInN1YiI6IjU2ZjliNDlmOTI1MTQxNGRmMTAwMDI2MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4murMPfAupna-hycPVRT5KSPeQSP888rWkacpZCxhgQ',
      },
    );

    categoryListResponseDto =
        CategoryResponseDto.fromJson(json.decode(response.body));

    //print(categoryListResponseDto.genres?.first.name);

    List<CategoryResponseDto> categories = [];
    // for (var category in responseData) {
    //   print(category["genre"].id);
    // }
    return categories;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (isNext && isLoading == false) {
          page++;
          getMovies(page);
          isLoading = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Genres>? categories = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
                future: getCategory(),
                builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }else if(snapshot.hasData){
                    categoryListResponseDto.genres?.forEach((element) {
                      categories.add(element);
                    });
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                              child: GestureDetector(
                                onTap: () {
                                  print(category.name);
                                },
                                child: Container(
                                    color: Colors.blue,
                                    height: 50,
                                    width: 150,
                                    alignment: Alignment.center,
                                    child: Text(
                                      category.name ?? "",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            );
                          }).toList(),
                        ));
                  }else{
                    return Text("No Data");
                  }
                }),
            TextField(
              onChanged: (text) {
                print(text);
              },
              decoration: const InputDecoration(
                hintText: 'I Could not complete the project in time',
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: getMovies(page),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Center(
                            child: CircularProgressIndicator()
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        controller: controller,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: movieListResponseDto.results?.length ?? 10,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            height: 140,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  placeholder: (context, url) => const SizedBox(
                                    height: 50.0,
                                    width: 50.0,
                                    child: Center(
                                        child: CircularProgressIndicator()
                                    ),
                                  ),
                                  imageUrl: 'https://image.tmdb.org/t/p/original/${movieListResponseDto.results?.elementAt(index)?.backdropPath?? ""}',
                                    height: 120,
                                    width: 80,
                                    fit: BoxFit.cover),
                                // Image.network(
                                //     'https://image.tmdb.org/t/p/original/${movieListResponseDto.results?.elementAt(index)?.backdropPath?? ""}',
                                //     // width: 300,
                                //     height: 120,
                                //     width: 80,
                                //     fit:BoxFit.cover
                                //
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(movieListResponseDto.results?.elementAt(index).originalTitle?? "",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text('Vote: ${movieListResponseDto.results?.elementAt(index).voteCount.toString()?? ""}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text('Language: ${movieListResponseDto.results?.elementAt(index).originalLanguage?? ""}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )

                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("No Data");
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<MovieListResponseDto> getMovies(int page) async {
    print("movies");
    const String _baseUrl = CustomStrings.baseUrl;
    final response = await http.get(
      Uri.parse("${_baseUrl}3/discover/movie?include_adult=false&include_video=false&language=en-US&page=$page&sort_by=popularity.desc"),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxNzc4ZjdiNzY5ZmY1YjkyN2U0MjRlMGFmYjk5ZGFjZSIsInN1YiI6IjU2ZjliNDlmOTI1MTQxNGRmMTAwMDI2MiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.4murMPfAupna-hycPVRT5KSPeQSP888rWkacpZCxhgQ',
      },
    );

    //print(response.body);
    if(page == 1){
      movieListResponseDto =
          MovieListResponseDto.fromJson(json.decode(response.body));
    }else{
      var data = MovieListResponseDto.fromJson(json.decode(response.body));
      data.results?.forEach((element) {
        movieListResponseDto.results?.add(element);
      });

      //movieListResponseDto.results?.addAll(MovieListResponseDto.fromJson(json.decode(response.body))?.results);
    }


    print(movieListResponseDto.results?[0].originalTitle);

    return movieListResponseDto;
  }
}
