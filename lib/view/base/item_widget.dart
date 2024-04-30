import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/item_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/wishlist_controller.dart';
import 'package:sixam_mart/data/model/response/config_model.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/module_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/date_converter.dart';
import 'package:sixam_mart/helper/price_converter.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/corner_banner/banner.dart';
import 'package:sixam_mart/view/base/corner_banner/corner_discount_tag.dart';
import 'package:sixam_mart/view/base/custom_image.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/discount_tag.dart';
import 'package:sixam_mart/view/base/not_available_widget.dart';
import 'package:sixam_mart/view/base/organic_tag.dart';
import 'package:sixam_mart/view/base/rating_bar.dart';
import 'package:sixam_mart/view/screens/store/store_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/notification_controller.dart';
import '../../myCustomController.dart';

class ItemWidget extends StatefulWidget {
  final Item? item;
  final Store? store;
  final bool isStore;
  final int index;
  final int? length;
  final bool inStore;
  final bool isCampaign;
  final bool isFeatured;
  final bool fromCartSuggestion;
  final double? imageHeight;
  final double? imageWidth;
  final bool? isCornerTag;
  const ItemWidget({Key? key, required this.item, required this.isStore, required this.store, required this.index,
    required this.length, this.inStore = false, this.isCampaign = false, this.isFeatured = false,
    this.fromCartSuggestion = false, this.imageHeight, this.imageWidth, this.isCornerTag = false}) : super(key: key);

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}
final controller = Get.put(MyClassController());
void _loadData() async {
  Get.find<MyClassController>();

}

