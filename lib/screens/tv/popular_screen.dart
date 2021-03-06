import 'package:async/async.dart';
import 'package:film_ku/consts/consts.dart';
import 'package:film_ku/providers/tv.dart' show TV;
import 'package:film_ku/widgets/back_button.dart';
import 'package:film_ku/widgets/loading_indicator.dart';
import 'package:film_ku/widgets/movie/movie_item.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'package:film_ku/widgets/tv/tv_item.dart';

enum MovieLoaderStatus {
  STABLE,
  LOADING,
}

class TrendingTVScreen extends StatefulWidget {
  static const routeName = '/TrendingTVScreen';

  TrendingTVScreen({
    Key key,
  }) : super(key: key);

  @override
  _TrendingTVScreenState createState() => _TrendingTVScreenState();
}

class _TrendingTVScreenState extends State<TrendingTVScreen> {
  bool _initLoaded = true;
  bool _isFetching = false;
  ScrollController scrollController;
  MovieLoaderStatus loaderStatus = MovieLoaderStatus.STABLE;
  CancelableOperation movieOperation;  
  int curPage = 1;

  @override
  void initState() {
    scrollController = ScrollController();    
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initLoaded) {
      Provider.of<TV>(context, listen: false).fetchPopular(1);
    }
    _initLoaded = false;    
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool onNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.metrics.pixels == notification.metrics.maxScrollExtent) {
        if (loaderStatus != null && loaderStatus == MovieLoaderStatus.STABLE) {
          loaderStatus = MovieLoaderStatus.LOADING;
          setState(() {
            _isFetching = true;
          });
          movieOperation = CancelableOperation.fromFuture(
                  Provider.of<TV>(context, listen: false)
                      .fetchPopular(curPage + 1))
              .then(
            (_) {
              loaderStatus = MovieLoaderStatus.STABLE;
              setState(() {
                curPage = curPage + 1;
                _isFetching = false;
              });
            },
          );
        }
      }
    }
    return true;
  }

  Future<void> _refreshMovies(bool refresh) async {
    if (refresh)
      await Provider.of<TV>(context, listen: false)
          .fetchPopular(1);
  }
  
  @override
  Widget build(BuildContext context) {    
    var movies = Provider.of<TV>(context).trending;
    // print('------------> length: ${movies.length}');
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(          
        //   centerTitle: true,
        //   title: Text('Popular', style: kTitleStyle),          
        // ),
        body: NotificationListener(
          onNotification: onNotification,
          child: Stack(
            children: [
               GridView.builder(
                  // padding: const EdgeInsets.only(bottom: APP_BAR_HEIGHT),
                  
                  controller: scrollController,
                  key: const PageStorageKey('UpcomingScreen'),
                  cacheExtent: 12,
                  itemCount: movies.length,
                  itemBuilder: (ctx, i) {
                    return MovieItem(
                      item: movies[i],
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3.5,
                    // mainAxisSpacing: 5,
                    // crossAxisSpacing: 5,
                  ),
                ),
                Positioned(
                top: 10,
                left: 0,
                child: CustomBackButton(text: 'Popular'),
              ),
              if (_isFetching)
                Positioned.fill(
                  bottom: 10,                  
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LoadingIndicator(size: 30),
                  ),
                )
            ],
          ),
        ),        
       
      ),
    );
  }
}
