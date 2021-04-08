import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../Models/post_item.dart' as Post;
import '../Models/savedPost.dart';
import '../Service/dunya_api.dart';
import '../Service/localdatabase.dart';
import '../Service/utils.dart';

class NotificationNews extends StatefulWidget {
  final String id;

  const NotificationNews({Key key, this.id}) : super(key: key);
  @override
  _NotificationNewsState createState() => _NotificationNewsState();
}

class _NotificationNewsState extends State<NotificationNews> {
  double fontsize = 17;
  String link;
  String title;
  String id;
  Post.Post post;
  changefontsize(index, bool incr) {
    setState(() {
      if (incr) {
        fontsize = fontsize + index;
      } else {
        fontsize = fontsize - index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Color(0xFF131A20),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: PreferredSize(
          preferredSize: Size(double.infinity, 45),
          child: GestureDetector(
            onPanUpdate: (pan) {
              if (pan.delta.dy > 0) {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 25,
                        width: 25,
                        child: Hero(
                          tag: 'dot',
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
                        padding: const EdgeInsets.only(bottom: 4, left: 10),
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
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Row(
                    children: [
                      Material(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: ValueListenableBuilder<Box<SavedPost>>(
                            valueListenable:
                                Hive.box<SavedPost>('posts').listenable(),
                            builder: (context, Box<SavedPost> box, child) =>
                                FocusedMenuHolder(
                              animateMenuItems: true,
                              openWithTap: true,
                              onPressed: () {},
                              menuItems: <FocusedMenuItem>[
                                // Add Each FocusedMenuItem  for Menu Options
                                FocusedMenuItem(
                                  backgroundColor: Colors.amber,
                                  title: Text("Paylaş"),
                                  trailingIcon: Icon(Icons.share),
                                  onPressed: () {
                                    share(
                                      context,
                                      link,
                                      title,
                                    );
                                  },
                                ),
                                FocusedMenuItem(
                                    title: Text("Yazı boyutunu büyüt"),
                                    trailingIcon: Icon(Icons.add_circle),
                                    onPressed: () {
                                      return changefontsize(2, true);
                                    }),
                                FocusedMenuItem(
                                  title: Text("Yazı boyutunu küçült"),
                                  trailingIcon: Icon(Icons.remove_circle),
                                  onPressed: () {
                                    return changefontsize(2, false);
                                  },
                                ),
                                id != null
                                    ? FocusedMenuItem(
                                        title: box.values.any(
                                                (element) => element.id == id)
                                            ? Text("Kaydedildi")
                                            : Text('Kaydet'),
                                        trailingIcon: box.values.any(
                                                (element) => element.id == id)
                                            ? Icon(Icons.bookmark)
                                            : Icon(Icons.bookmark_border),
                                        onPressed: () {
                                          //kaydet fonksuyonu
                                          HiveController().savePost(post);
                                        })
                                    : null,
                              ],
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: Hero(
                                    tag: 'fav',
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
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder<Post.Post>(
              future: DunyaApiManager().getPost(widget.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  link = snapshot.data.data.link;
                  title = snapshot.data.data.title;
                  id = snapshot.data.data.id;
                  post = snapshot.data;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(snapshot.data.data.image.url),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.data.title,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.red),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Güncellendi: ${snapshot.data.data.updatedAt}',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data.data.summary,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                        Html(
                          shrinkWrap: true,
                          data: snapshot.data.data.contentHtml,
                          style: {'body': Style(fontSize: FontSize(fontsize))},
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
