import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/event_detail.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';


class EventDetailController extends GetxController {
  final dynamic eventId = Get.arguments;

  final Rx<EventDetails?> eventDetail = Rx<EventDetails?>(null);
  final RxList<PreRegistrationDetail> preRegistrationList = <PreRegistrationDetail>[].obs;

  final List<String> bannerImages = [
    'assets/EventScreen_GJIIF.png',
  ];

  RxInt currentImageIndex = 0.obs;

  var isLoading = false.obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchEventDetail();
  }


  Future<void> fetchEventDetail() async {
    try {
      isLoading(true);
      final EventDetailResponse response = await ApiBaseService.request<EventDetailResponse>(
        'Event/FetchEventDetails?EventID=$eventId',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        final data = response.eventData;

        eventDetail.value = data?.eventDetails;
        preRegistrationList.assignAll(data?.preRegistrationDetail ?? []);
      }
    } catch (e) {
      print('Error fetching event detail: $e');
    } finally {
      isLoading(false);
    }
  }


}
