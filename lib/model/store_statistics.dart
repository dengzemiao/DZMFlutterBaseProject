import 'dart:convert';

class StoreStatisticsModel {
  /// 订单总数
  int? transactionCount;
  /// 销售额
  double? salesAmount;
  /// 收入
  double? incomeAmount;

  StoreStatisticsModel({
    this.transactionCount,
    this.salesAmount,
    this.incomeAmount,
  });

  StoreStatisticsModel copyWith({
    int? transactionCount,
    double? salesAmount,
    double? incomeAmount,
  }) => 
    StoreStatisticsModel(
      transactionCount: transactionCount ?? this.transactionCount,
      salesAmount: salesAmount ?? this.salesAmount,
      incomeAmount: incomeAmount ?? this.incomeAmount,
    );

  factory StoreStatisticsModel.fromRawJson(String str) => StoreStatisticsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreStatisticsModel.fromJson(Map<String, dynamic> json) => StoreStatisticsModel(
    transactionCount: json["transaction_count"],
    salesAmount: (json["sales_amount"] is int) ? json["sales_amount"].toDouble() : json["sales_amount"],
    incomeAmount: (json["income_amount"] is int) ? json["income_amount"].toDouble() : json["income_amount"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_count": transactionCount,
    "sales_amount": salesAmount,
    "income_amount": incomeAmount,
  };
}
