import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:dunyahaber/Providers/FinansProviders/BitsStatDetailProvider.dart';
import 'package:dunyahaber/Providers/FinansProviders/BitsStatProvider.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:provider/provider.dart';

class EnCokIslemGorenler extends StatefulWidget {
  @override
  _EnCokIslemGorenlerState createState() => _EnCokIslemGorenlerState();
}

class _EnCokIslemGorenlerState extends State<EnCokIslemGorenler>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BitsStatsProvider>(context, listen: false).getBitsStats();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Consumer<BitsStatsProvider>(
        builder: (context, bist, child) => ListView.builder(
          itemCount: bist.bitsStats.length,
          itemBuilder: (context, index) {
            return OpenContainer(
              transitionType: ContainerTransitionType.fade,
              transitionDuration: Duration(seconds: 1),
              closedShape: RoundedRectangleBorder(),
              closedColor: Colors.blueGrey[50],
              closedBuilder: (context, action) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            bist.bitsStats[index].name,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                DateTime.now()
                                            .difference(
                                                bist.bitsStats[index].updatedAt)
                                            .inMinutes >
                                        1
                                    ? DateTime.now()
                                                .difference(bist
                                                    .bitsStats[index].updatedAt)
                                                .inMinutes <
                                            1440
                                        ? DateTime.now()
                                                    .difference(bist
                                                        .bitsStats[index]
                                                        .updatedAt)
                                                    .inMinutes <
                                                60
                                            ? '${DateTime.now().difference(bist.bitsStats[index].updatedAt).inMinutes.toString()} dakika önce'
                                            : '${DateTime.now().difference(bist.bitsStats[index].updatedAt).inHours.toString()} saat önce'
                                        : '${DateTime.now().difference(bist.bitsStats[index].updatedAt).inDays.toString()} gün önce'
                                    : 'Şimdi',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                color:
                                    bist.bitsStats[index].dailyChange.isNegative
                                        ? Colors.red[50]
                                        : Colors.green[50],
                                child: InkWell(
                                  child: Icon(Icons.arrow_right),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              openBuilder: (context, action) {
                return SafeArea(
                  top: false,
                  child: ChangeNotifierProvider(
                    create: (context) => BitsStatDetailProvider(),
                    builder: (context, child) {
                      return Scaffold(
                        appBar: AppBar(
                          iconTheme: IconThemeData(color: Colors.white),
                          brightness: Brightness.dark,
                          backgroundColor: Color(0xFF131A20),
                          centerTitle: false,
                          titleSpacing: 0,
                          title: Container(
                            //color: Colors.blueAccent[100],
                            child: Text(bist.bitsStats[index].name,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Greycliff',
                                    color: Colors.white)),
                          ),
                        ),
                        body: SingleChildScrollView(
                          child: Column(
                            children: [
                              Card(
                                child: Selector<BitsStatDetailProvider, bool>(
                                  selector: (context, bits) => bits.finansqraf,
                                  builder: (context, value2, child) =>
                                      Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Foreks Qrafigi',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                    visible: value2,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Provider.of<BitsStatDetailProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .changeqraftype();
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .yearlyChangePercentage
                                                                      .isNegative
                                                                  ? Colors
                                                                      .red[50]
                                                                  : Colors
                                                                      .blueGrey[50],
                                                            ),
                                                            child: Selector<
                                                                BitsStatDetailProvider,
                                                                bool>(
                                                              selector: (context,
                                                                      bits) =>
                                                                  bits.isLine,
                                                              builder: (context,
                                                                      value,
                                                                      child) =>
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  value2
                                                                      ? 'CandlStick qrafik'
                                                                      : 'Line qrafik',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: value2
                                                        ? Icon(Icons
                                                            .arrow_drop_down)
                                                        : Icon(
                                                            Icons.arrow_right),
                                                    onPressed: () {
                                                      Provider.of<BitsStatDetailProvider>(
                                                              context,
                                                              listen: false)
                                                          .changefinansqraf();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: value2,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: SizedBox(
                                                  height: 200,
                                                  width: double.infinity,
                                                  child: FutureBuilder<
                                                      List<KLineEntity>>(
                                                    future: Provider.of<
                                                                BitsStatDetailProvider>(
                                                            context,
                                                            listen: false)
                                                        .getData(
                                                            bist
                                                                .bitsStats[
                                                                    index]
                                                                .foreksCode,
                                                            'daily'),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Consumer<
                                                                BitsStatDetailProvider>(
                                                            builder: (context,
                                                                value2, child) {
                                                          if (value2
                                                              .dat.isNotEmpty) {
                                                            return ClipRRect(
                                                              child:
                                                                  KChartWidget(
                                                                value2.dat,
                                                                volHidden: true,
                                                                maDayList: [
                                                                  5,
                                                                  10,
                                                                  20
                                                                ],
                                                                isLine: value2
                                                                    .isLine,
                                                                mainState:
                                                                    MainState
                                                                        .MA,
                                                                secondaryState:
                                                                    SecondaryState
                                                                        .NONE,
                                                                fixedLength: 2,
                                                                timeFormat:
                                                                    TimeFormat
                                                                        .YEAR_MONTH_DAY,
                                                                isChinese:
                                                                    false,
                                                                bgColor: [
                                                                  Color(
                                                                      0xFF121128),
                                                                  Color(
                                                                      0xFF121128),
                                                                  Color(
                                                                      0xFF121128)
                                                                ],
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child: SizedBox(
                                                                height: 200,
                                                                width: double
                                                                    .infinity,
                                                                child: Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      child:
                                                                          KChartWidget(
                                                                        null,
                                                                        volHidden:
                                                                            true,
                                                                        maDayList: [
                                                                          5,
                                                                          10,
                                                                          20
                                                                        ],
                                                                        isLine:
                                                                            true,
                                                                        mainState:
                                                                            MainState.MA,
                                                                        secondaryState:
                                                                            SecondaryState.NONE,
                                                                        fixedLength:
                                                                            2,
                                                                        timeFormat:
                                                                            TimeFormat.YEAR_MONTH_DAY,
                                                                        isChinese:
                                                                            false,
                                                                        bgColor: [
                                                                          Color(
                                                                              0xFF121128),
                                                                          Color(
                                                                              0xFF121128),
                                                                          Color(
                                                                              0xFF121128)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          Container(
                                                                            //alignment: Alignment.center,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.blueGrey[100], borderRadius: BorderRadius.circular(5)),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                'Yükleniyor...',
                                                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        });
                                                      } else {
                                                        return Center(
                                                          child: SizedBox(
                                                            height: 200,
                                                            width:
                                                                double.infinity,
                                                            child: Stack(
                                                              children: [
                                                                ClipRRect(
                                                                  child:
                                                                      KChartWidget(
                                                                    null,
                                                                    volHidden:
                                                                        true,
                                                                    maDayList: [
                                                                      5,
                                                                      10,
                                                                      20
                                                                    ],
                                                                    isLine:
                                                                        true,
                                                                    mainState:
                                                                        MainState
                                                                            .MA,
                                                                    secondaryState:
                                                                        SecondaryState
                                                                            .NONE,
                                                                    fixedLength:
                                                                        2,
                                                                    timeFormat:
                                                                        TimeFormat
                                                                            .YEAR_MONTH_DAY,
                                                                    isChinese:
                                                                        false,
                                                                    bgColor: [
                                                                      Color(
                                                                          0xFF121128),
                                                                      Color(
                                                                          0xFF121128),
                                                                      Color(
                                                                          0xFF121128)
                                                                    ],
                                                                  ),
                                                                ),
                                                                Center(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        //alignment: Alignment.center,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.blueGrey[100],
                                                                            borderRadius: BorderRadius.circular(5)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Text(
                                                                            'Yükleniyor...',
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
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
                                              Selector<BitsStatDetailProvider,
                                                  int>(
                                                selector: (_, bist) =>
                                                    bist.selectedtimeinterval,
                                                builder: (context, selectedtime,
                                                        child) =>
                                                    Container(
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (selectedtime !=
                                                                    1) {
                                                                  Provider.of<BitsStatDetailProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changedata(
                                                                          bist.bitsStats[index]
                                                                              .foreksCode,
                                                                          'daily',
                                                                          1);
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: selectedtime ==
                                                                            1
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .grey[50]),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    'Günlük',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: selectedtime ==
                                                                                1
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (selectedtime !=
                                                                    2) {
                                                                  Provider.of<BitsStatDetailProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changedata(
                                                                          bist.bitsStats[index]
                                                                              .foreksCode,
                                                                          'weekly',
                                                                          2);
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: selectedtime == 2
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey[50],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    'Haftalık',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: selectedtime ==
                                                                                2
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (selectedtime !=
                                                                    3) {
                                                                  Provider.of<BitsStatDetailProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changedata(
                                                                          bist.bitsStats[index]
                                                                              .foreksCode,
                                                                          'monthly',
                                                                          3);
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: selectedtime == 3
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey[50],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    'Aylık',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: selectedtime ==
                                                                                3
                                                                            ? Colors.white
                                                                            : Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () {
                                                                if (selectedtime !=
                                                                    4) {
                                                                  Provider.of<BitsStatDetailProvider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .changedata(
                                                                          bist.bitsStats[index]
                                                                              .foreksCode,
                                                                          'yearly',
                                                                          4);
                                                                }
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: selectedtime == 4
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey[50],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8,
                                                                      horizontal:
                                                                          10),
                                                                  child: Text(
                                                                    'Yıllık',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: selectedtime ==
                                                                                4
                                                                            ? Colors.white
                                                                            : Colors.black),
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Ask',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        bist.bitsStats[index].ask.toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index].ask
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Bid',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        bist.bitsStats[index].bid.toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index].bid
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Capital',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        bist.bitsStats[index].capital
                                            .toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index].capital
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Net Capital',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        bist.bitsStats[index].netCapital
                                            .toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index]
                                                    .netCapital.isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Net Profit',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        bist.bitsStats[index].netProfit
                                            .toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index]
                                                    .netProfit.isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Net Profit',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400)),
                                      Text(
                                        bist.bitsStats[index].netProfit
                                            .toString(),
                                        style: TextStyle(
                                            color: bist.bitsStats[index]
                                                    .netProfit.isNegative
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0,
                                child: Consumer<BitsStatDetailProvider>(
                                  builder: (context, value2, child) =>
                                      Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Günlük İstatistikler',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: bist
                                                                  .bitsStats[
                                                                      index]
                                                                  .dailyChangePercentage
                                                                  .isNegative
                                                              ? Colors.red
                                                              : Colors.green),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${bist.bitsStats[index].dailyChangePercentage.toString()}%',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    onPressed: () {
                                                      Provider.of<BitsStatDetailProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeSize();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: value2.size,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Gunluk Miktar',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .dailyAmount
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .dailyAmount
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Gunluk Hacim',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .dailyVolume
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .dailyVolume
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Gunluk Degisim',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .dailyChange
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .dailyChange
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Gunluk En Yuksek',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .dailyHighest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .dailyHighest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Gunluk En Dusuk',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .dailyLowest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .dailyLowest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
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
                              Card(
                                elevation: 0,
                                child: Consumer<BitsStatDetailProvider>(
                                  builder: (context, value2, child) =>
                                      Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Haftalik İstatistikler',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: bist
                                                                  .bitsStats[
                                                                      index]
                                                                  .weeklyChangePercentage
                                                                  .isNegative
                                                              ? Colors.red
                                                              : Colors.green),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${bist.bitsStats[index].weeklyChangePercentage.toString()}%',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    onPressed: () {
                                                      Provider.of<BitsStatDetailProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeweekly();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: value2.weekly,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Card(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Haftalik Degisim',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .weeklyChange
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .weeklyChange
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Haftalik En Yuksek',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .weeklyHighest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .weeklyHighest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Haftalik En Dusuk',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .weeklyLowest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .weeklyLowest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
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
                              Card(
                                elevation: 0,
                                child: Consumer<BitsStatDetailProvider>(
                                  builder: (context, value2, child) =>
                                      Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Aylik İstatistikler',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: bist
                                                                  .bitsStats[
                                                                      index]
                                                                  .monthlyChangePercentage
                                                                  .isNegative
                                                              ? Colors.red
                                                              : Colors.green),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${bist.bitsStats[index].monthlyChangePercentage.toString()}%',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    onPressed: () {
                                                      Provider.of<BitsStatDetailProvider>(
                                                              context,
                                                              listen: false)
                                                          .changemonthly();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: value2.monthly,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Aylik Degisim',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .monthlyChange
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .monthlyChange
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Aylik En Yuksek',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .monthlyHighest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .monthlyHighest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Aylik En Dusuk',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .monthlyLowest
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .monthlyLowest
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
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
                              Card(
                                elevation: 0,
                                child: Consumer<BitsStatDetailProvider>(
                                  builder: (context, value2, child) =>
                                      Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 0, 8, 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Yillik İstatistikler',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: bist
                                                                  .bitsStats[
                                                                      index]
                                                                  .yearlyChangePercentage
                                                                  .isNegative
                                                              ? Colors.red
                                                              : Colors.green),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          '${bist.bitsStats[index].yearlyChangePercentage.toString()}%',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    onPressed: () {
                                                      Provider.of<BitsStatDetailProvider>(
                                                              context,
                                                              listen: false)
                                                          .changeyearly();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: value2.yearly,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Card(
                                                  elevation: 0,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Yillik Degisim',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          bist.bitsStats[index]
                                                              .yearlyChange
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: bist
                                                                      .bitsStats[
                                                                          index]
                                                                      .yearlyChange
                                                                      .isNegative
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
