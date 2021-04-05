import 'package:dunyahaber/Models/post_model.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';

class HomeProviderPublisher extends ChangeNotifier {
  int index = 0;
  List<Item> posts = [];
  changePage(int page) {
    index = page;
    notifyListeners();
  }
   Future<List<Item>> getPublisherNews(id) async {
    posts.clear();
    Posts post = await DunyaApiManager().getPostsFromAuthorIDWithPagination(id);
    try {
      posts.addAll(post.data.items);
    } catch (e) {
      print(e);
    }
    return posts;
  }
}
