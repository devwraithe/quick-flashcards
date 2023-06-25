import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:quick_flashcards/core/app_colors.dart';
import 'package:quick_flashcards/presentation/widgets/back_flashcard.dart';
import 'package:quick_flashcards/presentation/widgets/front_flashcard.dart';

import '../data/data_list.dart';

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
    final textTheme = Theme.of(context).textTheme;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.close,
                        size: 22,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 24),
                      Container(
                        margin: const EdgeInsets.only(top: 0.6),
                        child: Text(
                          "Flashcards",
                          style: textTheme.titleLarge?.copyWith(
                            color: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.add,
                    size: 24,
                    color: AppColors.white,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: CardSwiper(
                  cardsCount: cards.length,
                  controller: _swiperController,
                  allowedSwipeDirection: AllowedSwipeDirection.symmetric(
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
                    final card = cards[index];
                    return FlipCard(
                      fill: Fill.fillBack,
                      direction: FlipDirection.HORIZONTAL,
                      side: CardSide.FRONT,
                      controller: _flipController,
                      front: FrontFlashcard(card: card),
                      back: BackFlashcard(card: card),
                    );
                  },
                ),
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
}
