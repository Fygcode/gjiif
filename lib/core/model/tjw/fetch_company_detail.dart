class FetchCompanyDetail {
  String? status;
  String? message;
  companyData? data;

  FetchCompanyDetail({this.status, this.message, this.data});

  FetchCompanyDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new companyData.fromJson(json['data']) : null;
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

class companyData {
  String? gstN;
  String? companyType;
  String? companyName;
  String? address;
  String? city;
  String? pincode;
  String? stateID;
  String? district;
  String? landline;
  String? mobileNumber;
  String? email;
  int? primaryVisitorID;
  String? gstFileName;
  int? saveFlag;
  int? gstChangedFlag;
  String? gstFilePath;

  companyData(
      {this.gstN,
      this.companyType,
      this.companyName,
      this.address,
      this.city,
      this.pincode,
      this.stateID,
      this.district,
      this.landline,
      this.mobileNumber,
      this.email,
      this.primaryVisitorID,
      this.gstFileName,
      this.saveFlag,
      this.gstChangedFlag, this.gstFilePath});

  companyData.fromJson(Map<String, dynamic> json) {
    gstN = json['gstN'];
    companyType = json['companyType'];
    companyName = json['companyName'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    stateID = json['stateID'];
    district = json['district'];
    landline = json['landline'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    primaryVisitorID = json['primaryVisitorID'];
    gstFileName = json['gstFileName'];
    saveFlag = json['saveFlag'];
    gstChangedFlag = json['gstChangedFlag'];
    gstFilePath = json['gstFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gstN'] = this.gstN;
    data['companyType'] = this.companyType;
    data['companyName'] = this.companyName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['stateID'] = this.stateID;
    data['district'] = this.district;
    data['landline'] = this.landline;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['primaryVisitorID'] = this.primaryVisitorID;
    data['gstFileName'] = this.gstFileName;
    data['saveFlag'] = this.saveFlag;
    data['gstChangedFlag'] = this.gstChangedFlag;
    data['gstFilePath'] = this.gstFilePath;
    return data;
  }
}