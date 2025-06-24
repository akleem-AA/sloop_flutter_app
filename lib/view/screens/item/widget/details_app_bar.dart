import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/cart_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../../../../myCustomController.dart';

class DetailsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DetailsAppBar({Key? key}) : super(key: key);

  @override
  DetailsAppBarState createState() => DetailsAppBarState();

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}

class DetailsAppBarState extends State<DetailsAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  // bool is_brotto = false;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void shake() {
    controller.forward(from: 0.0);
  }

  final MyClassController myClassController = Get.find<MyClassController>();

  final myCustomController = Get.put(MyClassController());
  @override
  Widget build(BuildContext context) {
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 15.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });

    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          onPressed: () => Navigator.pop(context)),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      title: Text(
        'item_details'.tr,
        // "testing",
        style: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
      centerTitle: true,
      actions: [
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: LiteRollingSwitch(
              value: myClassController.detailsPage.value,
              width: 85,
              colorOff: Theme.of(context).primaryColor,
              colorOn: Theme.of(context).primaryColor,
              iconOn: Icons.circle_outlined,
              iconOff: Icons.circle_outlined,
              textOn: "brutto".tr,
              textOff: "netto".tr,
              textOnColor: Colors.white,
              textOffColor: Colors.white,
              textSize: Dimensions.fontSizeSmall,
              onTap: () {},
              onDoubleTap: () {},
              onSwipe: () {},
              onChanged: (bool postion) {
                // Get.find<MyClassController>().showBrutto.value = postion;
                myClassController.detailsPage.value =
                    !myClassController.detailsPage.value;
              },
            ),
          ),
        ),
        AnimatedBuilder(
          animation: offsetAnimation,
          builder: (buildContext, child) {
            return Container(
              padding: EdgeInsets.only(
                  left: offsetAnimation.value + 15.0,
                  right: 15.0 - offsetAnimation.value),
              child: Stack(children: [
                IconButton(
                    icon: Icon(Icons.shopping_cart,
                        color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.pushNamed(context, RouteHelper.getCartRoute());
                    }),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                    child:
                        GetBuilder<CartController>(builder: (cartController) {
                      return Text(
                        cartController.cartList.length.toString(),
                        style: robotoMedium.copyWith(
                            color: Colors.white, fontSize: 8),
                      );
                    }),
                  ),
                ),
              ]),
            );
          },
        )
      ],
    );
  }
}
