import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dunyahaber/Providers/PublisherDetailProvider.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:dunyahaber/Providers/PublisherProvider.dart';
import 'package:dunyahaber/Models/authors_model.dart';
import 'package:dunyahaber/Service/utils.dart';
import 'package:provider/provider.dart';
import 'package:dunyahaber/Models/post_item.dart' as PostItem;
import 'package:dunyahaber/Models/post_model.dart' as PostModel;

class Publisher extends StatefulWidget {
  @override
  _PublisherState createState() => _PublisherState();
}

class _PublisherState extends State<Publisher> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF131A20),
      child: Scaffold(
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
                        elevation: 0,
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
                          elevation: 0,
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: () {},
                            child: Image.asset('assets/search.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Material(
                        elevation: 0,
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
          ),
        ),
        body: Container(
          color: Colors.grey[50],
          child: RefreshIndicator(
            onRefresh: () {
              return Provider.of<PublisherProvider>(context, listen: false)
                  .refreshPublisher();
            },
            child: FutureBuilder<List<Item>>(
              future: Provider.of<PublisherProvider>(context, listen: false)
                  .getPublisher(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return NotificationListener<ScrollNotification>(
                    // ignore: missing_return
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          notification.metrics.pixels ==
                              notification.metrics.maxScrollExtent) {
                        Provider.of<PublisherProvider>(context, listen: false)
                            .getMorePublisher();
                        //print('a');
                      }
                    },
                    child: Consumer<PublisherProvider>(
                      builder: (context, publisher, child) => ListView.builder(
                        itemCount: publisher.publisher.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: OpenContainer(
                              closedShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              closedElevation: 0,
                              openBuilder: (context, action) {
                                PageController controller2 =
                                    PageController(initialPage: index);
                                return SafeArea(
                                  top: false,
                                  child: ChangeNotifierProvider(
                                    create: (context) =>
                                        PublisherDetailProvider(),
                                    builder: (context, child) => Scaffold(
                                      body: Container(
                                        child: PageView.builder(
                                          controller: controller2,
                                          itemCount: publisher.publisher.length,
                                          itemBuilder: (context, index2) {
                                            PageController controller =
                                                PageController(
                                                    initialPage: 0,
                                                    keepPage: false);

                                            return Scaffold(
                                              appBar: AppBar(
                                                brightness: Brightness.dark,
                                                toolbarHeight: 140,
                                                automaticallyImplyLeading: true,
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
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundImage:
                                                                    NetworkImage(publisher
                                                                        .publisher[
                                                                            index2]
                                                                        .image
                                                                        .url),
                                                                backgroundColor:
                                                                    Colors.grey[
                                                                        200],
                                                                radius: 35.0,
                                                              )),
                                                          Flexible(
                                                              child: Text(
                                                            publisher
                                                                .publisher[
                                                                    index2]
                                                                .name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                        double.infinity, 50),
                                                    child: BottomAppBar(
                                                      child: Selector<
                                                          PublisherDetailProvider,
                                                          int>(
                                                        selector:
                                                            (_, publisher) =>
                                                                publisher.index,
                                                        builder: (context,
                                                                value, child) =>
                                                            Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      // Provider.of<PublisherDetailProvider>(
                                                                      //         context,
                                                                      //         listen:
                                                                      //             false)
                                                                      //     .changeindex(
                                                                      //         1);

                                                                      controller.animateToPage(
                                                                          0,
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  300),
                                                                          curve:
                                                                              Curves.ease);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: value == 0
                                                                              ? Colors.red
                                                                              : Colors.grey[300],
                                                                          borderRadius: BorderRadius.circular(3)),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'MAKALE DETAYİ',
                                                                            style:
                                                                                TextStyle(color: value == 0 ? Colors.white : Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Material(
                                                                  color: Colors
                                                                      .transparent,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      // Provider.of<PublisherDetailProvider>(
                                                                      //         context,
                                                                      //         listen:
                                                                      //             false)
                                                                      //     .changeindex(
                                                                      //         2);
                                                                      controller.animateToPage(
                                                                          1,
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  300),
                                                                          curve:
                                                                              Curves.ease);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              5),
                                                                      decoration: BoxDecoration(
                                                                          color: value == 1
                                                                              ? Colors.red
                                                                              : Colors.grey[300],
                                                                          borderRadius: BorderRadius.circular(3)),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            'MAKALE LİSTESİ',
                                                                            style:
                                                                                TextStyle(color: value == 1 ? Colors.white : Colors.black),
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
                                                    )),
                                              ),
                                              body: PageView(
                                                onPageChanged: (value) {
                                                  //controller.jumpToPage(0);
                                                  Provider.of<PublisherDetailProvider>(
                                                          context,
                                                          listen: false)
                                                      .changeindex(value);
                                                },
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                controller: controller,
                                                children: [
                                                  Detail(
                                                    index2: index2,
                                                    publisher: publisher,
                                                  ),
                                                  ArticleList(
                                                    publisherid: publisher
                                                        .publisher[index2].id,
                                                    publishername: publisher
                                                        .publisher[index2].name,
                                                    publisherurl: publisher
                                                        .publisher[index2]
                                                        .image
                                                        .url,
                                                  ),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    alignment: Alignment.center,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: publisher.publisher[index]
                                                        .image.url !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(publisher
                                                            .publisher[index]
                                                            .image
                                                            .url),
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    radius: 35.0,
                                                  )
                                                : CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    radius: 35,
                                                  ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6),
                                                child: Container(
                                                  width: 200,
                                                  child: Text(
                                                    publisher.publisher[index]
                                                            .name ??
                                                        ' ',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 6,
                                                      top: 5,
                                                      bottom: 5),
                                                  child: Container(
                                                    child: Text(
                                                      publisher.publisher[index]
                                                              .lastPost.title ??
                                                          ' ',
                                                      maxLines: 5,
                                                      style: TextStyle(
                                                          letterSpacing: 0.5,
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
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
          future: Provider.of<PublisherDetailProvider>(context, listen: false)
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
  final int index2;
  final PublisherProvider publisher;
  const Detail({
    Key key,
    this.index2,
    this.publisher,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<PostItem.Post>(
      future: DunyaApiManager()
          .getPost(widget.publisher.publisher[widget.index2].lastPost.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //print(publisher
          // .publisher[index]
          // .lastPost
          // .id);
          return SingleChildScrollView(
            child: Column(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          snapshot.data.data.title,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.red),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Güncellendi: ',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                              Text(snapshot.data.data.updatedAt.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54)),
                            ],
                          ),
                        ),
                      ),
                      snapshot.data.data.summary != '-'
                          ? Container(
                              color: Colors.grey[50],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data.data.summary,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                          : SizedBox(),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Html(
                          data: snapshot.data.data.contentHtml,
                          style: {'body': Style(fontSize: FontSize(18))},
                          shrinkWrap: true,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          //print(publisher
          // .publisher[index]
          // .lastPost
          // .id);
          return Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
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
                    Padding(
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
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[50]),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.red,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
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
