import 'dart:convert';
import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/location_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/data/model/body/signup_body.dart';
import 'package:sixam_mart/data/model/response/category_model.dart';
import 'package:sixam_mart/helper/custom_validator.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/images.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/custom_text_field.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile hide FormData;
import 'package:dio/dio.dart';

class SignUpNextScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final String referCode;
  final String countryCode;

  const SignUpNextScreen(
      {Key? key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.password,
      required this.confirmPassword,
      required this.referCode,
      required this.countryCode})
      : super(key: key);

  @override
  SignUpNextScreenState createState() => SignUpNextScreenState();
}

class SignUpNextScreenState extends State<SignUpNextScreen> {
  final FocusNode _storeNameFocus = FocusNode();
  final FocusNode _storeAddressFocus = FocusNode();
  final FocusNode _businessCategoryFocus = FocusNode();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController inputController = TextEditingController();

  //String? _countryDialCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ResponsiveHelper.isDesktop(context)
          ? Colors.transparent
          : Theme.of(context).cardColor,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: SafeArea(
          child: Scrollbar(
        child: Center(
          child: Container(
            width: context.width > 700 ? 700 : context.width,
            padding: context.width > 700
                ? const EdgeInsets.all(0)
                : const EdgeInsets.all(Dimensions.paddingSizeLarge),
            margin: context.width > 700
                ? const EdgeInsets.all(Dimensions.paddingSizeDefault)
                : null,
            decoration: context.width > 700
                ? BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  )
                : null,
            child: GetBuilder<AuthController>(builder: (authController) {
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    ResponsiveHelper.isDesktop(context)
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () => Get.back(),
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: ResponsiveHelper.isDesktop(context)
                          ? const EdgeInsets.all(40)
                          : EdgeInsets.zero,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.logo, width: 135),
                            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                            // Center(
                            //     child:
                            //         Image.asset(Images.logoName, width: 125)),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text('My Store',
                                  style: robotoBold.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge)),
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeDefault),
                            CustomTextField(
                              titleText: 'Store Name',
                              hintText: 'Enter your store name',
                              controller: _storeNameController,
                              focusNode: _storeNameFocus,
                              nextFocus: _storeAddressFocus,
                              inputType: TextInputType.name,
                              prefixIcon: Icons.store,
                            ),
                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),
                            CustomTextField(
                              titleText: 'Store Address',
                              hintText: 'Store address',
                              controller: _storeAddressController,
                              inputType: TextInputType.name,
                              prefixIcon: Icons.location_on,
                            ),
                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),

                            TypeAheadField<CategoryModel>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: inputController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    borderSide: BorderSide(
                                        style: true
                                            ? BorderStyle.solid
                                            : BorderStyle.none,
                                        width: 0.3,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    borderSide: BorderSide(
                                        style: true
                                            ? BorderStyle.solid
                                            : BorderStyle.none,
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radiusDefault),
                                    borderSide: BorderSide(
                                        style: true
                                            ? BorderStyle.solid
                                            : BorderStyle.none,
                                        width: 0.3,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  isDense: true,
                                  hintText: "Select Categories",
                                  fillColor: Theme.of(context).cardColor,
                                  hintStyle: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeLarge,
                                      color: Theme.of(context).hintColor),
                                  filled: true,
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                final suggestions = searchCategories(
                                    pattern,
                                    Get.find<CategoryController>()
                                        .categoryList!);

                                if (suggestions.isEmpty) {
                                  suggestions.add(CategoryModel(
                                      name: pattern.trim(),
                                      isNew: true // Flag for new category
                                      ));
                                }
                                return suggestions;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  leading: suggestion.isNew!
                                      ? Icon(Icons.add_circle,
                                          color: Theme.of(context)
                                              .primaryColor) // Icon for new category
                                      : null,
                                  title: Text(
                                    suggestion.name!,
                                    style: suggestion.isNew!
                                        ? TextStyle(
                                            fontStyle: FontStyle
                                                .italic) // Optional style for new entries
                                        : null,
                                  ),
                                );
                              },
                              onSuggestionSelected: (selection) {
                                if (selection != null) {
                                  setState(() {
                                    inputController.text = '';
                                    if (!authController.selectedCategories
                                        .contains(selection)) {
                                      authController.selectedCategories
                                          .add(selection);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              "Category already selected"), // Customize message as needed
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                            ),

                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: List.generate(
                                authController.selectedCategories.length,
                                (index) {
                                  final category =
                                      authController.selectedCategories[index];
                                  return Chip(
                                    label: Text(category.name!),
                                    backgroundColor: Colors.grey.shade200,
                                    onDeleted: () {
                                      removeItem(index, authController);
                                    },
                                  );
                                },
                              ),
                            ),

                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),

                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount:
                                    authController.pickedIdentities.length + 1,
                                itemBuilder: (context, index) {
                                  XFile? file = index ==
                                          authController.pickedIdentities.length
                                      ? null
                                      : authController.pickedIdentities[index];
                                  if (index ==
                                      authController.pickedIdentities.length) {
                                    return InkWell(
                                      onTap: () => authController.pickDmImage(
                                          false, false),
                                      child: DottedBorder(
                                        color: Theme.of(context).primaryColor,
                                        strokeWidth: 1,
                                        strokeCap: StrokeCap.butt,
                                        dashPattern: const [5, 5],
                                        padding: const EdgeInsets.all(5),
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(
                                            Dimensions.radiusDefault),
                                        child: Container(
                                          height: 120,
                                          width: 150,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                              Dimensions.paddingSizeDefault),
                                          child: Column(
                                            children: [
                                              Icon(Icons.camera_alt,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                              Text('upload_identity_image'.tr,
                                                  style: robotoMedium.copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                  textAlign: TextAlign.center),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        right: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radiusSmall),
                                    ),
                                    child: Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        child: GetPlatform.isWeb
                                            ? Image.network(
                                                file!.path,
                                                width: 150,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              )
                                            : (file!.path.endsWith('.pdf') ||
                                                    file.path
                                                        .endsWith('.docx') ||
                                                    file.path.endsWith('.xls'))
                                                ? Container(
                                                    width: Get.width / 2.5,
                                                    child: Text(
                                                        "${file.path.toString()}"))
                                                : Image.file(
                                                    File(file.path),
                                                    width: 150,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: InkWell(
                                          onTap: () => authController
                                              .removeIdentityImage(index),
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                                Dimensions.paddingSizeSmall),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                },
                              ),
                            ),

                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),
                            CustomButton(
                              height: ResponsiveHelper.isDesktop(context)
                                  ? 45
                                  : null,
                              width: ResponsiveHelper.isDesktop(context)
                                  ? 180
                                  : null,
                              radius: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.radiusSmall
                                  : Dimensions.radiusDefault,
                              isBold: !ResponsiveHelper.isDesktop(context),
                              fontSize: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.fontSizeExtraSmall
                                  : null,
                              buttonText: 'sign_up'.tr,
                              isLoading: authController.isLoading,
                              onPressed: authController.acceptTerms
                                  ? () => _register(
                                      authController, widget.countryCode)
                                  : null,
                            ),
                          ]),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      )),
    );
  }

  void removeItem(int index, AuthController authController) {
    setState(() {
      authController.selectedCategories.removeAt(index);
    });
  }

  void _register(AuthController authController, String countryCode) async {
    String firstName = widget.firstName.trim();
    String lastName = widget.lastName.trim();
    String email = widget.email.trim();
    String number = widget.phone.trim();
    String password = widget.password.trim();
    String confirmPassword = widget.confirmPassword.trim();
    String referCode = widget.referCode.trim();
    String storeName = _storeNameController.text.trim();
    String stroreAddress = _storeAddressController.text.trim();

    String numberWithCountryCode = '+$countryCode$number';
    PhoneValid phoneValid =
        await CustomValidator.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;
    if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (storeName.isEmpty) {
      showCustomSnackBar('Store name should not empty');
    } else if (authController.pickedIdentities.isEmpty) {
      showCustomSnackBar('Please upload documents');
    } else if (authController.selectedCategories.length <= 0) {
      showCustomSnackBar('Please select category');
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: firstName,
        lName: lastName,
        email: email,
        phone: numberWithCountryCode,
        password: password,
        refCode: referCode,
        store_name: storeName,
        store_address: stroreAddress,
        new_category: authController.selectedCategories
            .where((category) => category.isNew!)
            .map((category) => category.name)
            .join(','),
        exist_category: authController.selectedCategories
            .where((category) => !category.isNew!)
            .map((category) => category.id.toString())
            .join(','),
      );

      authController.registration(signUpBody, context).then((status) async {
        showCustomSnackBar(
            "Successfully registering! Please await admin approval before logging in",
            isError: false);
      });
    }
  }
}

List<CategoryModel> searchCategories(
    String query, List<CategoryModel> allCategories) {
  return allCategories
      .where((category) =>
          category.name!.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
