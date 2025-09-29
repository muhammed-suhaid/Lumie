import '../models/personality_result_model.dart';

class PersonalityResultsData {
  //************************* Personality Matches Map *************************//
  static final Map<String, List<String>> personalityMatches = {
    "INTJ": ["ENTP", "ENFP", "INFJ", "ENTJ"],
    "ENTP": ["INFJ", "INTJ", "ENFP", "ENTJ"],
    "INFJ": ["ENFP", "ENTP", "INTJ", "INFP"],
    "ENFP": ["INFJ", "INTJ", "ENTP", "ENFJ"],
    "ISTJ": ["ESFP", "ESTP", "ISFJ", "ESTJ"],
    "ISFJ": ["ESTP", "ESFP", "ISTJ", "ESFJ"],
    "ESTJ": ["ISFP", "ISTJ", "ESFJ", "ENTJ"],
    "ESFJ": ["ISFP", "ISTJ", "ENFP", "ESTJ"],
    "ISTP": ["ESFJ", "ESTJ", "ISFP", "INTP"],
    "ISFP": ["ESTJ", "ESFJ", "ISTP", "INFP"],
    "ESTP": ["ISFJ", "ISTJ", "ESFP", "ENTP"],
    "ESFP": ["ISTJ", "ISFJ", "ESTP", "ENFP"],
    "INFP": ["ENFJ", "INFJ", "ISFP", "ENFP"],
    "ENFJ": ["INFP", "ENFP", "INFJ", "ENTP"],
    "ENTJ": ["INTJ", "ENTP", "ENFJ", "ESTJ"],
    "INTP": ["ENTP", "INFJ", "ISTP", "INFP"],
  };

