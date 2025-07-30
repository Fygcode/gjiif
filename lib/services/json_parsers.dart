import 'package:tjw1/core/model/tjw/banner_event_response.dart';
import 'package:tjw1/core/model/tjw/event_detail.dart';
import 'package:tjw1/core/model/tjw/fetch_company_detail.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/otp_verify.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/core/model/tjw/today_rate_card.dart';

class JsonParsers {
  static T fromJson<T>(Map<String, dynamic> json) {
    if (T == OtpVerify) {
      return OtpVerify.fromJson(json) as T;
    } else if (T == SelectPrimaryNumber) {
      return SelectPrimaryNumber.fromJson(json) as T;
    } else if (T == Map<String, dynamic>) {
      return json as T;
    } else if (T == StateList) {
      return StateList.fromJson(json) as T;
    } else if (T == FetchCompanyType) {
      return FetchCompanyType.fromJson(json) as T;
    } else if (T == FetchCompanyDetail) {
      return FetchCompanyDetail.fromJson(json) as T;
    } else if (T == BannerEventResponse) {
      return BannerEventResponse.fromJson(json) as T;
    } else if (T == TodaysRateCard) {
      return TodaysRateCard.fromJson(json) as T;
    } else if (T == EventDetailResponse) {
      return EventDetailResponse.fromJson(json) as T;
    } else if (T == EventDetails) {
      return EventDetails.fromJson(json) as T;
    }
    else {
      throw Exception('Unsupported type $T');
    }
  }
}
