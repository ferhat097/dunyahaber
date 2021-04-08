import 'package:dunyahaber/Providers/FinansProviders/AltinProvider.dart';
import 'package:dunyahaber/Providers/FinansProviders/DovizProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:dunyahaber/Providers/FinanceProvider.dart';
import 'package:dunyahaber/Providers/FinansProviders/1000TLProvider.dart';
import 'package:dunyahaber/Providers/FinansProviders/BitsStatProvider.dart';
import 'package:dunyahaber/Providers/FinansProviders/BorsaProvider.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:dunyahaber/Screens/Finans/Borsa.dart';
import 'package:dunyahaber/Screens/DetailScreen.dart';
import 'package:dunyahaber/Screens/Finans/1000TLneOldu.dart';
import 'package:dunyahaber/Screens/Finans/EnCokIslemGorenler.dart';
import 'package:dunyahaber/Service/localdatabase.dart';
import 'package:dunyahaber/Models/current_rate.dart';
import 'package:dunyahaber/Models/post_model.dart';
import 'package:dunyahaber/Models/savedPost.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../Service/utils.dart';
import '../Search.dart';
import 'Altin.dart';
import 'Doviz.dart';

class Finance extends StatefulWidget {
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = TabController(length: 6, vsync: this);
    Provider.of<FinanceProvider>(context, listen: false)
        .settabcontroller(tabController);
    tabController.addListener(listen);
    super.initState();
  }

  listen() {
    Provider.of<FinanceProvider>(context, listen: false).setCont(tabController);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Provider1000TL(),
        ),
        ChangeNotifierProvider(
          create: (context) => BitsStatsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BorsaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AltinProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DovizProvider(),
        ),
      ],
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Color(0xFF131A20),
            title: title(context),
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 60),
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: bottom(),
              ),
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: tabController,
            children: [
              Container(
                key: PageStorageKey(1),
                child: Haber(),
              ),
              Container(
                key: PageStorageKey(2),
                child: Borsa(),
              ),
              Container(
                key: PageStorageKey(5),
                child: Doviz(),
              ),
              Container(
                key: PageStorageKey(6),
                child: Altin(),
              ),
              Container(
                key: PageStorageKey(3),
                child: BinTL(),
              ),
              Container(
                key: PageStorageKey(4),
                child: EnCokIslemGorenler(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding title(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Hero(
                tag: 'dot',
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Provider.of<MainProvider>(context, listen: false)
                            .globalKey
                            .currentState
                            .open(direction: InnerDrawerDirection.start);
                      },
                      child: Image.asset('assets/dot.png'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Hero(
                  tag: 'dunya',
                  child: Container(
                    height: 45,
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 4 / 2,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      // splashColor: Colors.transparent,
                      onTap: () {
                        List currentRate =
                            Provider.of<MainProvider>(context, listen: false)
                                .currentRate;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(
                              currentRate: currentRate,
                            ),
                          ),
                        );
                      },
                      child: Image.asset('assets/search.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      Provider.of<MainProvider>(context, listen: false)
                          .bottomnavigate(17);
                    },
                    child: Hero(
                      tag: 'fav',
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset('assets/fav.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottom() {
    return Consumer<FinanceProvider>(
      builder: (context, tabController, child) => TabBar(
        labelPadding: EdgeInsets.symmetric(horizontal: 5),
        controller: tabController.tabController,
        indicator: BoxDecoration(),
        indicatorColor: Colors.red,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        isScrollable: true,
        tabs: [
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 0
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('Finans Haberleri'),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 1
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('Borsa'),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 2
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('Döviz'),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 3
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('Altın'),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 4
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('1000 TL ne oldu?'),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: tabController.tabController.index == 5
                      ? Colors.red
                      : Colors.grey[50]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Container(
                  child: Text('En çok işlem görenler'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Haber extends StatefulWidget {
  const Haber({
    Key key,
  }) : super(key: key);

  @override
  _HaberState createState() => _HaberState();
}

class _HaberState extends State<Haber> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.grey[50],
      child: RefreshIndicator(
        onRefresh: () {
          return Provider.of<FinanceProvider>(context, listen: false)
              .refreshFinanceNews();
        },
        child: FutureBuilder<List<Item>>(
          future: Provider.of<FinanceProvider>(context, listen: false)
              .getFinanceNews(),
          builder: (context, snapshot) {
            // List<CurrentRate> currentRate =
            //     Provider.of<MainProvider>(context, listen: false).currentRate;
            if (snapshot.hasData) {
              return NotificationListener<ScrollNotification>(
                // ignore: missing_return
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    Provider.of<FinanceProvider>(context, listen: false)
                        .getMoreFinanceNews();
                    //print('a');
                  }
                },
                child: Consumer<FinanceProvider>(
                  builder: (context, value, child) {
                    return ValueListenableBuilder<Box<SavedPost>>(
                      valueListenable:
                          Hive.box<SavedPost>('posts').listenable(),
                      builder: (context, Box<SavedPost> box, child) =>
                          ListView.builder(
                        shrinkWrap: true,
                        itemCount: value.financeNews.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey[50],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                   List<CurrentRate> currentRate =
                Provider.of<MainProvider>(context, listen: false).currentRate;
                                  print(value.skipfinance);
                                  print(index);
                                  print(value.financeNews.length);
                                  //print(currentRate.length);
                                  print(value.finans);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        type: 'Finans Haberleri',
                                        skip: value.skipfinance,
                                        index: index,
                                        list: value.financeNews,
                                        currentRate: currentRate,
                                        newsid: value.finans,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: value.financeNews[index].image
                                                    .url !=
                                                null
                                            ? Stack(
                                                children: [
                                                  SizedBox(
                                                    height: 200,
                                                    width: double.infinity,
                                                    child: FittedBox(
                                                      fit: BoxFit.fill,
                                                      child: Image.network(
                                                          value
                                                              .financeNews[
                                                                  index]
                                                              .image
                                                              .url),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 7,
                                                    left: 7,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          3)),
                                                          color: Colors.red),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        child: Text(
                                                          value
                                                                      .financeNews[
                                                                          index]
                                                                      .diffrence >
                                                                  1
                                                              ? value.financeNews[index]
                                                                          .diffrence <
                                                                      1440
                                                                  ? value.financeNews[index].diffrence < 60
                                                                      ? '${DateTime.now().difference(value.financeNews[index].dateTime).inMinutes.toString()} dakika önce'
                                                                      : '${DateTime.now().difference(value.financeNews[index].dateTime).inHours.toString()} saat önce'
                                                                  : '${DateTime.now().difference(value.financeNews[index].dateTime).inDays.toString()} gün önce'
                                                              : 'Şimdi',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 7,
                                                    top: 7,
                                                    child: SizedBox(
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        elevation: 2,
                                                        shadowColor:
                                                            Colors.black12,
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          onTap: () {
                                                            share(
                                                                context,
                                                                value
                                                                    .financeNews[
                                                                        index]
                                                                    .link,
                                                                value
                                                                    .financeNews[
                                                                        index]
                                                                    .title);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: SizedBox(
                                                              height: 30,
                                                              width: 30,
                                                              child: Image.asset(
                                                                  'assets/shareicon.png'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Container(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 20,
                                                    width: 5,
                                                    color: Colors.red,
                                                  ),
                                                  Flexible(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6),
                                                      child: Container(
                                                        //width: double.infinity,
                                                        child: Text(
                                                          'Finans',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () {
                                                    box.values.any((element) =>
                                                            element.id ==
                                                            value
                                                                .financeNews[
                                                                    index]
                                                                .id)
                                                        ? HiveController()
                                                            .deletePostWithID(
                                                                value.financeNews[
                                                                    index])
                                                        : HiveController()
                                                            .savePostWithItem(
                                                                value.financeNews[
                                                                    index]);
                                                  },
                                                  child: box.values.any(
                                                          (element) =>
                                                              element.id ==
                                                              value
                                                                  .financeNews[
                                                                      index]
                                                                  .id)
                                                      ? Icon(Icons.bookmark)
                                                      : Icon(Icons
                                                          .bookmark_border),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11, vertical: 7),
                                        child: Container(
                                          child: Text(
                                            value.financeNews[index].title ??
                                                ' ',
                                            //maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 11, vertical: 7),
                                        child: Container(
                                          child: Text(
                                            value.financeNews[index].summary ??
                                                ' ',
                                            //maxLines: 2,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
