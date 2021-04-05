import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dunyahaber/Models/Hisseler.dart';
import 'package:dunyahaber/Models/chartModel.dart';
import 'package:dunyahaber/Models/snapshots.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';

class DovizProvider extends ChangeNotifier{
  bool isLine = true;
  Hisse selectedhisse = Hisse('SCUM', 'Cumhuriyyet Altini', 'SCUM', 'SCUM');
  List<Hisse> hisseler = [
    Hisse('USD/TRL', 'Amerikan Dolari Turk Lirasi', 'USD/TRL', 'USD/TRL'),
    Hisse('EUR/TRL', 'Avro Turk Lirasi', 'EUR/TRL', 'EUR/TRL'),
    Hisse('GBP/TRL', 'Ingiliz Sterlini Turk Lirasi', 'GBP/TRL', 'GBP/TRL'),
    Hisse('CHF/TR', 'Isvicre Franki Turk Lirasi', 'CHF/TR', 'CHF/TR'),
    Hisse('RUB/TRL', 'Rus Rublesi Turk Lirasi', 'RUB/TRL', 'RUB/TRL'),
    Hisse('CAD/TRL', 'Kanada dolari Turk Lirasi', 'CAD/TRL', 'CAD/TRL')
  ];
  Snapshots snapshots;
  List<KLineEntity> dat = [];
    int currentselectedtime = 1;
  Future<Snapshots> getcodeinfo(String codes) async {
    snapshots = await DunyaApiManager().getAllSnapshots(codes);
    notifyListeners();
    return snapshots;
  }

    changeCurrentSelectedTime(index) {
    currentselectedtime = index;
    notifyListeners();
  }
  changeVal(value) {
    selectedhisse = value;
    notifyListeners();
  }
  changeChartType() {
    isLine = !isLine;
    notifyListeners();
  }


  Future<List<KLineEntity>> getData(String period, String symbol) async {
    dat.clear();
    notifyListeners();
    var url =
        'https://www.dunya.com/api/v5/finance/chart?foreks_code=$symbol&period=$period';
    /*var url =
        'https://api.huobi.br.com/market/history/kline?period=${time ?? '1day'}&size=400&symbol=${symbol ?? 'btcusdt'}';*/
    var result;
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //print('yess2');
      result = response.body;
    } else {
      //print('yess3');
      //print('Failed getting IP address');
    }
    //var result = await getIPAddress(time);
    ChartModel chartModel = ChartModel.fromJson(json.decode(result));
    List<Datum> list1 = chartModel.data;
    //print(list1);
    dat = list1
        .map((item) => KLineEntity.fromCustom(
            open: item.open,
            close: item.close,
            low: item.low,
            high: item.high,
            amount: 1,
            time: item.date * 1000,
            vol: 1,
            change: 1,
            ratio: 1))
        .toList()
        .cast<KLineEntity>();
    DataUtil.calculate(dat);
    notifyListeners();
    return dat;
  }
}