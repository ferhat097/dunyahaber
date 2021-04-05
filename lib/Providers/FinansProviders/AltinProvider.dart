import 'dart:convert';
import 'package:dunyahaber/Models/Hisseler.dart';
import 'package:dunyahaber/Models/chartModel.dart';
import 'package:dunyahaber/Models/snapshots.dart';
import 'package:dunyahaber/Service/dunya_api.dart';
import 'package:flutter/material.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:http/http.dart' as http;

class AltinProvider extends ChangeNotifier {
  bool isLine = true;
  Hisse selectedhisse = Hisse('SCUM', 'Cumhuriyyet Altini', 'SCUM', 'SCUM');
  List<Hisse> hisseler = [
    Hisse('XAU/USD', 'Altin Amerikan Dolari', 'XAU/USD', 'XAU/USD'),
    Hisse('SCUM', 'Cumhuriyet Altını', 'SCUM', 'SCUM'),
    Hisse('SGCEYREK', 'Çeyrek Altın', 'SGCEYREK', 'SGCEYREK'),
    Hisse('XGLD', 'Spot Altın TL/Gr', 'XGLD', 'XGLD'),
    Hisse('SGLD', 'Altın TL/Gr', 'SGLD', 'SGLD'),
    Hisse('SGYARIM', 'Yarım Altın', 'SGYARIM', 'SGYARIM'),
    Hisse('SGGREMSE', 'Gremse Altın', 'SGGREMSE', 'SGGREMSE'),
    Hisse('SGATA', 'Ata Altın', 'SGATA', 'SGATA'),
    Hisse('SGBESLI', 'Beşli Altın', 'SGBESLI', 'SGBESLI'),
    Hisse('SGIKIBUCUK', 'İki Buçuk Altın', 'SGIKIBUCUK', 'SGIKIBUCUK'),
    Hisse('SGZIYNET', 'Zinet Altın', 'SGZIYNET', 'SGZIYNET'),
    Hisse('SG14BIL', '14 Ayar Bilezik Gram/TL', 'SG14BIL', 'SG14BIL'),
    Hisse('SG18BIL', '18 Ayar Bilezik Gram/TL', 'SG18BIL', 'SG18BIL'),
    Hisse('SG22BIL', '22 Ayar Bilezik Gram/TL', 'SG22BIL', 'SG22BIL'),
    Hisse('XSLV', 'Gumus Gram/TL', 'XSLV', 'XSLV'),
    Hisse('XAG/USD', 'Gumus Amerikan Dolari', 'XAG/USD', 'XAG/USD')
  ];
  Snapshots snapshots;
  List<KLineEntity> dat = [];
  int currentselectedtime = 1;
  Future<Snapshots> getcodeinfo(String codes) async {
    snapshots = await DunyaApiManager().getAllSnapshots(codes);
    notifyListeners();
    return snapshots;
  }

  changeVal(value) {
    selectedhisse = value;
    notifyListeners();
  }

  changeCurrentSelectedTime(index) {
    currentselectedtime = index;
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
