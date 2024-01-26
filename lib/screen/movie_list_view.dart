import 'package:flutter/material.dart';
import 'package:mp_uas/helper/http_helper.dart';
import 'package:mp_uas/screen/movie_detail.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);
  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  late int moviesCount;
  late List movies;
  late HttpHelper helper;

  Icon searchIcon = const Icon(Icons.search);
  Widget titleBar = const Text('Movie List');

  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clap board-1184339.jpg';

  @override
  void initState() {
    defaultList();
    super.initState();
  }

  Future defaultList() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getUpcomingAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  Future topRatedList() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getTopRatedAsList();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  void toggleSearch() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = const Icon(Icons.cancel);
        titleBar = TextField(
          autofocus: true,
          onSubmitted: (text) {
            searchMovies(text);
          },
          decoration: const InputDecoration(hintText: 'Ketik Judul Disini...'),
          textInputAction: TextInputAction.search,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        );
      } else {
        setState(() {
          searchIcon = const Icon(Icons.search);
          titleBar = const Text('Daftar Film');
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
        itemCount: moviesCount,
        itemBuilder: (context, position) {
          if (movies[position].posterPath != null) {
            image = NetworkImage(iconBase + movies[position].posterPath);
          } else {
            image = NetworkImage(defaultImage);
          }

          return Card(
            elevation: 2,
            child: ListTile(
              onTap: () {
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (context) {
                    return MovieDetail(
                      selectedMovie: movies[position],
                    );
                  },
                );
                Navigator.push(context, route);
              },
              leading: CircleAvatar(
                backgroundImage: image,
              ),
              title: Text(movies[position].title),
              subtitle: Text(
                'Released:  ${movies[position].releaseDate} - Vote: ${movies[position].voteAverage}',
              ),
            ),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Top Rated'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  searchIcon = const Icon(Icons.search);
                  titleBar = const Text('Rating Tertinggi');
                });
                topRatedList();
              },
            ),
            ListTile(
              title: const Text('Upcoming'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  searchIcon = const Icon(Icons.search);
                  titleBar = const Text('Yang Akan Datang');
                });
                defaultList();
              },
            ),
            ListTile(
              title: const Text('Cari'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  searchIcon = const Icon(Icons.cancel);
                  titleBar = TextField(
                    autofocus: true,
                    onSubmitted: (text) {
                      searchMovies(text);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Ketik Judul Disini...'),
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
