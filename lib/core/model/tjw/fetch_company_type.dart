import 'package:tjw1/core/enum/view_state.dart';

class FetchCompanyType {
  String? status;
  String? message;
  List<CompanyTypeData>? companyTypeData;

  FetchCompanyType({this.status, this.message, this.companyTypeData});

  FetchCompanyType.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      companyTypeData = <CompanyTypeData>[];
      json['data'].forEach((v) {
        companyTypeData!.add(new CompanyTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.companyTypeData != null) {
      data['data'] = this.companyTypeData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyTypeData {
  int? id;
  String? companyType;

  CompanyTypeData({this.id, this.companyType});

  CompanyTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyType = json['companyType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['companyType'] = this.companyType;
    return data;
  }
}