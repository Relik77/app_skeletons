import 'package:flutter/material.dart';
import 'package:sample_project/ui/widgets/cached_network_image/cached_network_image_platform.dart'
    if (dart.library.io) 'package:sample_project/ui/widgets/cached_network_image/cached_network_image_io.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final Map<String, String>? httpHeaders;
  final double? height;
  final double? width;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.httpHeaders,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      httpHeaders: httpHeaders,
      height: height,
      width: width,
    );
  }
}
