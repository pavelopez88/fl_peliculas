import 'package:fl_peliculas/models/models.dart';
import 'package:flutter/material.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({Key? key, required this.movies, this.titulo, required this.onNextPage}) : super(key: key);

  final List<Movie> movies;
  final String? titulo;
  final Function onNextPage;

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      if ( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 300) {
        widget.onNextPage();
      }
      
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.titulo != null) 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.titulo!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: ( _ ,int index) {

                final movie = widget.movies[index];

                 return _MoviePoster(movie: movie);
              }
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({Key? key, required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    movie.heroId = movie.id.toString();
    return Container(
      width: 130,
      height: 220,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 210,
                  fit: BoxFit.cover,  
                ),
              ),
            ),
          ),
          const SizedBox(height: 10,), 
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}