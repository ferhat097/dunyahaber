import 'package:flutter/material.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Models/bist_model.dart';

class BitsStatsProvider extends ChangeNotifier {
  List<Item> bitsStats = [];
  Future<List<Item>> getBitsStats() async {
    print(bitsStats.length);
    try {
      Bist bist = await DunyaApiManager().getBIST(true);
          print(bist.data.items.length);
    if (bist != null) {
      print(bist.data.items.length);
      bist.data.items.forEach((element) {
        bitsStats.add(element);
      });
    }
    } catch (e) {
      print(e);
    }



    notifyListeners();
    print(bitsStats.length);
    return bitsStats;
  }
}
