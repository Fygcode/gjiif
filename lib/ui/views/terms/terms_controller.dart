import 'package:get/get.dart';

import '../../../locator.dart';
import '../../../services/appconfig_service.dart';

class TermsController extends GetxController {
  String termsContentDefault = '''
1. Please note that this is a provisional pre-registration only. GJIIF 2023 is a B2B jewellery exhibition. Entry is only for jewellery business delegates. Your registration is complete only after verification and validation of the following documents that are to be submitted along with this application:
   a) Visiting card of your firm with your name and designation.
   b) Photocopy of valid photo ID (Driving License, Election Card, or Aadhar Card).
   c) Photocopy of company’s GST Certificate or your local association certificate.

2. Application forms once submitted cannot be cancelled or transferred under any circumstances.

3. Visitors’ registration fee once paid is non-refundable and cannot be adjusted under any circumstances.

4. The organizer reserves the right to restrict any pre-registered visitor at its discretion, even if the visitor’s badges have been issued and the registration fee paid.

5. Entry is not allowed for children below 18 years.

6. GJIIF 2023 IS A B2B TRADESHOW. SALES OR PURCHASE OVER THE COUNTER IS STRICTLY PROHIBITED.

7. Photography inside the exhibition is strictly prohibited. The organizer reserves the right to confiscate the gadget or camera used.

8. The organizer reserves the right to frisk the badge holder at the entrances, inside the exhibition halls, and at the exit for security reasons.

9. Badge must be worn and displayed prominently at all times during your stay at the exhibition site.

10. Badges will be issued upon your arrival at the pre-registration counters during exhibition hours.

11. The organizer does not take responsibility for the loss or theft of any personal belongings.

12. The consumption of banned substances is strictly prohibited within the exhibition venue.

13. The event is subject to force majeure conditions.

14. Carrying of bullion, bulk jewellery, or cash exceeding Rupees Fifty Thousand is STRICTLY NOT ALLOWED.

15. I hereby agree and accept the above Terms & Conditions and the Liability & Indemnity to visit GEM and Jewellery India International Fair 2023, organized from 29th Sept. to 1st Oct. 2023 at Chennai Trade Centre, Chennai. I also undertake that all the information and documents submitted by me/us along with this form are correct and true to the best of my knowledge.
''';

  String? termsContent;

  @override
  void onInit() {
    super.onInit();
    updateTerms();
  }

  void updateTerms() {
    termsContent = '';
    final newConfig = locator<AppConfigService>().config;
    if (newConfig.termsAndConditions != null &&
        newConfig.termsAndConditions!.isNotEmpty) {
      termsContent = newConfig.termsAndConditions;
    }
  }
}
