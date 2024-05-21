import 'package:flutter/foundation.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/response/item_model.dart';
import 'package:sixam_mart/data/model/response/store_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/myCustomController.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/cart_widget.dart';
import 'package:sixam_mart/view/base/item_view.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/veg_filter_widget.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';

class CategoryItemScreen extends StatefulWidget {
  final String? categoryID;
  final String categoryName;
  const CategoryItemScreen(
      {Key? key, required this.categoryID, required this.categoryName})
      : super(key: key);

  @override
  CategoryItemScreenState createState() => CategoryItemScreenState();
}

class CategoryItemScreenState extends State<CategoryItemScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController storeScrollController = ScrollController();
  TabController? _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.put(MyClassController());

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryItemList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryItemList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                .subCategoryList![
            Get.find<CategoryController>().subCategoryIndex]
                .id
                .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    storeScrollController.addListener(() {
      if (storeScrollController.position.pixels ==
          storeScrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryStoreList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
        (Get.find<CategoryController>().restPageSize! / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          if (kDebugMode) {
            print('end of the page');
          }
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryStoreList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                .subCategoryList![
            Get.find<CategoryController>().subCategoryIndex]
                .id
                .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (catController) {
      print('39-->> ${catController.isStore}');

      List<Item>? item;
      List<Store>? stores;
      if (catController.isSearching
          ? catController.searchItemList != null
          : catController.categoryItemList != null) {
        item = [];
        if (catController.isSearching) {
          item.addAll(catController.searchItemList!);
        } else {
          item.addAll(catController.categoryItemList!);
        }
      }
      if (catController.isSearching
          ? catController.searchStoreList != null
          : catController.categoryStoreList != null) {
        stores = [];
        if (catController.isSearching) {
          stores.addAll(catController.searchStoreList!);
        } else {
          stores.addAll(catController.categoryStoreList!);
        }
      }

      return WillPopScope(
        onWillPop: () async {
          if (catController.isSearching) {
            catController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          appBar: (ResponsiveHelper.isDesktop(context)
              ? const WebMenuBar()
              : AppBar(
            title: catController.isSearching
                ? TextField(
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                style: robotoRegular.copyWith(
                    fontSize: Dimensions.fontSizeLarge),
                onSubmitted: (String query) {
                  catController.searchData(
                    query,
                    catController.subCategoryIndex == 0
                        ? widget.categoryID
                        : catController
                        .subCategoryList![
                    catController.subCategoryIndex]
                        .id
                        .toString(),
                    catController.type,
                  );
                })
                : Text(widget.categoryName,
                style: robotoRegular.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Theme.of(context).textTheme.bodyLarge!.color,
              onPressed: () {
                if (catController.isSearching) {
                  catController.toggleSearch();
                } else {
                  Get.back();
                }
              },
            ),
            // backgroundColor: Colors.red,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => catController.toggleSearch(),
                    icon: Icon(
                      catController.isSearching
                          ? Icons.close_sharp
                          : Icons.search,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: Icon(Icons.shopping_cart,
                            color: Theme.of(context).primaryColor),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, RouteHelper.getCartRoute());
                        },
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: GetBuilder<CartController>(
                              builder: (cartController) {
                                return Text(
                                  cartController.cartList.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  VegFilterWidget(
                    type: catController.type,
                    fromAppBar: true,
                    onSelected: (String type) {
                      if (catController.isSearching) {
                        catController.searchData(
                          catController.subCategoryIndex == 0
                              ? widget.categoryID
                              : catController
                              .subCategoryList![
                          catController.subCategoryIndex]
                              .id
                              .toString(),
                          '1',
                          type,
                        );
                      } else {
                        if (catController.isStore) {
                          catController.getCategoryStoreList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                .subCategoryList![
                            catController.subCategoryIndex]
                                .id
                                .toString(),
                            1,
                            type,
                            true,
                          );
                        } else {
                          catController.getCategoryItemList(
                            catController.subCategoryIndex == 0
                                ? widget.categoryID
                                : catController
                                .subCategoryList![
                            catController.subCategoryIndex]
                                .id
                                .toString(),
                            1,
                            type,
                            true,
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          )) as PreferredSizeWidget?,
          endDrawer: const MenuDrawer(),
          endDrawerEnableOpenDragGesture: false,
          body: Container(
            // color: Colors.white, // Set the body background color to white
            child: Center(
              child: SizedBox(
                width: Dimensions.webMaxWidth,
                child: Column(
                  children: [
                    (catController.isStore || item?.length == 0)
                        ? SizedBox()
                        : Container(
                      height: 30,
                      color: Colors.white, // Set the background color of the Container to white
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LiteRollingSwitch(
                            value: controller.categoryPage.value,
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
                            onChanged: (bool position) {
                              controller.categoryPage.value = !controller.categoryPage.value;
                              print("toggle button 209   ${item?.length}");
                            },
                          ),
                        ],
                      ),
                    ),
                    (catController.subCategoryList != null && !catController.isSearching)
                        ? Center(
                      child: Container(
                        height: 40,
                        width: Dimensions.webMaxWidth,
                        color: Theme.of(context).cardColor,
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                        child: Row(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              key: scaffoldKey,
                              scrollDirection: Axis.horizontal,
                              itemCount: catController.subCategoryList!.length,
                              padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () => catController.setSubCategoryIndex(index, widget.categoryID),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                                    margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: index == catController.subCategoryIndex
                                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                                          : Colors.transparent,
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          catController.subCategoryList![index].name!,
                                          style: index == catController.subCategoryIndex
                                              ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                              : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                        : const SizedBox(),
                    Center(
                      child: Container(
                        width: Dimensions.webMaxWidth,
                        color: Theme.of(context).cardColor,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Theme.of(context).disabledColor,
                          unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                          labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                          tabs: [
                            Tab(text: 'item'.tr),
                            Tab(
                              text: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                                  ? 'restaurants'.tr
                                  : 'stores'.tr,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: NotificationListener(
                        onNotification: (dynamic scrollNotification) {
                          if (scrollNotification is ScrollEndNotification) {
                            if ((_tabController!.index == 1 && !catController.isStore) || (_tabController!.index == 0 && catController.isStore)) {
                              catController.setRestaurant(_tabController!.index == 1);
                              if (catController.isSearching) {
                                catController.searchData(
                                  catController.searchText,
                                  catController.subCategoryIndex == 0 ? widget.categoryID : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                  catController.type,
                                );
                              } else {
                                if (_tabController!.index == 1) {
                                  catController.getCategoryStoreList(
                                    catController.subCategoryIndex == 0 ? widget.categoryID : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                    1,
                                    catController.type,
                                    false,
                                  );
                                } else {
                                  catController.getCategoryItemList(
                                    catController.subCategoryIndex == 0 ? widget.categoryID : catController.subCategoryList![catController.subCategoryIndex].id.toString(),
                                    1,
                                    catController.type,
                                    false,
                                  );
                                }
                              }
                            }
                          }
                          return false;
                        },
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: ItemsView(
                                isStore: false,
                                items: item,
                                stores: null,
                                noDataText: 'no_category_item_found'.tr,
                              ),
                            ),
                            SingleChildScrollView(
                              controller: storeScrollController,
                              child: ItemsView(
                                isStore: true,
                                items: null,
                                stores: stores,
                                noDataText: Get.find<SplashController>().configModel!.moduleConfig!.module!.showRestaurantText!
                                    ? 'no_category_restaurant_found'.tr
                                    : 'no_category_store_found'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    catController.isLoading
                        ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                      ),
                    )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),


        ),
      );
    });
  }
}
