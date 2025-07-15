// class SelectPrimaryNumber {
//   String? status;
//   String? message;
//   List<VisitorData>? data;
//
//   SelectPrimaryNumber({this.status, this.message, this.data});
//
//   SelectPrimaryNumber.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <VisitorData>[];
//       json['data'].forEach((v) {
//         data!.add(new VisitorData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class VisitorData {
//   int? visitorID;
//   String? visitorPhone;
//   String? mobileNumber;
//   int? isPrimary;
//
//   VisitorData({this.visitorID, this.visitorPhone, this.mobileNumber, this.isPrimary});
//
//   VisitorData.fromJson(Map<String, dynamic> json) {
//     visitorID = json['visitorID'];
//     visitorPhone = json['visitorPhone'];
//     mobileNumber = json['mobileNumber'];
//     isPrimary = json['isPrimary'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visitorID'] = this.visitorID;
//     data['visitorPhone'] = this.visitorPhone;
//     data['mobileNumber'] = this.mobileNumber;
//     data['isPrimary'] = this.isPrimary;
//     return data;
//   }
// }


class SelectPrimaryNumber {
  final String status;
  final String message;
  final dynamic data;

  SelectPrimaryNumber({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SelectPrimaryNumber.fromJson(Map<String, dynamic> json) {
    return SelectPrimaryNumber(
      status: json['status'].toString(),
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

class VisitorPhone {
  final int visitorID;
  final String visitorPhone;
  final String mobileNumber;
  final int isPrimary;

  VisitorPhone({
    required this.visitorID,
    required this.visitorPhone,
    required this.mobileNumber,
    required this.isPrimary,
  });

  factory VisitorPhone.fromJson(Map<String, dynamic> json) {
    return VisitorPhone(
      visitorID: json['visitorID'],
      visitorPhone: json['visitorPhone'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      isPrimary: json['isPrimary'] ?? 0,
    );
  }
}

