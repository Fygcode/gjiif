class EventDetailResponse {
  String? status;
  String? message;
  EventData? eventData;

  EventDetailResponse({this.status, this.message, this.eventData});

  EventDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    eventData = json['data'] != null ? new EventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.eventData != null) {
      data['data'] = this.eventData!.toJson();
    }
    return data;
  }
}

class EventData {
  EventDetails? eventDetails;
  List<PreRegistrationDetail>? preRegistrationDetail;

  EventData({this.eventDetails, this.preRegistrationDetail});

  EventData.fromJson(Map<String, dynamic> json) {
    eventDetails = json['eventDetails'] != null
        ? new EventDetails.fromJson(json['eventDetails'])
        : null;
    if (json['preRegistrationDetail'] != null) {
      preRegistrationDetail = <PreRegistrationDetail>[];
      json['preRegistrationDetail'].forEach((v) {
        preRegistrationDetail!.add(new PreRegistrationDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventDetails != null) {
      data['eventDetails'] = this.eventDetails!.toJson();
    }
    if (this.preRegistrationDetail != null) {
      data['preRegistrationDetail'] =
          this.preRegistrationDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventDetails {
  int? eventID;
  String? eventName;
  String? eventVenue;
  String? eventCity;
  String? eventDates;
  String? eventTitle;
  String? eventDescription;
  String? eventLogoURL;
  String? eventBannerURL;

  EventDetails(
      {this.eventID,
        this.eventName,
        this.eventVenue,
        this.eventCity,
        this.eventDates,
        this.eventTitle,
        this.eventDescription,
        this.eventLogoURL,
        this.eventBannerURL});

  EventDetails.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventName = json['eventName'];
    eventVenue = json['eventVenue'];
    eventCity = json['eventCity'];
    eventDates = json['eventDates'];
    eventTitle = json['eventTitle'];
    eventDescription = json['eventDescription'];
    eventLogoURL = json['eventLogoURL'];
    eventBannerURL = json['eventBannerURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventID'] = this.eventID;
    data['eventName'] = this.eventName;
    data['eventVenue'] = this.eventVenue;
    data['eventCity'] = this.eventCity;
    data['eventDates'] = this.eventDates;
    data['eventTitle'] = this.eventTitle;
    data['eventDescription'] = this.eventDescription;
    data['eventLogoURL'] = this.eventLogoURL;
    data['eventBannerURL'] = this.eventBannerURL;
    return data;
  }
}

class PreRegistrationDetail {
  int? eventID;
  String? phase;
  String? preRegistrationFee;
  String? phaseDate;

  PreRegistrationDetail(
      {this.eventID, this.phase, this.preRegistrationFee, this.phaseDate});

  PreRegistrationDetail.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    phase = json['phase'];
    preRegistrationFee = json['preRegistrationFee'];
    phaseDate = json['phaseDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventID'] = this.eventID;
    data['phase'] = this.phase;
    data['preRegistrationFee'] = this.preRegistrationFee;
    data['phaseDate'] = this.phaseDate;
    return data;
  }
}