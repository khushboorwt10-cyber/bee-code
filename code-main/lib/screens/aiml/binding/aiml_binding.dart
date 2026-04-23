import 'package:beecode/screens/aiml/controller/aiml_controller.dart';
import 'package:get/get.dart';


class AiCoursesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiCoursesController>(() => AiCoursesController());
  }
}