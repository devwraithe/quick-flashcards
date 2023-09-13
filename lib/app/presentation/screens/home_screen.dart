import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_flashcards/app/core/constants/string_constants.dart';
import 'package:quick_flashcards/app/core/helpers/validators_helper.dart';
import 'package:quick_flashcards/app/core/routes/routes.dart';
import 'package:quick_flashcards/app/core/theme/app_colors.dart';
import 'package:quick_flashcards/app/core/theme/text_theme.dart';
import 'package:quick_flashcards/app/presentation/providers/auth_logic/sign_out_notifier.dart';
import 'package:quick_flashcards/app/presentation/providers/flashcards_logic/get_flashcards_provider.dart';
import 'package:quick_flashcards/app/presentation/widgets/app_textfield_widget.dart';
import 'package:quick_flashcards/app/presentation/widgets/custom_sub_icon.dart';

import '../../core/helpers/ui_helper.dart';
import '../providers/flashcards_logic/add_flashcard_notifier.dart';
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

  _signOut(context, SignOutNotifier notifier) async {
    final result = await notifier.signOut();
    if (result == SignOutState.success) {
      Navigator.pushNamed(
        context,
        Routes.signIn,
      );
    } else if (result == SignOutState.failed) {
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
                          onTap: () => addFlashcard(),
                          child: const Icon(
                            Icons.add,
                            size: 28,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 18),
                        Consumer(
                          builder: (context, ref, _) {
                            final state = ref.watch(signOutProvider);
                            final notifier = ref.watch(
                              signOutProvider.notifier,
                            );

                            return GestureDetector(
                              onTap: () => _signOut(context, notifier),
                              child: state == SignOutState.loading
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
                    child: handleFlashcards(
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

  Widget handleFlashcards(
    GetFlashcardsState state,
    GetFlashcardsNotifier notifier,
  ) {
    if (state == GetFlashcardsState.loading) {
      return Center(
        child: UiHelpers.loader(),
      );
    } else if (state == GetFlashcardsState.failed) {
      if (notifier.error == StringConstants.emptyFlashcardsList) {
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

  final colors = [
    AppColors.cardGreen,
    AppColors.cardRed,
    AppColors.cardBlue,
    AppColors.cardYellow,
  ];
  Random random = Random();

  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  _addFlashcard(context, ref) async {
    FocusManager.instance.primaryFocus?.unfocus(); // Dismiss the keyboard

    final state = ref.watch(fcProvider);
    final notifier = ref.watch(fcProvider.notifier);

    int randomColor = random.nextInt(colors.length);

    Color randomItem = colors[randomColor];

    final formState = _addFlashcardKey.currentState!;

    try {
      if (formState.validate()) {
        formState.save();
        final result = await notifier.addFlashcard(
          _questionController.text,
          _answerController.text,
          randomItem.toString(),
        );
        if (result != "flashcard_created") {
          debugPrint("Unable to Add Flashcard: ${state.toString()}");
          showFlushbar(
            context: context,
            flushbar: Flushbar(
              title: "Unable to Add Flashcard",
            ),
          );
        } else {
          debugPrint("Flashcard Added!");
          Navigator.pop(context, Routes.home);
        }
      }
    } catch (e) {
      debugPrint("${StringConstants.unknownError}: ${e.toString()}");
    }
  }

  final _addFlashcardKey = GlobalKey<FormState>(debugLabel: 'add-flashcard');

  void addFlashcard() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 26,
          ),
          child: Form(
            key: _addFlashcardKey,
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
                AppTextFieldWidget(
                  hintText: "Question e.g Who am I?",
                  controller: _questionController,
                  validator: (v) => ValidatorHelper.question(v),
                  onSaved: (v) => _questionController.text = v!,
                ),
                const SizedBox(height: 20),
                AppTextFieldWidget(
                  hintText: "Answer e.g I am Devwraithe",
                  controller: _answerController,
                  validator: (v) => ValidatorHelper.answer(v),
                  onSaved: (v) => _answerController.text = v!,
                ),
                const SizedBox(height: 32),
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(fcProvider);

                    return FilledButton(
                      onPressed: () => _addFlashcard(context, ref),
                      child: state == AddFlashcardState.loading
                          ? UiHelpers.darkLoader()
                          : Text(
                              "Add",
                              style: AppTextTheme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
