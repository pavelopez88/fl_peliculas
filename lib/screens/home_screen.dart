import 'package:fl_peliculas/providers/movies_provider.dart';
import 'package:fl_peliculas/search/search_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peliculas en Cines"),
        actions: [
          IconButton(
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),
      
            //Slider de peliculas
            MovieSlider(
              movies: moviesProvider.popularMovies,
              titulo: 'Populares!',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      )
    );
  }
}