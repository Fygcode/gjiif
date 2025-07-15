class OtpVerify {
  String? status;
  String? message;
  Data? data;

  OtpVerify({this.status, this.message, this.data});

  OtpVerify.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? visitorID;
  bool? isCompanyDetailFull;

  Data({this.visitorID, this.isCompanyDetailFull});

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    isCompanyDetailFull = json['isCompanyDetailFull'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = this.visitorID;
    data['isCompanyDetailFull'] = this.isCompanyDetailFull;
    return data;
  }
}