class PaymentSummaryResponse {
  String? status;
  String? message;
  PaymentSummaryData? paymentSummaryData;

  PaymentSummaryResponse({this.status, this.message, this.paymentSummaryData});

  PaymentSummaryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    paymentSummaryData = json['data'] != null ? new PaymentSummaryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.paymentSummaryData != null) {
      data['data'] = this.paymentSummaryData!.toJson();
    }
    return data;
  }
}

class PaymentSummaryData {
  List<VisitorSummary>? visitorSummary;
  EventDetail? eventDetail;
  int? totalPayment;

  PaymentSummaryData({this.visitorSummary, this.eventDetail, this.totalPayment});

  PaymentSummaryData.fromJson(Map<String, dynamic> json) {
    if (json['visitorSummary'] != null) {
      visitorSummary = <VisitorSummary>[];
      json['visitorSummary'].forEach((v) {
        visitorSummary!.add(new VisitorSummary.fromJson(v));
      });
    }
    eventDetail = json['eventDetail'] != null
        ? new EventDetail.fromJson(json['eventDetail'])
        : null;
    totalPayment = json['totalPayment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.visitorSummary != null) {
      data['visitorSummary'] =
          this.visitorSummary!.map((v) => v.toJson()).toList();
    }
    if (this.eventDetail != null) {
      data['eventDetail'] = this.eventDetail!.toJson();
    }
    data['totalPayment'] = this.totalPayment;
    return data;
  }
}

class VisitorSummary {
  int? visitorID;
  String? visitorName;
  int? preRegistrationFee;

  VisitorSummary({this.visitorID, this.visitorName, this.preRegistrationFee});

  VisitorSummary.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorName = json['visitorName'];
    preRegistrationFee = json['preRegistrationFee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = this.visitorID;
    data['visitorName'] = this.visitorName;
    data['preRegistrationFee'] = this.preRegistrationFee;
    return data;
  }
}

class EventDetail {
  int? eventID;
  int? eventMasterID;
  String? eventName;
  String? date;
  String? venue;
  String? city;
  String? eventLogoURL;

  EventDetail(
      {this.eventID,
        this.eventMasterID,
        this.eventName,
        this.date,
        this.venue,
        this.city,
        this.eventLogoURL});

  EventDetail.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventMasterID = json['eventMasterID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogoURL = json['eventLogoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventID'] = this.eventID;
    data['eventMasterID'] = this.eventMasterID;
    data['eventName'] = this.eventName;
    data['date'] = this.date;
    data['venue'] = this.venue;
    data['city'] = this.city;
    data['eventLogoURL'] = this.eventLogoURL;
    return data;
  }
}