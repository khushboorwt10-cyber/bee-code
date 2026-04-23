class ProfileModel {
  final String name;
  final String email;
  final String avatarInitial;
  final String? photoUrl;
  final String appVersion;
  final List<ProfileMenuItem> menuItems;
  // final StreakModel streak;
  final StatsModel stats;
  final List<AchievementModel> achievements;

  ProfileModel({
    required this.name,
    required this.email,
    required this.avatarInitial,
    this.photoUrl,
    required this.appVersion,
    required this.menuItems,
    // required this.streak,
    required this.stats,
    required this.achievements,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    return ProfileModel(
      name: name,
      email: json['email'] as String,
      avatarInitial: name.isNotEmpty ? name[0].toUpperCase() : 'U',
      photoUrl: json['photo'] as String?,
      appVersion: json['appVersion'] as String,
      menuItems: (json['menuItems'] as List)
          .map((e) => ProfileMenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      // streak: StreakModel.fromJson(json['streak'] as Map<String, dynamic>),
      stats: StatsModel.fromJson(json['stats'] as Map<String, dynamic>),
      achievements: (json['achievements'] as List)
          .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfileMenuItem {
  final String id;
  final String label;
  final List<String>? subItems;

  ProfileMenuItem({required this.id, required this.label, this.subItems});

  factory ProfileMenuItem.fromJson(Map<String, dynamic> json) {
    return ProfileMenuItem(
      id: json['id'] as String,
      label: json['label'] as String,
      subItems: json['subItems'] != null
          ? List<String>.from(json['subItems'] as List)
          : null,
    );
  }
}

// class StreakModel {
//   final int current;
//   final int longest;
//   final int dailyGoalMins;
//   final List<List<bool>> weeklyData;

//   StreakModel({
//     required this.current,
//     required this.longest,
//     required this.dailyGoalMins,
//     required this.weeklyData,
//   });

//   factory StreakModel.fromJson(Map<String, dynamic> json) {
//     return StreakModel(
//       current: json['current'] as int,
//       longest: json['longest'] as int,
//       dailyGoalMins: json['dailyGoalMins'] as int,
//       weeklyData: (json['weeklyData'] as List)
//           .map((week) => List<bool>.from(week as List))
//           .toList(),
//     );
//   }
// }

class StatsModel {
  final int totalWatchMins;
  final int lessonsCompleted;
  final int questionsAttempted;
  final int testsAttempted;

  StatsModel({
    required this.totalWatchMins,
    required this.lessonsCompleted,
    required this.questionsAttempted,
    required this.testsAttempted,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalWatchMins: json['totalWatchMins'] as int,
      lessonsCompleted: json['lessonsCompleted'] as int,
      questionsAttempted: json['questionsAttempted'] as int,
      testsAttempted: json['testsAttempted'] as int,
    );
  }
}

class AchievementModel {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final bool isLocked;

  AchievementModel({
    required this.title,
    required this.subtitle,
    this.imageUrl,
    required this.isLocked,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      imageUrl: json['imageUrl'] as String?,
      isLocked: json['isLocked'] as bool,
    );
  }
}