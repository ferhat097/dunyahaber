import 'package:dunyahaber/Models/Hisseler.dart';
import 'package:dunyahaber/Models/snapshots.dart';
import 'package:dunyahaber/Providers/FinansProviders/DovizProvider.dart';
import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:provider/provider.dart';
import 'package:smart_select/smart_select.dart';

class Doviz extends StatefulWidget {
  @override
  _DovizState createState() => _DovizState();
}

class _DovizState extends State<Doviz> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DovizProvider>(context, listen: false)
          .getData('daily', 'USD/TRL');
      Provider.of<DovizProvider>(context, listen: false).getcodeinfo('USD/TRL');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Consumer<DovizProvider>(
                builder: (context, value, child) => SmartSelect<Hisse>.single(
                  placeholder: 'Hisse Secin',
                  modalTitle: 'Hisse Ara',
                  modalFilter: true,
                  choiceStyle: S2ChoiceStyle(color: Colors.black),
                  modalStyle: S2ModalStyle(
                      backgroundColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAlias),
                  choiceHeaderStyle:
                      S2ChoiceHeaderStyle(backgroundColor: Colors.grey[400]),
                  modalFilterHint: 'ara',
                  //groupEnabled: true,
                  choiceType: S2ChoiceType.radios,
                  choiceLayout: S2ChoiceLayout.list,
                  title: 'Dövizler',
                  //choiceGrouped: true,
                  modalType: S2ModalType.bottomSheet,
                  value: value.selectedhisse,
                  choiceItems: value.hisseler.map((e) {
                    return S2Choice(value: e, title: e.name, group: e.exchange);
                  }).toList(),
                  onChange: (state) => {
                    Provider.of<DovizProvider>(context, listen: false)
                        .changeVal(state.value),
                    Provider.of<DovizProvider>(context, listen: false)
                        .getData('daily', state.value.symbol),
                    Provider.of<DovizProvider>(context, listen: false)
                        .getcodeinfo(state.value.code),
                    Provider.of<DovizProvider>(context, listen: false)
                        .changeCurrentSelectedTime(1)
                  },
                ),
              ),
            ),
            Consumer<DovizProvider>(
              builder: (context, value, child) {
                if (value.snapshots != null) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.white),
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value.snapshots.data.items.scad.first.name ?? '-',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value.snapshots.data.items.scad.first.time ?? '-',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            Stack(
              children: [
                SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: Consumer<DovizProvider>(
                    builder: (context, data, child) {
                      if (data.dat.isNotEmpty && data.dat.isNotEmpty != null) {
                        return Selector<DovizProvider, dynamic>(
                          selector: (context, finance) => finance.isLine,
                          builder: (context, isLine, child) => ClipRRect(
                            child: KChartWidget(
                              data.dat,
                              volHidden: true,
                              maDayList: [5, 10, 20],
                              isLine: isLine,
                              mainState: MainState.MA,
                              secondaryState: SecondaryState.NONE,
                              fixedLength: 2,
                              timeFormat: TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                              isChinese: false,
                              bgColor: [
                                Color(0xFF121128),
                                Color(0xFF121128),
                                Color(0xFF121128)
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            SizedBox(
                              height: 240,
                              width: double.infinity,
                              child: ClipRRect(
                                child: KChartWidget(
                                  null,
                                  volHidden: true,
                                  maDayList: [5, 10, 20],
                                  isLine: true,
                                  mainState: MainState.NONE,
                                  secondaryState: SecondaryState.NONE,
                                  fixedLength: 2,
                                  timeFormat:
                                      TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                                  isChinese: false,
                                  bgColor: [
                                    Color(0xFF121128),
                                    Color(0xFF121128),
                                    Color(0xFF121128)
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                //alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey[100],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Yükleniyor...',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Selector<DovizProvider, bool>(
                    selector: (_, borsa) => borsa.isLine,
                    builder: (context, value, child) => Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeChartType();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.blueGrey[100],
                              ),
                              child: Icon(
                                value
                                    ? Icons.equalizer
                                    : Icons.insights_rounded,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                String symbol = Provider.of<DovizProvider>(
                                        context,
                                        listen: false)
                                    .selectedhisse
                                    .symbol;
                                Provider.of<DovizProvider>(context,
                                        listen: false)
                                    .getData('daily', symbol ?? "USD/TRL");
                                Provider.of<DovizProvider>(context,
                                        listen: false)
                                    .changeCurrentSelectedTime(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blueGrey[100],
                                ),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  size: 30,
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
            Consumer<DovizProvider>(
              builder: (context, value, child) => Container(
                decoration: BoxDecoration(color: Colors.white),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    //  mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 1
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 1 ? true : false,
                          //padding: EdgeInsets.all(5),
                          label: Text('Günlük',
                          style: TextStyle(
                              color: value.currentselectedtime == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 1) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData('daily', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(1);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 2
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 2 ? true : false,
                          //padding: EdgeInsets.all(5),
                          label: Text('Haftalık',
                          style: TextStyle(
                              color: value.currentselectedtime == 2
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 2) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      'weekly', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(2);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 3
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 3 ? true : false,
                          //padding: EdgeInsets.all(5),
                          label: Text('Aylık',
                          style: TextStyle(
                              color: value.currentselectedtime == 3
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 3) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      'monthly', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(3);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 4
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 4 ? true : false,
                          //padding: EdgeInsets.all(5),
                          label: Text('3 Aylık',
                          style: TextStyle(
                              color: value.currentselectedtime == 4
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 4) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      '3months', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(4);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 5
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 5 ? true : false,
                          //padding: EdgeInsets.all(5),
                          label: Text('6 Aylık',
                          style: TextStyle(
                              color: value.currentselectedtime == 5
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 5) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      '6months', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(5);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          checkmarkColor: value.currentselectedtime == 6
                            ? Colors.white
                            : Colors.black,
                          //showCheckmark: false,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 6 ? true : false,
                          //padding: EdgeInsets.all(1),
                          label: Text('Yıllık',
                          style: TextStyle(
                              color: value.currentselectedtime == 6
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 6) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      'yearly', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(6);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: FilterChip(
                          //showCheckmark: false,
                          checkmarkColor: value.currentselectedtime == 7
                            ? Colors.white
                            : Colors.black,
                          backgroundColor: Colors.green[100],
                          disabledColor: Colors.green[100],
                          selectedColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          selected:
                              value.currentselectedtime == 7 ? true : false,
                          //padding: EdgeInsets.all(1),
                          label: Text('5 Yıl',
                          style: TextStyle(
                              color: value.currentselectedtime == 7
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),
                          onSelected: (select) {
                            if (value.currentselectedtime != 7) {
                              Provider.of<DovizProvider>(context, listen: false)
                                  .getData(
                                      '5years', value.selectedhisse.symbol);
                              Provider.of<DovizProvider>(context, listen: false)
                                  .changeCurrentSelectedTime(7);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Selector<DovizProvider, Snapshots>(
              selector: (context, borsa) => borsa.snapshots,
              builder: (context, value, child) {
                if (value != null) {
                  return Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Değer',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first.value
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Günlük Değişim %',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .dailyChangePercentage !=
                                                0
                                            ? value
                                                    .data
                                                    .items
                                                    .scad
                                                    .first
                                                    .dailyChangePercentage
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .dailyChangePercentage !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .dailyChangePercentage
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .dailyChangePercentage
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Haftalık Değişim %',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .weeklyChangePercentage !=
                                                0
                                            ? value
                                                    .data
                                                    .items
                                                    .scad
                                                    .first
                                                    .weeklyChangePercentage
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .weeklyChangePercentage !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .weeklyChangePercentage
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .weeklyChangePercentage
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aylık Değişim %',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .monthlyChangePercentage !=
                                                0
                                            ? value
                                                    .data
                                                    .items
                                                    .scad
                                                    .first
                                                    .monthlyChangePercentage
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .monthlyChangePercentage !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .monthlyChangePercentage
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .monthlyChangePercentage
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Yıllık Değişim %',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .yearlyChangePercentage !=
                                                0
                                            ? value
                                                    .data
                                                    .items
                                                    .scad
                                                    .first
                                                    .yearlyChangePercentage
                                                    .isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .yearlyChangePercentage !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .yearlyChangePercentage
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .yearlyChangePercentage
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Günlük Değişim',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .dailyChange !=
                                                0
                                            ? value.data.items.scad.first
                                                    .dailyChange.isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .dailyChange !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .dailyChange
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .dailyChange
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Haftalık Değişim',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .weeklyChange !=
                                                0
                                            ? value.data.items.scad.first
                                                    .weeklyChange.isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .weeklyChange !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .weeklyChange
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .weeklyChange
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aylık Değişim',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .monthlyChange !=
                                                0
                                            ? value.data.items.scad.first
                                                    .monthlyChange.isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .monthlyChange !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .monthlyChange
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .monthlyChange
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Yıllık Değişim',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: value.data.items.scad.first
                                                    .yearlyChange !=
                                                0
                                            ? value.data.items.scad.first
                                                    .yearlyChange.isNegative
                                                ? Colors.red
                                                : Colors.green
                                            : Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Icon(
                                              value.data.items.scad.first
                                                          .yearlyChange !=
                                                      0
                                                  ? value
                                                          .data
                                                          .items
                                                          .scad
                                                          .first
                                                          .yearlyChange
                                                          .isNegative
                                                      ? Icons
                                                          .trending_down_rounded
                                                      : Icons
                                                          .trending_up_rounded
                                                  : Icons
                                                      .trending_neutral_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Text(
                                              value.data.items.scad.first
                                                      .yearlyChange
                                                      .toString() ??
                                                  '-',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Günlük En Yüksek',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .dailyHighest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Haftalık En Yüksek',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .weeklyHighest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aylık En Yüksek',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .monthlyHighest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Günlük En Düşük',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .dailyLowest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Haftalık En Düşük',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .weeklyLowest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aylık En Düşük',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Text(
                                          value.data.items.scad.first
                                                  .monthlyLowest
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ask Değeri',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first.ask
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bid Değeri',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey[300],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Text(
                                          value.data.items.scad.first.bid
                                                  .toString() ??
                                              '-',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Yukleniyor',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
