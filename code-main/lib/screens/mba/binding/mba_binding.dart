import 'package:beecode/screens/mba/controller/mba_controller.dart';
import 'package:get/get.dart';

class MbaCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MbaCoursesController>(() => MbaCoursesController());
  }
}