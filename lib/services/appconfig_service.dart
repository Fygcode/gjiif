import 'dart:convert';

import '../helper/update_checker.dart';


// class AppConfigService {
//   AppConfig _appConfig = AppConfig(
//       appName: "Heavenly", baseApiUrl: "", firebaseNotificationApiKey: "");
//  // AppEnvironment? _appEnvironment;
//   String? _packageName;
//
// //  AppEnvironment? get appEnvironment => _appEnvironment;
//
//   String get envString {
//     if (_packageName?.endsWith(".dev") == true) {
//       return "DEVELOP";
//     } else if (_packageName?.endsWith(".uat") == true) {
//       return "UAT";
//     } else {
//       return "PROD";
//     }
//   }
//
//   Color get color {
//     if (_packageName?.endsWith(".dev") == true) {
//       return Colors.red;
//     } else if (_packageName?.endsWith(".uat") == true) {
//       return Colors.orange;
//     } else {
//       return Colors.green;
//     }
//   }
//
//   AppConfig get config {
//     return _appConfig;
//   }
//
//   // setConfig(String value, AppEnvironment appEnvironment, String packageName) {
//   //   _packageName = packageName;
//   //   _appConfig = AppConfig.fromJson(jsonDecode(value));
//   //   _appEnvironment = appEnvironment;
//   // }
// }

class AppConfigService {
  AppConfig _appConfig = AppConfig(
    appName: "TJW",
    baseApiUrl: "",
    firebaseNotificationApiKey: "",
  );

  String? _packageName;

  String get envString {
    if (_packageName?.endsWith(".dev") == true) {
      return "DEVELOP";
    } else if (_packageName?.endsWith(".uat") == true) {
      return "UAT";
    } else {
      return "PROD";
    }
  }

  AppConfig get config => _appConfig;

  void setConfig(Map<String, dynamic> value) {
    _appConfig = AppConfig.fromJson(value);
    print(
      'AppConfig loaded:\n${const JsonEncoder.withIndent('  ').convert(_appConfig.toJson())}',
    );
  }

  void setPackageName(String packageName) {
    _packageName = packageName;
  }
}

class AppConfig {
  String appName;
  String baseApiUrl;
  String? firebaseNotificationApiKey;
  Android? android;
  IOS? iOS;
  List<String>? banners;
  String? termsAndConditions;
  bool? forceUpdate;

  AppConfig({
    required this.appName,
    required this.baseApiUrl,
    this.firebaseNotificationApiKey,
    this.android,
    this.iOS,
    this.banners,
    this.termsAndConditions,
    this.forceUpdate
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      appName: json['AppName'] ?? '',
      baseApiUrl: json['BaseApiUrl'] ?? '',
      firebaseNotificationApiKey: json['FirebaseNotificationApiKey'],
      android: json['Android'] != null ? Android.fromJson(json['Android']) : null,
      iOS: json['IOS'] != null ? IOS.fromJson(json['IOS']) : null,
      banners: (json['Banners'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      termsAndConditions: json['TermsAndConditions']
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'AppName': appName,
      'BaseApiUrl': baseApiUrl,
      'FirebaseNotificationApiKey': firebaseNotificationApiKey,
      'TermsAndConditions' : termsAndConditions,
    };
    if (android != null) data['Android'] = android!.toJson();
    if (iOS != null) data['IOS'] = iOS!.toJson();
    if (banners != null) data['Banners'] = banners;
    return data;
  }
}

class Android {
  String? url;
  String? version;
  String? appID;

  Android({this.url, this.version, this.appID});

  factory Android.fromJson(Map<String, dynamic> json) {
    return Android(
      url: json['Url'],
      version: json['Version'],
      appID: json['AppID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Url': url,
      'Version': version,
      'AppID': appID,
    };
  }
}

class IOS {
  String? url;
  String? version;
  String? appId;

  IOS({this.url, this.version, this.appId});

  factory IOS.fromJson(Map<String, dynamic> json) {
    return IOS(
      url: json['Url'],
      version: json['Version'],
      appId: json['AppId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Url': url,
      'Version': version,
      'AppId': appId,
    };
  }
}

