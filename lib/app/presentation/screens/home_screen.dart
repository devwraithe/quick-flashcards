import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';
import 'package:quick_flashcards/app/presentation/widgets/custom_sub_icon.dart';

import '../../core/utilities/constants/constants.dart';
import '../../core/utilities/helpers/ui_helper.dart';
import '../../core/utilities/helpers/validators_helper.dart';
import '../notifiers/auth_notifiers/logout_notifier.dart';
import '../notifiers/flashcard_notifiers/add_flashcard_notifier.dart';
import '../notifiers/flashcard_notifiers/get_flashcards_notifier.dart';
import '../widgets/back_flashcard.dart';
import '../widgets/custom_icon.dart';
import '../widgets/front_flashcard.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
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

  _signOut(context, LogoutNotifier notifier) async {
    final result = await notifier.signOut();
    if (result == LogoutState.success) {
      Navigator.pushNamed(
        context,
        Routes.signIn,
      );
    }
    if (result == LogoutState.failed) {
      UiHelpers.errorFlush(
        notifier.error!,
        context,
      );
    }
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
              // The page title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Flashcards",
                      style: AppTextTheme.textTheme.headlineMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => createFlashcardSheet(),
                          child: const Icon(
                            Icons.add,
                            size: 28,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Consumer(
                          builder: (context, ref, _) {
                            final state = ref.watch(logoutProvider);
                            final notifier = ref.watch(logoutProvider.notifier);

                            return GestureDetector(
                              onTap: () => _signOut(context, notifier),
                              child: state == LogoutState.loading
                                  ? UiHelpers.loader()
                                  : const Icon(
                                      Icons.logout,
                                      size: 28,
                                      color: AppColors.red,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(getFlashcardsProvider);
                  final notifier = ref.read(getFlashcardsProvider.notifier);

                  return Expanded(
                    child: controlFlashcards(
                      state,
                      notifier,
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
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

  Widget controlFlashcards(
    GetFlashcardsState state,
    GetFlashcardsNotifier notifier,
  ) {
    if (state == GetFlashcardsState.loading) {
      return Center(
        child: UiHelpers.loader(),
      );
    } else if (state == GetFlashcardsState.failed) {
      if (notifier.error == Constants.emptyFlashcardsList) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Click the ",
                style: AppTextTheme.textTheme.bodyLarge,
              ),
              const Icon(
                Icons.add,
                size: 20,
                color: AppColors.white,
              ),
              Text(
                " to add a card",
                style: AppTextTheme.textTheme.bodyLarge,
              ),
            ],
          ),
        );
      } else {
        return Center(
          child: Text(
            "Failed",
            style: AppTextTheme.textTheme.bodyLarge,
          ),
        );
      }
    } else if (state == GetFlashcardsState.loaded) {
      return CardSwiper(
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
    } else {
      return const Text("Something went wrong");
    }
  }

  final createFlashcardKey = GlobalKey<FormState>(
    debugLabel: 'create-flashcard',
  );

  final colors = [
    AppColors.cardGreen,
    AppColors.cardRed,
    AppColors.cardBlue,
    AppColors.cardYellow,
  ];

  Random random = Random();

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  _createFlashcard(context, CreateFlashcardNotifier notifier) async {
    // Dismiss the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    int randomColor = random.nextInt(colors.length);
    Color randomItem = colors[randomColor];

    final formState = createFlashcardKey.currentState!;

    if (formState.validate()) {
      formState.save();
      final result = await notifier.createFlashcard(
        _questionController.text,
        _answerController.text,
        randomItem.toString(),
      );
      if (result == CreateFlashcardState.success) {
        Navigator.pop(context, Routes.home);
      }
      if (result == CreateFlashcardState.failed) {
        return UiHelpers.errorFlush(notifier.error!, context);
      }

      // Clear data from the bottom sheet
      _questionController.clear();
      _answerController.clear();
    }
  }

  // Bottom sheet for flashcard info fields
  void createFlashcardSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        const textTheme = AppTextTheme.textTheme;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 26,
          ),
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Form(
              key: createFlashcardKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 5,
                    width: 80,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Question e.g Who am I?",
                      prefix: Constants.prefixSpace,
                    ),
                    autovalidateMode: Constants.validateMode,
                    controller: _questionController,
                    validator: (v) => ValidatorHelper.question(v),
                    onSaved: (v) => _questionController.text = v!,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Answer e.g I am Devwraithe",
                      prefix: Constants.prefixSpace,
                    ),
                    autovalidateMode: Constants.validateMode,
                    controller: _answerController,
                    validator: (v) => ValidatorHelper.answer(v),
                    onSaved: (v) => _answerController.text = v!,
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Consumer(
                    builder: (context, ref, _) {
                      final state = ref.watch(createFlashcardProvider);
                      final notifier = ref.watch(
                        createFlashcardProvider.notifier,
                      );

                      return FilledButton(
                        onPressed: () {
                          _createFlashcard(context, notifier);
                        },
                        child: state == CreateFlashcardState.loading
                            ? UiHelpers.darkLoader()
                            : const Text("Add"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
