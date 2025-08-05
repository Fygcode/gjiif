class RegisteredBadgeResponse {
  String? status;
  String? message;
  List<RegisteredVisitorBadgeList>? registeredVisitorBadgeList;

  RegisteredBadgeResponse({this.status, this.message, this.registeredVisitorBadgeList});

  RegisteredBadgeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      registeredVisitorBadgeList = <RegisteredVisitorBadgeList>[];
      json['data'].forEach((v) {
        registeredVisitorBadgeList!.add(new RegisteredVisitorBadgeList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.registeredVisitorBadgeList != null) {
      data['data'] = this.registeredVisitorBadgeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisteredVisitorBadgeList {
  String? visitorName;
  String? registrationID;
  String? visitorPhone;
  String? photoURL;

  RegisteredVisitorBadgeList(
      {this.visitorName,
        this.registrationID,
        this.visitorPhone,
        this.photoURL});

  RegisteredVisitorBadgeList.fromJson(Map<String, dynamic> json) {
    visitorName = json['visitorName'];
    registrationID = json['registrationID'];
    visitorPhone = json['visitorPhone'];
    photoURL = json['photoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorName'] = this.visitorName;
    data['registrationID'] = this.registrationID;
    data['visitorPhone'] = this.visitorPhone;
    data['photoURL'] = this.photoURL;
    return data;
  }
}