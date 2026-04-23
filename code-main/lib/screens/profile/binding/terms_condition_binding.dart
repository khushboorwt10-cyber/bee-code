import 'package:beecode/screens/profile/repository/terms_condition_repository.dart';
import 'package:beecode/screens/profile/viewmodel/terms_condition_viewmodel.dart';
import 'package:get/get.dart';


class TermsConditionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionRepository>(() => TermsConditionRepository());
    Get.lazyPut<TermsConditionViewModel>(
      () => TermsConditionViewModel(
        repository: Get.find<TermsConditionRepository>(),
      ),
    );
  }
}