import 'package:flutter/material.dart';

import '../../core/routes/routes.dart';
import '../../core/theme/text_theme.dart';
import '../../core/utilities/helpers/ui_helper.dart';
import '../../data/card_model.dart';
import '../notifiers/flashcard_notifiers/delete_card_notifier.dart';
import '../widgets/custom_sub_icon.dart';
import '../widgets/front_flashcard.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({
    super.key,
    required this.card,
  });

  final CardModel card;

  _deleteCard(context, DeleteCardNotifier notifier, String cardId) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final result = await notifier.deleteCard(cardId);
    if (result == DeleteCardState.success) {
      Navigator.pop(context, Routes.home);
    }
    if (result == DeleteCardState.failed) {
      return UiHelpers.errorFlush(notifier.error!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const textTheme = AppTextTheme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Hero(
                tag: card.id,
                child: FrontFlashcard(
                  card: card,
                  currentCard: 0,
                  totalCards: 0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomSubIcon(
                  icon: Icons.arrow_back_rounded,
                  onTap: () {},
                ),
                CustomSubIcon(
                  icon: Icons.arrow_forward_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
