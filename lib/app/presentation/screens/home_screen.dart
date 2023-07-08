import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';
import 'package:quick_flashcards/app/presentation/logic/flashcards_logic/add_flashcard_notifier.dart';
import 'package:quick_flashcards/app/presentation/logic/flashcards_logic/get_flashcards_notifier.dart';
import 'package:quick_flashcards/app/presentation/widgets/back_flashcard.dart';
import 'package:quick_flashcards/app/presentation/widgets/card_color_picker.dart';
import 'package:quick_flashcards/app/presentation/widgets/front_flashcard.dart';

import '../../core/constants/string_constants.dart';
import '../../core/helpers/ui_helper.dart';
import '../../core/helpers/validators_helper.dart';
import '../widgets/app_textfield_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CardSwiperController _swiperController;
  late FlipCardController _flipController;

  @override
  void initState() {
    super.initState();
    _swiperController = CardSwiperController();
    _flipController = FlipCardController();
  }

  @override
  void dispose() {
    super.dispose();
    _swiperController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 26,
            horizontal: 16,
          ),
          child: Column(
            children: [
              // title section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Quick Flashcards",
                      style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => addFlashcard(),
                      child: const Icon(
                        Icons.add,
                        size: 28,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Consumer(
                builder: (context, ref, _) {
                  final flashcard = ref.watch(getFlashcardProv);

                  return flashcard.when(
                    data: (flashcard) {
                      return Expanded(
                        child: CardSwiper(
                          cardsCount: flashcard.length,
                          controller: _swiperController,
                          allowedSwipeDirection:
                              AllowedSwipeDirection.symmetric(
                            horizontal: true,
                          ),
                          numberOfCardsDisplayed: 3,
                          scale: 0.96,
                          backCardOffset: const Offset(14, 0),
                          padding: const EdgeInsets.only(
                            right: 22,
                            left: 6,
                          ),
                          cardBuilder: (context, index) {
                            final card = flashcard[index];
                            return FlipCard(
                              fill: Fill.fillBack,
                              direction: FlipDirection.HORIZONTAL,
                              side: CardSide.FRONT,
                              controller: _flipController,
                              front: FrontFlashcard(card: card!),
                              back: BackFlashcard(card: card),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Text(
                        "Something here 2",
                        style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                        ),
                      );
                    },
                    loading: () {
                      return Expanded(
                        child: Center(
                          child: UiHelpers.loader(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  subIcon(Icons.arrow_back_rounded, () {
                    _swiperController.swipeLeft();
                  }),
                  icon(Icons.close, AppColors.red, () {
                    _swiperController.swipeLeft();
                  }),
                  subIcon(Icons.flip_rounded, () {
                    _flipController.toggleCard();
                  }),
                  icon(Icons.check, AppColors.green, () {
                    _swiperController.swipeRight();
                  }),
                  subIcon(Icons.arrow_forward_rounded, () {
                    _swiperController.swipeRight();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget icon(IconData icon, Color iconColor, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 58,
        width: 58,
        child: Icon(
          icon,
          size: 28,
          color: iconColor,
        ),
      ),
    );
  }

  Widget subIcon(IconData icon, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGray,
          borderRadius: BorderRadius.circular(50),
        ),
        height: 50,
        width: 50,
        child: Icon(
          icon,
          size: 22,
          color: AppColors.white,
        ),
      ),
    );
  }

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  String? _selectedCardColor;

  final _key = GlobalKey<FormState>(debugLabel: 'add_flashcard');

  _addFlashcard(context, ref) async {
    final formState = _key.currentState!;

    final state = ref.watch(fcProvider);
    final notifier = ref.watch(fcProvider.notifier);

    try {
      if (formState.validate()) {
        formState.save();
        final result = await notifier.addFlashcard(
          _questionController.text,
          _answerController.text,
          _selectedCardColor ?? AppColors.cardGreen.toString(),
        );
        if (state != AddFlashcardState.success) {
          debugPrint('[UI AUTH ERROR] $result');
          // return AppSnackbar.error(context, result);
        } else {
          // Navigator.pushNamed(context, Routes.home);
        }
      }
    } catch (e) {
      debugPrint("${StringConstants.unknownError}: ${e.toString()}");
    }
  }

  // dialog box to add flashcard
  addFlashcard() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Add a Flashcard"),
                AppTextFieldWidget(
                  hintText: "Question",
                  controller: _questionController,
                  validator: (v) => ValidatorsHelper.def(v),
                  onSaved: (v) => _questionController.text = v!,
                ),
                AppTextFieldWidget(
                  hintText: "Answer",
                  controller: _answerController,
                  validator: (v) => ValidatorsHelper.def(v),
                  onSaved: (v) => _answerController.text = v!,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final cardColor in UiHelpers.cardColors)
                      CardColorPicker(
                        onTap: () {
                          _selectedCardColor = cardColor.toString();
                        },
                        cardColor: cardColor,
                        borderColor: _selectedCardColor == cardColor.toString()
                            ? Colors.black45
                            : Colors.transparent,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(fcProvider);

                    return FilledButton(
                      onPressed: () => _addFlashcard(context, ref),
                      child: state == AddFlashcardState.loading
                          ? UiHelpers.loader()
                          : const Text("Add Flashcard"),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
