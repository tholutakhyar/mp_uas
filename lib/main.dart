import 'package:flutter/material.dart';
import 'package:mp_uas/screen/movie_list_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MovieDB',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MovieListView(),
        ),
      ),
    );
  }
}
