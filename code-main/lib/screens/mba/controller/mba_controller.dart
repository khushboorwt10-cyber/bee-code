
import 'dart:ui';

import 'package:beecode/screens/mba/model/mba_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MbaCoursesController extends GetxController {
  final RxList<MbaCourse> courses = <MbaCourse>[
    MbaCourse(
      universityLogo:
          'https://upload.wikimedia.org/wikipedia/en/thumb/4/44/Liverpool_John_Moores_University_logo.svg/200px-Liverpool_John_Moores_University_logo.svg.png',
      universityName: 'Liverpool Business School',
      title: 'MBA from Liverpool Business School',
      badge: 'Bestseller',
      badgeColor: Color(0xFF6B21A8),
      degreeType: "Master's Degree",
      duration: '18 Months',
      tag: 'Integrated with GenAI modules',
    ),
    MbaCourse(
      universityLogo:
          'https://upload.wikimedia.org/wikipedia/en/thumb/6/6d/Golden_Gate_University_seal.svg/200px-Golden_Gate_University_seal.svg.png',
      universityName: 'Golden Gate University',
      title: 'MBA from Golden Gate University',
      badge: 'Popular',
      badgeColor: Color(0xFFD97706),
      degreeType: "Master's Degree",
      duration: '24 Months',
    ),
    MbaCourse(
      universityLogo:
          'https://cdn-icons-png.flaticon.com/512/3135/3135789.png',
      universityName: 'Global Business School',
      title: 'Executive MBA – Global Track',
      degreeType: "Master's Degree",
      duration: '12 Months',
      tag: 'Live sessions + recordings',
    ),
  ].obs;

  // Hero stats
  final String learnerCount = '10k+';
  final String avgPayHike = '46%';
  final String topPayHike = '233%';
}
