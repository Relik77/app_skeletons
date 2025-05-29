import 'package:flutter/material.dart';

class CachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final double? height;
  final double? width;

  const CachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.httpHeaders,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      headers: httpHeaders,
      height: height,
      width: width,
    );
  }
}
