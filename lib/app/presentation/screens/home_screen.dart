import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';
import 'package:quick_flashcards/app/presentation/logic/flashcards_logic/get_flashcards_notifier.dart';
import 'package:quick_flashcards/app/presentation/screens/add_flashcard_screen.dart';
import 'package:quick_flashcards/app/presentation/widgets/back_flashcard.dart';
import 'package:quick_flashcards/app/presentation/widgets/custom_sub_icon.dart';
import 'package:quick_flashcards/app/presentation/widgets/front_flashcard.dart';

import '../../core/helpers/ui_helper.dart';
import '../widgets/custom_icon.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddFlashcardScreen();
                          },
                        ),
                      ), // navigate to the add_flashcard screen
                      child: const Icon(
                        Icons.add,
                        size: 28,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
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
                            vertical: true,
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
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Something went wrong: $error",
                            style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
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
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomSubIcon(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => _swiperController.swipeLeft(),
                  ),
                  CustomIcon(
                    icon: Icons.close,
                    color: AppColors.red,
                    onTap: () => _swiperController.swipeLeft(),
                  ),
                  CustomSubIcon(
                    icon: Icons.flip_rounded,
                    onTap: () => _flipController.toggleCard(),
                  ),
                  CustomIcon(
                    icon: Icons.check,
                    color: AppColors.green,
                    onTap: () => _swiperController.swipeRight(),
                  ),
                  CustomSubIcon(
                    icon: Icons.arrow_forward_rounded,
                    onTap: () => _swiperController.swipeRight(),
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
