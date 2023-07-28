import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/banner/controllers/banner_controller.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/ficon_button.dart';
import 'package:image_picker/image_picker.dart';

class AddBannerScreen extends StatefulWidget {
  static const String routeName = '/add-banner-screen';

  const AddBannerScreen({super.key});

  @override
  State<AddBannerScreen> createState() => _AddBannerScreenState();
}

class _AddBannerScreenState extends State<AddBannerScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descriptionController = TextEditingController();
  String descriptionText = '';

  takePhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  uploadPhoto() async {
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  handleConfirm() async {
    BannerController bannerController = BannerController();
    await bannerController.createBanner(
      image: imageXFile!,
      description: descriptionController.text,
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Add Banner',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: imageXFile == null || descriptionText.isEmpty
                ? () {}
                : handleConfirm,
            icon: Icon(
              Icons.add,
              color: imageXFile == null || descriptionText.isEmpty
                  ? Colors.grey[400]
                  : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageXFile == null
                      // && imageUrl.isEmpty
                      ? DottedBorder(
                          color: Colors.grey[500]!,
                          strokeWidth: 1,
                          dashPattern: const [10, 6],
                          child: SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 70,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: CustomTextButton(
                                        text: 'Take a photo',
                                        onPressed: takePhoto,
                                        isDisabled: false,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: CustomTextButton(
                                        text: 'Upload a photo',
                                        onPressed: uploadPhoto,
                                        isDisabled: false,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      : DottedBorder(
                          color: Colors.grey[500]!,
                          strokeWidth: 1,
                          dashPattern: const [10, 6],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 180,
                                  // width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 4 / 5,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image:
                                                    //  imageUrl == '' ?
                                                    FileImage(
                                                  File(imageXFile!.path),
                                                )
                                                // : NetworkImage(imageUrl)
                                                //     as ImageProvider
                                                ,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: FIconButton(
                                            icon: const Icon(Icons.close),
                                            backgroundColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                // imageUrl = '';
                                                imageXFile = null;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: descriptionController,
                    labelText: 'Description',
                    onChanged: (value) {
                      setState(
                        () {
                          descriptionText = value;
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            CustomTextButton(
              text: 'Confirm',
              onPressed: handleConfirm,
              isDisabled: imageXFile == null || descriptionText.isEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
