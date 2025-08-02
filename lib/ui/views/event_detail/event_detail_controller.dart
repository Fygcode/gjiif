import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/event_detail.dart';
import 'package:tjw1/core/model/tjw/registered_visitor_list.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';
import 'package:tjw1/services/secure_storage_service.dart';

class EventDetailController extends GetxController {
  final dynamic eventId = Get.arguments;

  final Rx<EventDetails?> eventDetail = Rx<EventDetails?>(null);
  final RxList<PreRegistrationDetail> preRegistrationList =
      <PreRegistrationDetail>[].obs;

  final List<String> bannerImages = ['assets/EventScreen_GJIIF.png'];

  RxInt currentImageIndex = 0.obs;

  var isLoading = false.obs;

  String? gstNumber;
  String? mobileNumber;
  String? visitorId;

  @override
  void onInit() {
    print("EVENT-ID : $eventId");
    super.onInit();
    _loadGstFromStorage();
    fetchEventDetail();
  }

  Future<void> _loadGstFromStorage() async {
    gstNumber = await SecureStorageService().read("gst");
    mobileNumber = await SecureStorageService().read("mobileNumber");
    visitorId = await SecureStorageService().read("visitorID");
  }

  Future<void> fetchEventDetail() async {
    try {
      isLoading(true);
      final EventDetailResponse response =
          await ApiBaseService.request<EventDetailResponse>('Event/FetchEventDetails?EventID=$eventId',
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

  RxBool isVisitorListLoading = false.obs;

  final RxList<VisitorsList> registeredVisitorList = <VisitorsList>[].obs;
  final RxList<StatusList> statusList = <StatusList>[].obs;

  Future<bool> fetchRegisteredVisitorList({bool forceRefresh = false}) async {
    // if (registeredVisitorList.isNotEmpty && !forceRefresh) {
    //   return registeredVisitorList.isEmpty;
    // }

    try {
      isVisitorListLoading.value = true;

      final response = await ApiBaseService.request<RegisteredVisitorResponse>(
        'VisitorDetail/SelectVisitorToRegister?GSTN=$gstNumber&EventId=$eventId&StatusId=-1',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200") {
        registeredVisitorList.assignAll(response.registeredData?.visitorsList ?? []);
        statusList.assignAll(response.registeredData?.statusList ?? []);
        return registeredVisitorList.isEmpty;
      } else {
        return true;
      }
    } catch (e) {
      print("Error fetching visitor list: $e");
      return true;
    } finally {
      isVisitorListLoading.value = false;
    }
  }
}
