import 'package:ff_test/models/news_model.dart';
import 'package:ff_test/screens/home_screen/pages/news_page/bloc.dart';
import 'package:ff_test/services/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ff_test/services/global.dart' as globals;

class NewsPage extends StatefulWidget {
  GlobalKey<ScaffoldMessengerState>? homeScaffoldKey;
  NewsPage({Key? key, @required this.homeScaffoldKey}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  //
  //
  PageStorageKey? _pageKey;
  NewsRepositoriy? _newsRepositoriy;
  NewsBloc? _newsBloc;
  //
  //
  // OVERRIDED METHODS ---------------------------------------------------------
  //
  //
  @override
  void initState() {
    super.initState();
    _pageKey = PageStorageKey('news');
    _newsRepositoriy = NewsRepositoriy(scaffoldKey: widget.homeScaffoldKey);
    _newsBloc = NewsBloc(newsRepositoriy: _newsRepositoriy);
    _newsBloc!.add(NewsLoadEvent());
  }

  //
  //
  @override
  void dispose() {
    _newsBloc = null;
    super.dispose();
  }

  //
  //############################################################################
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
      create: (context) => _newsBloc!,
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) =>
            Container(child: _getPageBody(context, state)),
      ),
    );
  }

  //
  //
  // METHODS -------------------------------------------------------------------
  //
  //

  Widget _getPageBody(BuildContext context, NewsState state) {
    switch (state.runtimeType) {
      case NewsLoadingState:
        return Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          ),
        );
      case NewsLoadedState:
        return CustomScrollView(
          key: _pageKey,
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              floating: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'News',
                  style: TextStyle(
                      fontSize: 18 * globals.pixelRatio['height']!,
                      color: Colors.black),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(
                  right: 20 * globals.pixelRatio['width']!,
                  left: 20 * globals.pixelRatio['width']!),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(_getListItem,
                    childCount: _newsBloc!.news?.length),
              ),
            ),
          ],
        );
    }
    return Container();
  }

  //
  //
  Widget _getListItem(BuildContext context, int index) {
    final NewsModel curItem = _newsBloc!.news![index];
    return Container(
      margin: EdgeInsets.only(top: 20 * globals.pixelRatio['height']!),
      height: 200,
      child: Card(
        elevation: 10,
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40 * globals.pixelRatio['height']!),
              topRight: Radius.circular(4 * globals.pixelRatio['height']!),
              bottomLeft: Radius.circular(4 * globals.pixelRatio['height']!),
              bottomRight: Radius.circular(40 * globals.pixelRatio['height']!)),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getTextSpan('User Id: ', curItem.userId.toString()),
              _getTextSpan('Photo Id: ', curItem.photoId ?? 'missing'),
              _getTextSpan('Created at: ', curItem.createdAt ?? 'missing'),
            ],
          ),
        ),
      ),
    );
  }

  //
  //
  Widget _getTextSpan(String header, String text) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: header,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      TextSpan(
          text: text,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16))
    ]));
  }
}
