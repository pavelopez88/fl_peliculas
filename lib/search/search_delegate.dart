import 'package:fl_peliculas/models/models.dart';
import 'package:fl_peliculas/providers/movies_provider.dart';
import 'package:fl_peliculas/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{

  @override
  String? get searchFieldLabel => "Buscar Pelicula";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("BuildResults");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130,));
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    
    // * USANDO FUTUREBUILDER 
    // return FutureBuilder(
    //   future: moviesProvider.searchMovie(query),
    //   builder: ( _ , AsyncSnapshot<List<Movie>> snapshot) {
    //     if ( !snapshot.hasData ) return const Center(child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130,));

    //     final List<Movie> movies = snapshot.data!;
    //     return GridView.builder(
    //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 3
    //       ),
    //       itemCount: movies.length,
    //       itemBuilder: ( _ , index) => _SuggestMovie(movie: movies[index])
    //     );
    //   },
    // );

    // * USANDO STREAMBUILDER 
    moviesProvider.getSuggestionByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _ , AsyncSnapshot<List<Movie>> snapshot) {
        if ( !snapshot.hasData ) return const Center(child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130,));

        final List<Movie> movies = snapshot.data!;
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3
          ),
          itemCount: movies.length,
          itemBuilder: ( _ , index) => _SuggestMovie(movie: movies[index])
        );
      },
    );
  }

}


class _SuggestMovie extends StatelessWidget {
  const _SuggestMovie({super.key, required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
  //   return ListTile(
  //     leading: FadeInImage(
  //       placeholder: const AssetImage("assets/no-image.jpg"),
  //       image: NetworkImage(movie.fullPosterImg),
  //       fit: BoxFit.fill,
  //       width: 40,
  //     ),
  //     trailing: const Icon(Icons.arrow_forward_ios_outlined),
  //     title: Text(movie.title),
  //     subtitle: Text(movie.overview, overflow: TextOverflow.ellipsis, maxLines: 1,),
  //     onTap: () => Navigator.pushNamed(context, 'details', arguments: movie)
  //   );
  movie.heroId = 'search-${movie.id.toString()}';
  return InkWell(
    onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage("assets/no-image.jpg"),
          image: NetworkImage(movie.fullPosterImg),
          fit: BoxFit.contain,
          height: 120,
        ),
      ),
    ),
  );

  }
  
}