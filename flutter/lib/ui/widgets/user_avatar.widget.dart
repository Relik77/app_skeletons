import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sample_project/shared/models/user.model.dart';
import 'package:sample_project/shared/resource.dart';

class UserOnlineIndicator extends StatelessWidget {
  final bool isOnline;
  final double size;

  const UserOnlineIndicator({
    super.key,
    required this.isOnline,
    this.size = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.red,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final User? user;
  final Uint8List? imageData;
  final double size;

  const UserAvatar({
    super.key,
    this.user,
    this.imageData,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final Widget picture;
    // if (user?.picture != null) {
    //   picture = CachedNetworkImageWidget(
    //     imageUrl: user!.picture!,
    //     httpHeaders: ApplicationState.instance?.currentUser?.authorizationHeaders,
    //     height: size,
    //     width: size,
    //   );
    // } else
    if (imageData != null) {
      picture = Image.memory(
        imageData!,
        height: size,
        width: size,
        fit: BoxFit.cover,
      );
    } else {
      picture = Image.asset(
        Resource.imageAvatar,
        height: size,
        width: size,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(250.0),
      child: picture,
    );
  }
}
