import 'package:film_ku/consts/consts.dart';
import 'package:film_ku/models/movie_model.dart';
import 'package:film_ku/widgets/movie/movie_item.dart';
import 'package:film_ku/widgets/section_title.dart';
import 'package:flutter/material.dart';

class SimilarMovies extends StatelessWidget {
  final MovieModel movie;
  SimilarMovies(this.movie);

  List<MovieModel> extractSimilarMovies() {
    List<MovieModel> similar = [];
    if (movie.similar != null) {
      movie.similar.forEach((element) {
        similar.add(MovieModel.fromJson(element));
      });
    }

    return similar;
  }

  @override
  Widget build(BuildContext context) {
    final similar = extractSimilarMovies();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
            title: 'Similar Movies',
            withSeeAll: false,
            topPadding: 0,
            bottomPadding: 5),
        SizedBox(height: 5),
        Flexible(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: DEFAULT_PADDING),
            itemCount: similar.length,
            itemBuilder: (context, index) {
              return MovieItem(
                item: similar[index],
                withoutDetails: true,
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              mainAxisSpacing: 10,
            ),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}