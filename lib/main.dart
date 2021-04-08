import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dunyahaber/Providers/FinanceProvider.dart';
import 'package:dunyahaber/Providers/HomeProvider.dart';
import 'package:dunyahaber/Providers/MainProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Models/savedPost.dart';
import 'Providers/AllNewsProvider.dart';
import 'Providers/EducationProvider.dart';
import 'Providers/EkonomiProvider.dart';
import 'Providers/EmercekProvider.dart';
import 'Providers/GundemProvider.dart';
import 'Providers/HeadLineProvider.dart';
import 'Providers/IGAnewsProvider.dart';
import 'Providers/KulturSanatProvider.dart';
import 'Providers/OzelDosyalarProvider.dart';
import 'Providers/PiyasalarProvider.dart';
import 'Providers/PublisherProvider.dart';
import 'Providers/RamazanProvider.dart';
import 'Providers/SaglikProvider.dart';
import 'Providers/SehirlerProvider.dart';
import 'Providers/SirktetHaberleriProvider.dart';
import 'Providers/SportProvider.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'Providers/YasamProvider.dart';
import 'Screens/EDunya.dart';
import 'Screens/EMercek.dart';
import 'Screens/Education.dart';
import 'Screens/Ekonomi.dart';
import 'Screens/Finans/Finance.dart';
import 'Screens/Home2.dart';
import 'Screens/IGAnews.dart';
import 'Screens/Kobiden.dart';
import 'Screens/KulturSanat.dart';
import 'Screens/OzelDosyalar.dart';
import 'Screens/Publisher.dart';
import 'Screens/Ramazan.dart';
import 'Screens/Saglik.dart';
import 'Screens/SavedNews.dart';
import 'Screens/Sehirler.dart';
import 'Screens/SirketHaberleri.dart';
import 'Screens/Sport.dart';
import 'Screens/Yasam.dart';
import 'Screens/loginpage.dart';
import 'Models/current_rate.dart';
import 'Service/localdatabase.dart';
import 'Service/strings.dart';
import 'Service/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //initMessages();
  String token =await FirebaseMessaging.instance.getToken();
 print(token);
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(SavedPostAdapter());
  await Hive.openBox<SavedPost>('posts');
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

