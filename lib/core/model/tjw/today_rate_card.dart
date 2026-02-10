class TodaysRateCard {
  String? status;
  String? message;
  List<RateCardData>? rateCardData;

  TodaysRateCard({this.status, this.message, this.rateCardData});

  TodaysRateCard.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      rateCardData = <RateCardData>[];
      json['data'].forEach((v) {
        rateCardData!.add(RateCardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (rateCardData != null) {
      data['data'] = rateCardData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateCardData {
  String? metalCategory;
  String? metal;
  String? grams;
  int? rate;
  int? isGSTIncluded;
  int? gstPercentage;
  String? rateDate;
  int? deviation;

  RateCardData(
      {this.metalCategory,
        this.metal,
        this.grams,
        this.rate,
        this.isGSTIncluded,
        this.gstPercentage,
        this.rateDate,
        this.deviation
      });

  RateCardData.fromJson(Map<String, dynamic> json) {
    metalCategory = json['metalCategory'];
    metal = json['metal'];
    grams = json['grams'];
    rate = json['rate'];
    isGSTIncluded = json['isGSTIncluded'];
    gstPercentage = json['gstPercentage'];
    rateDate = json['rateDate'];
    deviation = json['deviation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['metalCategory'] = metalCategory;
    data['metal'] = metal;
    data['grams'] = grams;
    data['rate'] = rate;
    data['isGSTIncluded'] = isGSTIncluded;
    data['gstPercentage'] = gstPercentage;
    data['rateDate'] = rateDate;
    data['deviation'] = deviation;
    return data;
  }
}