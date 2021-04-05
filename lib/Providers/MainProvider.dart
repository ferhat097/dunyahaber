import 'package:dunyahaber/Models/snapshots.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:dunyahaber/Service/login_manager.dart';
import 'package:dunyahaber/Models/current_rate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProvider extends ChangeNotifier {
  List<CurrentRate> currentRate = [];
  bool loggedin = false;
  Map<String, dynamic> test = {'name': 'bilgi yok', 'email': 'bilgi yok'};
  Map<dynamic, dynamic> data = Map<dynamic, dynamic>();

  Future<void> logout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    await sp.remove('id');
    await sp.remove('email');
    await sp.remove('name');
    await checklogin();
  }

  Future<void> checklogin() async {
    loggedin = await ApiManager().checkLoginStatus();
    if (loggedin) {
      data = await ApiManager().getUserData();
    }
    notifyListeners();
    //return loggedin;
  }

  Stream<List<CurrentRate>> getCurrentRate() async* {
    currentRate.clear();
    Snapshots snapshots =
        await DunyaApiManager().getAllSnapshots('USD/TRL,EUR/TRL,XAU/USD');

    CurrentRate currentRate1 = CurrentRate(
        "Dolar",
        snapshots.data.items.scad[0].value,
        snapshots.data.items.scad[0].dailyChangePercentage.isNegative
            ?false 
            :true );
    CurrentRate currentRate2 = CurrentRate(
        "Euro",
        snapshots.data.items.scad[1].value,
        snapshots.data.items.scad[1].dailyChangePercentage.isNegative
            ?false 
            :true );
    CurrentRate currentRate3 = CurrentRate(
        "Altın",
        snapshots.data.items.scad[2].value,
        snapshots.data.items.scad[2].dailyChangePercentage.isNegative
            ?false 
            :true );
    currentRate.add(currentRate1);
    currentRate.add(currentRate2);
    currentRate.add(currentRate3);
    yield currentRate;
  }

  int page = 2;
  GlobalKey<InnerDrawerState> globalKey = GlobalKey<InnerDrawerState>();
  GlobalKey<NavigatorState> navstate = GlobalKey<NavigatorState>();

  bottomnavigate(index) {
    page = index;
    notifyListeners();
  }
}
