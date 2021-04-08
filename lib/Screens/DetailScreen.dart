import 'package:carousel_slider/carousel_slider.dart';
import 'package:dunyahaber/Service/localdatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:dunyahaber/Providers/DetailProvider.dart';
import 'package:dunyahaber/Models/savedPost.dart';
import 'package:dunyahaber/Service/utils.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:parallax_image/parallax_image.dart' as parallax;
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailPage extends StatefulWidget {
  final String newsid;
  final int skip;
  final String type;
  final int index;
  final List<dynamic> list;
  final List currentRate;
  const DetailPage(
      {Key key,
      this.skip,
      this.index,
      this.list,
      this.currentRate,
      this.type,
      this.newsid})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> list2;
    List list3;
    if (widget.list.length != 0) {
      list2 = widget.list;
      list3 = list2.toList(growable: false);
    }
    super.build(context);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => DetailProvider(),
          builder: (context, child) {
            Provider.of<DetailProvider>(context, listen: false).setfirstpost(
                widget.list, widget.index, widget.newsid, widget.type);
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                Provider.of<DetailProvider>(context, listen: false)
                    .lis(widget.index);
                Provider.of<DetailProvider>(context, listen: false)
                    .getpost(widget.list[widget.index].id);
              },
            );

            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 85,
                brightness: Brightness.dark,
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xFF131A20),
                title: Hero(
                  tag: 'rate',
                  child: Container(
                    height: 40,
                    color: Color(0xFF131A20),
                    child: CarouselSlider.builder(
                      itemCount: 3,
                      options: CarouselOptions(
                        height: 40,
                        viewportFraction: 0.34,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ),
                      itemBuilder: (context, index, index2) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              widget.currentRate[index].status == null
                                  ? Icon(Icons.arrow_forward,
                                      color: Colors.blueGrey[200])
                                  : widget.currentRate[index].status
                                      ? Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.arrow_downward,
                                          color: Colors.red,
                                        ),
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                  text: TextSpan(
                                      text:
                                          '${widget.currentRate[index].name} ',
                                      style:
                                          TextStyle(fontFamily: 'Greycliff')),
                                ),
                              ),
                              Flexible(
                                child: RichText(
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                  text: TextSpan(
                                      text: widget.currentRate[index].rate
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Greycliff')),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 45),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Hero(
                              tag: 'back',
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.arrow_back_rounded,
                                        size: 25, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 10),
                              child: Hero(
                                tag: 'logo',
                                child: Container(
                                  height: 45,
                                  width: 100,
                                  child: AspectRatio(
                                    aspectRatio: 4 / 2,
                                    child: Image.asset('assets/logo.png'),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        if (context.debugDoingBuild)
                          Row(
                            children: [
                              Consumer<DetailProvider>(
                                builder: (context, value, child) =>
                                    ValueListenableBuilder<Box<SavedPost>>(
                                  valueListenable:
                                      Hive.box<SavedPost>('posts').listenable(),
                                  builder:
                                      (context, Box<SavedPost> box, child) =>
                                          FocusedMenuHolder(
                                    animateMenuItems: true,
                                    openWithTap: true,
                                    onPressed: () {},
                                    menuItems: <FocusedMenuItem>[
                                      FocusedMenuItem(
                                        backgroundColor: Colors.amber,
                                        title: Text("Paylaş"),
                                        trailingIcon: Icon(Icons.share),
                                        onPressed: () {
                                          share(
                                            context,
                                            value.singleNews.data.link,
                                            value.singleNews.data.title,
                                          );
                                        },
                                      ),
                                      FocusedMenuItem(
                                          title: Text("Yazı boyutunu büyüt"),
                                          trailingIcon: Icon(Icons.add_circle),
                                          onPressed: () {
                                            return Provider.of<DetailProvider>(
                                                    context,
                                                    listen: false)
                                                .increasefontsize(2);
                                          }),
                                      FocusedMenuItem(
                                        title: Text("Yazı boyutunu küçült"),
                                        trailingIcon: Icon(Icons.remove_circle),
                                        onPressed: () {
                                          return Provider.of<DetailProvider>(
                                                  context,
                                                  listen: false)
                                              .decreasefontsize(2);
                                        },
                                      ),
                                      value.singleNews != null
                                          ? FocusedMenuItem(
                                              title: box.values.any((element) =>
                                                      element.id ==
                                                      value.singleNews.data.id)
                                                  ? Text("Kaydedildi")
                                                  : Text('Kaydet'),
                                              trailingIcon: box.values.any(
                                                      (element) =>
                                                          element.id ==
                                                          value.singleNews.data
                                                              .id)
                                                  ? Icon(Icons.bookmark)
                                                  : Icon(Icons.bookmark_border),
                                              onPressed: () {
                                                HiveController()
                                                    .savePost(value.singleNews);
                                              })
                                          : null,
                                    ],
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        child: SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Icon(
                                              Icons.more_horiz,
                                              color: Colors.white,
                                              size: 22,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Consumer<DetailProvider>(
                builder: (context, value, child) {
                  return NotificationListener<ScrollNotification>(
                    // ignore: missing_return
                    onNotification: (notification) {
                      if (notification.metrics.extentAfter < 500 &&
                          value.moree &&
                          widget.type != 'headline') {
                        Provider.of<DetailProvider>(context, listen: false)
                            .getmore();
                        list3 = list3.toList();
                        list3.addAll(value.addedNews);
                        list3 = list3.toList(growable: false);
                      }
                    },
                    child: TransformerPageView(
                      onPageChanged: (value1) {
                        Provider.of<DetailProvider>(context, listen: false)
                            .getpost(list3[value1].id);
                      },
                      controller: value.indxcntr,
                      itemCount: list3.length,
                      transformer: PageTransformerBuilder(
                        builder: (child, info) {
                          if (list3.isNotEmpty) {
                            return Stack(
                              fit: StackFit.loose,
                              children: [
                                Hero(
                                  tag: 'photos${info.index}',
                                  child: Container(
                                    height:
                                        widget.type == 'headline' ? 420 : 320,
                                    width: double.infinity,
                                    child: Material(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          parallax.ParallaxImage(
                                            key:
                                                PageStorageKey<int>(info.index),
                                            image: NetworkImage(
                                                list3[info.index].image.url),
                                            extent: 200,
                                          ),
                                          Positioned(
                                            top: 7,
                                            left: 7,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3)),
                                                  color: Colors.red),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                child: Text(
                                                  widget.type == 'headline'
                                                      ? ' '
                                                      : list3[info.index]
                                                                  .diffrence >
                                                              1
                                                          ? list3[info.index]
                                                                      .diffrence <
                                                                  1440
                                                              ? list3[info.index]
                                                                          .diffrence <
                                                                      60
                                                                  ? '${DateTime.now().difference(list3[info.index].dateTime).inMinutes.toString()} dakika önce'
                                                                  : '${DateTime.now().difference(list3[info.index].dateTime).inHours.toString()} saat önce'
                                                              : '${DateTime.now().difference(list3[info.index].dateTime).inDays.toString()} gün önce'
                                                          : 'Şimdi',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    SizedBox(
                                      height: 270,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                      ),
                                      width: double.infinity,
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(),
                                        color: Colors.grey[50],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0),
                                                      child: ParallaxContainer(
                                                        child: Text(
                                                          widget.type ==
                                                                  'headline'
                                                              ? value
                                                                  .newsHead[info
                                                                      .index]
                                                                  .title
                                                              : list3[info
                                                                      .index]
                                                                  .title,
                                                          style: TextStyle(
                                                              fontSize: 20.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                        position: info.position,
                                                        translationFactor:
                                                            200.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            value.singleNews != null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Güncellendi: ',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black54),
                                                          ),
                                                          Text(
                                                              value
                                                                  .singleNews
                                                                  .data
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
                                                  )
                                                : SizedBox(
                                                    height: 0,
                                                    width: 0,
                                                  ),
                                            ParallaxContainer(
                                              position: info.position,
                                              translationFactor: 100,
                                              child: Container(
                                                color: Colors.grey[50],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    widget.type == 'headline'
                                                        ? value
                                                            .newsHead[
                                                                info.index]
                                                            .summary
                                                        : list3[info.index]
                                                            .summary,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Consumer<DetailProvider>(builder:
                                                (context, value, child) {
                                              if (value.singleNews != null) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[50]),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Html(
                                                            data: value
                                                                .singleNews
                                                                .data
                                                                .contentHtml,
                                                            style: {
                                                              'body': Style(
                                                                  fontSize:
                                                                      FontSize(value
                                                                          .contentfontsize))
                                                            },
                                                            shrinkWrap: true,
                                                          ),
                                                        ],
                                                      )),
                                                );
                                              } else {
                                                return SizedBox(
                                                    width: double.infinity,
                                                    height: 10,
                                                    child:
                                                        LinearProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Colors.red),
                                                      backgroundColor:
                                                          Colors.white,
                                                    ));
                                              }
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
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
  }

  @override
  bool get wantKeepAlive => true;
}