void initMessages() {
  FirebaseMessaging.instance.requestPermission(
      announcement: true, criticalAlert: true, provisional: true);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF131A20),
        statusBarColor: Color(0xFF131A20),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Greycliff',
      ),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<EkonomiProvider>(
            create: (context) => EkonomiProvider(),
          ),
          ChangeNotifierProvider<EmercekProvider>(
            create: (context) => EmercekProvider(),
          ),
          ChangeNotifierProvider<SehirlerProvider>(
            create: (context) => SehirlerProvider(),
          ),
          ChangeNotifierProvider<SirketProvider>(
            create: (context) => SirketProvider(),
          ),
          ChangeNotifierProvider<OzelProvider>(
            create: (context) => OzelProvider(),
          ),
          ChangeNotifierProvider<RamazanProvider>(
            create: (context) => RamazanProvider(),
          ),
          ChangeNotifierProvider<KulturSanatProvider>(
            create: (context) => KulturSanatProvider(),
          ),
          ChangeNotifierProvider<SaglikProvider>(
            create: (context) => SaglikProvider(),
          ),
          ChangeNotifierProvider<YasamProvider>(
            create: (context) => YasamProvider(),
          ),
          ChangeNotifierProvider<IGAnewsProvider>(
            create: (context) => IGAnewsProvider(),
          ),
          ChangeNotifierProvider<PiyasalarProvider>(
            create: (context) => PiyasalarProvider(),
          ),
          ChangeNotifierProvider<AllNewsProvider>(
            create: (context) => AllNewsProvider(),
          ),
          ChangeNotifierProvider<HeadLineProvider>(
            create: (context) => HeadLineProvider(),
          ),
          ChangeNotifierProvider<GundemProvider>(
            create: (context) => GundemProvider(),
          ),
          ChangeNotifierProvider<PublisherProvider>(
            create: (context) => PublisherProvider(),
          ),
          ChangeNotifierProvider<EducationProvider>(
            create: (context) => EducationProvider(),
          ),
          ChangeNotifierProvider<FinanceProvider>(
            create: (context) => FinanceProvider(),
          ),
          ChangeNotifierProvider<SportProvider>(
            create: (context) => SportProvider(),
          ),
          ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider(),
          ),
          ChangeNotifierProvider<MainProvider>(
            create: (context) => MainProvider(),
          )
        ],
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    Provider.of<MainProvider>(context, listen: false).checklogin();
    super.initState();
  }

  final List<Widget> screens = [
    Finance(),
    Publisher(),
    Home2(),
    Sport(),
    Education(),
    EDunya(),
    EMercek(),
    SirketHaberleri(),
    Kobiden(),
    Ramazan(),
    Ekonomi(),
    Yasam(),
    Saglik(),
    KulturSanat(),
    Sehirler(),
    IGAnews(),
    OzelDosyalar(),
    SavedNews()
  ];

  Widget innerDrawerLeft() {
    return Selector<MainProvider, bool>(
      selector: (context, main) => main.loggedin,
      builder: (context, loggedin, child) {
        Map<dynamic, dynamic> data =
            Provider.of<MainProvider>(context, listen: false).data ??
                Provider.of<MainProvider>(context, listen: false).test;
        //print(loggedin);
        return Container(
          height: 200,
          width: 200,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 25, right: 70, top: 30),
                      child: Container(
                        height: 45,
                        width: 150,
                        child: AspectRatio(
                            aspectRatio: 4 / 2,
                            child: Image.asset('assets/logomoon.png')),
                      ),
                    ),
                    Visibility(
                      visible: loggedin,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: "Hoşgeldin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Greycliff',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: data['name'],
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Greycliff',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(2);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Anasayfa",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Greycliff')),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Image.asset('assets/Line.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(5);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "E-Dünya",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.only(left: 15),
                                child: Image.asset('assets/Line.png')),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(6);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "E-Mercek",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Image.asset('assets/Line.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(1);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Yazarlar",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Image.asset('assets/Line.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(7);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Şirket Haberleri",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Image.asset('assets/Line.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(8);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Kobiden",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15),
                              child: Image.asset('assets/Line.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, top: 20),
                              child: Container(
                                color: Colors.transparent,
                                height: 30,
                                width: 200,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(0);
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .globalKey
                                          .currentState
                                          .close();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Finans",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Greycliff'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: loggedin,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(9);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Ramazan",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(10);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Ekonomi",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(11);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Yaşam",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(12);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Sağlık",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(13);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Kültür-Sanat",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(14);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Şehirler",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(15);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "İGA Haberleri",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Image.asset('assets/Line.png'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 20, top: 20),
                                    child: Container(
                                      color: Colors.transparent,
                                      height: 30,
                                      width: 200,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .bottomnavigate(16);
                                            Provider.of<MainProvider>(context,
                                                    listen: false)
                                                .globalKey
                                                .currentState
                                                .close();
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              text: "Özel Dosyalar",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Greycliff'),
                                            ),
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
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 15),
                      child: Visibility(
                        visible: true,
                        child: GestureDetector(
                          onTap: () {
                            loggedin
                                ? Provider.of<MainProvider>(context,
                                        listen: false)
                                    .logout()
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context11) =>
                                          LoginPage(context1: context),
                                    ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: loggedin
                                  ? RichText(
                                      text: TextSpan(
                                          text: "Çıkış Yap",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)))
                                  : RichText(
                                      text: TextSpan(
                                          text: 'Giriş Yap',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              try {
                                bool yes = await canLaunch(Strings.link);
                                if (yes) {
                                  launch(Strings.twitter, forceWebView: true);
                                }
                              } catch (e) {
                                //print(e);
                              }
                            },
                            child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Image.asset('assets/twitter.png')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () async {
                                try {
                                  bool yes = await canLaunch(Strings.link);
                                  if (yes) {
                                    launch(Strings.linkedin,
                                        forceWebView: true);
                                  }
                                } catch (e) {
                                  //print(e);
                                }
                              },
                              child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset('assets/linkedin.png')),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              try {
                                bool yes = await canLaunch(Strings.link);
                                if (yes) {
                                  launch(Strings.youtube, forceWebView: true);
                                }
                              } catch (e) {
                                //print(e);
                              }
                            },
                            child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Image.asset('assets/youtube.png')),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: () async {
                                try {
                                  bool yes = await canLaunch(Strings.link);
                                  if (yes) {
                                    launch(Strings.instagram,
                                        forceWebView: true);
                                  }
                                } catch (e) {
                                  //print(e);
                                }
                              },
                              child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset('assets/instagram.png')),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              try {
                                bool yes = await canLaunch(Strings.link);
                                if (yes) {
                                  launch(Strings.facebook, forceWebView: true);
                                }
                              } catch (e) {
                                //print(e);
                              }
                            },
                            child: SizedBox(
                                height: 35,
                                width: 35,
                                child: Image.asset('assets/facebook.png')),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget mainScaffold(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF131A20),
      body: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFF131A20),
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            brightness: Brightness.dark,
            toolbarHeight: 40,
            backgroundColor: Color(0xFF131A20),
            //titleSpacing: 0,
            elevation: 0,
            title: Center(
              child: Container(
                color: Color(0xFF131A20),
                child: StreamBuilder<List<CurrentRate>>(
                  stream: Provider.of<MainProvider>(context, listen: false)
                      .getCurrentRate(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Hero(
                        tag: 'rate',
                                              child: Container(
                          height: 40,
                          color: Color(0xFF131A20),
                          child: CarouselSlider.builder(
                            itemCount: snapshot.data.length,
                            options: CarouselOptions(
                              height: 40,
                              // aspectRatio: 16 / 9,
                              viewportFraction: 0.34,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            itemBuilder: (context, index, index2) {
                              return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: [
                                      snapshot.data[index].status == null
                                          ? Icon(Icons.arrow_forward,
                                              color: Colors.blueGrey[200])
                                          : snapshot.data[index].status
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
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          text: TextSpan(
                                            text: '${snapshot.data[index].name} ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Greycliff'),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: RichText(
                                          maxLines: 1,
                                          overflow: TextOverflow.visible,
                                          text: TextSpan(
                                            text: snapshot.data[index].rate
                                                .toStringAsFixed(2),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Greycliff'),
                                          ),
                                          /* style:  TextStyle(
                                       color: Colors.white, fontFamily: 'GreycliffCF'),*/
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            },
                          ),
                        ),
                      );
                    } else {
                      return LinearProgressIndicator(
                        minHeight: 1,
                        valueColor: AlwaysStoppedAnimation(Colors.red.shade400),
                      );
                    }
                  },
                ),
              ),
            ),
            /*bottom: PreferredSize(
              child: 
              preferredSize: Size(double.infinity, 60),
            ),*/
          ),
          resizeToAvoidBottomInset: false,
          //resizeToAvoidBottomPadding: false,
          drawerScrimColor: Colors.transparent,
          body: Container(
            color: Color(0xFF131A20),
            child: Selector<MainProvider, int>(
              selector: (context, main) => main.page,
              builder: (context, page, child) => Container(
                  color: Color(0xFF131A20),
                  child: IndexedStack(index: page, children: screens)),
            ),
          ),
          extendBody: true,
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: Container(
              width: size.width,
              color: Colors.transparent,
              height: 60,
              child: Stack(
                clipBehavior: Clip.antiAlias,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: DunyaBottomStyle(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFFE02020),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 3, bottom: 3),
                        child: SizedBox(
                          height: 42,
                          width: 42,
                          child: Image.asset("assets/Bitmap.png"),
                        ),
                      ),
                      elevation: 0.1,
                      onPressed: () {
                        Provider.of<MainProvider>(context, listen: false)
                            .bottomnavigate(2);
                      },
                    ),
                  ),
                  Selector<MainProvider, int>(
                    selector: (context, main) => main.page,
                    builder: (context, page, child) => Container(
                      width: size.width,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Opacity(
                                opacity: page == 0 ? 1 : 0.5,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  highlightColor: Colors.grey[50],
                                  hoverColor: Colors.white,
                                  autofocus: false,
                                  onPressed: () {
                                    Provider.of<MainProvider>(context,
                                            listen: false)
                                        .bottomnavigate(0);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                            'assets/refund.png',
                                          ),
                                        ),
                                        SizedBox(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              "Finans",
                                              style: TextStyle(fontSize: 13),
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
                          Flexible(
                            child: Opacity(
                              opacity: page == 1 ? 1 : 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: SizedBox(
                                  height: 80,
                                  width: 90,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    highlightColor: Colors.grey[50],
                                    hoverColor: Colors.white,
                                    autofocus: false,
                                    onPressed: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(1);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      height: 50,
                                      width: 60,
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              'assets/pen.png',
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              "Yazarlar",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.15,
                          ),
                          Flexible(
                            child: Opacity(
                              opacity: page == 3 ? 1 : 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    highlightColor: Colors.grey[50],
                                    hoverColor: Colors.white,
                                    autofocus: false,
                                    onPressed: () {
                                      Provider.of<MainProvider>(context,
                                              listen: false)
                                          .bottomnavigate(3);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: Column(
                                        // Replace with a Row for horizontal icon + text
                                        children: <Widget>[
                                          SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Image.asset(
                                              'assets/football.png',
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Text(
                                              "Spor",
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Opacity(
                              opacity: page == 4 ? 1 : 0.5,
                              child: SizedBox(
                                height: 80,
                                width: 80,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  highlightColor: Colors.grey[50],
                                  hoverColor: Colors.white,
                                  autofocus: false,
                                  onPressed: () {
                                    Provider.of<MainProvider>(context,
                                            listen: false)
                                        .bottomnavigate(4);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    height: 50,
                                    width: 50,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: Image.asset(
                                            'assets/graduation.png',
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text(
                                            "Eğitim",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131A20),
      body: Selector<MainProvider, GlobalKey<InnerDrawerState>>(
        selector: (context, main) => main.globalKey,
        builder: (context, globalKey, child) {
          return InnerDrawer(
            colorTransitionScaffold: Colors.white.withOpacity(0.2),
            rightAnimationType: InnerDrawerAnimation.static,
            swipe: false,
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            borderRadius: 20,
            offset: IDOffset.horizontal(0.4),
            scale: IDOffset.horizontal(0.9),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 5),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: -40,
                offset: Offset.fromDirection(3, 60),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: -70,
                offset: Offset.fromDirection(3, 110),
              ),
            ],
            onTapClose: true,
            leftChild: SafeArea(child: innerDrawerLeft()),
            key: globalKey,
            scaffold: mainScaffold(context),
          );
        },
      ),
    );
  }
}

class DunyaBottomStyle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(
      size.width * 0.34,
      0,
    );
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.42, 25);
    path.quadraticBezierTo(size.width * 0.45, 48, size.width * 0.50, 48);
    path.quadraticBezierTo(size.width * 0.55, 48, size.width * 0.58, 25);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    canvas.drawShadow(path, Colors.black, 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
