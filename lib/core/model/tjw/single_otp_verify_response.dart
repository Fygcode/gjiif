class SingleOtpVerifyResponse {
  String? status;
  String? message;
  Data? data;

  SingleOtpVerifyResponse({this.status, this.message, this.data});

  SingleOtpVerifyResponse.fromJson(Map<String, dynamic> json) {
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
  String? visitorPhotoURL;
  int? status;
  String? barcode;
  String? visitorName;
  String? designation;
  String? company;
  String? address;
  String? city;
  String? pincode;
  String? gstn;
  String? phone;
  String? emailID;

  Data(
      {this.visitorID,
        this.visitorPhotoURL,
        this.status,
        this.barcode,
        this.visitorName,
        this.designation,
        this.company,
        this.address,
        this.city,
        this.pincode,
        this.gstn,
        this.phone,
        this.emailID});

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorPhotoURL = json['visitorPhotoURL'];
    status = json['status'];
    barcode = json['barcode'];
    visitorName = json['visitorName'];
    designation = json['designation'];
    company = json['company'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    gstn = json['gstn'];
    phone = json['phone'];
    emailID = json['emailID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = this.visitorID;
    data['visitorPhotoURL'] = this.visitorPhotoURL;
    data['status'] = this.status;
    data['barcode'] = this.barcode;
    data['visitorName'] = this.visitorName;
    data['designation'] = this.designation;
    data['company'] = this.company;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['gstn'] = this.gstn;
    data['phone'] = this.phone;
    data['emailID'] = this.emailID;
    return data;
  }
}