import 'package:ff_test/services/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

//
//
//
// Events
abstract class NewsEvent {}

class NewsLoadEvent extends NewsEvent {}

class NewsLoadedEvent extends NewsEvent {}

//
//
//
// States
abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {}

//
//
//
//
//
//
//
//
// Bloc
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepositoriy? newsRepositoriy;
  List<dynamic>? news;
  NewsBloc({@required this.newsRepositoriy}) : super(NewsInitialState());

  @override
  Stream<NewsState> mapEventToState(event) async* {
    switch (event.runtimeType) {
      case NewsLoadEvent:
        yield NewsLoadingState();
        news = await newsRepositoriy!.getNews();
        if (news!.isNotEmpty)
          this.add(NewsLoadedEvent());
        else
          yield NewsInitialState();
        break;
      case NewsLoadedEvent:
        yield NewsLoadedState();
        break;
    }
  }
}
