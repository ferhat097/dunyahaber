import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dunyahaber/Models/Hisseler.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:dunyahaber/Models/chartModel.dart';
import 'package:dunyahaber/Models/snapshots.dart';
import 'package:dunyahaber/Models/definitions.dart' as Definition;
import 'package:http/http.dart' as http;
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:k_chart/utils/data_util.dart';

class BorsaProvider extends ChangeNotifier {
  Snapshots snapshots;
  Future<Snapshots> getcodeinfo(String codes) async {
    snapshots = await DunyaApiManager().getAllSnapshots(codes);
    notifyListeners();
    return snapshots;
  }

  bool isLine = true;

  List<Hisse> hisseler = [];
  Hisse selectedhisse =
      Hisse('SG14BIL', '14 Ayar Bilezik Gram\/TL', 'GrandBazaar', 'SG14BIL');

  List<KLineEntity> dat = [];

  changeVal(value) {
    selectedhisse = value;
    notifyListeners();
  }

  int currentselectedtime = 1;

  changeCurrentSelectedTime(index) {
    currentselectedtime = index;
    notifyListeners();
  }

  changeChartType() {
    isLine = !isLine;
    notifyListeners();
  }

  Future<List<Hisse>> getHisse() async {
    //var url = 'https://www.dunya.com/api/v5/finance/definitions?take=991';
    Definition.Definitions definitions =
        await DunyaApiManager().getAllDefinitions(true);
    definitions.data.items.forEach((element) {
      Hisse hisse = Hisse(
          element.foreksCode, element.name, element.exchange, element.code);
      hisseler.add(hisse);
    });
    notifyListeners();
    return hisseler;
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
