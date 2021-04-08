import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:dunyahaber/Providers/SportProvider.dart';
import 'package:dunyahaber/Screens/DetailScreen.dart';
import 'package:dunyahaber/Screens/Search.dart';
import 'package:dunyahaber/Service/localdatabase.dart';
import 'package:dunyahaber/Models/current_rate.dart';
import 'package:dunyahaber/Models/post_model.dart';
import 'package:dunyahaber/Models/savedPost.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Service/utils.dart';

class Sport extends StatefulWidget {
  @override
  _SportState createState() => _SportState();
}

class _SportState extends State<Sport> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF6F7FA),
      child: Scaffold(
        backgroundColor: Color(0xFFF6F7FA),
        appBar: AppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF131A20),
          title: Padding(
            padding: EdgeInsets.only(
              top: 1,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: 'back',
                      child: SizedBox(
                          height: 45,
                          width: 45,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Provider.of<MainProvider>(context,
                                        listen: false)
                                    .globalKey
                                    .currentState
                                    .open(
                                        direction: InnerDrawerDirection.start);
                              },
                              child: Image.asset('assets/dot.png'),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Hero(
                        tag: 'logo',
                        child: Container(
                          height: 45,
                          width: 100,
                          child: AspectRatio(
                              aspectRatio: 4 / 2,
                              child: Image.asset('assets/logo.png')),
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
                            // splashColor: Colors.transparent,
                            onTap: () {
                              List currentRate = Provider.of<MainProvider>(
                                      context,
                                      listen: false)
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
                              child: Image.asset('assets/fav.png')),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[50],
          child: RefreshIndicator(
            onRefresh: () {
              return Provider.of<SportProvider>(context, listen: false)
                  .refreshSportNews();
            },
            child: FutureBuilder<List<Item>>(
              future: Provider.of<SportProvider>(context, listen: false)
                  .getSportNews(),
              builder: (context, snapshot) {
                List<CurrentRate> currentRate =
                    Provider.of<MainProvider>(context, listen: false)
                        .currentRate;
                if (snapshot.hasData) {
                  return NotificationListener<ScrollNotification>(
                    // ignore: missing_return
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                        Provider.of<SportProvider>(context, listen: false)
                            .getMoreSportNews();
                        //print('a');
                      }
                    },
                    child: Consumer<SportProvider>(
                      builder: (context, value, child) {
                        return ValueListenableBuilder<Box<SavedPost>>(
                          valueListenable:
                              Hive.box<SavedPost>('posts').listenable(),
                          builder: (context, Box<SavedPost> box, child) =>
                              ListView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: value.aa.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.grey[50],
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(value.aa.length);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            type: 'Spor Haberleri',
                                            skip: value.skip,
                                            index: index,
                                            list: value.aa,
                                            currentRate: currentRate,
                                            newsid: value.id,
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
                                            child:
                                                value.aa[index].image.url !=
                                                        null
                                                    ? Stack(
                                                        children: [
                                                          Hero(
                                                            tag: 'photos$index',
                                                                                                                      child: SizedBox(
                                                              height: 200,
                                                              width:
                                                                  double.infinity,
                                                              child: FittedBox(
                                                                fit: BoxFit.fill,
                                                                child: Image
                                                                    .network(value
                                                                        .aa[index]
                                                                        .image
                                                                        .url),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            top: 7,
                                                            left: 7,
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              3)),
                                                                  color: Colors
                                                                      .red),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4,
                                                                ),
                                                                child: Text(
                                                                  value.aa[index].diffrence >
                                                                          1
                                                                      ? value.aa[index].diffrence <
                                                                              1440
                                                                          ? value.aa[index].diffrence < 60
                                                                              ? '${DateTime.now().difference(value.aa[index].dateTime).inMinutes.toString()} dakika önce'
                                                                              : '${DateTime.now().difference(value.aa[index].dateTime).inHours.toString()} saat önce'
                                                                          : '${DateTime.now().difference(value.aa[index].dateTime).inDays.toString()} gün önce'
                                                                      : 'Şimdi',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
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
                                                                        .circular(
                                                                            30),
                                                                elevation: 0.1,
                                                                shadowColor:
                                                                    Colors
                                                                        .black12,
                                                                color: Colors
                                                                    .transparent,
                                                                child: InkWell(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  onTap: () {
                                                                    share(
                                                                        context,
                                                                        value
                                                                            .aa[
                                                                                index]
                                                                            .link,
                                                                        value
                                                                            .aa[index]
                                                                            .title);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      child: Image
                                                                          .asset(
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
                                                            child: AutoSizeText
                                                                .rich(
                                                              TextSpan(
                                                                text:
                                                                    'Spor' /*value.aa[index].title*/,
                                                              ),
                                                              //maxLines: 2,
                                                              minFontSize: 18,
                                                              maxFontSize: 18,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .red,
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
                                                        box.values.any(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    value
                                                                        .aa[
                                                                            index]
                                                                        .id)
                                                            ? HiveController()
                                                                .deletePostWithID(
                                                                    value.aa[
                                                                        index])
                                                            : HiveController()
                                                                .savePostWithItem(
                                                                    value.aa[
                                                                        index]);
                                                      },
                                                      child: box.values.any(
                                                              (element) =>
                                                                  element.id ==
                                                                  value
                                                                      .aa[index]
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
                                                value.aa[index].title ?? ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 7),
                                            child: Container(
                                              child: Text(
                                                value.aa[index].summary ?? ' ',
                                                //maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w500),
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
        ),
      ),
    );
  }
}
