/*===============
*   @file       browse_photo_button.dart
*   @project    JP dating
*   @purpose    Browse Photo Button
*   @author     Chanvichay on 12/02/20
*   @copyright  VCodeBest
=================*/

import 'package:flutter/material.dart';


class BrowsePhotoButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const BrowsePhotoButton({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            this.title,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
