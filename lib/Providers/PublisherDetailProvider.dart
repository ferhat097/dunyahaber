import 'package:dunyahaber/Models/post_model.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';

class PublisherDetailProvider extends ChangeNotifier {
  PageController controller2 = PageController(initialPage: 0);
  List<Item> posts = [];
  int index = 0;
  List<int> indexes = [];
  changeindex(newindex) {
    index = newindex;
    notifyListeners();
  }

  changepage(index) {
    controller2.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
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
