class AbilityScores {
  final int explosive;
  final int speed;
  final int precision;
  final int endurance;
  final int flexibility;
  final int stability;
  final int? iq;

  AbilityScores({
    required this.explosive,
    required this.speed,
    required this.precision,
    required this.endurance,
    required this.flexibility,
    required this.stability,
    this.iq,
  });

  factory AbilityScores.fromJson(Map<String, dynamic> json) {
    return AbilityScores(
      explosive: json['explosive'] ?? 0,
      speed: json['speed'] ?? 0,
      precision: json['precision'] ?? 0,
      endurance: json['endurance'] ?? 0,
      flexibility: json['flexibility'] ?? 0,
      stability: json['stability'] ?? 0,
      iq: json['iq'],
    );
  }
}

class SkillDetails {
  final int passAccuracy;
  final int shootAccuracy;
  final int dribbleSuccess;
  final int trapQuality;

  SkillDetails({
    required this.passAccuracy,
    required this.shootAccuracy,
    required this.dribbleSuccess,
    required this.trapQuality,
  });

  factory SkillDetails.fromJson(Map<String, dynamic> json) {
    return SkillDetails(
      passAccuracy: json['pass_accuracy'] ?? 0,
      shootAccuracy: json['shoot_accuracy'] ?? 0,
      dribbleSuccess: json['dribble_success'] ?? 0,
      trapQuality: json['trap_quality'] ?? 0,
    );
  }
}

class Report {
  final int overallScore;
  final String level;
  final AbilityScores abilityScores;
  final List<String> highlights;
  final List<String> suggestions;
  final SkillDetails? skillDetails;

  Report({
    required this.overallScore,
    required this.level,
    required this.abilityScores,
    required this.highlights,
    required this.suggestions,
    this.skillDetails,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      overallScore: json['overall_score'] ?? 0,
      level: json['level'] ?? '',
      abilityScores: AbilityScores.fromJson(json['ability_scores'] ?? {}),
      highlights: List<String>.from(json['highlights'] ?? []),
      suggestions: List<String>.from(json['suggestions'] ?? []),
      skillDetails: json['skill_details'] != null
          ? SkillDetails.fromJson(json['skill_details'])
          : null,
    );
  }
}