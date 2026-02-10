class DropdownApi {
  String? status;
  String? message;
  List<DropDownData>? data;

  DropdownApi({this.status, this.message, this.data});

  DropdownApi.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DropDownData>[];
      json['data'].forEach((v) {
        data!.add(new DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  int? eventID;
  int? eventMasterID;
  String? eventName;
  String? eventShortName;
  String? date;
  String? venue;
  String? city;
  String? eventLogoURL;

  DropDownData(
      {this.eventID,
        this.eventMasterID,
        this.eventName,
        this.date,
        this.venue,
        this.eventShortName,
        this.city,
        this.eventLogoURL});

  DropDownData.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventMasterID = json['eventMasterID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogoURL = json['eventLogoURL'];
    eventShortName = json['eventShortName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventID'] = this.eventID;
    data['eventMasterID'] = this.eventMasterID;
    data['eventName'] = this.eventName;
    data['date'] = this.date;
    data['venue'] = this.venue;
    data['city'] = this.city;
    data['eventLogoURL'] = this.eventLogoURL;
    data['eventShortName'] = this.eventShortName;
    return data;
  }
}