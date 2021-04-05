import 'package:flutter/material.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Models/headline_item.dart' as HeadLine;

class PiyasalarProvider extends ChangeNotifier {
  List<HeadLine.Item> piyasalar = List<HeadLine.Item>();
  Future<List<HeadLine.Item>> getPiyasalar() async {
    try {
      HeadLine.Headline post =
          await DunyaApiManager().getHeadlineFromLocation(4);
      if (post != null) {
        piyasalar.clear();
        piyasalar = post.data.items;
        notifyListeners();
      }
    } catch (e) {
      //print(e);
    }
    return piyasalar;
  }
}
