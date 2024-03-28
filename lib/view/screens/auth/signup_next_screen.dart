import 'dart:convert';
import 'dart:io';
import 'package:chips_choice/chips_choice.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/category_controller.dart';
import 'package:sixam_mart/controller/localization_controller.dart';
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
import 'package:sixam_mart/view/screens/auth/sign_in_screen.dart';
import 'package:sixam_mart/view/screens/auth/widget/condition_check_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpNextScreen extends StatefulWidget {
  const SignUpNextScreen({Key? key}) : super(key: key);

  @override
  SignUpNextScreenState createState() => SignUpNextScreenState();
}

class SignUpNextScreenState extends State<SignUpNextScreen> {
  final FocusNode _storeNameFocus = FocusNode();
  final FocusNode _storeAddressFocus = FocusNode();
  final FocusNode _businessCategoryFocus = FocusNode();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _businessCategoryController = TextEditingController();

  final TextEditingController _referCodeController = TextEditingController();
  String? _countryDialCode;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel!.country!)
        .dialCode;
    if (Get.find<AuthController>().showPassView) {
      Get.find<AuthController>().showHidePass(isUpdate: false);
    }
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
                              hintText: 'Enter your store address',
                              controller: _storeAddressController,
                              focusNode: _storeAddressFocus,
                              nextFocus: _businessCategoryFocus,
                              inputType: TextInputType.name,
                              prefixIcon: Icons.location_on,
                            ),
                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),

                            TypeAheadField<CategoryModel>(
                              textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    borderSide: BorderSide(style: true ? BorderStyle.solid : BorderStyle.none, width: 0.3, color: Theme.of(context).primaryColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    borderSide: BorderSide(style: true ? BorderStyle.solid : BorderStyle.none, width: 1, color: Theme.of(context).primaryColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    borderSide: BorderSide(style: true ? BorderStyle.solid : BorderStyle.none, width: 0.3, color: Theme.of(context).primaryColor),
                                  ),
                                  isDense: true,
                                  hintText: "Select Categories",
                                  fillColor: Theme.of(context).cardColor,
                                  hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor),
                                  filled: true,
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                final suggestions = searchCategories(pattern, Get.find<CategoryController>().categoryList!);

                                if (suggestions.isEmpty) {
                                  suggestions.add(CategoryModel(name: pattern.trim())); // Custom suggestion with trimmed pattern
                                }
                                return suggestions;
                              },
                              itemBuilder: (context, suggestion) {
                                return ListTile(
                                  title: Text(
                                    suggestion.name!,
                                    style: true ? TextStyle(fontStyle: FontStyle.italic) : null, // Optional style for custom entries
                                  ),
                                );
                              },
                              onSuggestionSelected: (selection) {
                                if (selection != null) {
                                  setState(() {
                                    if (!authController.selectedCategories.contains(selection)) {
                                      authController.selectedCategories.add(selection);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Category already selected"), // Customize message as needed
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
                                  final category = authController.selectedCategories[index];
                                  return Chip(
                                    label: Text(category.name!),
                                    backgroundColor: Colors.grey.shade200,
                                    onDeleted: (){
                                      removeItem(index, authController);
                                    },
                                  );
                                },
                              ),
                            ),

                            InkWell(
                                onTap: () async {
                                  authController.pickDocument();
                                },
                                child: Text("Upload Document")),

                            SizedBox(
                                height: !ResponsiveHelper.isDesktop(context)
                                    ? Dimensions.paddingSizeLarge
                                    : 0),
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
                                      authController, _countryDialCode!)
                                  : null,
                            ),
                            const SizedBox(
                                height: Dimensions.paddingSizeExtraLarge),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (ResponsiveHelper.isDesktop(context)) {
                                        Get.back();
                                        Get.dialog(const SignInScreen(
                                            exitFromApp: false,
                                            backFromThis: false));
                                      } else {
                                        if (Get.currentRoute ==
                                            RouteHelper.signUp) {
                                          Get.back();
                                        } else {
                                          Get.toNamed(
                                              RouteHelper.getSignInRoute(
                                                  RouteHelper.signUp));
                                        }
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeExtraSmall),
                                      child: Text('<< Go Back',
                                          style: robotoMedium.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                    ),
                                  ),
                                ]),
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
    /*
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String number = _phoneController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    String numberWithCountryCode = countryCode + number;
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
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: firstName,
        lName: lastName,
        email: email,
        phone: numberWithCountryCode,
        password: password,
        refCode: referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel!.customerVerification!) {
            List<int> encoded = utf8.encode(password);
            String data = base64Encode(encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(numberWithCountryCode,
                status.message, RouteHelper.signUp, data));
          } else {
            Get.find<LocationController>()
                .navigateToLocationScreen(RouteHelper.signUp);
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
 */
  }
}

List<CategoryModel> searchCategories(
    String query, List<CategoryModel> allCategories) {
  return allCategories
      .where((category) =>
          category.name!.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
