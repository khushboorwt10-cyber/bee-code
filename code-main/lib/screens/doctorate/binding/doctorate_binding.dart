import 'package:beecode/screens/doctorate/controller/doctorate_courses_controller.dart';
import 'package:get/get.dart';

class DoctorateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorateController>(() => DoctorateController());
  }
}