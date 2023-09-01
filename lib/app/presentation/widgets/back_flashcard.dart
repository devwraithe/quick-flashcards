import 'package:flutter/material.dart';
import 'package:quick_flashcards/app/data/card_model.dart';

import '../../core/theme/app_colors.dart';
import 'card_content.dart';

class BackFlashcard extends StatelessWidget {
  final CardModel card;

  const BackFlashcard({
    Key? key,
    required this.card,
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
        title: "Answer",
        value: card.answer,
        counter: '1/20',
      ),
    );
  }
}
