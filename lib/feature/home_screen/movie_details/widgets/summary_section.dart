import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/color_manager.dart';

class SummarySection extends StatelessWidget {
  final String summary;

  const SummarySection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .015),

        Text(
          summary,
          style: TextStyle(
            color: ColorManager.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
