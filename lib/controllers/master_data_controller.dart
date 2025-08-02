import 'package:get/get.dart';
import 'package:tjw1/core/model/tjw/designation_response.dart';
import 'package:tjw1/core/model/tjw/fetch_company_type.dart';
import 'package:tjw1/core/model/tjw/stateList.dart';
import 'package:tjw1/services/api_base_service.dart';
import 'package:tjw1/services/request_method.dart';

class MasterDataController extends GetxController {
  RxList<CompanyTypeData> companyTypes = <CompanyTypeData>[].obs;
  RxList<StateData> states = <StateData>[].obs;
  RxList<DesignationData> designations = <DesignationData>[].obs;

  RxBool isLoading = false.obs;

  // Call this once at app start
  Future<void> loadInitialData() async {
    print("loadInitialData CALLED");
    try {
      isLoading(true);
      final results = await Future.wait([
        fetchCompanyType(),
        fetchStateList(),
        fetchDesignation(),
      ]);

      companyTypes.assignAll(results[0] as List<CompanyTypeData>);
      states.assignAll(results[1] as List<StateData>);
      designations.assignAll(results[2] as List<DesignationData>);
    } catch (e) {
      print("Error loading master data: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fetch Company Type
  Future<List<CompanyTypeData>> fetchCompanyType() async {
    try {
      FetchCompanyType response = await ApiBaseService.request<FetchCompanyType>(
        'CompanyDetails/FetchCompanyType',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.status == "200" && response.companyTypeData != null) {
        return response.companyTypeData!;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching company types: $e');
      return [];
    }
  }

  // Fetch State List
  Future<List<StateData>> fetchStateList() async {
    try {
      StateList response = await ApiBaseService.request<StateList>(
        'SQ/GetStateList',
        method: RequestMethod.GET,
        authenticated: false,
      );

      if (response.response?.status == "200" && response.stateData != null) {
        return response.stateData!;
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching state list: $e');
      return [];
    }
  }

  Future<List<DesignationData>> fetchDesignation() async {
    final response = await ApiBaseService.request<DesignationResponse>(
      'SQ/GetDesignationList',
      method: RequestMethod.GET,
      authenticated: false,
    );
    return response.data ?? [];
  }
}
