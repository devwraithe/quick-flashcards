import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/data/card_model.dart';

import 'card_content.dart';

class FrontFlashcard extends StatelessWidget {
  final CardModel card;

  const FrontFlashcard({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
        counter: '1/20',
      ),
    );
  }
}