@override
void initState() {
  initState();

  _loadData();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    print('68-->> ${controller.showBrutto.value}');
    print('69-->> ${widget.item?.price}');
    final bool ltr = Get.find<LocalizationController>().isLtr;
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    if(widget.isStore) {
      discount = widget.store!.discount != null ? widget.store!.discount!.discount : 0;
      discountType = widget.store!.discount != null ? widget.store!.discount!.discountType : 'percent';
      // bool _isClosedToday = Get.find<StoreController>().isRestaurantClosed(true, store.active, store.offDay);
      // _isAvailable = DateConverter.isAvailable(store.openingTime, store.closeingTime) && store.active && !_isClosedToday;
      isAvailable = widget.store!.open == 1 && widget.store!.active!;
    }else {
      discount = (widget.item!.storeDiscount == 0 || widget.isCampaign) ? widget.item!.discount : widget.item!.storeDiscount;
      discountType = (widget.item!.storeDiscount == 0 || widget.isCampaign) ? widget.item!.discountType : 'percent';
      isAvailable = DateConverter.isAvailable(widget.item!.availableTimeStarts, widget.item!.availableTimeEnds);
    }

    return InkWell(
      onTap: () {
        if(widget.isStore) {
          if(widget.store != null) {
            if(widget.isFeatured && Get.find<SplashController>().moduleList != null) {
              for(ModuleModel module in Get.find<SplashController>().moduleList!) {
                if(module.id == widget.store!.moduleId) {
                  Get.find<SplashController>().setModule(module);
                  break;
                }
              }
            }
            Get.toNamed(
              RouteHelper.getStoreRoute(id: widget.store!.id, page: widget.isFeatured ? 'module' : 'item'),
              arguments: StoreScreen(store: widget.store, fromModule: widget.isFeatured),
            );
          }
        }else {
          if(widget.isFeatured && Get.find<SplashController>().moduleList != null) {
            for(ModuleModel module in Get.find<SplashController>().moduleList!) {
              if(module.id == widget.item!.moduleId) {
                Get.find<SplashController>().setModule(module);
                break;
              }
            }
          }
          Get.find<ItemController>().navigateToItemPage(widget.item, context, inStore: widget.inStore, isCampaign: widget.isCampaign);
        }
      },
      child:
      Obx(()=>Stack(
        children: [
          Container(
            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(widget.fromCartSuggestion ? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall) : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            margin: ResponsiveHelper.isDesktop(context) ? null : const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              color: Theme.of(context).cardColor,
              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5, offset: Offset(0, 0))],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
                child: Row(children: [

                  Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      child: CustomImage(
                        image: '${widget.isCampaign ? baseUrls!.campaignImageUrl : widget.isStore ? baseUrls!.storeImageUrl
                            : baseUrls!.itemImageUrl}'
                            '/${widget.isStore ? widget.store != null ? widget.store!.logo : '' : widget.item!.image}',
                        height: widget.imageHeight ?? (desktop ? 120 : widget.length == null ? 100 : 65), width: widget.imageWidth ?? (desktop ? 120 : 80), fit: BoxFit.cover,
                      ),
                    ),

                    (widget.isStore || widget.isCornerTag!) ? DiscountTag(
                      discount: discount, discountType: discountType,
                      freeDelivery: widget.isStore ? widget.store!.freeDelivery : false,
                    ) : const SizedBox(),

                    !widget.isStore ? OrganicTag(item: widget.item!, placeInImage: true) : const SizedBox(),

                    isAvailable ? const SizedBox() : NotAvailableWidget(isStore: widget.isStore),
                  ]),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                        Text(
                          widget.isStore ? widget.store!.name! : widget.item!.name!,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                        (!widget.isStore && Get.find<SplashController>().configModel!.moduleConfig!.module!.vegNonVeg! && Get.find<SplashController>().configModel!.toggleVegNonVeg!)
                            ? Image.asset(widget.item != null && widget.item!.veg == 0 ? Images.nonVegImage : Images.vegImage,
                            height: 10, width: 10, fit: BoxFit.contain) : const SizedBox(),
                      ]),
                      SizedBox(height: widget.isStore ? Dimensions.paddingSizeExtraSmall : 0),

                      (widget.isStore ? widget.store!.address != null : widget.item!.storeName != null) ? Text(
                        widget.isStore ? widget.store!.address ?? '' : widget.item!.storeName ?? '',
                        style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).disabledColor,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ) : const SizedBox(),
                      SizedBox(height: ((desktop || widget.isStore) && (widget.isStore ? widget.store!.address != null : widget.item!.storeName != null)) ? 5 : 0),

                      !widget.isStore ? RatingBar(
                        rating: widget.isStore ? widget.store!.avgRating : widget.item!.avgRating, size: desktop ? 15 : 12,
                        ratingCount: widget.isStore ? widget.store!.ratingCount : widget.item!.ratingCount,
                      ) : const SizedBox(),
                      SizedBox(height: (!widget.isStore && desktop) ? Dimensions.paddingSizeExtraSmall : 0),

                      (Get.find<SplashController>().configModel!.moduleConfig!.module!.unit! && widget.item != null && widget.item!.unitType != null) ? Text(
                        '(${ widget.item!.unitType ?? ''})',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor),
                      ) : const SizedBox(),

                      widget.isStore ? RatingBar(
                        rating: widget.isStore ? widget.store!.avgRating : widget.item!.avgRating, size: desktop ? 15 : 12,
                        ratingCount: widget.isStore ? widget.store!.ratingCount : widget.item!.ratingCount,
                      ) :
                      Row(children: [
                        (controller.showBrutto.value) ?
                        Text(
                          PriceConverter.convertPrice(widget.item!.price, discount: discount, discountType: discountType),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                        ):
                        Text(
                          PriceConverter.convertPrice(widget.item!.brutto_price, discount: discount, discountType: discountType),
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textDirection: TextDirection.ltr,
                        ),
                        SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),


                        discount > 0 ? Text(
                          PriceConverter.convertPrice(widget.item!.price),
                          style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor,
                            decoration: TextDecoration.lineThrough,
                          ), textDirection: TextDirection.ltr,
                        ) : const SizedBox(),
                      ]),
                      Row(children: [
                        (!controller.showBrutto.value) ?
                        Text(
                          "Inclu : ${Get.find<SplashController>().configModel!.currencySymbol!}" +
                              " " +
                              widget.item!.tax.toString(),
                          textDirection: TextDirection.ltr,
                          style: robotoMedium.copyWith(fontSize: 10),
                        ):
                        Text(
                          "Exlu : ${Get.find<SplashController>().configModel!.currencySymbol!}" +
                              " " +
                              widget.item!.tax.toString(),
                          textDirection: TextDirection.ltr,
                          style: robotoMedium.copyWith(fontSize: 10),
                        ),
                        SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),


                      ]),




                    ]),
                  ),

                  Column(mainAxisAlignment: widget.isStore ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween, children: [

                    const SizedBox(),

                    widget.fromCartSuggestion ? Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Icon(Icons.add, color: Theme.of(context).cardColor, size: 12),
                    ) : GetBuilder<WishListController>(builder: (wishController) {
                      bool isWished = widget.isStore ? wishController.wishStoreIdList.contains(widget.store!.id)
                          : wishController.wishItemIdList.contains(widget.item!.id);
                      return InkWell(
                        onTap: !wishController.isRemoving ? () {
                          if(Get.find<AuthController>().isLoggedIn()) {
                            isWished ? wishController.removeFromWishList(widget.isStore ? widget.store!.id : widget.item!.id, widget.isStore)
                                : wishController.addToWishList(widget.item, widget.store, widget.isStore);
                          }else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        } : null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: desktop ? Dimensions.paddingSizeSmall : 0),
                          child: Icon(
                            isWished ? Icons.favorite : Icons.favorite_border,  size: desktop ? 30 : 25,
                            color: isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                          ),
                        ),
                      );
                    }),

                  ]),

                ]),
              )),

            ]),
          ),

          (!widget.isStore && widget.isCornerTag! == false) ? Positioned(
              right: ltr ? 0 : null, left: ltr ? null : 0,
              child: CornerDiscountTag(
                bannerPosition: ltr ? CornerBannerPosition.topRight : CornerBannerPosition.topLeft,
                elevation: 0,
                discount: discount, discountType: discountType,
                freeDelivery: widget.isStore ? widget.store!.freeDelivery : false,
              )) : const SizedBox(),

        ],
      )),
    );
  }
}
