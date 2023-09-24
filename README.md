# 📑 Quick Flashcards
**Quick Flashcards** is a simple, cross-platform mobile application designed for creating flashcards quickly. It's built using Google Firebase Firestore for the backend and database system for storing and retrieving the flashcards, and Riverpod for the state management.

🎨 [Design Inspiration](https://dribbble.com/shots/8258284-Flashcards-x-Tinder)

## Table of Contents
- [Getting Started](#getting-started)
- [Preview](#preview)
- [Swipeable Stacked Cards](#swipeable-stacked-cards)
- [Flip Card Functionality](#flip-card-functionality)

## Getting Started

### Installation

**1. Clone the Repository:** Open your terminal and clone the "Quick Flashcards" repository to your local machine:

```sh
$ git clone https://github.com/devwraithe/quick-flashcards
```

**2. Navigate to the Project Folder:** Change your working directory to the project folder:

```
$ cd quick-flashcards
```

**3. Install the Dependencies:** Install the project's dependencies using **pub** (Dart Package Manager):

```sh
$ flutter pub get
```

### Usage

To run and use the application, ensure you have either an emulator or a mobile device connected to your IDE. **[Here](https://developer.android.com/design-for-safety/privacy-sandbox/download#:~:text=Set%20up%20an%20Android%20device%20emulator%20image,-To%20set%20up&text=In%20Android%20Studio%2C%20go%20to,it%20isn't%20already%20installed.)** is a guide from the Android Developers' documentation to help you set up a device or an emulator.

**1. Run the Application:** To start the "Quick Flashcards" application, run the following command:

```sh
$ flutter run
```

## Preview
### List of Flashcards
https://github.com/devwraithe/quick-flashcards/assets/39105147/5178e723-69ad-4dc5-890c-2fc87df971a0

## Swipeable Stacked Cards
I've implemented swipeable stacked cards using the **[flutter_card_swiper](https://pub.dev/packages/flutter_card_swiper)** package to provide an engaging user experience reminiscent of popular apps like Tinder. This feature enhances the app's usability and interactivity by offering a fun and intuitive card interface.

### How it works
The core of this functionality is the CardSwiper widget, a crucial component of the **flutter_card_swiper** package. It's responsible for managing our stack of swipeable cards and offers various customization options to fine-tune its behavior.
```dart
/// The `CardSwiper` widget is at the heart of our swipeable card stack.
/// It dynamically adjusts the number of displayed cards based on the length
/// of the flashcardsList to prevent potential `RangeError` issues.
CardSwiper(
  cardsCount: notifier.flashcardsList!.length, // Total number of cards in the stack
  controller: _swiperController, // Controls card swiping
  allowedSwipeDirection: AllowedSwipeDirection.symmetric(
    horizontal: true, // Enables horizontal swiping
    vertical: true,   // Enables vertical swiping
  ),
  /// Here, we intelligently adjust the number of cards displayed based on
  /// the length of the flashcardsList:
  /// - If there's only one card, we show just one card.
  /// - If there are two cards, we display two cards.
  /// - If there are more than two cards, we reveal three cards at once.
  numberOfCardsDisplayed: notifier.flashcardsList!.length == 1
    ? 1
    : notifier.flashcardsList!.length == 2
    ? 2
    : 3,
  scale: 0.96, // Adjust the scale factor for the cards
  backCardOffset: const Offset(14, 0), // Customize the offset of the back cards
  padding: const EdgeInsets.only(
    right: 22,
    left: 6,
  ), // Add padding around the card stack
  cardBuilder: (context, index) {
    final card = notifier.flashcardsList![index]; // Retrieve the current card

    /// Here's where the magic happens. We use the FlipCard widget to create
    /// a dynamic card that can be flipped to reveal the answer.
    ///
    /// Note: For more details on the `FlipCard` widget and how it works, 
    /// you can find additional information below.
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

## Flip Card Functionality
The flip card feature is achieved using the **[flip_card](https://pub.dev/packages/flip_card)** package. This nifty addition displays answers to questions on the back of each card in a way that's both fun and interactive, making the app more user-friendly.

### How it works
To create this flip card effect, two custom widgets were designed: `FrontFlashcard` and `BackFlashcard`. These widgets handle what you see on the front and back of each card. They work in harmony with the **flip_card** package, which is responsible for making the flipping animation look smooth and seamless. Below is the code snippet for implementing the flip card:
````dart
FlipCard(
  fill: Fill.fillBack, // Ensures the card occupies the entire space when flipped
  direction: FlipDirection.HORIZONTAL, // Specifies horizontal flipping
  side: CardSide.FRONT, // Initially displays the front side
  controller: _flipController, // Manages the card flipping animation
  front: FrontFlashcard(
    card: card, // Presents the question on the front side
    currentCard: index + 1, // Indicates the current card number (starting from 1)
    totalCards: notifier.flashcardsList!.length, // Shows the total number of cards
  ),
  back: BackFlashcard(
    card: card, // Displays the answer on the back side
    currentCard: index + 1,
    totalCards: notifier.flashcardsList!.length,
  ),
);

````
