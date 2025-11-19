import 'package:flutter/material.dart';

class RemoteImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Duration fadeInDuration;

  const RemoteImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.fadeInDuration = const Duration(milliseconds: 300),
  });

  bool get _isValidNetworkUrl {
    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(imageUrl!.trim());
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    if (_isValidNetworkUrl) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/img/no-image.png',
        image: imageUrl!.trim(),
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: fadeInDuration,
      );
    }
    return Image.asset(
      'assets/img/no-image.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
}
