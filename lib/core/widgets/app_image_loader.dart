import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:task_currency/core/extensions/context_extensions.dart';

class AppImageLoader extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImageLoader({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      fit: fit,
      cache: true,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      loadStateChanged: (state) => switch (state.extendedImageLoadState) {
        LoadState.completed => null,
        LoadState.loading =>
          placeholder ??
              Container(
                width: width,
                height: height,
                color: context.colorScheme.surfaceContainerHighest,
              ),
        LoadState.failed =>
          errorWidget ??
              Container(
                width: width,
                height: height,
                color: context.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.broken_image,
                  color: context.colorScheme.error,
                  size: (width != null && width! < 30) ? 12 : 24,
                ),
              ),
      },
    );
  }
}
