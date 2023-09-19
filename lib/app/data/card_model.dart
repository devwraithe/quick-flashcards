import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String id, user, question, answer;
  final Color? color;

  const CardModel({
    required this.id,
    required this.user,
    required this.question,
    required this.answer,
    this.color,
  });

  factory CardModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    return CardModel(
      id: snapshot.id,
      user: data['user'],
      question: data['question'],
      answer: data['answer'],
      color: Color(
        int.parse(
          data['color'].replaceAll("Color(", "").replaceAll(")", ""),
        ),
      ),
    );
  }
  List<Object?> get props => [
        id,
        user,
        question,
        answer,
        color,
      ];
}
