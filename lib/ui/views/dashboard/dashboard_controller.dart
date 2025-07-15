
import 'package:get/get.dart';
class DashboardController extends GetxController {
  var isLoading = false.obs;  // Observable variable to track loading state



  @override
  void onInit() {
    super.onInit();
    print("INIT CALLED");
   // fetchInitialData(); // Fetch data when controller is initialized
  }

  // Function to handle tab changes
  // GetX automatically updates the UI based on these changes
  var selectedIndex = 0.obs;

  void onItemTapped(int index) {
    print("ONNNNNN $index");
    selectedIndex.value = index;  // Directly update the selected index (no setState needed)
  }

  // // Function to fetch initial data
  // void fetchInitialData() async {
  //   isLoading(true);  // Set loading to true
  //   try {
  //     UserResponse? response = await ApiBaseService.request<UserResponse>(
  //       'users?page=2',
  //       method: 'GET',
  //       authenticated: true,
  //     );
  //
  //     if (response.data!.isNotEmpty) {
  //       userList = response.data!;  // Update user list with fetched data
  //       print("======= $userList");
  //     } else {
  //       Fluttertoast.showToast(msg: 'No data found');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error: $e');  // Show error toast
  //   } finally {
  //     isLoading(false);  // Set loading to false after fetching data
  //   }
  // }
}
