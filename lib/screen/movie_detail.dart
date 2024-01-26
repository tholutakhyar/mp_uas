import 'package:flutter/material.dart';
import 'package:mp_uas/model/movie.dart';

class MovieDetail extends StatelessWidget {
  final Movie selectedMovie;
  const MovieDetail({Key? key, required this.selectedMovie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String path;
    double screenHeight = MediaQuery.of(context).size.height;
    double movieRate =
        double.parse(((selectedMovie.voteAverage ?? 0)).toStringAsFixed(1));
    if (selectedMovie.posterPath != null) {
      path = 'https://image.tmdb.org/t/p/w500/${selectedMovie.posterPath}';
    } else {
      path =
          'https://images.freeimages.com/images/large-previews/5eb/movie-clap board-1184339.jpg';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('${selectedMovie.title}'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(16),
              height: screenHeight / 1.5,
              child: Image.network(path),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                child: Text('${selectedMovie.overview}')),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
              child: Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Penilaian: $movieRate'),
                  Text('Tanggal Rilis: ${selectedMovie.releaseDate}')
                ],
              )),
            )
          ]),
        ));
  }
}
