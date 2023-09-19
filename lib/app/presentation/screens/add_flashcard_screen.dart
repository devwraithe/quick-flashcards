import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/data/card_model.dart';

import '../../core/helpers/ui_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/text_theme.dart';
import '../providers/flashcards_logic/add_flashcard_notifier.dart';
import '../widgets/flashcard_text_field.dart';

class AddFlashcardScreen extends StatefulWidget {
  final CardModel? cardModel;
  const AddFlashcardScreen({
    super.key,
    this.cardModel,
  });

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  final colors = [
    AppColors.cardGreen,
    AppColors.cardRed,
    AppColors.cardBlue,
    AppColors.cardYellow,
  ];
  Random random = Random();

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  _createFlashcard(context, CreateFlashcardNotifier notifier) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    int randomColor = random.nextInt(colors.length);
    Color randomItem = colors[randomColor];

    final result = await notifier.createFlashcard(
      _questionController.text,
      _answerController.text,
      randomItem.toString(),
    );
    if (result == CreateFlashcardState.success) {
      Navigator.pop(context, Routes.home);
    }
    if (result == CreateFlashcardState.failed) {
      return UiHelpers.errorFlush(notifier.error!, context);
    }

    // try {
    //   final result = await notifier.addFlashcard(
    //     _questionController.text,
    //     _answerController.text,
    //     randomItem.toString(),
    //   );
    //   if (result != "flashcard_created") {
    //     debugPrint("Unable to Add Flashcard: ${state.toString()}");
    //     showFlushbar(
    //       context: context,
    //       flushbar: Flushbar(
    //         title: "Unable to Add Flashcard",
    //       ),
    //     );
    //   } else {
    //     debugPrint("Flashcard Added!");
    //     Navigator.pop(context, Routes.home);
    //   }
    // } catch (e) {
    //   debugPrint("${StringConstants.unknownError}: ${e.toString()}");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  "Back",
                  style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(createFlashcardProvider);
                  final notifier = ref.watch(
                    createFlashcardProvider.notifier,
                  );

                  return FilledButton(
                    onPressed: () => _createFlashcard(context, notifier),
                    child: state == CreateFlashcardState.loading
                        ? UiHelpers.darkLoader()
                        : Text(
                            "Save",
                            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
