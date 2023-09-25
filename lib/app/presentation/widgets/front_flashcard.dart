import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/data/card_model.dart';

import 'card_content.dart';

class FrontFlashcard extends StatelessWidget {
  final CardModel card;
  final int? currentCard, totalCards;

  const FrontFlashcard({
    Key? key,
    required this.card,
    this.currentCard,
    this.totalCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: card.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.8),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 26,
      ),
      child: CardContent(
        title: "Question",
        value: card.question,
        counter: '${currentCard ?? "0"} of ${totalCards ?? "0"}',
      ),
    );
  }
}
