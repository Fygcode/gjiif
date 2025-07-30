class BannerEventResponse {
  String? status;
  String? message;
  BannerEventData? bannerEventData;

  BannerEventResponse({this.status, this.message, this.bannerEventData});

  BannerEventResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    bannerEventData = json['data'] != null ? new BannerEventData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.bannerEventData != null) {
      data['data'] = this.bannerEventData!.toJson();
    }
    return data;
  }
}

class BannerEventData {
  List<BannerList>? bannerList;
  List<EventsList>? eventsList;

  BannerEventData({this.bannerList, this.eventsList});

  BannerEventData.fromJson(Map<String, dynamic> json) {
    if (json['bannerList'] != null) {
      bannerList = <BannerList>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(new BannerList.fromJson(v));
      });
    }
    if (json['eventsList'] != null) {
      eventsList = <EventsList>[];
      json['eventsList'].forEach((v) {
        eventsList!.add(new EventsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bannerList != null) {
      data['bannerList'] = this.bannerList!.map((v) => v.toJson()).toList();
    }
    if (this.eventsList != null) {
      data['eventsList'] = this.eventsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BannerList {
  String? bannerURL;
  int? eventID;

  BannerList({this.bannerURL, this.eventID});

  BannerList.fromJson(Map<String, dynamic> json) {
    bannerURL = json['bannerURL'];
    eventID = json['eventID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bannerURL'] = this.bannerURL;
    data['eventID'] = this.eventID;
    return data;
  }
}

class EventsList {
  int? eventID;
  String? eventName;
  String? date;
  String? venue;
  String? city;
  String? eventLogo;


  EventsList(
      {this.eventID,
        this.eventName,
        this.date,
        this.venue,
        this.city,
        this.eventLogo,
       });

  EventsList.fromJson(Map<String, dynamic> json) {
    eventID = json['eventID'];
    eventName = json['eventName'];
    date = json['date'];
    venue = json['venue'];
    city = json['city'];
    eventLogo = json['eventLogoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventID'] = this.eventID;
    data['eventName'] = this.eventName;
    data['date'] = this.date;
    data['venue'] = this.venue;
    data['city'] = this.city;
    data['eventLogoURL'] = this.eventLogo;
    return data;
  }
}