import 'package:flutter/material.dart';
import 'package:lumie/dummyData/personality_quiz_data.dart';
import 'package:lumie/models/personality_quiz_model.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/utils/custom_snakbar.dart';
import 'package:lumie/widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PersonalityQuizScreen extends StatefulWidget {
  const PersonalityQuizScreen({super.key});

  @override
  State<PersonalityQuizScreen> createState() => _PersonalityQuizScreenState();
}

class _PersonalityQuizScreenState extends State<PersonalityQuizScreen> {
  int _currentIndex = 0;
  late List<QuizQuestion> _questions;

  //************************* initState method *************************//
  @override
  void initState() {
    super.initState();
    _questions = PersonalityQuizData.questions;
  }

  //************************* _selectOption method *************************//
  void _selectOption(String optionId) {
    setState(() {
      _questions[_currentIndex] = _questions[_currentIndex].copyWith(
        selectedOptionId: optionId,
      );
    });
  }

  //************************* _nextQuestion method *************************//
  void _nextQuestion() {
    if (_questions[_currentIndex].selectedOptionId == null) {
      CustomSnackbar.show(context, "Please select an option to continue");
      return;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishQuiz();
    }
  }

  //************************* _previousQuestion method *************************//
  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  //************************* _finishQuiz method *************************//
  void _finishQuiz() {
    int eScore = 0, sScore = 0, tScore = 0, jScore = 0;

    for (var q in _questions) {
      final selected = q.options.firstWhere(
        (o) => o.id == q.selectedOptionId,
        orElse: () => QuizOption(id: '', text: '', score: 0),
      );

      if (["q1", "q2", "q3", "q4"].contains(q.id)) eScore += selected.score;
      if (["q5", "q6", "q7", "q8"].contains(q.id)) sScore += selected.score;
      if (["q9", "q10", "q11", "q12"].contains(q.id)) tScore += selected.score;
      if (["q13", "q14", "q15", "q16"].contains(q.id)) jScore += selected.score;
    }

    String mbti = "";
    mbti += eScore >= 0 ? "E" : "I";
    mbti += sScore >= 0 ? "S" : "N";
    mbti += tScore >= 0 ? "T" : "F";
    mbti += jScore >= 0 ? "J" : "P";

    debugPrint(mbti);
    //TODO: Go to  result screen
  }

  //************************* Body *************************//
  //************************* Body *************************//
  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kPaddingL),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              //************************* title *************************//
              Text(
                AppTexts.personalityQuizTitle,
                style: TextStyle(
                  fontSize: AppConstants.kFontSizeXXL,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.secondary,
                ),
              ),
              const SizedBox(height: AppConstants.kPaddingS),
              //************************* Question Number *************************//
              Text(
                "Question ${_currentIndex + 1} of ${_questions.length}",
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeM,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              //************************* LinearProgressIndicator *************************//
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
              ),
              SizedBox(height: screenHeight * 0.04),
              //************************* Question *************************//
              Text(
                question.question,
                style: GoogleFonts.poppins(
                  fontSize: AppConstants.kFontSizeL,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              //************************* Option Buttons *************************//
              Expanded(
                child: ListView.builder(
                  itemCount: question.options.length,
                  itemBuilder: (context, index) {
                    final option = question.options[index];
                    final isSelected = question.selectedOptionId == option.id;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: CustomSelectableTile(
                        label: option.text,
                        selected: isSelected,
                        onTap: () => _selectOption(option.id),
                      ),
                    );
                  },
                ),
              ),
              //************************* Next & Previous Buttons *************************//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentIndex > 0)
                    CustomButton(
                      text: "Previous",
                      type: ButtonType.secondary,
                      width: (screenWidth) /3,
                      onPressed: _previousQuestion,
                    ),
                  const SizedBox(width: 10),
                  CustomButton(
                    text: _currentIndex == _questions.length - 1
                        ? "Finish"
                        : "Next",
                    type: ButtonType.secondary,
                    width: (screenWidth) / 3,
                    onPressed: _nextQuestion,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
