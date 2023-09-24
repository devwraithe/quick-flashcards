# 📑 Quick Flashcards
**Quick Flashcards** is a simple, cross-platform mobile application designed for creating flashcards quickly. It's built using Google Firebase Firestore for the backend and database system for storing and retrieving the flashcards, and Riverpod for the state management.

🎨 [Design Inspiration](https://dribbble.com/shots/8258284-Flashcards-x-Tinder)

## Previews
### List of Flashcards
https://github.com/devwraithe/quick-flashcards/assets/39105147/5178e723-69ad-4dc5-890c-2fc87df971a0

## Stacked Swipeable Cards
The stacked cards functionality is achieved by utilizing the flutter_cards_swiper package to accomplish a Tinder-like effect and using it's `cardBuilder` parameter to listen to the list of items returned from Firebase whenever the loading is successful, the `CardSwiper` widget also has additional useful parameters such as the `numberOfCardsDisplayed` which controls the number of cards in view at once. Here is the code with explanation in the comments:
```dart
/**
  The widget that handles the list of swipeable stacked cards.

  It handles the number of cards displayed based on the current length
  of the flashcardsList. For example, if the flashcardsList length is 1
  then only one card is shown in the `numberOfCardsDisplayed` parameter.
  This fix is added to avoid `RangeError`
**/
CardSwiper(
  cardsCount: notifier.flashcardsList!.length,
  controller: _swiperController,
  allowedSwipeDirection: AllowedSwipeDirection.symmetric(
    horizontal: true,
    vertical: true,
  ),
  numberOfCardsDisplayed: notifier.flashcardsList!.length == 1
    ? 1
    : notifier.flashcardsList!.length == 2
    ? 2
    : 3,
    scale: 0.96,
    backCardOffset: const Offset(14, 0),
    padding: const EdgeInsets.only(
      right: 22,
      left: 6,
    ),
    cardBuilder: (context, index) {
      final card = notifier.flashcardsList![index];

      return FlipCard(
        fill: Fill.fillBack,
        direction: FlipDirection.HORIZONTAL,
        side: CardSide.FRONT,
        controller: _flipController,
        front: FrontFlashcard(
          card: card,
          currentCard: index + 1,
          totalCards: notifier.flashcardsList!.length,
        ),
        back: BackFlashcard(
          card: card,
          currentCard: index + 1,
          totalCards: notifier.flashcardsList!.length,
        ),
      );
    },
  );
```
