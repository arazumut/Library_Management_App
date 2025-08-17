import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:library_app/core/constants/app_constants.dart';
import 'package:library_app/core/theme/app_colors.dart';

class BookCoverImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  
  const BookCoverImage({
    Key? key,
    this.imageUrl,
    this.width = 120.0,
    this.height = 180.0,
    this.borderRadius = 8.0,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final imageSource = imageUrl?.isNotEmpty == true
        ? imageUrl!
        : AppConstants.defaultBookCoverUrl;
        
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imageSource,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          color: AppColors.textLight,
          child: const Center(
            child: SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: AppColors.textLight,
          child: const Icon(
            Icons.book,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