  static final List<PersonalityResult> results = [
    PersonalityResult(
      type: "INTJ",
      fullForm: "Introverted, Intuitive, Thinking, Judging",
      subtitle: "The Mastermind – strategic and independent thinker.",
      description:
          "INTJs are analytical visionaries who excel at long-term planning. "
          "They value knowledge, competence, and logical problem-solving. "
          "Independent and determined, they pursue their goals with focus.",
      strengths: ["Strategic", "Independent", "Determined", "Visionary"],
      weaknesses: [
        "Perfectionistic",
        "Overly critical",
        "Struggles with emotions",
      ],
      idealMatches: personalityMatches["INTJ"]!,
    ),
    PersonalityResult(
      type: "INTP",
      fullForm: "Introverted, Intuitive, Thinking, Perceiving",
      subtitle: "The Thinker – curious and analytical problem solver.",
      description:
          "INTPs are logical and imaginative, often diving deep into abstract ideas. "
          "They love exploring theories and solving complex problems. "
          "Independent and curious, they seek understanding above all.",
      strengths: ["Analytical", "Innovative", "Objective", "Independent"],
      weaknesses: ["Indecisive", "Overly abstract", "Can seem detached"],
      idealMatches: personalityMatches["INTP"]!,
    ),
    PersonalityResult(
      type: "ENTJ",
      fullForm: "Extraverted, Intuitive, Thinking, Judging",
      subtitle: "The Commander – confident and natural leader.",
      description:
          "ENTJs are bold leaders who thrive in organization and strategy. "
          "They excel at making decisions, setting goals, and inspiring others. "
          "Driven and confident, they push themselves and others to succeed.",
      strengths: ["Decisive", "Confident", "Efficient", "Charismatic leader"],
      weaknesses: ["Impatient", "Stubborn", "Insensitive under stress"],
      idealMatches: personalityMatches["ENTJ"]!,
    ),
    PersonalityResult(
      type: "ENTP",
      fullForm: "Extraverted, Intuitive, Thinking, Perceiving",
      subtitle: "The Debater – innovative and adaptable explorer.",
      description:
          "ENTPs are energetic and quick-witted, loving debates and new ideas. "
          "They thrive on challenges and brainstorming creative solutions. "
          "Adventurous and adaptable, they enjoy pushing boundaries.",
      strengths: ["Energetic", "Creative", "Adaptable", "Charismatic"],
      weaknesses: [
        "Easily distracted",
        "Argumentative",
        "Can lack follow-through",
      ],
      idealMatches: personalityMatches["ENTP"]!,
    ),
    PersonalityResult(
      type: "INFJ",
      fullForm: "Introverted, Intuitive, Feeling, Judging",
      subtitle: "The Advocate – insightful and empathetic guide.",
      description:
          "INFJs are deeply empathetic and value-driven. "
          "They are visionaries who often focus on helping others and creating harmony. "
          "They thrive on meaningful connections and personal growth.",
      strengths: ["Empathetic", "Visionary", "Creative", "Altruistic"],
      weaknesses: [
        "Perfectionistic",
        "Overly sensitive",
        "Can burn out easily",
      ],
      idealMatches: personalityMatches["INFJ"]!,
    ),
    PersonalityResult(
      type: "INFP",
      fullForm: "Introverted, Intuitive, Feeling, Perceiving",
      subtitle: "The Mediator – idealistic and reflective.",
      description:
          "INFPs are idealists who seek meaning and purpose in life. "
          "They are sensitive, compassionate, and creative thinkers. "
          "Driven by values, they strive for authenticity in everything they do.",
      strengths: ["Compassionate", "Idealistic", "Creative", "Open-minded"],
      weaknesses: ["Overly sensitive", "Avoids conflict", "Can be unrealistic"],
      idealMatches: personalityMatches["INFP"]!,
    ),
    PersonalityResult(
      type: "ENFJ",
      fullForm: "Extraverted, Intuitive, Feeling, Judging",
      subtitle: "The Protagonist – supportive and inspiring organizer.",
      description:
          "ENFJs are charismatic leaders who inspire others with passion and empathy. "
          "They value harmony and personal growth. "
          "Organized and people-focused, they motivate others to succeed.",
      strengths: ["Charismatic", "Supportive", "Organized", "Empathetic"],
      weaknesses: [
        "Overly idealistic",
        "Can be controlling",
        "Struggles with criticism",
      ],
      idealMatches: personalityMatches["ENFJ"]!,
    ),
    PersonalityResult(
      type: "ENFP",
      fullForm: "Extraverted, Intuitive, Feeling, Perceiving",
      subtitle: "The Campaigner – enthusiastic and imaginative creator.",
      description:
          "ENFPs are curious, energetic, and creative explorers. "
          "They thrive on possibilities, new ideas, and deep connections with others. "
          "Spontaneous and fun-loving, they inspire those around them.",
      strengths: ["Enthusiastic", "Creative", "Empathetic", "Adaptable"],
      weaknesses: [
        "Easily distracted",
        "Overcommits",
        "Struggles with routine",
      ],
      idealMatches: personalityMatches["ENFP"]!,
    ),
    PersonalityResult(
      type: "ISTJ",
      fullForm: "Introverted, Sensing, Thinking, Judging",
      subtitle: "The Inspector – responsible and dependable planner.",
      description:
          "ISTJs are practical and reliable individuals who value order and tradition. "
          "Detail-oriented and hardworking, they are committed to their responsibilities. "
          "They excel at creating stability and structure.",
      strengths: ["Responsible", "Dependable", "Organized", "Practical"],
      weaknesses: ["Rigid", "Struggles with change", "Can be overly cautious"],
      idealMatches: personalityMatches["ISTJ"]!,
    ),
    PersonalityResult(
      type: "ISFJ",
      fullForm: "Introverted, Sensing, Feeling, Judging",
      subtitle: "The Nurturer – caring and loyal supporter.",
      description:
          "ISFJs are gentle and dependable caregivers who prioritize others’ needs. "
          "They value tradition, harmony, and stability. "
          "Practical and responsible, they create warm and supportive environments.",
      strengths: ["Loyal", "Caring", "Practical", "Dependable"],
      weaknesses: ["Overly selfless", "Avoids conflict", "Can be too cautious"],
      idealMatches: personalityMatches["ISFJ"]!,
    ),
    PersonalityResult(
      type: "ESTJ",
      fullForm: "Extraverted, Sensing, Thinking, Judging",
      subtitle: "The Executive – efficient and organized doer.",
      description:
          "ESTJs are natural managers who value order, rules, and structure. "
          "They excel at organizing people and processes. "
          "Confident and practical, they ensure tasks are completed effectively.",
      strengths: ["Efficient", "Confident", "Organized", "Reliable"],
      weaknesses: ["Stubborn", "Insensitive", "Rigid"],
      idealMatches: personalityMatches["ESTJ"]!,
    ),
    PersonalityResult(
      type: "ESFJ",
      fullForm: "Extraverted, Sensing, Feeling, Judging",
      subtitle: "The Provider – friendly and cooperative helper.",
      description:
          "ESFJs are sociable and caring individuals who value harmony and community. "
          "They enjoy helping others and maintaining traditions. "
          "Warm and practical, they thrive in supportive roles.",
      strengths: ["Friendly", "Caring", "Practical", "Organized"],
      weaknesses: ["People-pleasing", "Overly sensitive", "Can avoid conflict"],
      idealMatches: personalityMatches["ESFJ"]!,
    ),
    PersonalityResult(
      type: "ISTP",
      fullForm: "Introverted, Sensing, Thinking, Perceiving",
      subtitle: "The Virtuoso – pragmatic and independent problem solver.",
      description:
          "ISTPs are hands-on and adaptable individuals who love solving practical problems. "
          "They are adventurous and prefer action over theory. "
          "Curious and logical, they enjoy experimenting and exploring.",
      strengths: ["Practical", "Logical", "Adaptable", "Independent"],
      weaknesses: ["Risk-taking", "Can be detached", "Struggles with routine"],
      idealMatches: personalityMatches["ISTP"]!,
    ),
    PersonalityResult(
      type: "ISFP",
      fullForm: "Introverted, Sensing, Feeling, Perceiving",
      subtitle: "The Adventurer – gentle and creative explorer.",
      description:
          "ISFPs are artistic, sensitive, and spontaneous. "
          "They value freedom and self-expression, often finding beauty in small details. "
          "Gentle and compassionate, they prefer to live in the moment.",
      strengths: ["Creative", "Gentle", "Flexible", "Observant"],
      weaknesses: ["Avoids conflict", "Overly reserved", "Can be indecisive"],
      idealMatches: personalityMatches["ISFP"]!,
    ),
    PersonalityResult(
      type: "ESTP",
      fullForm: "Extraverted, Sensing, Thinking, Perceiving",
      subtitle: "The Dynamo – energetic and adventurous risk-taker.",
      description:
          "ESTPs are thrill-seekers who thrive on action and excitement. "
          "They are adaptable, bold, and practical in problem-solving. "
          "Outgoing and spontaneous, they love living in the moment.",
      strengths: ["Energetic", "Bold", "Practical", "Adaptable"],
      weaknesses: ["Impulsive", "Risk-prone", "Can be insensitive"],
      idealMatches: personalityMatches["ESTP"]!,
    ),
    PersonalityResult(
      type: "ESFP",
      fullForm: "Extraverted, Sensing, Feeling, Perceiving",
      subtitle: "The Entertainer – playful and outgoing performer.",
      description:
          "ESFPs are lively, social, and spontaneous individuals. "
          "They love entertaining others and embracing new experiences. "
          "Warm and enthusiastic, they thrive in fun and dynamic environments.",
      strengths: ["Playful", "Outgoing", "Enthusiastic", "Sociable"],
      weaknesses: ["Impulsive", "Easily bored", "Struggles with planning"],
      idealMatches: personalityMatches["ESFP"]!,
    ),
  ];

  //************************* Helper Function *************************//
  static PersonalityResult getByType(String type) {
    return results.firstWhere(
      (result) => result.type == type,
      orElse: () => PersonalityResult(
        type: type,
        fullForm: "Unique personality",
        subtitle: "Unique personality type",
        description: "You have a unique personality!",
        strengths: ["Adaptable", "Creative"],
        weaknesses: ["Sometimes unpredictable"],
        idealMatches: ["Any type"],
      ),
    );
  }
}
