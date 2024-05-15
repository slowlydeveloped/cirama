import 'package:cirama/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class MovieTile extends StatelessWidget {
  final GetIt getIt = GetIt.instance;

  final double height;
  final double width;
  final MovieModel movieModel;

  MovieTile(
      {super.key,
      required this.height,
      required this.width,
      required this.movieModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _moviePosterWidget(movieModel.posterURL()),
            _movieInfoTile(),
          ]),
    );
  }

  Widget _movieInfoTile() {
    return Container(
        height: height,
        width: width * 0.66,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width * 0.56,
                  child: Text(
                    movieModel.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 22,
                    ),
                  ),
                ),
                Text(
                  movieModel.rating.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
              child: Text(
                '${movieModel.language.toUpperCase()} | R:${movieModel.isAdult} | ${movieModel.releaseDate}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, 0),
              child: Text(
                movieModel.description,
                maxLines: 9,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _moviePosterWidget(String imageUrl) {
    return Container(
      height: height,
      width: width*0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imageUrl,
          ),
        ),
      ),
    );
  }
}
