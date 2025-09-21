import 'package:flutter/material.dart';
import 'package:lumie/utils/app_constants.dart';
import 'package:lumie/utils/app_texts.dart';
import 'package:lumie/widgets/custom_selectable_tile.dart';

class PreferenceInterestsPage extends StatefulWidget {
  final List<String> selectedInterests;
  final ValueChanged<List<String>> onChanged;

  const PreferenceInterestsPage({
    super.key,
    required this.selectedInterests,
    required this.onChanged,
  });

  @override
  State<PreferenceInterestsPage> createState() =>
      _PreferenceInterestsPageState();
}

class _PreferenceInterestsPageState extends State<PreferenceInterestsPage> {
  late List<String> _selected;
  // sample categories
  final Map<String, List<String>> _categories = {
    "Hobbies": [
      "Photography",
      "Gaming",
      "Cooking",
      "Reading",
      "Gardening",
      "DIY",
    ],
    "Fitness": ["Yoga", "Gym", "Running", "Cycling", "Hiking"],
    "Music & Arts": ["Concerts", "Painting", "Singing", "Instruments"],
    "Food": ["Vegan", "Street Food", "Fine Dining", "Baking", "Coffee"],
    "Travel": [
      "Backpacking",
      "Beach",
      "Mountain",
      "Road Trips",
      "Cultural Travel",
    ],
  };
  //************************* initState Method *************************//
  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedInterests);
  }

  //************************* _toggle Method *************************//
  void _toggle(String interest) {
    setState(() {
      if (_selected.contains(interest)) {
        _selected.remove(interest);
      } else {
        _selected.add(interest);
      }
      widget.onChanged(_selected);
    });
  }

  //************************* _chip Widget *************************//
  Widget _chip(String label) {
    final isSelected = _selected.contains(label);
    return CustomSelectableTile(
      label: label,
      selected: isSelected,
      onTap: () => _toggle(label),
      height: 36,
      isFullWidth: false,
    );
  }

  //************************* Body *************************//
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //************************* Title *************************//
          Text(
            AppTexts.preferenceInterestTitle,
            style: TextStyle(
              fontSize: AppConstants.kFontSizeXXL,
              fontWeight: FontWeight.bold,
              color: colorScheme.secondary,
            ),
          ),
          const SizedBox(height: AppConstants.kPaddingM),

          //************************* Selected display *************************//
          if (_selected.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selected.map((s) => Chip(label: Text(s))).toList(),
            ),

          const SizedBox(height: AppConstants.kPaddingM),

          //************************* All interests list *************************//
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _categories.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppConstants.kPaddingL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Name
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: AppConstants.kFontSizeL,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppConstants.kPaddingS),
                        // Chips
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: entry.value.map(_chip).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
