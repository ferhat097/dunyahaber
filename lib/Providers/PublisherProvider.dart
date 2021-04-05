import 'package:flutter/material.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Models/authors_model.dart';

class PublisherProvider extends ChangeNotifier {
  List<Item> publisher = [];
  int skip = 0;
  int index = 1;
  changeindex(newindex) {
    index = newindex;
    notifyListeners();
  }


  Future<List<Item>> getPublisher() async {
    publisher.clear();
    Authors author = await DunyaApiManager().getAuthorsWithPagination(0, 10);
    publisher = author.data.items;
    //print("ok cleared");
    return publisher;
  }

  Future<List<Item>> getMorePublisher() async {
    skip = skip + 5;
    //print('ok iam run');
    Authors author = await DunyaApiManager().getAuthorsWithPagination(skip, 10);
    publisher.addAll(author.data.items);
    notifyListeners();
    return publisher;
  }

  Future<List<Item>> refreshPublisher() async {
    skip = 0;
    //print('ok iam run');
    Authors author = await DunyaApiManager().getAuthorsWithPagination(0, 10);
    publisher = author.data.items;
    notifyListeners();
    return publisher;
  }
}
