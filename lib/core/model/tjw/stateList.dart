class StateList {
  Response? response;
  List<StateData>? stateData;

  StateList({this.response, this.stateData});

  StateList.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    if (json['data'] != null) {
      stateData = <StateData>[];
      json['data'].forEach((v) {
        stateData!.add(new StateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    if (this.stateData != null) {
      data['data'] = this.stateData!.map((v) => v.toJson()).toList();
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

class StateData {
  int? stateID;
  String? stateName;
  String? countryID;

  StateData({this.stateID, this.stateName, this.countryID});

  StateData.fromJson(Map<String, dynamic> json) {
    stateID = json['stateID'];
    stateName = json['stateName'];
    countryID = json['countryID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateID'] = stateID;
    data['stateName'] = this.stateName;
    data['countryID'] = this.countryID;
    return data;
  }
}