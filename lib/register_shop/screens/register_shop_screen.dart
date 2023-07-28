import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_seller/authentication/widgets/custom_textbutton.dart';
import 'package:foodpanda_seller/constants/colors.dart';
import 'package:foodpanda_seller/models/address.dart';
import 'package:foodpanda_seller/providers/internet_provider.dart';
import 'package:foodpanda_seller/providers/register_shop_provider.dart';
import 'package:foodpanda_seller/register_shop/screens/search_address_manual_screen.dart';
import 'package:foodpanda_seller/widgets/custom_textfield.dart';
import 'package:foodpanda_seller/widgets/ficon_button.dart';
import 'package:foodpanda_seller/widgets/map_preview.dart';
import 'package:foodpanda_seller/widgets/my_snack_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterShopScreen extends StatefulWidget {
  static const String routeName = '/register-shop-screen';
  const RegisterShopScreen({super.key});

  @override
  State<RegisterShopScreen> createState() => _RegisterShopScreenState();
}

class _RegisterShopScreenState extends State<RegisterShopScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  GoogleMapController? mapPreviewController;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String nameText = '';
  String descriptionText = '';
  String imageUrl = '';
  Address? address;

  Future checkInfo() async {
    final rp = context.read<RegisterShopProvider>();
    await rp.checkIfAddressExist();
    setState(() {
      nameController.text = rp.shopName ?? '';
      nameText = rp.shopName ?? '';
      descriptionController.text = rp.shopDescription ?? '';
      descriptionText = rp.shopDescription ?? '';
      address = rp.shopAddress;
      imageUrl = rp.shopImage ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    checkInfo();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    descriptionController.dispose();
  }

  handleRegisterShop() async {
    final registerShopProvider = context.read<RegisterShopProvider>();
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      Navigator.pop(context);
      openSnackbar(context, 'Check your internet connection', scheme.primary);
    } else {
      if (imageUrl.isNotEmpty) {
        await registerShopProvider.registerShop(
          shopName: nameController.text.trim().toString(),
          shopDescription: descriptionController.text.trim().toString(),
          imageUrl: imageUrl,
          address: address!,
        );
      } else {
        await registerShopProvider.registerShop(
          shopName: nameController.text.trim().toString(),
          shopDescription: descriptionController.text.trim().toString(),
          image: imageXFile!,
          address: address!,
        );
      }

      Navigator.pop(context);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Register Shop',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: nameText.isNotEmpty &&
                    descriptionText.isNotEmpty &&
                    address != null &&
                    ((imageXFile == null && imageUrl.isNotEmpty) ||
                        (imageXFile != null && imageUrl.isEmpty))
                ? handleRegisterShop
                : null,
            icon: Icon(
              Icons.check,
              color: nameText.isNotEmpty &&
                      descriptionText.isNotEmpty &&
                      address != null &&
                      ((imageXFile == null && imageUrl.isNotEmpty) ||
                          (imageXFile != null && imageUrl.isEmpty))
                  ? Colors.white
                  : Colors.grey[400],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Register shop',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const Text(
                'Fill in the informations',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: nameController,
                labelText: 'Shop Name',
                onChanged: (value) {
                  setState(() {
                    nameText = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[500]!,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      descriptionText = value;
                    });
                  },
                  maxLength: 500,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Description',
                    counterStyle: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Shop location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SearchAddressManualScreen.routeName,
                    arguments: SearchAddressManualScreen(
                      mapPreviewController: mapPreviewController,
                      initialLatLng: address != null
                          ? LatLng(address!.latitude, address!.longitude)
                          : null,
                      changeAddress: (Address newAddress) {
                        setState(() {
                          address = newAddress;
                        });
                      },
                    ),
                  );
                },
                child: DottedBorder(
                  color: Colors.grey[500]!,
                  strokeWidth: 1,
                  dashPattern: const [10, 6],
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: address == null
                        ? SizedBox(
                            height: 130,
                            child: Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/foodpanda_location.png',
                                    width: 100,
                                  ),
                                  const Text(
                                    'Choose location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MapPreview(
                                onMapCreated: (GoogleMapController controller) {
                                  setState(() {
                                    mapPreviewController = controller;
                                  });
                                },
                                selectedAddress: address!,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${address!.houseNumber.isEmpty ? '' : address!.houseNumber + ' '}${address!.street}',
                              ),
                              Text(address!.province),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Shop background image',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              imageXFile == null && imageUrl.isEmpty
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
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageUrl == ''
                                                ? FileImage(
                                                    File(imageXFile!.path),
                                                  )
                                                : NetworkImage(imageUrl)
                                                    as ImageProvider,
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
                                            imageUrl = '';
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
            ],
          ),
        ),
      ),
    );
  }
}
