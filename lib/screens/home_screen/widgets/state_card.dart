import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class StateCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const StateCard({super.key, required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: SizedBox(
          height: 120.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge),
              Gap(8.h),
              Text('Total\n$title',
                  style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
