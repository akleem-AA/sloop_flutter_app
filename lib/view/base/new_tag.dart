import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';

class NewTag extends StatelessWidget {
  final double? top, left, right;
  const NewTag({Key? key, this.top = 5, this.left = 3, this.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          // color: Theme.of(context).primaryColor,
          // color: Color(0xFFFF0000), // Change background color to red
          color: Theme.of(context).colorScheme.error,
        ),
        child: Text('new'.tr,
            style: robotoMedium.copyWith(
                color: Theme.of(context).cardColor,
                fontSize: Dimensions.fontSizeSmall)),
      ),
    );
  }
}
