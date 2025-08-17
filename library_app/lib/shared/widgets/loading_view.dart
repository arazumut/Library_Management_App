import 'package:flutter/material.dart';
import 'package:library_app/core/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class LoadingView extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  
  const LoadingView({
    Key? key,
    this.baseColor = AppColors.textLight,
    this.highlightColor = Colors.white,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
