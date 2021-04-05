import 'dart:async';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Models/post_model.dart';
import 'package:flutter/material.dart';

class FinanceProvider extends ChangeNotifier {
  List<Item> financeNews = [];
  TabController tabController;
  int skipfinance = 0;
  String finans = '5fa6ea2f1913fb1ae0497ab3';
  settabcontroller(TabController tabController1) {
    tabController = tabController1;
  }

  setCont(TabController tabController1) {
    tabController = tabController1;
    notifyListeners();
  }

  Future<List<Item>> getFinanceNews() async {
    try {
      Posts posts = await DunyaApiManager()
          .getPostsFromCatagoryIDWithPagination(finans, 0, 10);
      if (posts != null) {
        financeNews.clear();

        financeNews = posts.data.items;
      }
    } catch (e) {
      //print(e);
    }

    return financeNews;
  }

  Future<List<Item>> getMoreFinanceNews() async {
    skipfinance = skipfinance + 10;
    try {
      Posts posts = await DunyaApiManager()
          .getPostsFromCatagoryIDWithPagination(finans, skipfinance, 10);
      if (posts != null) {
        financeNews.addAll(posts.data.items);

        notifyListeners();
      }
    } catch (e) {
      //print(e);
    }

    //print('b');
    return financeNews;
  }

  Future<List<Item>> refreshFinanceNews() async {
    skipfinance = 0;
    try {
      Posts posts = await DunyaApiManager()
          .getPostsFromCatagoryIDWithPagination(finans, 0, 10);

      if (posts != null) {
        financeNews.clear();
        financeNews = posts.data.items;
        notifyListeners();
      }
    } catch (e) {
      //print(e);
    }
    return financeNews;
  }

  int currentpage = 0;
  bool search = false;
}
