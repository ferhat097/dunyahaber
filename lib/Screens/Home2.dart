import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dunyahaber/Models/authors_model.dart';
import 'package:dunyahaber/Models/post_model.dart' as PostModel;
import 'package:dunyahaber/Providers/HomeProviderPublisher.dart';
import 'package:dunyahaber/Screens/NotificationNews.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:dunyahaber/Providers/AllNewsProvider.dart';
import 'package:dunyahaber/Providers/GundemProvider.dart';
import 'package:dunyahaber/Providers/HeadLineProvider.dart';
import 'package:dunyahaber/Providers/HomeProvider.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:dunyahaber/Providers/PiyasalarProvider.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Service/localdatabase.dart';
import 'package:dunyahaber/Models/current_rate.dart';
import 'package:dunyahaber/Models/post_item.dart' as PostItem;
import 'package:dunyahaber/Models/savedPost.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Service/utils.dart';
import 'DetailScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Search.dart';

class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationNews(
                    id: value.data['id'],
                  )));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((event) async {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationNews(
                    id: event.data['id'],
                  )));
    });
    Provider.of<MainProvider>(context, listen: false).getCurrentRate();
    Provider.of<HeadLineProvider>(context, listen: false).getElectedNews();
    Provider.of<AllNewsProvider>(context, listen: false).getAllNews();
    Provider.of<HomeProvider>(context, listen: false).getOneCikanlar();
    Provider.of<HomeProvider>(context, listen: false).getPublisher();
    Provider.of<GundemProvider>(context, listen: false).getGundem();
    Provider.of<PiyasalarProvider>(context, listen: false).getPiyasalar();

    controller = TabController(length: 4, vsync: this);
    controller.addListener(listen);
    Provider.of<HomeProvider>(context, listen: false).setfirst(controller);
    super.initState();
  }

  listen() {
    Provider.of<HomeProvider>(context, listen: false).setCont(controller);
  }

  @override
  Widget build(BuildContext context) {
    List<CurrentRate> currentRate =
        Provider.of<MainProvider>(context, listen: false).currentRate;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            ////print(innerBoxIsScrolled);
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  titleSpacing: 0,
                  //collapsedHeight: 150,
                  automaticallyImplyLeading: false,
                  elevation: 10,
                  backgroundColor: Color(0xFF131A20),
                  centerTitle: true,
                  title: appBarTitle(),
                  pinned: true,
                  flexibleSpace: headerCorusel(currentRate),
                  expandedHeight: MediaQuery.of(context).size.width,
                  forceElevated: innerBoxIsScrolled,
                  bottom: PreferredSize(
                    preferredSize: Size(double.infinity, 50),
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Consumer<HomeProvider>(
                        builder: (context, value, child) => TabBar(
                          labelPadding: EdgeInsets.symmetric(horizontal: 5),
                          controller: value.controller,
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
                                    color: value.controller.index == 0
                                        ? Colors.red
                                        : Colors.grey[50]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  child: Container(
                                    child: Text('Hepsi'),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Tab(
                                child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: value.controller.index == 1
                                          ? Colors.red
                                          : Colors.grey[50]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Text('Öne Çıkanlar'),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: value.controller.index == 2
                                        ? Colors.red
                                        : Colors.grey[50]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  child: Text('Gündem'),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: value.controller.index == 3
                                        ? Colors.red
                                        : Colors.grey[50]),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  child: Text('Piyasalar'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
              hepsi(currentRate),
              oneCikanlar(currentRate),
              gundem(currentRate),
              piyasalar(currentRate)
            ],
          ),
        ),
      ),
    );
  }

  Widget oneCikanlar(currentRate) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Selector<HomeProvider, List>(
            selector: (_, home) => home.oneCikanlar,
            builder: (context, oneCikanlar, child) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<SavedPost>('posts').listenable(),
                builder: (context, box, child) => CustomScrollView(
                  key: PageStorageKey<int>(2),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, int index) {
                            return Container(
                              color: Colors.grey[50],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    int skip = Provider.of<HomeProvider>(
                                            context,
                                            listen: false)
                                        .skip;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          skip: skip,
                                          index: index,
                                          list: oneCikanlar,
                                          currentRate: currentRate,
                                          type: 'headline',
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
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Image.network(
                                                      oneCikanlar[index]
                                                          .image
                                                          .url),
                                                ),
                                              ),
                                              Positioned(
                                                right: 7,
                                                top: 7,
                                                child: SizedBox(
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    elevation: 2,
                                                    shadowColor: Colors.black12,
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      onTap: () {
                                                        share(
                                                            context,
                                                            oneCikanlar[index]
                                                                .link,
                                                            oneCikanlar[index]
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
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 5,
                                                      color: Colors.red,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6),
                                                        child: Container(
                                                          //width: double.infinity,
                                                          child: Text(
                                                            'Öne Çıkanlar',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: () {
                                                      box.values.any(
                                                              (element) =>
                                                                  element.id ==
                                                                  oneCikanlar[
                                                                          index]
                                                                      .id)
                                                          ? HiveController()
                                                              .deletePostWithID(
                                                                  oneCikanlar[
                                                                      index])
                                                          : HiveController()
                                                              .savePostWithItem(
                                                                  oneCikanlar[
                                                                      index]);
                                                    },
                                                    child: box.values.any(
                                                            (element) =>
                                                                element.id ==
                                                                oneCikanlar[
                                                                        index]
                                                                    .id)
                                                        ? Icon(Icons.bookmark)
                                                        : Icon(Icons
                                                            .bookmark_border),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 11, vertical: 7),
                                          child: Container(
                                            child: Text(
                                              oneCikanlar[index].title ?? ' ',
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
                                              oneCikanlar[index].summary ?? ' ',
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
                          addAutomaticKeepAlives: true,
                          childCount: oneCikanlar.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget hepsi(currentRate) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Consumer<AllNewsProvider>(
            builder: (context, allNews, child) {
              return NotificationListener<ScrollNotification>(
                // ignore: missing_return
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    Provider.of<AllNewsProvider>(context, listen: false)
                        .getMoreAllNews();
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<SavedPost>('posts').listenable(),
                  builder: (context, box, child) => CustomScrollView(
                    key: PageStorageKey<int>(0),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverToBoxAdapter(
                        key: PageStorageKey<int>(1),
                        child: Container(
                          height: 150,
                          color: Colors.grey[200],
                          child: Consumer<HomeProvider>(
                            builder: (context, publisher, child) {
                              //print('futurehepsipub');
                              if (publisher.publisher.isNotEmpty) {
                                return CarouselSlider.builder(
                                  options: CarouselOptions(
                                      height: 150,
                                      viewportFraction: 0.8,
                                      initialPage: 1,
                                      enableInfiniteScroll: true,
                                      autoPlay: true,
                                      scrollDirection: Axis.horizontal,
                                      aspectRatio: 16 / 2),
                                  itemCount: publisher.publisher.length,
                                  itemBuilder: (BuildContext context, int index,
                                      int nfd) {
                                    return OpenContainer(
                                      closedElevation: 0,
                                      closedColor: Colors.grey[50],
                                      openBuilder: (context, action) {
                                        return SafeArea(
                                          top: false,
                                          child: Scaffold(
                                            body: Container(
                                              child: ChangeNotifierProvider(
                                                create: (context) =>
                                                    HomeProviderPublisher(),
                                                builder: (context, child) =>
                                                    PageView.builder(
                                                  controller: PageController(
                                                      initialPage: index),
                                                  itemCount: publisher
                                                      .publisher.length,
                                                  itemBuilder:
                                                      (context, index2) {
                                                    print('error');
                                                    PageController controller2 =
                                                        PageController();
                                                    return Scaffold(
                                                      appBar: AppBar(
                                                        brightness:
                                                            Brightness.dark,
                                                        toolbarHeight: 140,
                                                        automaticallyImplyLeading:
                                                            true,
                                                        backgroundColor:
                                                            Color(0xFF131A20),
                                                        titleSpacing: 0,
                                                        centerTitle: true,
                                                        title: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Flexible(
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundImage: NetworkImage(publisher
                                                                            .publisher[index2]
                                                                            .image
                                                                            .url),
                                                                        backgroundColor:
                                                                            Colors.grey[200],
                                                                        radius:
                                                                            35.0,
                                                                      )),
                                                                  Flexible(
                                                                      child:
                                                                          Text(
                                                                    publisher
                                                                        .publisher[
                                                                            index2]
                                                                        .name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                            IconButton(
                                                                icon: Icon(Icons
                                                                    .mail_outline_outlined),
                                                                onPressed: () {
                                                                  sendMail(
                                                                      publisher
                                                                          .publisher[
                                                                              index2]
                                                                          .name,
                                                                      publisher
                                                                          .publisher[
                                                                              index2]
                                                                          .email);
                                                                })
                                                          ],
                                                        ),
                                                        bottom: PreferredSize(
                                                          preferredSize: Size(
                                                              double.infinity,
                                                              50),
                                                          child: BottomAppBar(
                                                            child: Selector<
                                                                HomeProviderPublisher,
                                                                int>(
                                                              selector: (_,
                                                                      publisher) =>
                                                                  publisher
                                                                      .index,
                                                              builder: (context,
                                                                      value,
                                                                      child) =>
                                                                  Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Provider.of<HomeProviderPublisher>(context, listen: false).changePage(0);
                                                                            controller2.animateToPage(0,
                                                                                duration: Duration(milliseconds: 300),
                                                                                curve: Curves.ease);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.all(5),
                                                                            decoration:
                                                                                BoxDecoration(color: value == 0 ? Colors.red : Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'MAKALE DETAYİ',
                                                                                  style: TextStyle(color: value == 0 ? Colors.white : Colors.black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Material(
                                                                        color: Colors
                                                                            .transparent,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            Provider.of<HomeProviderPublisher>(context, listen: false).changePage(1);
                                                                            controller2.animateToPage(1,
                                                                                duration: Duration(milliseconds: 300),
                                                                                curve: Curves.ease);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            margin:
                                                                                EdgeInsets.all(5),
                                                                            decoration:
                                                                                BoxDecoration(color: value == 1 ? Colors.red : Colors.grey[300], borderRadius: BorderRadius.circular(3)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'MAKALE LİSTESİ',
                                                                                  style: TextStyle(color: value == 1 ? Colors.white : Colors.black),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      body: PageView(
                                                        controller: controller2,
                                                        children: [
                                                          Detail(
                                                            publisher: publisher
                                                                .publisher,
                                                            index: index2,
                                                          ),
                                                          Container(
                                                            child: ArticleList(
                                                              publisherid:
                                                                  publisher
                                                                      .publisher[
                                                                          index2]
                                                                      .id,
                                                              publishername:
                                                                  publisher
                                                                      .publisher[
                                                                          index2]
                                                                      .name,
                                                              publisherurl:
                                                                  publisher
                                                                      .publisher[
                                                                          index2]
                                                                      .image
                                                                      .url,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      closedBuilder: (context, action) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 2,
                                              bottom: 4,
                                              top: 4,
                                              right: 2),
                                          child: Container(
                                            color: Colors.white,
                                            alignment: Alignment.center,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10,
                                                            right: 10),
                                                    child: publisher
                                                                .publisher[
                                                                    index]
                                                                .image
                                                                .url !=
                                                            null
                                                        ? CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    publisher
                                                                        .publisher[
                                                                            index]
                                                                        .image
                                                                        .url),
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            radius: 35.0,
                                                          )
                                                        : CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[200],
                                                            radius: 35,
                                                          ),
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 6),
                                                      child: Container(
                                                        width: 200,
                                                        child: Text(
                                                          publisher
                                                                  .publisher[
                                                                      index]
                                                                  .name ??
                                                              ' ',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 6,
                                                          right: 6,
                                                          top: 2),
                                                      child: Container(
                                                        width: 200,
                                                        child: Text(
                                                          publisher
                                                                  .publisher[
                                                                      index]
                                                                  .lastPost
                                                                  .title ??
                                                              ' ',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 6,
                                                          top: 5,
                                                          bottom: 5),
                                                      child: Container(
                                                        width: 200,
                                                        child: Text(
                                                          publisher
                                                                  .publisher[
                                                                      index]
                                                                  .lastPost
                                                                  .title ??
                                                              ' ',
                                                          maxLines: 3,
                                                          style: TextStyle(
                                                              letterSpacing:
                                                                  0.5,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5,
                                                          vertical: 4),
                                                      child: Material(
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          hoverColor:
                                                              Colors.grey,
                                                          highlightColor:
                                                              Colors.grey,
                                                          splashColor:
                                                              Colors.grey,
                                                          onTap: () {
                                                            action();
                                                          },
                                                          child: Ink(
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                                color: Colors
                                                                    .grey[200]),
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          7,
                                                                      vertical:
                                                                          4),
                                                              child: Text(
                                                                'Okumaya Devam Et',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else {
                                return Container(
                                  height: 150,
                                  width: 200,
                                  color: Colors.grey[50],
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.red)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            'Yükleniyor...',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, int index) {
                              return Container(
                                color: Colors.grey[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                    skip: allNews.skip,
                                                    index: index,
                                                    list: allNews.allNews,
                                                    currentRate: currentRate,
                                                    type: 'category',
                                                  )));
                                    },
                                    child: Card(
                                      elevation: 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: double.infinity,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Image.network(allNews
                                                        .allNews[index]
                                                        .image
                                                        .url),
                                                  ),
                                                ),
                                                allNews.allNews[index]
                                                            .diffrence !=
                                                        null
                                                    ? Positioned(
                                                        top: 7,
                                                        left: 7,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              3)),
                                                              color:
                                                                  Colors.red),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                            child: Text(
                                                              allNews
                                                                          .allNews[
                                                                              index]
                                                                          .diffrence >
                                                                      1
                                                                  ? allNews.allNews[index].diffrence <
                                                                          1440
                                                                      ? allNews.allNews[index].diffrence <
                                                                              60
                                                                          ? '${DateTime.now().difference(allNews.allNews[index].dateTime).inMinutes.toString()} dakika önce'
                                                                          : '${DateTime.now().difference(allNews.allNews[index].dateTime).inHours.toString()} saat önce'
                                                                      : '${DateTime.now().difference(allNews.allNews[index].dateTime).inDays.toString()} gün önce'
                                                                  : 'Şimdi',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                Positioned(
                                                  right: 7,
                                                  top: 7,
                                                  child: SizedBox(
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 2,
                                                      shadowColor:
                                                          Colors.black12,
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        onTap: () {
                                                          share(
                                                              context,
                                                              allNews
                                                                  .allNews[
                                                                      index]
                                                                  .link,
                                                              allNews
                                                                  .allNews[
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
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 5,
                                                        color: Colors.red,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Container(
                                                            //width: double.infinity,
                                                            child: Text(
                                                              'Tüm Haberler',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      onTap: () {
                                                        box.values.any((element) =>
                                                                element.id ==
                                                                allNews
                                                                    .allNews[
                                                                        index]
                                                                    .id)
                                                            ? HiveController()
                                                                .deletePostWithID(
                                                                    allNews.allNews[
                                                                        index])
                                                            : HiveController()
                                                                .savePostWithItem(
                                                                    allNews.allNews[
                                                                        index]);
                                                      },
                                                      child: box.values.any(
                                                              (element) =>
                                                                  element.id ==
                                                                  allNews
                                                                      .allNews[
                                                                          index]
                                                                      .id)
                                                          ? Icon(Icons.bookmark)
                                                          : Icon(Icons
                                                              .bookmark_border),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 7),
                                            child: Container(
                                              child: Text(
                                                allNews.allNews[index].title ??
                                                    ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 7),
                                            child: Container(
                                              child: Text(
                                                allNews.allNews[index]
                                                        .summary ??
                                                    ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                            addAutomaticKeepAlives: true,
                            childCount: allNews.allNews.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget gundem(currentRate) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Consumer<GundemProvider>(
            builder: (context, gundem, child) {
              return NotificationListener<ScrollNotification>(
                // ignore: missing_return
                onNotification: (notification) {
                  if (notification is ScrollEndNotification &&
                      notification.metrics.pixels ==
                          notification.metrics.maxScrollExtent) {
                    Provider.of<GundemProvider>(context, listen: false)
                        .getMoreGundem();
                    //print('aonecikanlar');
                  }
                },
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<SavedPost>('posts').listenable(),
                  builder: (context, box, child) => CustomScrollView(
                    key: PageStorageKey<int>(3),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, int index) {
                              return Container(
                                color: Colors.grey[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            skip: gundem.skipgundem,
                                            index: index,
                                            list: gundem.gundemNews,
                                            currentRate: currentRate,
                                            type: 'category',
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
                                            child: Stack(
                                              children: [
                                                SizedBox(
                                                  height: 200,
                                                  width: double.infinity,
                                                  child: FittedBox(
                                                    fit: BoxFit.fill,
                                                    child: Image.network(gundem
                                                        .gundemNews[index]
                                                        .image
                                                        .url),
                                                  ),
                                                ),
                                                gundem.gundemNews[index]
                                                            .diffrence !=
                                                        null
                                                    ? Positioned(
                                                        top: 7,
                                                        left: 7,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              3)),
                                                              color:
                                                                  Colors.red),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                            child: Text(
                                                              gundem
                                                                          .gundemNews[
                                                                              index]
                                                                          .diffrence >
                                                                      1
                                                                  ? gundem.gundemNews[index].diffrence <
                                                                          1440
                                                                      ? gundem.gundemNews[index].diffrence <
                                                                              60
                                                                          ? '${DateTime.now().difference(gundem.gundemNews[index].dateTime).inMinutes.toString()} dakika önce'
                                                                          : '${DateTime.now().difference(gundem.gundemNews[index].dateTime).inHours.toString()} saat önce'
                                                                      : '${DateTime.now().difference(gundem.gundemNews[index].dateTime).inDays.toString()} gün önce'
                                                                  : 'Şimdi',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                                Positioned(
                                                  right: 7,
                                                  top: 7,
                                                  child: SizedBox(
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 2,
                                                      shadowColor:
                                                          Colors.black12,
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        onTap: () {
                                                          share(
                                                              context,
                                                              gundem
                                                                  .gundemNews[
                                                                      index]
                                                                  .link,
                                                              gundem
                                                                  .gundemNews[
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
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        height: 20,
                                                        width: 5,
                                                        color: Colors.red,
                                                      ),
                                                      Flexible(
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Container(
                                                            //width: double.infinity,
                                                            child: Text(
                                                              'Gündem',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      onTap: () {
                                                        box.values.any((element) =>
                                                                element.id ==
                                                                gundem
                                                                    .gundemNews[
                                                                        index]
                                                                    .id)
                                                            ? HiveController()
                                                                .deletePostWithID(
                                                                    gundem.gundemNews[
                                                                        index])
                                                            : HiveController()
                                                                .savePostWithItem(
                                                                    gundem.gundemNews[
                                                                        index]);
                                                      },
                                                      child: box.values.any(
                                                              (element) =>
                                                                  element.id ==
                                                                  gundem
                                                                      .gundemNews[
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
                                                gundem.gundemNews[index]
                                                        .title ??
                                                    ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 7),
                                            child: Container(
                                              child: Text(
                                                gundem.gundemNews[index]
                                                        .summary ??
                                                    ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                            addAutomaticKeepAlives: true,
                            childCount: gundem.gundemNews.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget piyasalar(currentRate) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) {
          return Consumer<PiyasalarProvider>(
            builder: (context, piyasalar, child) {
              return ValueListenableBuilder(
                valueListenable: Hive.box<SavedPost>('posts').listenable(),
                builder: (context, box, child) => CustomScrollView(
                  key: PageStorageKey<int>(4),
                  slivers: <Widget>[
                    SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, int index) {
                            return Container(
                              color: Colors.grey[50],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailPage(
                                          index: index,
                                          list: piyasalar.piyasalar,
                                          currentRate: currentRate,
                                          type: 'headline',
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
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Image.network(piyasalar
                                                      .piyasalar[index]
                                                      .image
                                                      .url),
                                                ),
                                              ),
                                              Positioned(
                                                right: 7,
                                                top: 7,
                                                child: SizedBox(
                                                  child: Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    elevation: 2,
                                                    shadowColor: Colors.black12,
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      onTap: () {
                                                        share(
                                                            context,
                                                            piyasalar
                                                                .piyasalar[
                                                                    index]
                                                                .link,
                                                            piyasalar
                                                                .piyasalar[
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
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      height: 20,
                                                      width: 5,
                                                      color: Colors.red,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6),
                                                        child: Container(
                                                          //width: double.infinity,
                                                          child: Text(
                                                            'Piyasalar',
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: () {
                                                      box.values.any((element) =>
                                                              element.id ==
                                                              piyasalar
                                                                  .piyasalar[
                                                                      index]
                                                                  .id)
                                                          ? HiveController()
                                                              .deletePostWithID(
                                                                  piyasalar
                                                                          .piyasalar[
                                                                      index])
                                                          : HiveController()
                                                              .savePostWithItem(
                                                                  piyasalar
                                                                          .piyasalar[
                                                                      index]);
                                                    },
                                                    child: box.values.any(
                                                            (element) =>
                                                                element.id ==
                                                                piyasalar
                                                                    .piyasalar[
                                                                        index]
                                                                    .id)
                                                        ? Icon(Icons.bookmark)
                                                        : Icon(Icons
                                                            .bookmark_border),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 11, vertical: 7),
                                          child: Container(
                                            child: Text(
                                              piyasalar
                                                      .piyasalar[index].title ??
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
                                              piyasalar.piyasalar[index]
                                                      .summary ??
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
                          addAutomaticKeepAlives: true,
                          childCount: piyasalar.piyasalar.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget appBarTitle() {
    return Padding(
      padding: EdgeInsets.only(
        top: 1,
        left: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
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
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  height: 45,
                  width: 100,
                  child: AspectRatio(
                    aspectRatio: 4 / 2,
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
              )
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
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset('assets/fav.png'),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget headerCorusel(currentRate) {
    return FlexibleSpaceBar(
      centerTitle: true,
      stretchModes: [StretchMode.blurBackground, StretchMode.zoomBackground],
      collapseMode: CollapseMode.pin,
      background: Container(
        child: Consumer<HeadLineProvider>(
          builder: (context, home, child) {
            if (home.electedNews.isNotEmpty) {
              return Column(
                children: [
                  CarouselSlider.builder(
                    itemCount: home.electedNews.length,
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        return Provider.of<HeadLineProvider>(
                          context,
                          listen: false,
                        ).dotPosition(index);
                      },
                      height: MediaQuery.of(context).size.width - 80,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInOut,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemBuilder: (context, index, index2) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                index: index,
                                list: home.electedNews,
                                currentRate: currentRate,
                                type: 'headline',
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.width - 40,
                              width: MediaQuery.of(context).size.width,
                              foregroundDecoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, -220),
                                      color: Colors.black54,
                                      spreadRadius: 10,
                                      blurRadius: 55),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black45,
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.black12
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0, 0.8, 0.2, 1],
                                ),
                              ),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: CachedNetworkImage(
                                    placeholder: (context, string) {
                                      return Container(
                                        color: Colors.grey[100],
                                      );
                                    },
                                    imageUrl: home.electedNews[index].image.url,
                                  )),
                            ),
                            Positioned(
                              bottom: 60,
                              left: 30,
                              child: SizedBox(
                                width: 250,
                                height: 150,
                                child: Stack(
                                  children: [
                                    AutoSizeText.rich(
                                      TextSpan(
                                          text: home.electedNews[index].title),
                                      style: TextStyle(
                                          fontSize: 36,
                                          wordSpacing: 3,
                                          height: 1.25,
                                          //backgroundColor: Colors.black26,
                                          fontWeight: FontWeight.bold,
                                          decorationStyle:
                                              TextDecorationStyle.double,
                                          color: Colors.white),
                                      minFontSize: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    color: //Colors.lightBlue,
                        Color(0xFF131A20),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text((home.dotposition + 1).toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ),
                              DotsIndicator(
                                position: home.dotposition.toDouble(),
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                dotsCount: home.electedNews.length,
                                decorator: DotsDecorator(
                                  spacing: EdgeInsets.all(2),
                                  color: Colors.white,
                                  activeColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0)),
                                  size: Size(16, 2),
                                  activeSize: Size(16, 2),
                                  activeShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0)),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text('1-15',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ArticleList extends StatefulWidget {
  final String publisherid;
  final String publisherurl;
  final String publishername;
  const ArticleList({
    Key key,
    this.publisherid,
    this.publisherurl,
    this.publishername,
  }) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<PostModel.Item>>(
          future: Provider.of<HomeProviderPublisher>(context, listen: false)
              .getPublisherNews(widget.publisherid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(widget.publisherid);
              return ListView.separated(
                itemCount: snapshot.data.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 2,
                  );
                },
                itemBuilder: (context, index) {
                  return OpenContainer(
                    closedElevation: 0,
                    closedBuilder: (context, action) {
                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data[index].dateTime.day}. ${snapshot.data[index].dateTime.month}. ${snapshot.data[index].dateTime.year}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                snapshot.data[index].title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    openBuilder: (context, action) {
                      return Scaffold(
                        backgroundColor: Color(0xFFF6F7FA),
                        appBar: AppBar(
                          brightness: Brightness.dark,
                          titleSpacing: 0,
                          toolbarHeight: 90,
                          backgroundColor: Color(0xFF131A20),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(widget.publisherurl),
                                          backgroundColor: Colors.grey[200],
                                          radius: 35.0,
                                        )),
                                    Flexible(
                                        child: Text(
                                      widget.publishername,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        body: SafeArea(
                          child: Container(
                            color: Colors.white,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.network(
                                          snapshot.data[index].image.url),
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data[index].dateTime.day}.${snapshot.data[index].dateTime.month}.${snapshot.data[index].dateTime.year}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data[index].title,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  //Text(snapshot.data[index].summary),
                                  FutureBuilder<PostItem.Post>(
                                    future: DunyaApiManager()
                                        .getPost(snapshot.data[index].id),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        return Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        'Güncellendi: ',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black54),
                                                      ),
                                                      Text(
                                                          snapshot2.data.data
                                                              .updatedAt
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black54)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Html(
                                                  data: snapshot2
                                                      .data.data.contentHtml,
                                                  style: {
                                                    'body': Style(
                                                        fontSize: FontSize(18))
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Detail extends StatefulWidget {
  final List<Item> publisher;
  final int index;
  const Detail({
    Key key,
    this.publisher,
    this.index,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<PostItem.Post>(
      future:
          DunyaApiManager().getPost(widget.publisher[widget.index].lastPost.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //print(publisher
          // .publisher[index]
          // .lastPost
          // .id);
          return Container(
            color: Colors.grey[50],
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 180,
                    child: Image.network(
                      snapshot.data.data.image.url,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Card(
                    elevation: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Container(
                                  width: double.infinity,
                                  // height: 40,
                                  child: Text(
                                    snapshot.data.data.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.red),
                                    maxLines: 5,
                                    //overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        snapshot.data.data.summary != '-'
                            ? Container(
                                width: double.infinity,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data.data.summary,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )
                            : SizedBox(),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Html(
                              data: snapshot.data.data.contentHtml,
                              shrinkWrap: true,
                              style: {'body': Style(fontSize: FontSize(17))},
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  )),
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              'Yükleniyor...',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[50]),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
