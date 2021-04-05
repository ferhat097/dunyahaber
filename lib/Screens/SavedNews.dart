import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dunyahaber/Models/savedPost.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:dunyahaber/Service/localdatabase.dart';
import 'package:dunyahaber/Service/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Search.dart';

class SavedNews extends StatefulWidget {
  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                          child: Image.asset('assets/logo.png')),
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Kaydedilenler',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: FutureBuilder(
                future: Hive.openBox<SavedPost>('posts'),
                builder: (context, snapshot) =>
                    ValueListenableBuilder<Box<SavedPost>>(
                  valueListenable: Hive.box<SavedPost>('posts').listenable(),
                  builder: (context, Box<SavedPost> value, child) {
                    if (value.isNotEmpty) {
                      return ListView.builder(
                        itemCount: value.values.length,
                        itemBuilder: (context, index) {
                          return OpenContainer(
                            closedColor: Colors.grey[200],
                            closedElevation: 0,
                            closedBuilder: (context, action) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Card(
                                  elevation: 0,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                              child: CachedNetworkImage(
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Image(
                                                      image: imageProvider);
                                                },
                                                imageUrl:
                                                    value.getAt(index).imageUrl,
                                                placeholder: (context, string) {
                                                  return Container(
                                                    color: Colors.grey[100],
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                            Positioned(
                                              right: 15,
                                              top: 5,
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 0.1,
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
                                                              value
                                                                  .getAt(index)
                                                                  .link,
                                                              value
                                                                  .getAt(index)
                                                                  .title);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: SizedBox(
                                                            height: 40,
                                                            width: 40,
                                                            child: Image.asset(
                                                                'assets/shareicon.png'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20)),
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: Container(
                                                                height: 200,
                                                                child: Scaffold(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    body:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              12),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Center(
                                                                              child: Text(
                                                                            'Silmek İstediğinize\nemin misiniz ?',
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          )),
                                                                          Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(20)),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                                                                      child: Text(
                                                                                        'Iptal',
                                                                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 18),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Material(
                                                                                color: Colors.transparent,
                                                                                child: InkWell(
                                                                                  borderRadius: BorderRadius.circular(20),
                                                                                  onTap: () {
                                                                                    HiveController().deletePost(
                                                                                      value.keyAt(index),
                                                                                    );
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Container(
                                                                                    decoration: BoxDecoration(color: Colors.red.withAlpha(250), borderRadius: BorderRadius.circular(20)),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                                                                                      child: Text(
                                                                                        'Sil',
                                                                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            color: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Image.asset(
                                                                'assets/delete.png'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          // height: 60,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[50]),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                //height: 20,
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  top: 10),
                                                          child: Text(
                                                            value
                                                                .getAt(index)
                                                                .title,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                            maxLines: 3,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.red,
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5),
                                                    child: Text(
                                                      value
                                                          .getAt(index)
                                                          .summary,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      maxLines: 4,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            openBuilder: (context, action) {
                              return Scaffold(
                                backgroundColor: Color(0xFF131A20),
                                appBar: AppBar(
                                  brightness: Brightness.dark,
                                  backgroundColor: Color(0xFF131A20),
                                  title: Text(
                                    value.getAt(index).title,
                                    maxLines: 3,
                                  ),
                                ),
                                body: SafeArea(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Image.network(
                                            value.getAt(index).imageUrl),
                                        Container(
                                          color: Colors.grey[100],
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Text(
                                                    value.getAt(index).summary,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                ),
                                                Html(
                                                  data: value
                                                      .getAt(index)
                                                      .contentHtml,
                                                  shrinkWrap: true,
                                                  style: {
                                                    'body': Style(
                                                        fontSize: FontSize(17))
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
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
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blueGrey[50]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: "Kaydedilen Haber Yok",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontFamily: 'Greycliff'),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
