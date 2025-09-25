class QuizQuestion {
  final String id;
  final String question;
  final List<QuizOption> options;
  final String? selectedOptionId;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    this.selectedOptionId,
  });

  // Copy with method to update selected option
  QuizQuestion copyWith({String? selectedOptionId}) {
    return QuizQuestion(
      id: id,
      question: question,
      options: options,
      selectedOptionId: selectedOptionId ?? this.selectedOptionId,
    );
  }
}

class QuizOption {
  final String id;
  final String text;
  final int score;

  QuizOption({required this.id, required this.text, this.score = 0});
}
