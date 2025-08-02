// class RegisteredVisitorList {
//   String? status;
//   String? message;
//   List<RegisteredData>? registeredData;
//
//   RegisteredVisitorList({this.status, this.message, this.registeredData});
//
//   RegisteredVisitorList.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       registeredData = <RegisteredData>[];
//       json['data'].forEach((v) {
//         registeredData!.add(new RegisteredData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.registeredData != null) {
//       data['data'] = this.registeredData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class RegisteredData {
//   int? visitorID;
//   String? visitorName;
//   String? visitorPhoto;
//   String? visitorPhone;
//   int? statusID;
//   String? status;
//
//   RegisteredData(
//       {this.visitorID,
//         this.visitorName,
//         this.visitorPhoto,
//         this.visitorPhone,
//         this.statusID,
//         this.status});
//
//   RegisteredData.fromJson(Map<String, dynamic> json) {
//     visitorID = json['visitorID'];
//     visitorName = json['visitorName'];
//     visitorPhoto = json['visitorPhoto'];
//     visitorPhone = json['visitorPhone'];
//     statusID = json['statusID'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visitorID'] = this.visitorID;
//     data['visitorName'] = this.visitorName;
//     data['visitorPhoto'] = this.visitorPhoto;
//     data['visitorPhone'] = this.visitorPhone;
//     data['statusID'] = this.statusID;
//     data['status'] = this.status;
//     return data;
//   }
// }


class RegisteredVisitorResponse {
  String? status;
  String? message;
  RegisteredData? registeredData;

  RegisteredVisitorResponse({this.status, this.message, this.registeredData});

  RegisteredVisitorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    registeredData = json['data'] != null ? new RegisteredData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.registeredData != null) {
      data['data'] = this.registeredData!.toJson();
    }
    return data;
  }
}

class RegisteredData {
  List<VisitorsList>? visitorsList;
  List<StatusList>? statusList;

  RegisteredData({this.visitorsList, this.statusList});

  RegisteredData.fromJson(Map<String, dynamic> json) {
    if (json['visitorsList'] != null) {
      visitorsList = <VisitorsList>[];
      json['visitorsList'].forEach((v) {
        visitorsList!.add(new VisitorsList.fromJson(v));
      });
    }
    if (json['statusList'] != null) {
      statusList = <StatusList>[];
      json['statusList'].forEach((v) {
        statusList!.add(new StatusList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.visitorsList != null) {
      data['visitorsList'] = this.visitorsList!.map((v) => v.toJson()).toList();
    }
    if (this.statusList != null) {
      data['statusList'] = this.statusList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitorsList {
  int? visitorID;
  String? visitorName;
  String? visitorPhotoURL;
  String? visitorPhone;
  int? statusID;
  String? status;

  VisitorsList(
      {this.visitorID,
        this.visitorName,
        this.visitorPhotoURL,
        this.visitorPhone,
        this.statusID,
        this.status});

  VisitorsList.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorName = json['visitorName'];
    visitorPhotoURL = json['visitorPhotoURL'];
    visitorPhone = json['visitorPhone'];
    statusID = json['statusID'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = this.visitorID;
    data['visitorName'] = this.visitorName;
    data['visitorPhotoURL'] = this.visitorPhotoURL;
    data['visitorPhone'] = this.visitorPhone;
    data['statusID'] = this.statusID;
    data['status'] = this.status;
    return data;
  }
}

class StatusList {
  int? statusID;
  String? status;

  StatusList({this.statusID, this.status});

  StatusList.fromJson(Map<String, dynamic> json) {
    statusID = json['statusID'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusID'] = this.statusID;
    data['status'] = this.status;
    return data;
  }
}