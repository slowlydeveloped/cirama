import '../models/config.dart';
import 'package:get_it/get_it.dart';

class MovieModel {
  final String name;
  final String language;
  final bool isAdult;
  final String description;
  final String posterPath;
  final String backdropPath;
  final num rating;
  final String releaseDate;

  MovieModel(
      {required this.name,
      required this.language,
      required this.isAdult,
      required this.description,
      required this.posterPath,
      required this.backdropPath,
      required this.rating,
      required this.releaseDate});

  factory MovieModel.fromJson(Map<String, dynamic> data) {
    return MovieModel(
      name: data['title'],
      language: data['original_language'],
      isAdult: data['adult'],
      description: data['overview'],
      posterPath: data['poster_path'],
      backdropPath: data['backdrop_path'],
      rating: data['vote_average'],
      releaseDate: data['release_date'],
    );
  }

  String posterURL() {
    final AppConfig _appConfig = GetIt.instance.get<AppConfig>();
    return '${_appConfig.BASE_IMAGE_API_URL}${this.posterPath}';
  }
}
