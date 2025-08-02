class DesignationResponse {
  Response? response;
  List<DesignationData>? data;

  DesignationResponse({this.response, this.data});

  DesignationResponse.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    if (json['data'] != null) {
      data = <DesignationData>[];
      json['data'].forEach((v) {
        data!.add(new DesignationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? status;
  String? message;

  Response({this.status, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class DesignationData {
  int? designationID;
  String? designation;

  DesignationData({this.designationID, this.designation});

  DesignationData.fromJson(Map<String, dynamic> json) {
    designationID = json['designationID'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['designationID'] = this.designationID;
    data['designation'] = this.designation;
    return data;
  }
}