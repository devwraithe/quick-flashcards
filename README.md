# 📑 Quick Flashcards

**Quick Flashcards** is a simple, cross-platform mobile application designed for creating flashcards quickly. It's built using Google Firebase Firestore for the backend and database system for storing and retrieving the flashcards, and Riverpod for the state management.

🎨 [Design Inspiration](https://dribbble.com/shots/8258284-Flashcards-x-Tinder)

<!-- Table of Contents -->
### Table of Contents
<!-- - [Getting Started](#getting-started) -->
- [Previews](#previews)
- [Folder Structure and Architecture](#folder-structure-and-architecture)

<!-- Getting Started -->
<!-- ## Getting Started

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
-->

<!-- Previews i.e. Screenshots, Demo -->
## Previews
### List of Flashcards
https://github.com/devwraithe/quick-flashcards/assets/39105147/5178e723-69ad-4dc5-890c-2fc87df971a0

<!-- Folder Structure and Architecture -->
## Folder Structure and Architecture
- **Coming soon...**

<!-- Stacked Cards Functionality -->
## Stacked Cards
Swipeable stacked cards functionality was achieved by using the [flutter_card_swiper](https://pub.dev/packages/flutter_card_swiper) package. The package is very verbose and has a lot of customizations such as the number of cards displayed at once, card offsetting, and scaling, it also allows the option to either allow swiping horizontally, vertically or both. Here is the code used in this project with explanatory comments:

**Implementation:**
```dart
/// This widget handles the swipeable stacked cards functionality
CardSwiperr(
  cardsCount: notifier.flashcardsList!.length
)
```
