class PersonalityResult {
  final String type;
  final String fullForm;
  final String subtitle;
  final String description;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> idealMatches;

  PersonalityResult({
    required this.type,
    required this.fullForm,
    required this.subtitle,
    required this.description,
    required this.strengths,
    required this.weaknesses,
    required this.idealMatches,
  });
}
