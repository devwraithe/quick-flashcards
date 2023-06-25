import 'package:flutter/material.dart';
import 'package:quick_flashcards/data/card_model.dart';

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
