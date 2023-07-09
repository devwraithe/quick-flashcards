import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/presentation/screens/home_screen.dart';

import '../../core/constants/string_constants.dart';
import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../logic/flashcards_logic/add_flashcard_notifier.dart';
import '../widgets/card_color_picker.dart';
import '../widgets/flashcard_text_field.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  Color? selectedColor;
  String? _selectedCardColor;

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  _addFlashcard(context, ref) async {
    final state = ref.watch(fcProvider);
    final notifier = ref.watch(fcProvider.notifier);

    try {
      final result = await notifier.addFlashcard(
        _questionController.text,
        _answerController.text,
        _selectedCardColor ?? AppColors.cardGreen.toString(),
      );
      if (state != AddFlashcardState.success) {
        debugPrint('[UI AUTH ERROR] $result');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return const HomeScreen();
            },
          ),
        );
        // return AppSnackbar.error(context, result);
      } else {
        // Navigator.pushNamed(context, Routes.home);
      }
    } catch (e) {
      debugPrint("${StringConstants.unknownError}: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedColor ?? AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 20,
          ),
          child: Column(
            children: [
              // title section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Back",
                    style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final state = ref.watch(fcProvider);

                      return GestureDetector(
                        onTap: () => _addFlashcard(context, ref),
                        child: state == AddFlashcardState.loading
                            ? UiHelpers.loader()
                            : Text(
                                "Save",
                                style:
                                    AppTextTheme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 62),
              FlashcardTextField(
                label: "Question",
                hint: "Who was the first human being to visit space?",
                controller: _questionController,
              ),
              FlashcardTextField(
                label: "Answer",
                hint: "Yuri Gagarin",
                controller: _answerController,
              ),
              const SizedBox(height: 62),
              Row(
                children: [
                  for (final cardColor in UiHelpers.cardColors)
                    selectedColor == cardColor
                        ? const SizedBox()
                        : CardColorPicker(
                            onTap: () {
                              setState(() {
                                selectedColor = cardColor;
                              });
                              _selectedCardColor = cardColor.toString();
                            },
                            cardColor: cardColor,
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
