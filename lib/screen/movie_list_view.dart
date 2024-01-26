import 'package:flutter/material.dart';
import 'package:mp_uas/helper/http_helper.dart';
import 'package:mp_uas/screen/movie_detail.dart';

class MovieListView extends StatefulWidget {
  //2
  const MovieListView({Key? key}) : super(key: key);
  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  //3
  late int moviesCount;
  late List movies;
  late HttpHelper helper;

  Icon searchIcon = Icon(Icons.search);
  Widget titleBar = Text('Movie List');

  //tambahan iconBase
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clap board-1184339.jpg';

  @override
  void initState() {
    //4
    defaultList();
    super.initState();
  }

  Future defaultList() async {
    //5
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getUpComingAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  void toggleSearch() {
    setState(() {
      if (this.searchIcon.icon == Icons.search) {
        this.searchIcon = Icon(Icons.cancel);
        this.titleBar = TextField(
          autofocus: true,
          onSubmitted: (text) {
            searchMovies(text);
          },
          decoration: InputDecoration(hintText: 'Ketik kata pencarian'),
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        );
      } else {
        setState(() {
          this.searchIcon = Icon(Icons.search);
          this.titleBar = Text('Daftar Film');
        });
        defaultList();
      }
    });
  }

  Future searchMovies(String text) async {
    List searchedMovies = await helper.findMovies(text);
    setState(() {
      movies = searchedMovies;
      moviesCount = movies.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: titleBar,
        actions: [IconButton(onPressed: toggleSearch, icon: searchIcon)],
      ),
      body: ListView.builder(
        //6
        itemCount: moviesCount,
        itemBuilder: (context, position) {
          // tambahan kode untuk akses image pada url
          if (movies[position].posterPath != null) {
            image = NetworkImage(iconBase + movies[position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }

          return Card(
            //7
            elevation: 2,
            child: ListTile(
              onTap: () {
                //1
                MaterialPageRoute route = MaterialPageRoute(
                  //2
                  builder: (context) {
                    return MovieDetail(
                      selectedMovie: movies[position],
                    );
                  },
                );
                Navigator.push(context, route); //3
              },
              leading: CircleAvatar(
                // leading adalah kolom di depan title
                backgroundImage: image,
              ),
              title: Text(movies[position].title),
              subtitle: Text(
                'Released: ' +
                    movies[position].releaseDate +
                    ' - Vote: ' +
                    movies[position].voteAverage.toString(),
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Upcoming'),
              onTap: () {
                Navigator.pop(context); //untuk menutup drawer
                setState(() {
                  this.searchIcon = Icon(Icons.search);
                  this.titleBar = Text('Daftar Film');
                });
                defaultList(); //perintah getUpcoming()
              },
            ),
            ListTile(
              title: Text('Cari'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  this.searchIcon = Icon(Icons.cancel);
                  this.titleBar = TextField(
                    autofocus: true,
                    onSubmitted: (text) {
                      searchMovies(text); //perintah cari Movie
                    },
                    decoration:
                        InputDecoration(hintText: 'Ketik kata pencarian'),
                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}