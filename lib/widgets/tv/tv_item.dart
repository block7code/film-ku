import 'package:film_ku/models/tv_model.dart';
import 'package:film_ku/screens/tv/tv_details_screen.dart';
import 'package:film_ku/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:film_ku/consts/consts.dart';
import 'package:film_ku/widgets/placeholder_image.dart';

class TVItem extends StatelessWidget {
  final TVModel item;
  final bool isRound;
  final double radius;
  final bool withoutDetails;
      
  TVItem({
    this.item,
    this.withoutDetails = false,
    this.isRound = false,
    this.radius,    
  });

  // Functions
  String getGenreName(List<dynamic> genreIds) {
    String str = 'N/A';
    if (genreIds == null || genreIds.length == 0) return 'N/A';
    if (MOVIE_GENRES.containsKey(genreIds[0])) {
      str = MOVIE_GENRES[genreIds[0]];
    }
    if(str == 'Documentary') {
      str = 'Docu...';
    }
    return str;
    
  }

  String _formatDate(DateTime date) {
    return date == null ? 'N/A' : date.year.toString();
  }

  Route _buildRoute() {
    return MaterialPageRoute(
      builder: (context) =>TVDetailsScreen(),
      settings: RouteSettings(arguments: item)
    );      
  }
 

  String _getRatings(double rating) {
    return rating == null ? 'N/A' : rating.toString();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {        
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(_buildRoute());
          },
          child: ClipRRect(
            borderRadius: isRound ?  BorderRadius.circular(radius?? 20) : BorderRadius.circular(0),
                      child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                item.posterUrl == null
                    ? PlaceHolderImage(item.title)
                    : CachedNetworkImage(
                        imageUrl: item.posterUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) {
                          return Center(
                            child:LoadingIndicator(),
                          );
                        },
                      ),    
                      if(!withoutDetails)                
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(0, 0, 0, 0.8),
                      Color.fromRGBO(0, 0, 0, 0.1),
                    ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                  ),
                ),      
                if(!withoutDetails)        
                Positioned(
                  bottom: 10,
                  left: 5,
                  child: Container(
                    width: constraints.maxWidth,   
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.87),
                          ),
                        ),
                        Text(
                          _formatDate(item.date),
                          style: kSubtitle1,
                        ),
                        Container(
                          width: constraints.maxWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white38)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0, vertical: 2),
                                  child: Text(
                                    getGenreName(item.genreIDs),
                                    style: kSubtitle1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      _getRatings(item.voteAverage),
                                      style: kSubtitle1,
                                    ),
                                    SizedBox(width: 2),
                                    Icon(Icons.favorite_border,
                                        color: Theme.of(context).accentColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    //  LayoutBuilder(
    //   builder: (context, constraints) {
        
    //     return Column(
    //       children: [
    //         Container(              
    //           height: withFooter ? constraints.maxHeight * 0.75 : constraints.maxHeight,
    //           width: constraints.maxWidth,
    //           child: _buildBackgroundImage(context, constraints),
    //         ),            
    //         if (withFooter)
    //           Container(                
    //             height: constraints.maxHeight * 0.25,
    //             padding: const EdgeInsets.only(top: 10, left: 10),
    //             child: _buildFooter(context),
    //           ),
    //       ],
    //     );
    //   },
    // );
  }
}
