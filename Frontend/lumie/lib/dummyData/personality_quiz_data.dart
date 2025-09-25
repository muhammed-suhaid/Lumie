import 'package:lumie/models/personality_quiz_model.dart';

//************************* Standard 5-point options *************************//
final standardOptions = [
  QuizOption(id: "o1", text: "Strongly Agree", score: 2),
  QuizOption(id: "o2", text: "Agree", score: 1),
  QuizOption(id: "o3", text: "Neutral", score: 0),
  QuizOption(id: "o4", text: "Disagree", score: -1),
  QuizOption(id: "o5", text: "Strongly Disagree", score: -2),
];

//************************* Reverse scoring options *************************//
List<QuizOption> reversedOptions() {
  return standardOptions
      .map((o) => QuizOption(id: o.id, text: o.text, score: -o.score))
      .toList();
}

class PersonalityQuizData {
  static final List<QuizQuestion> questions = [
    //************************* Extraversion / Introversion (E/I) *************************//
    QuizQuestion(
      id: "q1",
      question: "I enjoy social gatherings and meeting new people.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q2",
      question: "I prefer spending time alone rather than in a crowd.",
      options: reversedOptions(),
    ),
    QuizQuestion(
      id: "q3",
      question: "I like being the center of attention.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q4",
      question: "I enjoy quiet activities alone or with a few people.",
      options: reversedOptions(),
    ),

    //************************* Sensing / Intuition (S/N) *************************//
    QuizQuestion(
      id: "q5",
      question: "I focus on facts and details rather than abstract ideas.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q6",
      question: "I enjoy thinking about possibilities and abstract concepts.",
      options: reversedOptions(),
    ),
    QuizQuestion(
      id: "q7",
      question: "I prefer practical solutions over imaginative ideas.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q8",
      question: "I like exploring abstract theories and concepts.",
      options: reversedOptions(),
    ),

    //************************* Thinking / Feeling (T/F) *************************//
    QuizQuestion(
      id: "q9",
      question: "I make decisions with my head rather than my heart.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q10",
      question: "I consider others’ feelings when making decisions.",
      options: reversedOptions(),
    ),
    QuizQuestion(
      id: "q11",
      question: "I value logic and fairness over personal feelings.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q12",
      question: "I am empathetic and sensitive to others’ emotions.",
      options: reversedOptions(),
    ),

    //************************* Judging / Perceiving (J/P) *************************//
    QuizQuestion(
      id: "q13",
      question: "I prefer planning everything in advance.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q14",
      question: "I enjoy being spontaneous and flexible.",
      options: reversedOptions(),
    ),
    QuizQuestion(
      id: "q15",
      question: "I like to follow schedules and deadlines.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q16",
      question: "I enjoy improvising and adapting to unexpected situations.",
      options: reversedOptions(),
    ),

    //************************* Mix for more balance *************************//
    QuizQuestion(
      id: "q17",
      question: "I am energized by being around people.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q18",
      question: "I prefer working quietly alone rather than in groups.",
      options: reversedOptions(),
    ),
    QuizQuestion(
      id: "q19",
      question: "I enjoy organizing tasks and planning carefully.",
      options: standardOptions,
    ),
    QuizQuestion(
      id: "q20",
      question: "I like improvising and going with the flow.",
      options: reversedOptions(),
    ),
  ];
}
