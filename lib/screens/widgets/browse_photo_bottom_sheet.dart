/*===============
*   @file       browse_photo_bottom_sheet.dart
*   @project    JP dating
*   @purpose    Browse Photo Bottom Sheet View
*   @author     Chanvichay on 12/02/20
*   @copyright  VCodeBest
=================*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'browse_photo_button.dart';

class BrowsePhotoBottomSheetView extends StatefulWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  BrowsePhotoBottomSheetView({
    required this.onCameraTap,
   required this.onGalleryTap,
  });

  static void browseGalleryPhoto(
    BuildContext context, {
    required Function(File) onResult,
  }) async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null)
      onResult(File(pickedFile.path));
    else {
      print("is Error Now");
    }

  }

  @override
  _BrowsePhotoBottomSheetViewState createState() =>
      _BrowsePhotoBottomSheetViewState();
}

class _BrowsePhotoBottomSheetViewState
    extends State<BrowsePhotoBottomSheetView> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Option'
              ),
              // AppText(
              //   'Select Option'.translate(),
              //   padding: EdgeInsets.all(AppDimension().medium),
              //   style: AppFont().titleDialog(
              //     color: AppColors().text,
              //   ),
              // ),
              BrowsePhotoButton(
                title: 'Gallery',
                onTap: () {
                  Navigator.of(context).pop("Discard");
                  Future.delayed(Duration(milliseconds: 500),
                      () => this.widget.onGalleryTap());
                },
              ),
              BrowsePhotoButton(
                title: 'Camera',
                onTap: () {
                  Navigator.of(context).pop("Discard");
                  Future.delayed(Duration(milliseconds: 500),
                      () => this.widget.onCameraTap());
                },
              ),
              BrowsePhotoButton(
                title: 'Cancel',
                onTap: () => Navigator.of(context).pop("Discard"),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
