class Bist {
  Bist({
    this.status,
    this.success,
    this.error,
    this.data,
  });

  int status;
  bool success;
  dynamic error;
  Data data;

  factory Bist.fromJson(Map<String, dynamic> json) => Bist(
        status: json["status"],
        success: json["success"],
        error: json["error"],
        data: Data.fromJson(
          json["data"],
        ),
      );
}

class Data {
  Data({
    this.items,
  });

  List<Item> items;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: List<Item>.from(
          json["items"].map(
            (x) => Item.fromJson(x),
          ),
        ),
      );
}

class Item {
  Item({
    this.id,
    this.code,
    this.foreksCode,
    this.type,
    this.name,
    this.shortName,
    this.time,
    this.value,
    this.ask,
    this.bid,
    this.dailyLowest,
    this.dailyHighest,
    this.weeklyLowest,
    this.weeklyHighest,
    this.monthlyLowest,
    this.monthlyHighest,
    this.dailyVolume,
    this.dailyAmount,
    this.dailyChange,
    this.weeklyChange,
    this.monthlyChange,
    this.yearlyChange,
    this.dailyChangePercentage,
    this.weeklyChangePercentage,
    this.monthlyChangePercentage,
    this.yearlyChangePercentage,
    this.capital,
    this.netCapital,
    this.netProfit,
    this.updatedAt,
    this.createdAt,
  });

  String id;
  String code;
  String foreksCode;
  String type;
  String name;
  String shortName;
  String time;
  double value;
  double ask;
  double bid;
  double dailyLowest;
  double dailyHighest;
  double weeklyLowest;
  double weeklyHighest;
  double monthlyLowest;
  double monthlyHighest;
  double dailyVolume;
  int dailyAmount;
  double dailyChange;
  double weeklyChange;
  double monthlyChange;
  double yearlyChange;
  double dailyChangePercentage;
  double weeklyChangePercentage;
  double monthlyChangePercentage;
  double yearlyChangePercentage;
  double capital;
  double netCapital;
  double netProfit;
  DateTime updatedAt;
  DateTime createdAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
     id: json["_id"],
        code: json["code"],
        foreksCode: json["foreks_code"],
       // type: typeValues.map[json["type"]],
        name: json["name"],
        shortName: json["short_name"],
       // time: timeValues.map[json["time"]],
        value: json["value"].toDouble(),
        ask: json["ask"].toDouble(),
        bid: json["bid"].toDouble(),
        dailyLowest: json["daily_lowest"].toDouble(),
        dailyHighest: json["daily_highest"].toDouble(),
        weeklyLowest: json["weekly_lowest"].toDouble(),
        weeklyHighest: json["weekly_highest"].toDouble(),
        monthlyLowest: json["monthly_lowest"].toDouble(),
        monthlyHighest: json["monthly_highest"].toDouble(),
        dailyVolume: json["daily_volume"].toDouble(),
        dailyAmount: json["daily_amount"],
        dailyChange: json["daily_change"].toDouble(),
        weeklyChange: json["weekly_change"].toDouble(),
        monthlyChange: json["monthly_change"].toDouble(),
        yearlyChange: json["yearly_change"].toDouble(),
        dailyChangePercentage: json["daily_change_percentage"].toDouble(),
        weeklyChangePercentage: json["weekly_change_percentage"].toDouble(),
        monthlyChangePercentage: json["monthly_change_percentage"].toDouble(),
        yearlyChangePercentage: json["yearly_change_percentage"].toDouble(),
        capital: json["capital"].toDouble(),
        netCapital: json["net_capital"].toDouble(),
        netProfit: json["net_profit"].toDouble(),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );
}
