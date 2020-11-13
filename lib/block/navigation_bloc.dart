import 'package:bloc/bloc.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/pages/myaccout.dart';
import 'package:flutteriezakat/pages/myoderpage.dart';
import 'package:flutteriezakat/income_expense/balance.dart';

enum NavigationEvents {
  HomePageClickedEvent,
  AccountClickedEvent,
  OderClickedEvent,
  BalanceClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  // TODO: implement initialState
  NavigationStates get initialState => HomePage();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield HomePage();
        break;
      case NavigationEvents.AccountClickedEvent:
        yield Account();
        break;
      case NavigationEvents.OderClickedEvent:
        yield Oder();
        break;
      /*case NavigationEvents.BalanceClickedEvent:
        yield balanceHome();
        break;*/
    }
  }
}
