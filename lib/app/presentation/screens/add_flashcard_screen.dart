import 'package:flutter/material.dart';

class AddFlashcardScreen extends StatefulWidget {
  const AddFlashcardScreen({super.key});

  @override
  State<AddFlashcardScreen> createState() => _AddFlashcardScreenState();
}

class _AddFlashcardScreenState extends State<AddFlashcardScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  // dialog box to add flashcard
  // addFlashcard() {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog.fullscreen(
  //         child: Form(
  //           key: _key,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               const Text("Add a Flashcard"),
  //               AppTextFieldWidget(
  //                 hintText: "Question",
  //                 controller: _questionController,
  //                 validator: (v) => ValidatorsHelper.def(v),
  //                 onSaved: (v) => _questionController.text = v!,
  //               ),
  //               AppTextFieldWidget(
  //                 hintText: "Answer",
  //                 controller: _answerController,
  //                 validator: (v) => ValidatorsHelper.def(v),
  //                 onSaved: (v) => _answerController.text = v!,
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   for (final cardColor in UiHelpers.cardColors)
  //                     CardColorPicker(
  //                       onTap: () {
  //                         _selectedCardColor = cardColor.toString();
  //                       },
  //                       cardColor: cardColor,
  //                       borderColor: _selectedCardColor == cardColor.toString()
  //                           ? Colors.black45
  //                           : Colors.transparent,
  //                     ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               Consumer(
  //                 builder: (context, ref, _) {
  //                   final state = ref.watch(fcProvider);
  //
  //                   return FilledButton(
  //                     onPressed: () => _addFlashcard(context, ref),
  //                     child: state == AddFlashcardState.loading
  //                         ? UiHelpers.loader()
  //                         : const Text("Add Flashcard"),
  //                   );
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // final _questionController = TextEditingController();
  // final _answerController = TextEditingController();
  //
  // String? _selectedCardColor;
  //
  // final _key = GlobalKey<FormState>(debugLabel: 'add_flashcard');
  //
  // _addFlashcard(context, ref) async {
  //   final formState = _key.currentState!;
  //
  //   final state = ref.watch(fcProvider);
  //   final notifier = ref.watch(fcProvider.notifier);
  //
  //   try {
  //     if (formState.validate()) {
  //       formState.save();
  //       final result = await notifier.addFlashcard(
  //         _questionController.text,
  //         _answerController.text,
  //         _selectedCardColor ?? AppColors.cardGreen.toString(),
  //       );
  //       if (state != AddFlashcardState.success) {
  //         debugPrint('[UI AUTH ERROR] $result');
  //         // return AppSnackbar.error(context, result);
  //       } else {
  //         // Navigator.pushNamed(context, Routes.home);
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint("${StringConstants.unknownError}: ${e.toString()}");
  //   }
  // }
}
