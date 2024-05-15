import 'package:sixam_mart/controller/auth_controller.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/controller/user_controller.dart';
import 'package:sixam_mart/data/model/response/response_model.dart';
import 'package:sixam_mart/data/model/response/userinfo_model.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/view/base/custom_button.dart';
import 'package:sixam_mart/view/base/custom_snackbar.dart';
import 'package:sixam_mart/view/base/footer_view.dart';
import 'package:sixam_mart/view/base/image_picker_widget.dart';
import 'package:sixam_mart/view/base/menu_drawer.dart';
import 'package:sixam_mart/view/base/my_text_field.dart';
import 'package:sixam_mart/view/base/not_logged_in_screen.dart';
import 'package:sixam_mart/view/base/web_menu_bar.dart';
import 'package:sixam_mart/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../util/images.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _taxFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController inputController = TextEditingController();
  List documents = [];
  RxList<String> imagesSelected = <String>[].obs;
  String? _filePath = '';

  @override
  void initState() {
    super.initState();
    FlutterDownloader.initialize();
    initCall();
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _filePath = file.path;

        imagesSelected.add(_filePath!);
        // log('82-->> ${imagesSelected}');
      });
    } else {}
  }

  Future<void> downloadFile() async {
    final savedDir = await getExternalStorageDirectory();
    if (savedDir == null) {
      print('bhai path nhi hai!!');
      // Handle error when directory is not available
      return;
    }

    final taskId = await FlutterDownloader.enqueue(
      url: "https://www.sharedfilespro.com/shared-files/38/?sample.pdf",
      savedDir: savedDir.path,
      fileName: "certificate.pdf", // Specify desired filename
      showNotification: true, // Display download progress notification
      // Set headers if needed
      // headers: {"auth": "your_auth_token"},
    );
  }

  Widget videoSectionWidget() {
    //  Video View..
    return Column(
      children: [
        Obx(() => imagesSelected.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  onPressed: () async {
                    _pickImage();
                  },
                  child: DottedBorder(
                    color: Theme.of(context).primaryColor,
                    strokeWidth: 1,
                    strokeCap: StrokeCap.butt,
                    dashPattern: const [5, 5],
                    padding: const EdgeInsets.all(5),
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(Dimensions.radiusDefault),
                    child: Container(
                      height: 120,
                      width: 150,
                      alignment: Alignment.center,
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt,
                              color: Theme.of(context).disabledColor),
                          Text('Upload Documents',
                              style: robotoMedium.copyWith(
                                  color: Theme.of(context).disabledColor),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      crossAxisCount: 3),
                  children: List.generate(
                      imagesSelected.length + 1,
                      (index) => index == imagesSelected.length
                          ? InkWell(
                              onTap: () async {
                                _pickImage();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 15, 15),
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
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5.0),
                                      // border: Border.all(
                                      //   color: Colors.black54,
                                      // ),
                                    ),
                                    child: const Center(
                                      child: Icon(Icons.add,
                                          size: 20, color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      // Get.to(() => ImageSliderScreen(
                                      //   imageUrls: imagesSelected.value
                                      //   as List<String>,
                                      //   type: 'file',
                                      //   index: index,
                                      // ));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: (imagesSelected[index]
                                                  .endsWith('.pdf')) ||
                                              (imagesSelected[index]
                                                  .endsWith('.doc')) ||
                                              (imagesSelected[index]
                                                  .endsWith('.docx')) ||
                                              (imagesSelected[index]
                                                  .endsWith('.ppt'))
                                          ? Container(
                                              width: Get.width / 2.5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Image.asset(Images.docc,
                                                    width: 135),
                                              ))
                                          : Image.file(
                                              File(
                                                imagesSelected[index],
                                              ),
                                              height: 80,
                                              width: 80,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 20,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        setState(() {
                                          imagesSelected.removeAt(index);
                                        });
                                      },
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(1.0, 1.0),
                                                    blurRadius: 1.0,
                                                    spreadRadius: 1.0)
                                              ]),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.clear,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            )),
                ),
              ))
      ],
    );
  }

  Widget buildHorizontalFilesList() {
    log('292-->> ${documents}');
    return Container(
      height: 90, // Adjust height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: documents.length, // Fixed item count for testing
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              downloadFile();
              // Handle onTap event
              print('Tapped on item $index');
            },
            child: Container(
              width: 80, // Adjust width as needed
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                  child: (documents[index].endsWith('.pdf')) ||
                          (documents[index].endsWith('.doc')) ||
                          (documents[index].endsWith('.docx')) ||
                          (documents[index].endsWith('.ppt'))
                      ? Container(
                          width: Get.width / 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(Images.docc, width: 135),
                          ))
                      : Container(
                          width: Get.width / 2.5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(Images.image, width: 135),
                          ))),
            ),
          );
        },
      ),
    );
  }

  void initCall() {
    if (Get.find<AuthController>().isLoggedIn() &&
        Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    Get.find<UserController>().initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: ResponsiveHelper.isDesktop(context) ? const WebMenuBar() : null,
      endDrawer: const MenuDrawer(),
      endDrawerEnableOpenDragGesture: false,
      body: GetBuilder<UserController>(builder: (userController) {
        bool isLoggedIn = Get.find<AuthController>().isLoggedIn();
        if (userController.userInfoModel != null &&
            _phoneController.text.isEmpty) {
          _firstNameController.text = userController.userInfoModel!.fName ?? '';
          _lastNameController.text = userController.userInfoModel!.lName ?? '';
          _phoneController.text = userController.userInfoModel!.phone ?? '';
          _emailController.text = userController.userInfoModel!.email ?? '';
          _taxController.text = userController.userInfoModel!.taxId ?? '';
          documents = userController.userInfoModel!.userDocuments!;
        }

        return isLoggedIn
            ? userController.userInfoModel != null
                ? ProfileBgWidget(
                    backButton: true,
                    circularImage: ImagePickerWidget(
                      image:
                          '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${userController.userInfoModel!.image}',
                      onTap: () => userController.pickImage(),
                      rawFile: userController.rawFile,
                    ),
                    mainWidget: Column(children: [
                      videoSectionWidget(),
                      buildHorizontalFilesList(),
                      Expanded(
                          child: Scrollbar(
                              child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: ResponsiveHelper.isDesktop(context)
                            ? EdgeInsets.zero
                            : const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Center(
                            child: FooterView(
                          minHeight: 0.45,
                          child: SizedBox(
                              width: Dimensions.webMaxWidth,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'first_name'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    MyTextField(
                                      hintText: 'first_name'.tr,
                                      controller: _firstNameController,
                                      focusNode: _firstNameFocus,
                                      nextFocus: _lastNameFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),

                                    Text(
                                      'last_name'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    MyTextField(
                                      hintText: 'last_name'.tr,
                                      controller: _lastNameController,
                                      focusNode: _lastNameFocus,
                                      nextFocus: _emailFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),

                                    Text(
                                      'email'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),

                                    MyTextField(
                                      hintText: 'email'.tr,
                                      controller: _emailController,
                                      focusNode: _emailFocus,
                                      inputAction: TextInputAction.done,
                                      inputType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),

                                    Text(
                                      'Tax ID: ',
                                      style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color:
                                              Theme.of(context).disabledColor),
                                    ),
                                    MyTextField(
                                      hintText: 'Tax id',
                                      controller: _taxController,
                                      focusNode: _taxFocus,
                                      nextFocus: _phoneFocus,
                                      inputType: TextInputType.name,
                                      capitalization: TextCapitalization.words,
                                    ),

                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Row(children: [
                                      Text(
                                        'phone'.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      ),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text('(${'non_changeable'.tr})',
                                          style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error,
                                          )),
                                    ]),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    MyTextField(
                                      hintText: 'phone'.tr,
                                      controller: _phoneController,
                                      focusNode: _phoneFocus,
                                      inputType: TextInputType.phone,
                                      isEnabled: false,
                                    ),

                                    //
                                    ResponsiveHelper.isDesktop(context)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions
                                                    .paddingSizeLarge),
                                            child: UpdateProfileButton(
                                                isLoading:
                                                    userController.isLoading,
                                                onPressed: () {
                                                  return _updateProfile(
                                                      userController);
                                                }),
                                          )
                                        : const SizedBox.shrink(),
                                  ])),
                        )),
                      ))),
                      ResponsiveHelper.isDesktop(context)
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(
                                  bottom: GetPlatform.isIOS
                                      ? Dimensions.paddingSizeLarge
                                      : 0),
                              child: UpdateProfileButton(
                                  isLoading: userController.isLoading,
                                  onPressed: () =>
                                      _updateProfile(userController)),
                            ),
                    ]),
                  )
                : const Center(child: CircularProgressIndicator())
            : NotLoggedInScreen(callBack: (value) {
                initCall();
                setState(() {});
              });
      }),
    );
  }

  void _updateProfile(UserController userController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String tax = _taxController.text.trim();
    if (userController.userInfoModel!.fName == firstName &&
        userController.userInfoModel!.lName == lastName &&
        userController.userInfoModel!.phone == phoneNumber &&
        userController.userInfoModel!.email == _emailController.text &&
        userController.pickedFile == null &&
        imagesSelected.isEmpty &&
        userController.userInfoModel!.taxId == tax) {
      showCustomSnackBar('change_something_to_update'.tr);
    } else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else if (tax.isEmpty) {
      showCustomSnackBar('Enter Tax ID');
    } else {
      UserInfoModel updatedUser = UserInfoModel(
          fName: firstName,
          lName: lastName,
          email: email,
          phone: phoneNumber,
          userDocuments: imagesSelected,
          taxId: tax);
      ResponseModel responseModel = await userController.updateUserInfo(
          updatedUser,
          Get.find<AuthController>().getUserToken(),
          imagesSelected);
      if (responseModel.isSuccess) {
        showCustomSnackBar('profile_updated_successfully'.tr, isError: false);
      } else {
        showCustomSnackBar(responseModel.message);
      }
    }
  }
}

class UpdateProfileButton extends StatelessWidget {
  final bool isLoading;
  final Function onPressed;
  const UpdateProfileButton(
      {Key? key, required this.isLoading, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? CustomButton(
            onPressed: onPressed,
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            buttonText: 'update'.tr,
          )
        : const Center(child: CircularProgressIndicator());
  }
}
