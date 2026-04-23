import 'package:beecode/screens/profile/repository/privacy_policy_repository.dart';
import 'package:beecode/screens/profile/viewmodel/privacy_policy_viewmodel.dart';
import 'package:get/get.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyRepository>(() => PrivacyPolicyRepository());
    Get.lazyPut<PrivacyPolicyViewModel>(
      () => PrivacyPolicyViewModel(
        repository: Get.find<PrivacyPolicyRepository>(),
      ),
    );
  }
}