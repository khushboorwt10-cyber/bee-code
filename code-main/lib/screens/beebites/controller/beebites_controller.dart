import 'package:beecode/screens/beebites/model/beebites_model.dart';
import 'package:beecode/screens/utils/images.dart';
import 'package:get/get.dart';

class BeeBitesController extends GetxController {

  final RxInt selectedIndex = 0.obs;


  final RxSet<String> likedIds = <String>{}.obs;

  final List<BeeBitesModel> reels = [
    BeeBitesModel(
      id: '1',
      videoUrl: AppImages.mam_small,
      authorName: 'BeeCode Team',
      title: 'Flutter for Beginners – Build your first app from scratch 🚀',
      likes: '1.2K',
      views: '8.4K',
      duration: '0:45',
    ),
    BeeBitesModel(
      id: '2',
      videoUrl: AppImages.mam_small,
      authorName: 'BeeCode Team',
      title: 'GetX State Management made simple ⚡',
      likes: '984', 
      views: '5.1K',
      duration: '0:38',
    ),
    BeeBitesModel(
      id: '3',
      videoUrl: AppImages.mam_small,
      authorName: 'BeeCode Team',
      title: 'Dart Streams & Futures – async programming deep dive 🎯',
      likes: '2.3K',
      views: '12.7K',
      duration: '1:02',
    ),
    BeeBitesModel(
      id: '4',
      videoUrl: AppImages.mam_small,
      authorName: 'BeeCode Team',
      title: 'Firebase Auth & Firestore in Flutter 🔥',
      likes: '3.1K',
      views: '18.2K',
      duration: '0:55',
    ),
    BeeBitesModel(
      id: '5',
      videoUrl:AppImages.mam_small,
      authorName: 'BeeCode Team',
      title: 'Flutter Animations – Hero, Lottie & custom painters 🎨',
      likes: '756',
      views: '4.3K',
      duration: '0:41',
    ),
  ];

  void selectReel(int index) {
    selectedIndex.value = index;
  }

  void toggleLike(String id) {
    if (likedIds.contains(id)) {
      likedIds.remove(id);
    } else {
      likedIds.add(id);
    }
  }
}