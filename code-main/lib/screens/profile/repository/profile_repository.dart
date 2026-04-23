import 'package:beecode/screens/profile/model/profile_model.dart';
import 'package:beecode/screens/utils/local_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProfileModel> fetchProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final User? user = _auth.currentUser;

    String name;
    String email;
    String? photo;

    if (user != null) {
      // ✅ Firebase user (Google / any Firebase auth)
      name  = user.displayName?.trim().isNotEmpty == true
          ? user.displayName!
          : _nameFromEmail(user.email);
      email = user.email ?? 'No email';
      photo = user.photoURL;
    } else {
      // ✅ Local user (email/password stored in SharedPreferences)
      final data = await LocalUserService.instance.getUser();
      name  = data['name']?.isNotEmpty == true
          ? data['name']!
          : _nameFromEmail(data['email']);
      email = data['email'] ?? 'No email';
      photo = data['photoUrl']?.isNotEmpty == true ? data['photoUrl'] : null;
    }

    return ProfileModel.fromJson({
      'name': name,
      'email': email,
      'photo': photo,
      'appVersion': 'Version 1.0.0',
      'menuItems': [
        {
          'id': 'profile',
          'label': 'Profile',
          'subItems': [
            'Personal Details',
            'Education',
            'Professional Experience',
            'Aspirations & Preferences',
          ],
        },
        {'id': 'applications', 'label': 'My Applications'},
      ],
      'streak': {
        'current': 0,
        'longest': 0,
        'dailyGoalMins': 10,
        'weeklyData': [
          [false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false],
          [false, false, false, false, false, false, false],
        ],
      },
      'stats': {
        'totalWatchMins': 1,
        'lessonsCompleted': 0,
        'questionsAttempted': 0,
        'testsAttempted': 0,
      },
      'achievements': [
        {
          'title': "Teachers' Day hat",
          'subtitle': "Happy Teachers'...",
          'imageUrl': null,
          'isLocked': false,
        },
        {
          'title': 'White Hat',
          'subtitle': '10 minutes',
          'imageUrl': null,
          'isLocked': true,
        },
      ],
    });
  }

  String _nameFromEmail(String? email) {
    if (email == null || email.isEmpty) return 'User';
    return email
        .split('@')
        .first
        .replaceAll(RegExp(r'[._]'), ' ')
        .split(' ')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}