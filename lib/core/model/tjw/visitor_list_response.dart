class VisitorListResponse {
  String? status;
  String? message;
  List<VisitorListData>? visitorListData;

  VisitorListResponse({this.status, this.message, this.visitorListData});

  VisitorListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      visitorListData = <VisitorListData>[];
      json['data'].forEach((v) {
        visitorListData!.add(new VisitorListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.visitorListData != null) {
      data['data'] = this.visitorListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitorListData {
  int? visitorID;
  String? visitorName;
  String? designation;
  String? visitorMobile;
  String? visitorPhoto;
  int? isPrimary;
  int? isDataComplete;

  VisitorListData(
      {this.visitorID,
        this.visitorName,
        this.designation,
        this.visitorMobile,
        this.visitorPhoto,
        this.isPrimary,
        this.isDataComplete});

  VisitorListData.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorName = json['visitorName'];
    designation = json['designation'];
    visitorMobile = json['visitorMobile'];
    visitorPhoto = json['visitorPhoto'];
    isPrimary = json['isPrimary'];
    isDataComplete = json['isDataComplete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = this.visitorID;
    data['visitorName'] = this.visitorName;
    data['designation'] = this.designation;
    data['visitorMobile'] = this.visitorMobile;
    data['visitorPhoto'] = this.visitorPhoto;
    data['isPrimary'] = this.isPrimary;
    data['isDataComplete'] = this.isDataComplete;
    return data;
  }
}