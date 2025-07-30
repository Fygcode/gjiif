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
        rateCardData!.add(new RateCardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.rateCardData != null) {
      data['data'] = this.rateCardData!.map((v) => v.toJson()).toList();
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

  RateCardData(
      {this.metalCategory,
        this.metal,
        this.grams,
        this.rate,
        this.isGSTIncluded,
        this.gstPercentage,
        this.rateDate});

  RateCardData.fromJson(Map<String, dynamic> json) {
    metalCategory = json['metalCategory'];
    metal = json['metal'];
    grams = json['grams'];
    rate = json['rate'];
    isGSTIncluded = json['isGSTIncluded'];
    gstPercentage = json['gstPercentage'];
    rateDate = json['rateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['metalCategory'] = this.metalCategory;
    data['metal'] = this.metal;
    data['grams'] = this.grams;
    data['rate'] = this.rate;
    data['isGSTIncluded'] = this.isGSTIncluded;
    data['gstPercentage'] = this.gstPercentage;
    data['rateDate'] = this.rateDate;
    return data;
  }
}