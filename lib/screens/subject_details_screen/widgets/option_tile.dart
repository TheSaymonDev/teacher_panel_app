import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final int index;
  final int correctAnswer;
  final TextStyle? textStyle;

  const OptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.index,
    required this.correctAnswer,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = index == correctAnswer;
    return Expanded(
      child: Text(
        '$label। $text',
        style: textStyle?.copyWith(
          color: isCorrect ? Colors.green : null,
        ) ??
            Theme.of(context).textTheme.bodySmall!.copyWith(
              color: isCorrect ? Colors.green : null,
            ),
      ),
    );
  }
}
