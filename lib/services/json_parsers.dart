import 'package:tjw1/core/model/tjw/otp_verify.dart';
import 'package:tjw1/core/model/tjw/select_primary_number.dart';

class JsonParsers {
  static T fromJson<T>(Map<String, dynamic> json) {
    if (T == OtpVerify) {
      return OtpVerify.fromJson(json) as T;
    }  else if (T == SelectPrimaryNumber) {
      return SelectPrimaryNumber.fromJson(json) as T;
    } else if (T == Map<String, dynamic>) {
      return json as T;
    } else {
      throw Exception('Unsupported type $T');
    }
  }
}
